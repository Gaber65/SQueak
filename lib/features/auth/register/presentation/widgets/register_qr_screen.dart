import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/features/auth/register/presentation/cubit/register_cubit.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';


class RegisterQrScreen extends StatefulWidget {
  final String clinicCode;
  final String clinicName;
  final String clinicLogo;

  const RegisterQrScreen({
    super.key,
    required this.clinicCode,
    required this.clinicName,
    required this.clinicLogo,
  });

  @override
  State<RegisterQrScreen> createState() => _RegisterQrScreenState();
}

class _RegisterQrScreenState extends State<RegisterQrScreen> {
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    final cubit = context.read<RegisterCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register with ${widget.clinicName}'),
        centerTitle: true,
      ),
      body: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegistrationErrorState) {
            errorToast(context, state.error);
          }
          if (state is RegistrationSuccessState) {
            _handleRegistrationSuccess(context);
          }
        },
        builder: (context, state) {
          final cubit = context.read<RegisterCubit>();
          
          return AbsorbPointer(
            absorbing: state is RegistrationLoadingState,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildClinicHeader(),
                  const SizedBox(height: 24),
                  _buildRegistrationForm(cubit, state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildClinicHeader() {
    return Column(
      children: [
        if (widget.clinicLogo.isNotEmpty)
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(widget.clinicLogo),
                fit: BoxFit.cover,
              ),
            ),
          ),
        const SizedBox(height: 16),
        Text(
          'Register with ${widget.clinicName}',
          textAlign: TextAlign.center,
          style: FontStyleThame.textStyle(
            context: context,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Clinic Code: ${widget.clinicCode}',
          textAlign: TextAlign.center,
          style: FontStyleThame.textStyle(
            context: context,
            fontSize: 16,
            fontColor: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationForm(RegisterCubit cubit, RegisterState state) {
    return Form(
      key: cubit.formKey,
      child: Column(
        children: [
          _buildNameField(cubit),
          const SizedBox(height: 16),
          _buildEmailField(cubit),
          const SizedBox(height: 16),
          _buildPhoneField(cubit),
          const SizedBox(height: 16),
          _buildPasswordField(cubit),
          const SizedBox(height: 24),
          _buildDataSharingCheckbox(cubit),
          const SizedBox(height: 24),
          _buildRegisterButton(cubit, state),
          if (state is RegistrationLoadingState)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: LinearProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildNameField(RegisterCubit cubit) {
    return TextFormField(
      controller: cubit.nameController,
      decoration: InputDecoration(
        labelText: 'Full Name',
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your name';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField(RegisterCubit cubit) {
    return TextFormField(
      controller: cubit.emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField(RegisterCubit cubit) {
    return TextFormField(
      controller: cubit.phoneController,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        prefixIcon: const Icon(Icons.phone_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your phone number';
        }
        if (!RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$').hasMatch(value)) {
          return 'Please enter a valid phone number';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(RegisterCubit cubit) {
    return TextFormField(
      controller: cubit.passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
      obscureText: _obscurePassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildDataSharingCheckbox(RegisterCubit cubit) {
    return Row(
      children: [
        Checkbox(
          value: cubit.isAccept,
          onChanged: (value) {
            cubit.toggleDataSharing();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Expanded(
          child: Text(
            'I agree to share my data with ${widget.clinicName}',
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton(RegisterCubit cubit, RegisterState state) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        onPressed: state is RegistrationLoadingState
            ? null
            : () {
                if (cubit.formKey.currentState!.validate()) {
                  cubit.registerWithQr(widget.clinicCode, context);
                }
              },
        child: state is RegistrationLoadingState
            ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              )
            : const Text(
                'Register',
                style: TextStyle(fontSize: 16),
              ),
      ),
    );
  }

  void _handleRegistrationSuccess(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LayoutScreen()),
      (route) => false,
    );
    successToast(context, 'Registration successful! Welcome to ${widget.clinicName}');
  }
}