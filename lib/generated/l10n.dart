// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Email Address`
  String get email {
    return Intl.message('Email Address', name: 'email', desc: '', args: []);
  }

  /// `Address`
  String get address {
    return Intl.message('Address', name: 'address', desc: '', args: []);
  }

  /// `Enter your email address`
  String get enterUrEmail {
    return Intl.message(
      'Enter your email address',
      name: 'enterUrEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter your email or phone number`
  String get enterUrEmailOPhone {
    return Intl.message(
      'Please Enter your email or phone number',
      name: 'enterUrEmailOPhone',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email or phone number`
  String get enterUrEmailORPhone {
    return Intl.message(
      'Enter your email or phone number',
      name: 'enterUrEmailORPhone',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter a valid email or phone number`
  String get enterUrEmailOPhoneValid {
    return Intl.message(
      'Please Enter a valid email or phone number',
      name: 'enterUrEmailOPhoneValid',
      desc: '',
      args: [],
    );
  }

  /// `Check Your Email`
  String get checkYourEmail {
    return Intl.message(
      'Check Your Email',
      name: 'checkYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email to\n Receive the instruction to reset your password`
  String get receiveEmail {
    return Intl.message(
      'Enter your email to\n Receive the instruction to reset your password',
      name: 'receiveEmail',
      desc: '',
      args: [],
    );
  }

  /// `Send me now`
  String get sendMeNow {
    return Intl.message('Send me now', name: 'sendMeNow', desc: '', args: []);
  }

  /// `Enter your password`
  String get enterUrPassword {
    return Intl.message(
      'Enter your password',
      name: 'enterUrPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your address`
  String get enterUrAddress {
    return Intl.message(
      'Enter your address',
      name: 'enterUrAddress',
      desc: '',
      args: [],
    );
  }

  /// `Password more than 6 charts`
  String get enterCharPassword {
    return Intl.message(
      'Password more than 6 charts',
      name: 'enterCharPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `My pets`
  String get myPets {
    return Intl.message('My pets', name: 'myPets', desc: '', args: []);
  }

  /// `Service`
  String get addPetService {
    return Intl.message('Service', name: 'addPetService', desc: '', args: []);
  }

  /// `My favourites`
  String get myFavorites {
    return Intl.message(
      'My favourites',
      name: 'myFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Invite friends`
  String get inviteFriends {
    return Intl.message(
      'Invite friends',
      name: 'inviteFriends',
      desc: '',
      args: [],
    );
  }

  /// `Support`
  String get help {
    return Intl.message('Support', name: 'help', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Sign Out`
  String get signOut {
    return Intl.message('Sign Out', name: 'signOut', desc: '', args: []);
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Male`
  String get male {
    return Intl.message('Male', name: 'male', desc: '', args: []);
  }

  /// `Female`
  String get female {
    return Intl.message('Female', name: 'female', desc: '', args: []);
  }

  /// `Verification`
  String get verification {
    return Intl.message(
      'Verification',
      name: 'verification',
      desc: '',
      args: [],
    );
  }

  /// `We have sent a verification code to`
  String get sentVerification {
    return Intl.message(
      'We have sent a verification code to',
      name: 'sentVerification',
      desc: '',
      args: [],
    );
  }

  /// `Enter the received code`
  String get receiveCode {
    return Intl.message(
      'Enter the received code',
      name: 'receiveCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter code your sent`
  String get enterCode {
    return Intl.message(
      'Enter code your sent',
      name: 'enterCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter your new password`
  String get enterNewPassword {
    return Intl.message(
      'Enter your new password',
      name: 'enterNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your confirm new password`
  String get enterConfirmNewPass {
    return Intl.message(
      'Enter your confirm new password',
      name: 'enterConfirmNewPass',
      desc: '',
      args: [],
    );
  }

  /// `Confirm New Password`
  String get confirmNewPassword {
    return Intl.message(
      'Confirm New Password',
      name: 'confirmNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter confirm your password`
  String get comparePassword {
    return Intl.message(
      'Enter confirm your password',
      name: 'comparePassword',
      desc: '',
      args: [],
    );
  }

  /// `confirm password not equal password`
  String get notEqualPassword {
    return Intl.message(
      'confirm password not equal password',
      name: 'notEqualPassword',
      desc: '',
      args: [],
    );
  }

  /// `By signing up you agree to our Terms of use and Privacy Policy`
  String get terms {
    return Intl.message(
      'By signing up you agree to our Terms of use and Privacy Policy',
      name: 'terms',
      desc: '',
      args: [],
    );
  }

  /// `Sign up as a Doctor`
  String get signUpAsADoctor {
    return Intl.message(
      'Sign up as a Doctor',
      name: 'signUpAsADoctor',
      desc: '',
      args: [],
    );
  }

  /// `Already have account?`
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have account?',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message('Full Name', name: 'fullName', desc: '', args: []);
  }

  /// `Phone`
  String get phone {
    return Intl.message('Phone', name: 'phone', desc: '', args: []);
  }

  /// `Enter your phone`
  String get enterPhone {
    return Intl.message(
      'Enter your phone',
      name: 'enterPhone',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get haveNotAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'haveNotAccount',
      desc: '',
      args: [],
    );
  }

  /// `Update Profile`
  String get updateProfile {
    return Intl.message(
      'Update Profile',
      name: 'updateProfile',
      desc: '',
      args: [],
    );
  }

  /// `LogOut`
  String get logout {
    return Intl.message('LogOut', name: 'logout', desc: '', args: []);
  }

  /// `Forgot password?`
  String get forgotPass {
    return Intl.message(
      'Forgot password?',
      name: 'forgotPass',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid email`
  String get enterAValidEm {
    return Intl.message(
      'Enter a valid email',
      name: 'enterAValidEm',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message('Sign Up', name: 'signUp', desc: '', args: []);
  }

  /// `Enter your Full Name`
  String get enterName {
    return Intl.message(
      'Enter your Full Name',
      name: 'enterName',
      desc: '',
      args: [],
    );
  }

  /// `name more than 6 charts `
  String get enterCharNamePls {
    return Intl.message(
      'name more than 6 charts ',
      name: 'enterCharNamePls',
      desc: '',
      args: [],
    );
  }

  /// `Create Post `
  String get createPost {
    return Intl.message('Create Post ', name: 'createPost', desc: '', args: []);
  }

  /// `What\'s on your mind ?`
  String get labelPost {
    return Intl.message(
      'What\\\'s on your mind ?',
      name: 'labelPost',
      desc: '',
      args: [],
    );
  }

  /// `Add Reminder`
  String get addRecord {
    return Intl.message('Add Reminder', name: 'addRecord', desc: '', args: []);
  }

  /// `Add Pet`
  String get addPet {
    return Intl.message('Add Pet', name: 'addPet', desc: '', args: []);
  }

  /// `Pet Name`
  String get petName {
    return Intl.message('Pet Name', name: 'petName', desc: '', args: []);
  }

  /// `Name Of Record`
  String get NameOfRecord {
    return Intl.message(
      'Name Of Record',
      name: 'NameOfRecord',
      desc: '',
      args: [],
    );
  }

  /// `Data`
  String get DateOfRecord {
    return Intl.message('Data', name: 'DateOfRecord', desc: '', args: []);
  }

  /// `Time`
  String get TimeOfRecord {
    return Intl.message('Time', name: 'TimeOfRecord', desc: '', args: []);
  }

  /// `Appointments`
  String get yourAppointments {
    return Intl.message(
      'Appointments',
      name: 'yourAppointments',
      desc: '',
      args: [],
    );
  }

  /// `Add Service Supplier`
  String get AddServiceSupplier {
    return Intl.message(
      'Add Service Supplier',
      name: 'AddServiceSupplier',
      desc: '',
      args: [],
    );
  }

  /// `Service Name`
  String get ServiceName {
    return Intl.message(
      'Service Name',
      name: 'ServiceName',
      desc: '',
      args: [],
    );
  }

  /// `Service Phone`
  String get ServicePhone {
    return Intl.message(
      'Service Phone',
      name: 'ServicePhone',
      desc: '',
      args: [],
    );
  }

  /// `Service location`
  String get ServiceLocation {
    return Intl.message(
      'Service location',
      name: 'ServiceLocation',
      desc: '',
      args: [],
    );
  }

  /// `Add Service Image`
  String get ServiceImage {
    return Intl.message(
      'Add Service Image',
      name: 'ServiceImage',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// ` Add Service`
  String get searchValid {
    return Intl.message(
      ' Add Service',
      name: 'searchValid',
      desc: '',
      args: [],
    );
  }

  /// `Search For Service`
  String get searchFor {
    return Intl.message(
      'Search For Service',
      name: 'searchFor',
      desc: '',
      args: [],
    );
  }

  /// ` Verify Phone`
  String get VerifyPhone {
    return Intl.message(
      ' Verify Phone',
      name: 'VerifyPhone',
      desc: '',
      args: [],
    );
  }

  /// `Add  Your Comment . . . .`
  String get addComment {
    return Intl.message(
      'Add  Your Comment . . . .',
      name: 'addComment',
      desc: '',
      args: [],
    );
  }

  /// `Add  Reply  Comment . . . .`
  String get addReplayComment {
    return Intl.message(
      'Add  Reply  Comment . . . .',
      name: 'addReplayComment',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Follow Confirmation`
  String get followConfirmation {
    return Intl.message(
      'Follow Confirmation',
      name: 'followConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Unfollow Confirmation`
  String get unfollowConfirmation {
    return Intl.message(
      'Unfollow Confirmation',
      name: 'unfollowConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Unfollow`
  String get unfollow {
    return Intl.message('Unfollow', name: 'unfollow', desc: '', args: []);
  }

  /// `Cancel`
  String get cancelFollow {
    return Intl.message('Cancel', name: 'cancelFollow', desc: '', args: []);
  }

  /// `Publish`
  String get publish {
    return Intl.message('Publish', name: 'publish', desc: '', args: []);
  }

  /// `What are you thinking .... ?`
  String get enterYourText {
    return Intl.message(
      'What are you thinking .... ?',
      name: 'enterYourText',
      desc: '',
      args: [],
    );
  }

  /// `Species`
  String get species {
    return Intl.message('Species', name: 'species', desc: '', args: []);
  }

  /// `Clinics`
  String get yourClinic {
    return Intl.message('Clinics', name: 'yourClinic', desc: '', args: []);
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Speciality`
  String get speciality {
    return Intl.message('Speciality', name: 'speciality', desc: '', args: []);
  }

  /// `Location`
  String get addressCity {
    return Intl.message('Location', name: 'addressCity', desc: '', args: []);
  }

  /// `Your Profile`
  String get profile {
    return Intl.message('Your Profile', name: 'profile', desc: '', args: []);
  }

  /// `Dark Mode`
  String get darkMode {
    return Intl.message('Dark Mode', name: 'darkMode', desc: '', args: []);
  }

  /// `language Mode`
  String get langMode {
    return Intl.message('language Mode', name: 'langMode', desc: '', args: []);
  }

  /// `Remove Clinic`
  String get removeClinic {
    return Intl.message(
      'Remove Clinic',
      name: 'removeClinic',
      desc: '',
      args: [],
    );
  }

  /// `Add available times`
  String get addAvailabilities {
    return Intl.message(
      'Add available times',
      name: 'addAvailabilities',
      desc: '',
      args: [],
    );
  }

  /// `Open At`
  String get openAt {
    return Intl.message('Open At', name: 'openAt', desc: '', args: []);
  }

  /// `Close In`
  String get closeIn {
    return Intl.message('Close In', name: 'closeIn', desc: '', args: []);
  }

  /// `Booking`
  String get booking {
    return Intl.message('Booking', name: 'booking', desc: '', args: []);
  }

  /// `Add Appointment`
  String get addAppointment {
    return Intl.message(
      'Add Appointment',
      name: 'addAppointment',
      desc: '',
      args: [],
    );
  }

  /// `Choose Pet`
  String get chosePet {
    return Intl.message('Choose Pet', name: 'chosePet', desc: '', args: []);
  }

  /// `Time`
  String get time {
    return Intl.message('Time', name: 'time', desc: '', args: []);
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `Update Appointment`
  String get updateAppointment {
    return Intl.message(
      'Update Appointment',
      name: 'updateAppointment',
      desc: '',
      args: [],
    );
  }

  /// `General Information`
  String get generalInformation {
    return Intl.message(
      'General Information',
      name: 'generalInformation',
      desc: '',
      args: [],
    );
  }

  /// `Doctor Name`
  String get doctorName {
    return Intl.message('Doctor Name', name: 'doctorName', desc: '', args: []);
  }

  /// `Edit Comment . . . .`
  String get editComment {
    return Intl.message(
      'Edit Comment . . . .',
      name: 'editComment',
      desc: '',
      args: [],
    );
  }

  /// `reply`
  String get reply {
    return Intl.message('reply', name: 'reply', desc: '', args: []);
  }

  /// `Comments`
  String get comments {
    return Intl.message('Comments', name: 'comments', desc: '', args: []);
  }

  /// `Delete Comment`
  String get deleteComment {
    return Intl.message(
      'Delete Comment',
      name: 'deleteComment',
      desc: '',
      args: [],
    );
  }

  /// `Comment Reply`
  String get commentReply {
    return Intl.message(
      'Comment Reply',
      name: 'commentReply',
      desc: '',
      args: [],
    );
  }

  /// `Your Upcoming Appointments`
  String get yourUpcomingAppointments {
    return Intl.message(
      'Your Upcoming Appointments',
      name: 'yourUpcomingAppointments',
      desc: '',
      args: [],
    );
  }

  /// `breed`
  String get breed {
    return Intl.message('breed', name: 'breed', desc: '', args: []);
  }

  /// `gender`
  String get gender {
    return Intl.message('gender', name: 'gender', desc: '', args: []);
  }

  /// `Unique Code`
  String get uniqueCode {
    return Intl.message('Unique Code', name: 'uniqueCode', desc: '', args: []);
  }

  /// `location`
  String get location {
    return Intl.message('location', name: 'location', desc: '', args: []);
  }

  /// `city`
  String get city {
    return Intl.message('city', name: 'city', desc: '', args: []);
  }

  /// `Remove post`
  String get removePost {
    return Intl.message('Remove post', name: 'removePost', desc: '', args: []);
  }

  /// `Send`
  String get send {
    return Intl.message('Send', name: 'send', desc: '', args: []);
  }

  /// `Clinic Doctors`
  String get clinicDoctor {
    return Intl.message(
      'Clinic Doctors',
      name: 'clinicDoctor',
      desc: '',
      args: [],
    );
  }

  /// `testEN`
  String get gaber {
    return Intl.message('testEN', name: 'gaber', desc: '', args: []);
  }

  /// `Done`
  String get appointmentStatus {
    return Intl.message('Done', name: 'appointmentStatus', desc: '', args: []);
  }

  /// `Reserved`
  String get appointmentReserved {
    return Intl.message(
      'Reserved',
      name: 'appointmentReserved',
      desc: '',
      args: [],
    );
  }

  /// `Canceled`
  String get appointmentCanceled {
    return Intl.message(
      'Canceled',
      name: 'appointmentCanceled',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get appointmentDone {
    return Intl.message('Done', name: 'appointmentDone', desc: '', args: []);
  }

  /// `clinic exam`
  String get appointmentExamination {
    return Intl.message(
      'clinic exam',
      name: 'appointmentExamination',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get appointmentButtonCancel {
    return Intl.message(
      'Cancel',
      name: 'appointmentButtonCancel',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get appointmentButtonEdit {
    return Intl.message(
      'Edit',
      name: 'appointmentButtonEdit',
      desc: '',
      args: [],
    );
  }

  /// `Call`
  String get appointmentButtonCall {
    return Intl.message(
      'Call',
      name: 'appointmentButtonCall',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Confirmation`
  String get appointmentModalTitle {
    return Intl.message(
      'Cancel Confirmation',
      name: 'appointmentModalTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to cancel Appointment to`
  String get appointmentModalDescription {
    return Intl.message(
      'Are you sure you want to cancel Appointment to',
      name: 'appointmentModalDescription',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get appointmentModalButtonYes {
    return Intl.message(
      'Yes',
      name: 'appointmentModalButtonYes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get appointmentModalButtonNo {
    return Intl.message(
      'No',
      name: 'appointmentModalButtonNo',
      desc: '',
      args: [],
    );
  }

  /// `Book again`
  String get appointmentButtonBooking {
    return Intl.message(
      'Book again',
      name: 'appointmentButtonBooking',
      desc: '',
      args: [],
    );
  }

  /// `Update App ?`
  String get updateVersionModuleTitle {
    return Intl.message(
      'Update App ?',
      name: 'updateVersionModuleTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your app needs to be updated\n`
  String get updateVersionModuleContent {
    return Intl.message(
      'Your app needs to be updated\n',
      name: 'updateVersionModuleContent',
      desc: '',
      args: [],
    );
  }

  /// `This version of the application is outdated.\nPlease go to the store to update`
  String get updateVersionModuleContent2 {
    return Intl.message(
      'This version of the application is outdated.\nPlease go to the store to update',
      name: 'updateVersionModuleContent2',
      desc: '',
      args: [],
    );
  }

  /// `IGNORE`
  String get updateVersionModuleButtonIgnore {
    return Intl.message(
      'IGNORE',
      name: 'updateVersionModuleButtonIgnore',
      desc: '',
      args: [],
    );
  }

  /// `LATER`
  String get updateVersionModuleButtonLater {
    return Intl.message(
      'LATER',
      name: 'updateVersionModuleButtonLater',
      desc: '',
      args: [],
    );
  }

  /// `UPDATE NOW`
  String get updateVersionModuleButtonUpdateNow {
    return Intl.message(
      'UPDATE NOW',
      name: 'updateVersionModuleButtonUpdateNow',
      desc: '',
      args: [],
    );
  }

  /// `No Appointments`
  String get noAppointment {
    return Intl.message(
      'No Appointments',
      name: 'noAppointment',
      desc: '',
      args: [],
    );
  }

  /// `Choose..`
  String get addPetChoose {
    return Intl.message('Choose..', name: 'addPetChoose', desc: '', args: []);
  }

  /// `Version`
  String get versionNumber {
    return Intl.message('Version', name: 'versionNumber', desc: '', args: []);
  }

  /// `Search`
  String get HomePageSearchText {
    return Intl.message(
      'Search',
      name: 'HomePageSearchText',
      desc: '',
      args: [],
    );
  }

  /// `Search For Your Doctor`
  String get HomePageSearchText2 {
    return Intl.message(
      'Search For Your Doctor',
      name: 'HomePageSearchText2',
      desc: '',
      args: [],
    );
  }

  /// `You have already followed this clinic before`
  String get clinicFollowedBefore {
    return Intl.message(
      'You have already followed this clinic before',
      name: 'clinicFollowedBefore',
      desc: '',
      args: [],
    );
  }

  /// `No Internet Connection`
  String get offlineMessagesTitle {
    return Intl.message(
      'No Internet Connection',
      name: 'offlineMessagesTitle',
      desc: '',
      args: [],
    );
  }

  /// ` check your internet connection and try again`
  String get offlineMessagesContent {
    return Intl.message(
      ' check your internet connection and try again',
      name: 'offlineMessagesContent',
      desc: '',
      args: [],
    );
  }

  /// `Start Appointment`
  String get startAppointment {
    return Intl.message(
      'Start Appointment',
      name: 'startAppointment',
      desc: '',
      args: [],
    );
  }

  /// `Your Feedback`
  String get reviewTitle {
    return Intl.message(
      'Your Feedback',
      name: 'reviewTitle',
      desc: '',
      args: [],
    );
  }

  /// `Help us to provide the best care for your beloved pets.`
  String get reviewDescription {
    return Intl.message(
      'Help us to provide the best care for your beloved pets.',
      name: 'reviewDescription',
      desc: '',
      args: [],
    );
  }

  /// `Cleanliness of the Clinic`
  String get CleanlinessOfClinic {
    return Intl.message(
      'Cleanliness of the Clinic',
      name: 'CleanlinessOfClinic',
      desc: '',
      args: [],
    );
  }

  /// `Doctor's Service`
  String get DoctorService {
    return Intl.message(
      'Doctor\'s Service',
      name: 'DoctorService',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Your review has been submitted successfully.`
  String get reviewMessage {
    return Intl.message(
      'Your review has been submitted successfully.',
      name: 'reviewMessage',
      desc: '',
      args: [],
    );
  }

  /// `You can view your review by Appointment Screen.`
  String get reviewMessage2 {
    return Intl.message(
      'You can view your review by Appointment Screen.',
      name: 'reviewMessage2',
      desc: '',
      args: [],
    );
  }

  /// `Clinic`
  String get clinic {
    return Intl.message('Clinic', name: 'clinic', desc: '', args: []);
  }

  /// `Invoice No`
  String get invoiceNo {
    return Intl.message('Invoice No', name: 'invoiceNo', desc: '', args: []);
  }

  /// `Tax ID`
  String get taxId {
    return Intl.message('Tax ID', name: 'taxId', desc: '', args: []);
  }

  /// `Pet Details`
  String get petDetails {
    return Intl.message('Pet Details', name: 'petDetails', desc: '', args: []);
  }

  /// `Item Name`
  String get itemName {
    return Intl.message('Item Name', name: 'itemName', desc: '', args: []);
  }

  /// `price`
  String get price {
    return Intl.message('price', name: 'price', desc: '', args: []);
  }

  /// `Pet`
  String get pet {
    return Intl.message('Pet', name: 'pet', desc: '', args: []);
  }

  /// `Species`
  String get speciesOne {
    return Intl.message('Species', name: 'speciesOne', desc: '', args: []);
  }

  /// `Sex`
  String get sex {
    return Intl.message('Sex', name: 'sex', desc: '', args: []);
  }

  /// `Owner Details`
  String get ownerDetails {
    return Intl.message(
      'Owner Details',
      name: 'ownerDetails',
      desc: '',
      args: [],
    );
  }

  /// `Qty`
  String get qty {
    return Intl.message('Qty', name: 'qty', desc: '', args: []);
  }

  /// `Total`
  String get total {
    return Intl.message('Total', name: 'total', desc: '', args: []);
  }

  /// `Total Invoice`
  String get totalAmount {
    return Intl.message(
      'Total Invoice',
      name: 'totalAmount',
      desc: '',
      args: [],
    );
  }

  /// `Paid`
  String get paid {
    return Intl.message('Paid', name: 'paid', desc: '', args: []);
  }

  /// `vat`
  String get vat {
    return Intl.message('vat', name: 'vat', desc: '', args: []);
  }

  /// `Return & Exchange Policy: Items can be returned within 3 days of purchase with receipt. Medical products are non-refundable.`
  String get returnPolicy {
    return Intl.message(
      'Return & Exchange Policy: Items can be returned within 3 days of purchase with receipt. Medical products are non-refundable.',
      name: 'returnPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get paymentType {
    return Intl.message('Type', name: 'paymentType', desc: '', args: []);
  }

  /// `Payment`
  String get payment {
    return Intl.message('Payment', name: 'payment', desc: '', args: []);
  }

  /// `Value`
  String get value {
    return Intl.message('Value', name: 'value', desc: '', args: []);
  }

  /// `Or login as a doctor`
  String get Orloginasadoctor {
    return Intl.message(
      'Or login as a doctor',
      name: 'Orloginasadoctor',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters long`
  String get PASSWORD_MIN_LENGTH {
    return Intl.message(
      'Password must be at least 6 characters long',
      name: 'PASSWORD_MIN_LENGTH',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address`
  String get email_hint {
    return Intl.message(
      'Enter your email address',
      name: 'email_hint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address`
  String get email_validation {
    return Intl.message(
      'Please enter a valid email address',
      name: 'email_validation',
      desc: '',
      args: [],
    );
  }

  /// `Please enter email address`
  String get email_valid {
    return Intl.message(
      'Please enter email address',
      name: 'email_valid',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number`
  String get phone_hint {
    return Intl.message(
      'Enter your phone number',
      name: 'phone_hint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your phone number`
  String get phone_validation {
    return Intl.message(
      'Please enter your phone number',
      name: 'phone_validation',
      desc: '',
      args: [],
    );
  }

  /// `Enter your full name`
  String get name_hint {
    return Intl.message(
      'Enter your full name',
      name: 'name_hint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your name`
  String get name_validation {
    return Intl.message(
      'Please enter your name',
      name: 'name_validation',
      desc: '',
      args: [],
    );
  }

  /// `Enter the title`
  String get title_hint {
    return Intl.message(
      'Enter the title',
      name: 'title_hint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a title`
  String get title_validation {
    return Intl.message(
      'Please enter a title',
      name: 'title_validation',
      desc: '',
      args: [],
    );
  }

  /// `Enter your message`
  String get message_hint {
    return Intl.message(
      'Enter your message',
      name: 'message_hint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a message`
  String get message_validation {
    return Intl.message(
      'Please enter a message',
      name: 'message_validation',
      desc: '',
      args: [],
    );
  }

  /// `Enter your address`
  String get address_hint {
    return Intl.message(
      'Enter your address',
      name: 'address_hint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your address`
  String get address_validation {
    return Intl.message(
      'Please enter your address',
      name: 'address_validation',
      desc: '',
      args: [],
    );
  }

  /// `Select a service`
  String get service_hint {
    return Intl.message(
      'Select a service',
      name: 'service_hint',
      desc: '',
      args: [],
    );
  }

  /// `Please select a service`
  String get service_validation {
    return Intl.message(
      'Please select a service',
      name: 'service_validation',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get password_hint {
    return Intl.message(
      'Enter your password',
      name: 'password_hint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a password`
  String get password_validation {
    return Intl.message(
      'Please enter a password',
      name: 'password_validation',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number or password`
  String get phone_or_password_hint {
    return Intl.message(
      'Enter your phone number or password',
      name: 'phone_or_password_hint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your phone number or password`
  String get phone_or_password_validation {
    return Intl.message(
      'Please enter your phone number or password',
      name: 'phone_or_password_validation',
      desc: '',
      args: [],
    );
  }

  /// `Enter your birthdate`
  String get birthdate_hint {
    return Intl.message(
      'Enter your birthdate',
      name: 'birthdate_hint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your birthdate`
  String get birthdate_validation {
    return Intl.message(
      'Please enter your birthdate',
      name: 'birthdate_validation',
      desc: '',
      args: [],
    );
  }

  /// `Enter your pet's birthdate`
  String get pet_birthdate_hint {
    return Intl.message(
      'Enter your pet\'s birthdate',
      name: 'pet_birthdate_hint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your pet's birthdate`
  String get pet_birthdate_validation {
    return Intl.message(
      'Please enter your pet\'s birthdate',
      name: 'pet_birthdate_validation',
      desc: '',
      args: [],
    );
  }

  /// `Filter by pet`
  String get filter_hint_pets {
    return Intl.message(
      'Filter by pet',
      name: 'filter_hint_pets',
      desc: '',
      args: [],
    );
  }

  /// `Filter by status`
  String get filter_hint_State {
    return Intl.message(
      'Filter by status',
      name: 'filter_hint_State',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get appointmentsAll {
    return Intl.message('All', name: 'appointmentsAll', desc: '', args: []);
  }

  /// `Reserved`
  String get appointmentsReserved {
    return Intl.message(
      'Reserved',
      name: 'appointmentsReserved',
      desc: '',
      args: [],
    );
  }

  /// `Attended`
  String get appointmentsAttended {
    return Intl.message(
      'Attended',
      name: 'appointmentsAttended',
      desc: '',
      args: [],
    );
  }

  /// `Start Examination`
  String get appointmentsStartExamination {
    return Intl.message(
      'Start Examination',
      name: 'appointmentsStartExamination',
      desc: '',
      args: [],
    );
  }

  /// `End Examination`
  String get appointmentsEndExamination {
    return Intl.message(
      'End Examination',
      name: 'appointmentsEndExamination',
      desc: '',
      args: [],
    );
  }

  /// `Finished`
  String get appointmentsFinished {
    return Intl.message(
      'Finished',
      name: 'appointmentsFinished',
      desc: '',
      args: [],
    );
  }

  /// `Canceled`
  String get appointmentsCanceled {
    return Intl.message(
      'Canceled',
      name: 'appointmentsCanceled',
      desc: '',
      args: [],
    );
  }

  /// `CR`
  String get crNumber {
    return Intl.message('CR', name: 'crNumber', desc: '', args: []);
  }

  /// `Swipe left or right to select a pet`
  String get swapPet {
    return Intl.message(
      'Swipe left or right to select a pet',
      name: 'swapPet',
      desc: '',
      args: [],
    );
  }

  /// `Go to clinics`
  String get goToClinicsFromPetsScreen {
    return Intl.message(
      'Go to clinics',
      name: 'goToClinicsFromPetsScreen',
      desc: '',
      args: [],
    );
  }

  /// `Files And Prescription`
  String get filesAndPrescription {
    return Intl.message(
      'Files And Prescription',
      name: 'filesAndPrescription',
      desc: '',
      args: [],
    );
  }

  /// `Bill`
  String get bill {
    return Intl.message('Bill', name: 'bill', desc: '', args: []);
  }

  /// `Rate`
  String get rate {
    return Intl.message('Rate', name: 'rate', desc: '', args: []);
  }

  /// `Prescription`
  String get prescription {
    return Intl.message(
      'Prescription',
      name: 'prescription',
      desc: '',
      args: [],
    );
  }

  /// `Files`
  String get files {
    return Intl.message('Files', name: 'files', desc: '', args: []);
  }

  /// `Follow Code`
  String get followCode {
    return Intl.message('Follow Code', name: 'followCode', desc: '', args: []);
  }

  /// `Please enter your reminder type`
  String get reminderOtherHintText {
    return Intl.message(
      'Please enter your reminder type',
      name: 'reminderOtherHintText',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid title`
  String get other_valid {
    return Intl.message(
      'Please enter valid title',
      name: 'other_valid',
      desc: '',
      args: [],
    );
  }

  /// `the range is from 1 - 30 char`
  String get other_valid_more_than_30_char {
    return Intl.message(
      'the range is from 1 - 30 char',
      name: 'other_valid_more_than_30_char',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
