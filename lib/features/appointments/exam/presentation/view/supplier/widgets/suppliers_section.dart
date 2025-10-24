import 'package:flutter/material.dart';
import 'package:squeak/features/appointments/exam/domain/entities/clinic_entity.dart';
import '../../../../../../../core/service/global_function/format_utils.dart';
import 'clinic_card.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';

class SuppliersSection extends StatefulWidget {
  final List<ClinicInfo> allSuppliers;
  final PetEntities? petSelectFromIcon;
  final Function() onRefresh;

  const SuppliersSection({
    super.key,
    required this.allSuppliers,
    this.petSelectFromIcon,
    required this.onRefresh,
  });

  @override
  State<SuppliersSection> createState() => _SuppliersSectionState();
}

class _SuppliersSectionState extends State<SuppliersSection> {
  final TextEditingController _searchController = TextEditingController();
  List<ClinicInfo> _filteredSuppliers = [];

  @override
  void initState() {
    super.initState();
    _filteredSuppliers = widget.allSuppliers;
    _searchController.addListener(_filterSuppliers);
  }

  void _filterSuppliers() {
    final query = _searchController.text.toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _filteredSuppliers = widget.allSuppliers;
      });
    } else {
      setState(() {
        _filteredSuppliers =
            widget.allSuppliers.where((supplier) {
              final name = supplier.data.name.toLowerCase();
              final code = supplier.data.code.toLowerCase();
              return name.contains(query) || code.contains(query);
            }).toList();
      });
    }
  }

  @override
  void didUpdateWidget(SuppliersSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.allSuppliers != oldWidget.allSuppliers) {
      _filterSuppliers();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchTextField(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => widget.onRefresh(),
            child:
                _filteredSuppliers.isEmpty
                    ? Center(
                      child: Text(
                        'No clinics found',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                    : ListView.builder(
                      itemCount: _filteredSuppliers.length,
                      itemBuilder:
                          (context, index) => ClinicCard(
                            clinic: _filteredSuppliers[index],
                            petSelectFromIcon: widget.petSelectFromIcon,
                          ),
                    ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText:
              isArabic() ? 'ابحث بالاسم او الكود' : 'Search by name or code',
          contentPadding: const EdgeInsets.all(0),
          filled: true,
          fillColor: Colors.grey.shade200,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
