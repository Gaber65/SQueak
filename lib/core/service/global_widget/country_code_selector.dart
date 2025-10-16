import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:squeak/features/auth/register/domin/entities/country_entity.dart';
import 'package:squeak/features/auth/register/presentation/cubit/register_cubit.dart';
import '../../utils/export_path/export_files.dart';

class CountryCodeSelector extends StatefulWidget {
  final List<CountryEntity> countries;
  final RegisterCubit registerCubit;
  final VoidCallback? onCountryChanged;
  final bool isValid;
  final VoidCallback? onAnimationStop;

  const CountryCodeSelector({
    super.key,
    required this.countries,
    required this.registerCubit,
    this.onCountryChanged,
    this.isValid = false,
    this.onAnimationStop,
  });

  @override
  State<CountryCodeSelector> createState() => _CountryCodeSelectorState();
}

class _CountryCodeSelectorState extends State<CountryCodeSelector> {
  late CountryEntity _selectedCountry;

  @override
  void initState() {
    super.initState();
    _initializeSelectedCountry();
  }

  @override
  void didUpdateWidget(CountryCodeSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update if the cubit values have changed
    if (widget.registerCubit.countryPhoneCode != _selectedCountry.phoneCode) {
      _initializeSelectedCountry();
    }
  }

  void _initializeSelectedCountry() {
    _selectedCountry = CountryEntity(
      name: widget.registerCubit.countryCode,
      id: widget.registerCubit.countryIdToServer,
      phoneCode: widget.registerCubit.countryPhoneCode,
    );
    
    // If no country is selected, set a default empty state
    if (_selectedCountry.phoneCode.isEmpty) {
      _selectedCountry = CountryEntity(
        name: '',
        id: 0,
        phoneCode: '',
      );
    }
  }

  void _showCountryPicker() {
    HapticFeedback.selectionClick();
    
    showDialog(
      context: context,
      builder: (context) => _CountryPickerDialog(
        countries: widget.countries,
        selectedCountry: _selectedCountry,
        onSelectCountry: _handleCountrySelection,
      ),
    );
  }

  void _handleCountrySelection(CountryEntity country) {
    setState(() {
      _selectedCountry = country;
    });

    // Update cubit
    widget.registerCubit.countryCode = country.name;
    widget.registerCubit.countryPhoneCode = country.phoneCode;
    widget.registerCubit.countryIdToServer = country.id;

    // Update cache
    CacheHelper.saveData('countryId', country.id);
    CacheHelper.saveData('countryCodeE', country.name);

    // Notify parent widget
    widget.onCountryChanged?.call();
    
    // Stop animation when country is selected
    widget.onAnimationStop?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showCountryPicker,
      child: Container(
        height: 56, // Fixed height to match other fields
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.isValid
                ? ColorManager.green.withValues(alpha: 0.7)
                : Theme.of(context).colorScheme.outlineVariant,
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.flag_outlined,
                size: 16,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      _selectedCountry.phoneCode.isNotEmpty
                          ? _selectedCountry.phoneCode
                          : 'Select',
                      style: FontStyleThame.textStyle(
                        context: context,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        fontColor: _selectedCountry.phoneCode.isNotEmpty
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.outline,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).colorScheme.outline,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountryPickerDialog extends StatefulWidget {
  final List<CountryEntity> countries;
  final CountryEntity selectedCountry;
  final Function(CountryEntity) onSelectCountry;

  const _CountryPickerDialog({
    required this.countries,
    required this.selectedCountry,
    required this.onSelectCountry,
  });

  @override
  State<_CountryPickerDialog> createState() => _CountryPickerDialogState();
}

class _CountryPickerDialogState extends State<_CountryPickerDialog> {
  late List<CountryEntity> _filteredCountries;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredCountries = widget.countries;
  }

  void _filterCountries(String query) {
    setState(() {
      _filteredCountries = widget.countries
          .where((country) =>
              country.name.toLowerCase().contains(query.toLowerCase()) ||
              country.phoneCode.contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.flag_outlined,
                  color: ColorManager.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Select Country',
                  style: FontStyleThame.textStyle(
                    context: context,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontColor: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Search field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search countries...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: _filterCountries,
            ),
            const SizedBox(height: 16),
            
            // Countries list
            Expanded(
              child: ListView.builder(
                itemCount: _filteredCountries.length,
                itemBuilder: (context, index) {
                  final country = _filteredCountries[index];
                  final isSelected = country.id == widget.selectedCountry.id;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ColorManager.primaryColor.withValues(alpha: 0.1)
                          : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 30,
                        decoration: BoxDecoration(
                          color: ColorManager.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            country.phoneCode,
                            style: FontStyleThame.textStyle(
                              context: context,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontColor: ColorManager.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        country.name,
                        style: FontStyleThame.textStyle(
                          context: context,
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          fontColor: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: ColorManager.primaryColor,
                              size: 20,
                            )
                          : null,
                      onTap: () {
                        widget.onSelectCountry(country);
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
