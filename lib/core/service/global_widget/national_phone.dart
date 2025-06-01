import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/features/auth/register/domin/entities/country_entity.dart';
import 'package:squeak/features/auth/register/presentation/cubit/register_cubit.dart';

import '../../../generated/l10n.dart';

import '../../utils/export_path/export_files.dart';

class PhoneTextField extends StatefulWidget {
  final List<CountryEntity> countries;
  final TextEditingController controller;
  final RegisterCubit registerCubit;

  const PhoneTextField({
    super.key,
    required this.countries,
    required this.controller,
    required this.registerCubit,
  });

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  late CountryEntity _selectedCountry;

  @override
  void initState() {
    super.initState();
    _initializeSelectedCountry();
  }

  void _initializeSelectedCountry() {
    _selectedCountry = CountryEntity(
      name: widget.registerCubit.countryCode,
      id: widget.registerCubit.countryIdToServer,
      phoneCode: widget.registerCubit.countryPhoneCode,
    );

    _updateCubitCountry();
  }

  void _updateCubitCountry() {
    widget.registerCubit.countryCode = _selectedCountry.name;
    widget.registerCubit.countryPhoneCode = _selectedCountry.phoneCode;
    widget.registerCubit.countryIdToServer = _selectedCountry.id;
  }

  void _openCountryDialog() {
    showDialog(
      context: context,
      builder:
          (context) => CountryDialog(
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
    widget.registerCubit.countryIdToServer = country.id;
    widget.registerCubit.countryPhoneCode = country.phoneCode;
    widget.registerCubit.countryCode = country.name;
  }

  isDark(context) => MainCubit.get(context).isDark;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is CountryCodeDetectionSuccessState) {
          _selectedCountry = CountryEntity(
            name: widget.registerCubit.countryCode,
            id: widget.registerCubit.countryIdToServer,
            phoneCode: widget.registerCubit.countryPhoneCode,
          );
        }
      },
      builder: (context, state) {
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
            contentPadding: const EdgeInsets.only(right: 10, left: 10),
            filled: true,
            fillColor:
                isDark(context)
                    ? Colors.black26
                    : Colors.grey.shade200, // ✅ Key change

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),

            labelStyle: FontStyleThame.textStyle(
              context: context,
              fontColor:
                  isDark(context) ? ColorManager.sWhite : ColorManager.black_87,
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
            prefixIcon: _buildCountryCodeSelector(),
            hintText: S.of(context).phone_hint,
            counterStyle: FontStyleThame.textStyle(
              context: context,
              fontSize: 13,
            ),
            hintStyle: _getHintTextStyle(context),
          ),
        );
      },
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
      fontColor:
          isDark(context) ? Colors.white : const Color.fromRGBO(0, 0, 0, .3),
    );
  }

  TextStyle _getHintTextStyle(BuildContext context) {
    return FontStyleThame.textStyle(
      context: context,
      fontSize: 14,
      fontWeight: FontWeight.w700,
      fontColor:
          isDark(context) ? Colors.white : const Color.fromRGBO(0, 0, 0, .3),
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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
