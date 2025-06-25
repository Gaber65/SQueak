import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/qr_cubit.dart';
import '../widgets/qr_scanner_widget.dart';
import 'pet_profile_screen.dart';
import '../widgets/qr_guideline_widget.dart';
import '../../../../core/utils/responsive_utils.dart';

class QrScannerScreen extends StatelessWidget {
  const QrScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scan QR Code',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocListener<QrCubit, QrState>(
        listener: (context, state) {
          if (state is QrScanSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PetProfileScreen(pet: state.pet),
              ),
            );
          } else if (state is QrScanEmpty) {
            _showGuidelineDialog(context);
          } else if (state is QrError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.all(responsiveWidth(16, context)),
          child: const QrScannerWidget(),
        ),
      ),
    );
  }

  void _showGuidelineDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const QrGuidelineWidget(),
    );
  }
}
