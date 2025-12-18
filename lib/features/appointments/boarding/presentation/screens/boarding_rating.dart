import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/service/global_widget/care_loading_widget.dart';
import 'package:squeak/generated/l10n.dart';
import '../../../../../core/service/service_locator/service_locator.dart';
import '../../../../../core/utils/theme/navigation_helper/navigation.dart';
import '../../../../layout/layout/presentation/cubit/layout_cubit.dart';
import '../../../../layout/layout/presentation/screens/layout_screen.dart';
import '../../domain/entities/boarding_entry_entity.dart';
import '../cubit/boarding_cubit.dart';
import '../cubit/boarding_state.dart';

class RateBoarding extends StatefulWidget {
  final BoardingEntryEntity boardingEntryEntity;

  const RateBoarding({
    super.key,
    required this.boardingEntryEntity,
  });

  @override
  State<RateBoarding> createState() => _RateBoardingState();
}

class _RateBoardingState extends State<RateBoarding> {
  final TextEditingController _feedbackController = TextEditingController();
  int _cleanlinessRating = 0;
  int _doctorRating = 0;

  @override
  void initState() {
    super.initState();
    _initializeRatings();
  }

  void _initializeRatings() {
    if (widget.boardingEntryEntity.isRating) {
      _cleanlinessRating = widget.boardingEntryEntity.cleanlinessRate;
      _doctorRating = widget.boardingEntryEntity.doctorServiceRate;
      _feedbackController.text =
          widget.boardingEntryEntity.feedbackComment ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BoardingCubit>(),
      child: BlocConsumer<BoardingCubit, BoardingState>(
        listener: (context, state) {
          if (state is RateBoardingSuccess) {
            LayoutCubit.get(context).changeBottomNav(2);
            navigateAndFinish(context, LayoutScreen());
          } else if (state is RateBoardingError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Rate Boarding')),
            floatingActionButton:
                !widget.boardingEntryEntity.isRating
                    ? _buildSubmitButton(context, state)
                    : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeaderImage(),
                    const SizedBox(height: 20),
                    _buildTitle(),
                    const SizedBox(height: 10),
                    _buildDescription(),
                    const SizedBox(height: 50),
                    _buildDoctorRating(),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),
                    _buildCleanlinessRating(),
                    const SizedBox(height: 20),
                    if (widget.boardingEntryEntity.isRating)
                      _buildFeedbackField(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: NetworkImage(
            'https://firebasestorage.googleapis.com/v0/b/squeak-c005f.appspot.com/o/dog-breeding-buying-puppy-pet-store-domestic-animal-couple-adopting-puppy-breed-club-top-breed-standard-buy-your-purebred-pet-here-concept-bright-vibrant-violet-isolated-illustration.png?alt=media&token=249eb91a-008a-4c52-b87b-433b1c4eb256',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Session Feedback',
      style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDescription() {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(text: 'Please rate your experience with '),
          TextSpan(
            text: widget.boardingEntryEntity.clinicName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.grey.shade600,
      ),
    );
  }

  Widget _buildDoctorRating() {
    return _buildRatingRow('Doctor Service:', _doctorRating, (rating) {
      if (!widget.boardingEntryEntity.isRating) {
        setState(() {
          _doctorRating = rating;
        });
      }
    });
  }

  Widget _buildCleanlinessRating() {
    return _buildRatingRow('Cleanliness of Clinic:', _cleanlinessRating, (
      rating,
    ) {
      if (!widget.boardingEntryEntity.isRating) {
        setState(() {
          _cleanlinessRating = rating;
        });
      }
    });
  }

  Widget _buildRatingRow(
    String title,
    int rating,
    Function(int) onRatingChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 14)),
        Row(
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () => onRatingChanged(index + 1),
              child: Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 24,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildFeedbackField() {
    return TextFormField(
      controller: _feedbackController,
      enabled: !widget.boardingEntryEntity.isRating,
      maxLines: 5,
      decoration: InputDecoration(
        hintText:
            widget.boardingEntryEntity.isRating
                ? widget.boardingEntryEntity.feedbackComment ?? ''
                : 'Please enter your feedback',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, BoardingState state) {
    final isLoading = state is RateBoardingLoading;
    final canSubmit = _cleanlinessRating > 0 && _doctorRating > 0;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _feedbackController,
              decoration: InputDecoration(
                hintText: 'Please enter your feedback',
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed:
                (canSubmit && !isLoading) ? () => _submitRating(context) : null,
            child:
                isLoading
                    ? CareLoadingWidget(
                      theme: Theme.of(context),
                      isDark: Theme.of(context).brightness == Brightness.dark,
                      text: S.of(context).loadingInfo,
                    )
                    : const Icon(IconlyLight.send),
          ),
        ],
      ),
    );
  }

  void _submitRating(context) {
    BoardingCubit.get(context).rateBoarding(
      BoardingEntryEntity(
        id: widget.boardingEntryEntity.id,
        entryDate: widget.boardingEntryEntity.entryDate,
        existDate: widget.boardingEntryEntity.existDate,
        period: widget.boardingEntryEntity.period,
        paymentDate: widget.boardingEntryEntity.paymentDate,
        comment: widget.boardingEntryEntity.comment,
        status: widget.boardingEntryEntity.status,
        boardingTypeId: widget.boardingEntryEntity.boardingTypeId,
        boardingType: widget.boardingEntryEntity.boardingType,
        petId: widget.boardingEntryEntity.petId,
        pet: widget.boardingEntryEntity.pet,
        boardingImages: widget.boardingEntryEntity.boardingImages,
        // boardingVideos: widget.boardingEntryEntity.boardingVideos, // added
        clinicPhone: widget.boardingEntryEntity.clinicPhone,
        clinicLocation: widget.boardingEntryEntity.clinicLocation,
        clinicLogo: widget.boardingEntryEntity.clinicLogo,
        clinicCode: widget.boardingEntryEntity.clinicCode,
        clinicName: widget.boardingEntryEntity.clinicName,
        clinicId: widget.boardingEntryEntity.clinicId,
        cleanlinessRate: _cleanlinessRating,
        doctorServiceRate: _doctorRating,
        feedbackComment: _feedbackController.text,
        isRating: true,
        tenantId: widget.boardingEntryEntity.tenantId,
      ),
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }
}
