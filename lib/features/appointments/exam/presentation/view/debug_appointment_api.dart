import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

class DebugAppointmentAPI extends StatefulWidget {
  final String clinicCode;
  
  const DebugAppointmentAPI({super.key, required this.clinicCode});

  @override
  State<DebugAppointmentAPI> createState() => _DebugAppointmentAPIState();
}

class _DebugAppointmentAPIState extends State<DebugAppointmentAPI> {
  List<Map<String, dynamic>> pets = [];
  Map<String, dynamic>? selectedPet;
  bool isLoading = false;
  String resultMessage = '';
  String appointmentDate = DateTime.now().add(Duration(days: 1)).toString().split(' ')[0];
  String appointmentTime = '10:00:00';
  String? doctorId;
  
  @override
  void initState() {
    super.initState();
    _loadPets();
  }
  
  Future<void> _loadPets() async {
    setState(() {
      isLoading = true;
      resultMessage = isArabic() ? 'جاري تحميل أصدقائك الأليفة...' : 'Loading pets...';
    });
    
    try {
      Response response = await DioFinalHelper.getData(
        method: getClientClinicEndPoint(widget.clinicCode, CacheHelper.getData('phone')),
        language: false,
      );
      
      if (response.data['success'] == true) {
        setState(() {
          pets = List<Map<String, dynamic>>.from(response.data['data']);
          if (pets.isNotEmpty) {
            selectedPet = pets.first;
          }
          resultMessage = 'Loaded ${pets.length} pets';
        });
      } else {
        setState(() {
          resultMessage = 'Failed to load pets: ${response.data['message']}';
        });
      }
    } catch (e) {
      setState(() {
        resultMessage = 'Error loading pets: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  
  Future<void> _createAppointment() async {
    if (selectedPet == null) {
      setState(() {
        resultMessage = 'No pet selected';
      });
      return;
    }
    
    setState(() {
      isLoading = true;
      resultMessage = 'Creating appointment...';
    });
    
    try {
      // Create the request payload
      Map<String, dynamic> requestData = {
        "date": appointmentDate,
        "time": appointmentTime,
        "petId": selectedPet!['id'],
        "clinicCode": widget.clinicCode,
        "clientId": selectedPet!['clientId'],
        "petSqueakId": selectedPet!['squeakPetId'],
      };
      
      // Only add doctorId if it's not null
      if (doctorId != null && doctorId!.isNotEmpty) {
        requestData["doctorUserId"] = doctorId;
      }
      
      // print("DEBUG: Request payload: $requestData");
      
      Response response = await DioFinalHelper.postData(
        method: '$version/vetcare/reservation/existedClient',
        data: requestData,
      );
      
      setState(() {
        resultMessage = 'Success! Response: ${response.data}';
      });
    } on DioException catch (e) {
      setState(() {
        resultMessage = 'API Error: ${e.response?.data ?? e.message}';
      });
      // print("DEBUG: Error response: ${e.response?.data}");
    } catch (e) {
      setState(() {
        resultMessage = 'Error creating appointment: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debug Appointment API'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Clinic Code: ${widget.clinicCode}', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            
            Text('Select Pet:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            
            if (pets.isEmpty && !isLoading)
              Text('No pets found'),
              
            if (pets.isNotEmpty)
              DropdownButton<Map<String, dynamic>>(
                isExpanded: true,
                value: selectedPet,
                items: pets.map((pet) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: pet,
                    child: Text('${pet['name']} (ID: ${pet['id'].toString().substring(0, 8)}...)'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPet = value;
                  });
                },
              ),
            
            SizedBox(height: 16),
            Text('Appointment Date:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextFormField(
              initialValue: appointmentDate,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'YYYY-MM-DD',
              ),
              onChanged: (value) {
                setState(() {
                  appointmentDate = value;
                });
              },
            ),
            
            SizedBox(height: 16),
            Text('Appointment Time:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextFormField(
              initialValue: appointmentTime,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'HH:MM:SS',
              ),
              onChanged: (value) {
                setState(() {
                  appointmentTime = value;
                });
              },
            ),
            
            SizedBox(height: 16),
            Text('Doctor ID (optional):', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter doctor ID',
              ),
              onChanged: (value) {
                setState(() {
                  doctorId = value.isEmpty ? null : value;
                });
              },
            ),
            
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _createAppointment,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: isLoading 
                      ? CircularProgressIndicator() 
                      : Text('Create Appointment', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
            
            SizedBox(height: 24),
            Text('Result:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(resultMessage),
            ),
            
            if (selectedPet != null) ...[
              SizedBox(height: 24),
              Text('Selected Pet Details:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${selectedPet!['name']}'),
                    Text('ID: ${selectedPet!['id']}'),
                    Text('SqueakID: ${selectedPet!['squeakPetId']}'),
                    Text('ClientID: ${selectedPet!['clientId']}'),
                    Text('Gender: ${selectedPet!['gender']}'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 