// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:squeak/core/thames/styles.dart';
// import 'package:squeak/features/authentication/controller/auth_cubit.dart';
// import 'package:squeak/features/authentication/models/country_model.dart';
//
// import '../../../generated/l10n.dart';
// import '../../helper/build_service/main_cubit/main_cubit.dart';
// import '../../helper/cache/cache_helper.dart';
//
// class PhoneTextField extends StatefulWidget {
//   final List<CountryModel> countries;
//   final TextEditingController controller;
//
//   PhoneTextField({
//     super.key,
//     required this.countries,
//     required this.controller,
//   });
//
//   @override
//   _PhoneTextFieldState createState() => _PhoneTextFieldState();
// }
//
// class _PhoneTextFieldState extends State<PhoneTextField> {
//   late AuthCubit authCubit;
//   late CountryModel selectedCountry;
//
//   @override
//   void initState() {
//     super.initState();
//     authCubit = BlocProvider.of<AuthCubit>(context);
//
//     selectedCountry = CountryModel(
//       name: CacheHelper.getData('countryCodeE') ?? 'EG',
//       id: 1,
//       phoneCode: authCubit.countryPhoneCode,
//     );
//
//     CacheHelper.saveData('countryId', selectedCountry.id);
//   }
//
//   @override
//   void didUpdateWidget(covariant PhoneTextField oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     selectedCountry = CountryModel(
//       name: CacheHelper.getData('countryCodeE') ?? 'EG',
//       id: 1,
//       phoneCode: authCubit.countryPhoneCode,
//     );
//   }
//
//   void _openCountryDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return CountryDialog(
//           countries: widget.countries,
//           onSelectCountry: (CountryModel country) {
//             CacheHelper.saveData('countryId', country.id);
//             CacheHelper.saveData('countryCodeE', country.id);
//             setState(() {
//               authCubit.countryIdToServer = country.id;
//               selectedCountry = country;
//             });
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: widget.controller,
//       keyboardType: TextInputType.phone,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       validator: (value) {
//         if (value!.isEmpty) {
//           return S.of(context).phone_validation;
//         }
//         return null;
//       },
//       decoration: InputDecoration(
//         prefixIcon: InkWell(
//           onTap: _openCountryDialog,
//           child: SizedBox(
//             width: 60,
//             child: Row(
//               children: [
//                 SizedBox(width: 4),
//                 Text(
//                   selectedCountry.phoneCode,
//                   style: FontStyleThame.textStyle(
//                     context: context,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w700,
//                     fontColor: sl<MainCubit>().isDark
//                         ? Colors.white54
//                         : Color.fromRGBO(0, 0, 0, .3),
//                   ),
//                 ),
//                 const Icon(Icons.arrow_drop_down),
//               ],
//             ),
//           ),
//         ),
//         hintText: S.of(context).phone_hint,
//         contentPadding: EdgeInsets.all(0),
//         filled: true,
//         counterStyle: FontStyleThame.textStyle(
//           context: context,
//           fontSize: 13,
//         ),
//         hintStyle: FontStyleThame.textStyle(
//           context: context,
//           fontSize: 14,
//           fontWeight: FontWeight.w700,
//           fontColor: sl<MainCubit>().isDark
//               ? Colors.white54
//               : Color.fromRGBO(0, 0, 0, .3),
//         ),
//         fillColor: sl<MainCubit>().isDark
//             ? Colors.black26
//             : Colors.grey.shade200,
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide.none,
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide.none,
//         ),
//         disabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide.none,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide.none,
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide.none,
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
// }
//
// class CountryDialog extends StatefulWidget {
//   final Function(CountryModel) onSelectCountry;
//   final List<CountryModel> countries;
//
//   const CountryDialog({Key? key, required this.onSelectCountry, required this.countries})
//       : super(key: key);
//
//   @override
//   _CountryDialogState createState() => _CountryDialogState();
// }
//
// class _CountryDialogState extends State<CountryDialog> {
//   String _searchQuery = '';
//   List<CountryModel> _filteredCountries = [];
//
//   void _filterCountries(String query) {
//     setState(() {
//       _searchQuery = query;
//       _filteredCountries = widget.countries
//           .where((country) => country.name.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _filteredCountries = widget.countries;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               onChanged: _filterCountries,
//               decoration: const InputDecoration(
//                 labelText: 'Search countries',
//                 prefixIcon: Icon(Icons.search),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _filteredCountries.length,
//                 itemBuilder: (context, index) {
//                   final country = _filteredCountries[index];
//                   return ListTile(
//                     title: Text(country.name),
//                     trailing: Text(country.phoneCode),
//                     onTap: () {
//                       widget.onSelectCountry(country);
//                       Navigator.of(context).pop();
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
