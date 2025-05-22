import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/features/auth/register/domin/entities/country_entity.dart';
import 'package:squeak/features/auth/register/presentation/cubit/register_cubit.dart';

import '../../../generated/l10n.dart';


import '../../utils/export_path/export_files.dart';

class PhoneTextField extends StatefulWidget {
  final List<CountryEntity> countries;
  final TextEditingController controller;

  const PhoneTextField({
    super.key,
    required this.countries,
    required this.controller,
  });

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  late RegisterCubit _registerCubit;
  late CountryEntity _selectedCountry;

  @override
  void initState() {
    super.initState();
    _registerCubit = context.read<RegisterCubit>();
    _initializeSelectedCountry();
  }

  void _initializeSelectedCountry() {
    final cachedCountryCode = CacheHelper.getData('countryCodeE') ?? 'EG';
    final cachedCountryId = CacheHelper.getData('countryId') ?? 1;
    final cachedPhoneCode = _registerCubit.countryPhoneCode;

    // Try to find matching country from the list
    _selectedCountry = widget.countries.firstWhere(
          (country) => country.name == cachedCountryCode,
      orElse: () => CountryEntity(
        name: cachedCountryCode,
        id: cachedCountryId,
        phoneCode: cachedPhoneCode,
      ),
    ) ;

    _updateCubitCountry();
  }

  void _updateCubitCountry() {
    _registerCubit.countryCode = _selectedCountry.name;
    _registerCubit.countryPhoneCode = _selectedCountry.phoneCode;
    _registerCubit.countryIdToServer = _selectedCountry.id;
  }

  void _openCountryDialog() {
    showDialog(
      context: context,
      builder: (context) => CountryDialog(
        countries: widget.countries,
        onSelectCountry: (country) {
          _handleCountrySelection(country);
        },
      ),
    );
  }

  void _handleCountrySelection(CountryEntity country) {
    setState(() {
      _selectedCountry = country;
    });

    // Update cache
    CacheHelper.saveData('countryId', country.id);
    CacheHelper.saveData('countryCodeE', country.name);

    // Update cubit
    _registerCubit.countryIdToServer = country.id;
    _registerCubit.countryPhoneCode = country.phoneCode;
    _registerCubit.countryCode = country.name;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.phone,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return S.of(context).phone_validation;
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: _buildCountryCodeSelector(),
        hintText: S.of(context).phone_hint,
        contentPadding: EdgeInsets.zero,
        filled: true,
        counterStyle: FontStyleThame.textStyle(
          context: context,
          fontSize: 13,
        ),
        hintStyle: _getHintTextStyle(context),
        fillColor: _getFillColor(context),
        border: _getInputBorder(),
        enabledBorder: _getInputBorder(),
        focusedBorder: _getInputBorder(),
        disabledBorder: _getInputBorder(),
        errorBorder: _getInputBorder(),
        focusedErrorBorder: _getInputBorder(),
      ),
    );
  }

  Widget _buildCountryCodeSelector() {
    return InkWell(
      onTap: _openCountryDialog,
      child: SizedBox(
        width: 60,
        child: Row(
          children: [
            const SizedBox(width: 4),
            Text(
              _selectedCountry.phoneCode,
              style: _getCountryCodeTextStyle(context),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  TextStyle _getCountryCodeTextStyle(BuildContext context) {
    return FontStyleThame.textStyle(
      context: context,
      fontSize: 14,
      fontWeight: FontWeight.w700,
      fontColor: _isDarkMode(context)
          ? Colors.white54
          : const Color.fromRGBO(0, 0, 0, .3),
    );
  }

  TextStyle _getHintTextStyle(BuildContext context) {
    return FontStyleThame.textStyle(
      context: context,
      fontSize: 14,
      fontWeight: FontWeight.w700,
      fontColor: _isDarkMode(context)
          ? Colors.white54
          : const Color.fromRGBO(0, 0, 0, .3),
    );
  }

  Color _getFillColor(BuildContext context) {
    return _isDarkMode(context)
        ? Colors.black26
        : Colors.grey.shade200;
  }

  bool _isDarkMode(BuildContext context) {
    // Implement your dark mode check logic here
    // For example, if you're using a theme cubit:
    // return context.read<ThemeCubit>().isDarkMode;
    return false; // Default to light mode
  }

  InputBorder _getInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    );
  }
}

class CountryDialog extends StatelessWidget {
  final List<CountryEntity> countries;
  final Function(CountryEntity) onSelectCountry;

  const CountryDialog({
    super.key,
    required this.countries,
    required this.onSelectCountry,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select Country',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: countries.length,
              itemBuilder: (context, index) {
                final country = countries[index];
                return ListTile(
                  leading: Text(country.phoneCode),
                  title: Text(country.name),
                  onTap: () {
                    onSelectCountry(country);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



