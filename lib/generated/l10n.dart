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
    final name = (locale.countryCode?.isEmpty ?? false)
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

  /// `All Appointments`
  String get allYourAppointments {
    return Intl.message(
      'All Appointments',
      name: 'allYourAppointments',
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

  /// `Follow`
  String get follow {
    return Intl.message('Follow', name: 'follow', desc: '', args: []);
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

  /// `Edit Comment`
  String get editCommentPost {
    return Intl.message(
      'Edit Comment',
      name: 'editCommentPost',
      desc: '',
      args: [],
    );
  }

  /// `Edit Reply Comment`
  String get editReplyCommentPost {
    return Intl.message(
      'Edit Reply Comment',
      name: 'editReplyCommentPost',
      desc: '',
      args: [],
    );
  }

  /// `Reply`
  String get reply {
    return Intl.message('Reply', name: 'reply', desc: '', args: []);
  }

  /// `View 1 reply`
  String get view1Reply {
    return Intl.message('View 1 reply', name: 'view1Reply', desc: '', args: []);
  }

  /// `View {count} replies`
  String viewReplies(Object count) {
    return Intl.message(
      'View $count replies',
      name: 'viewReplies',
      desc: '',
      args: [count],
    );
  }

  /// `replies`
  String get replies {
    return Intl.message('replies', name: 'replies', desc: '', args: []);
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

  /// `Spayed`
  String get spayed {
    return Intl.message('Spayed', name: 'spayed', desc: '', args: []);
  }

  /// `Unspayed`
  String get notSpayed {
    return Intl.message('Unspayed', name: 'notSpayed', desc: '', args: []);
  }

  /// `Spayed`
  String get sterilization {
    return Intl.message('Spayed', name: 'sterilization', desc: '', args: []);
  }

  /// `Edit Pet`
  String get editPet {
    return Intl.message('Edit Pet', name: 'editPet', desc: '', args: []);
  }

  /// `Enter pet name`
  String get enterPetName {
    return Intl.message(
      'Enter pet name',
      name: 'enterPetName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter pet name`
  String get enterPetNameValidation {
    return Intl.message(
      'Please enter pet name',
      name: 'enterPetNameValidation',
      desc: '',
      args: [],
    );
  }

  /// `Birth Date`
  String get birthdate {
    return Intl.message('Birth Date', name: 'birthdate', desc: '', args: []);
  }

  /// `Please enter date of birth`
  String get birthdateValidation {
    return Intl.message(
      'Please enter date of birth',
      name: 'birthdateValidation',
      desc: '',
      args: [],
    );
  }

  /// `Delete Photo`
  String get deletePhoto {
    return Intl.message(
      'Delete Photo',
      name: 'deletePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Change Photo`
  String get changePhoto {
    return Intl.message(
      'Change Photo',
      name: 'changePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Cancel Friend`
  String get cancelFriend {
    return Intl.message(
      'Cancel Friend',
      name: 'cancelFriend',
      desc: '',
      args: [],
    );
  }

  /// `Delete Confirmation`
  String get deleteConfirmation {
    return Intl.message(
      'Delete Confirmation',
      name: 'deleteConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Pet Deleted Successfully`
  String get petDeletedSuccessfully {
    return Intl.message(
      'Pet Deleted Successfully',
      name: 'petDeletedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Select Pet Type`
  String get selectPetType {
    return Intl.message(
      'Select Pet Type',
      name: 'selectPetType',
      desc: '',
      args: [],
    );
  }

  /// `No Pets Found`
  String get noPetsFound {
    return Intl.message(
      'No Pets Found',
      name: 'noPetsFound',
      desc: '',
      args: [],
    );
  }

  /// `Add Your First Pet`
  String get addYourFirstPet {
    return Intl.message(
      'Add Your First Pet',
      name: 'addYourFirstPet',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message('About', name: 'about', desc: '', args: []);
  }

  /// `Could not open link`
  String get couldNotOpenLink {
    return Intl.message(
      'Could not open link',
      name: 'couldNotOpenLink',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get version {
    return Intl.message('Version', name: 'version', desc: '', args: []);
  }

  /// `Failed to load version`
  String get failedToLoadVersion {
    return Intl.message(
      'Failed to load version',
      name: 'failedToLoadVersion',
      desc: '',
      args: [],
    );
  }

  /// `Trademark Information`
  String get trademarkInfo {
    return Intl.message(
      'Trademark Information',
      name: 'trademarkInfo',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `© 2023 Quad Insight. All rights reserved`
  String get copyright {
    return Intl.message(
      '© 2023 Quad Insight. All rights reserved',
      name: 'copyright',
      desc: '',
      args: [],
    );
  }

  /// `Last updated`
  String get lastUpdated {
    return Intl.message(
      'Last updated',
      name: 'lastUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Information We Collect`
  String get infoWeCollect {
    return Intl.message(
      'Information We Collect',
      name: 'infoWeCollect',
      desc: '',
      args: [],
    );
  }

  /// `We may collect the following types of information:`
  String get infoWeCollectDesc {
    return Intl.message(
      'We may collect the following types of information:',
      name: 'infoWeCollectDesc',
      desc: '',
      args: [],
    );
  }

  /// `Personal identification information (Name, email address, phone number, etc.)`
  String get personalInfo {
    return Intl.message(
      'Personal identification information (Name, email address, phone number, etc.)',
      name: 'personalInfo',
      desc: '',
      args: [],
    );
  }

  /// `How We Use Your Information`
  String get howWeUse {
    return Intl.message(
      'How We Use Your Information',
      name: 'howWeUse',
      desc: '',
      args: [],
    );
  }

  /// `Your information is used to provide and improve our services.`
  String get howWeUseDesc {
    return Intl.message(
      'Your information is used to provide and improve our services.',
      name: 'howWeUseDesc',
      desc: '',
      args: [],
    );
  }

  /// `Information Protection`
  String get infoProtection {
    return Intl.message(
      'Information Protection',
      name: 'infoProtection',
      desc: '',
      args: [],
    );
  }

  /// `We take data security seriously and implement appropriate measures to safeguard your personal information against unauthorized access, alteration, or disclosure.`
  String get infoProtectionDesc {
    return Intl.message(
      'We take data security seriously and implement appropriate measures to safeguard your personal information against unauthorized access, alteration, or disclosure.',
      name: 'infoProtectionDesc',
      desc: '',
      args: [],
    );
  }

  /// `Sharing Your Information`
  String get sharingInfo {
    return Intl.message(
      'Sharing Your Information',
      name: 'sharingInfo',
      desc: '',
      args: [],
    );
  }

  /// `We do not sell or trade your personal information. However, we may share certain information with trusted third-party service providers to support and improve our services. These providers are required to adhere to strict data protection standards and are only permitted to use the information for the purposes outlined in our privacy policy.`
  String get sharingInfoDesc {
    return Intl.message(
      'We do not sell or trade your personal information. However, we may share certain information with trusted third-party service providers to support and improve our services. These providers are required to adhere to strict data protection standards and are only permitted to use the information for the purposes outlined in our privacy policy.',
      name: 'sharingInfoDesc',
      desc: '',
      args: [],
    );
  }

  /// `Data Security and Privacy`
  String get dataSecurity {
    return Intl.message(
      'Data Security and Privacy',
      name: 'dataSecurity',
      desc: '',
      args: [],
    );
  }

  /// `Your privacy and the security of your clinic's data are of utmost importance to us. We implement industry-standard security measures to protect your data against unauthorized access, alteration, and disclosure. Our systems are regularly updated to address potential vulnerabilities and ensure the highest level of protection.`
  String get dataSecurityDesc {
    return Intl.message(
      'Your privacy and the security of your clinic\'s data are of utmost importance to us. We implement industry-standard security measures to protect your data against unauthorized access, alteration, and disclosure. Our systems are regularly updated to address potential vulnerabilities and ensure the highest level of protection.',
      name: 'dataSecurityDesc',
      desc: '',
      args: [],
    );
  }

  /// `User Control Over Data`
  String get userControl {
    return Intl.message(
      'User Control Over Data',
      name: 'userControl',
      desc: '',
      args: [],
    );
  }

  /// `You have full control over the data you share with us. You can update, modify, or delete your personal and clinic information at any time through our platform. We provide clear settings and options for managing your data to ensure you are always in control of what information is stored and shared.`
  String get userControlDesc {
    return Intl.message(
      'You have full control over the data you share with us. You can update, modify, or delete your personal and clinic information at any time through our platform. We provide clear settings and options for managing your data to ensure you are always in control of what information is stored and shared.',
      name: 'userControlDesc',
      desc: '',
      args: [],
    );
  }

  /// `Data Encryption`
  String get dataEncryption {
    return Intl.message(
      'Data Encryption',
      name: 'dataEncryption',
      desc: '',
      args: [],
    );
  }

  /// `All data transmitted between our application and our servers is encrypted using secure protocols (such as HTTPS). Additionally, sensitive information, including your clinic's data and payment information, is encrypted and securely stored to prevent unauthorized access.`
  String get dataEncryptionDesc {
    return Intl.message(
      'All data transmitted between our application and our servers is encrypted using secure protocols (such as HTTPS). Additionally, sensitive information, including your clinic\'s data and payment information, is encrypted and securely stored to prevent unauthorized access.',
      name: 'dataEncryptionDesc',
      desc: '',
      args: [],
    );
  }

  /// `Compliance with Data Protection Regulations`
  String get compliance {
    return Intl.message(
      'Compliance with Data Protection Regulations',
      name: 'compliance',
      desc: '',
      args: [],
    );
  }

  /// `We comply with relevant data protection laws and regulations.`
  String get complianceDesc {
    return Intl.message(
      'We comply with relevant data protection laws and regulations.',
      name: 'complianceDesc',
      desc: '',
      args: [],
    );
  }

  /// `Data Retention Policy`
  String get dataRetention {
    return Intl.message(
      'Data Retention Policy',
      name: 'dataRetention',
      desc: '',
      args: [],
    );
  }

  /// `We retain your data only for as long as necessary to provide you with our services and for legitimate business purposes, such as maintaining records for financial, legal, or compliance reasons. Once the data is no longer needed, we take steps to securely delete or anonymize it.`
  String get dataRetentionDesc {
    return Intl.message(
      'We retain your data only for as long as necessary to provide you with our services and for legitimate business purposes, such as maintaining records for financial, legal, or compliance reasons. Once the data is no longer needed, we take steps to securely delete or anonymize it.',
      name: 'dataRetentionDesc',
      desc: '',
      args: [],
    );
  }

  /// `Regular Security Audits`
  String get securityAudits {
    return Intl.message(
      'Regular Security Audits',
      name: 'securityAudits',
      desc: '',
      args: [],
    );
  }

  /// `We conduct regular security audits to identify and address potential security risks. Our team is dedicated to continuously monitoring and enhancing our security measures to ensure the safety and privacy of your clinic's data.`
  String get securityAuditsDesc {
    return Intl.message(
      'We conduct regular security audits to identify and address potential security risks. Our team is dedicated to continuously monitoring and enhancing our security measures to ensure the safety and privacy of your clinic\'s data.',
      name: 'securityAuditsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us About Privacy`
  String get contactPrivacy {
    return Intl.message(
      'Contact Us About Privacy',
      name: 'contactPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `If you have any concerns or questions about how we handle your data or if you would like to exercise your data rights, please contact our privacy team at support@veticare.com. We are here to ensure that you feel confident and secure in using our services.`
  String get contactPrivacyDesc {
    return Intl.message(
      'If you have any concerns or questions about how we handle your data or if you would like to exercise your data rights, please contact our privacy team at support@veticare.com. We are here to ensure that you feel confident and secure in using our services.',
      name: 'contactPrivacyDesc',
      desc: '',
      args: [],
    );
  }

  /// `Update Notification`
  String get updateNotification {
    return Intl.message(
      'Update Notification',
      name: 'updateNotification',
      desc: '',
      args: [],
    );
  }

  /// `We may update our privacy policy from time to time. When we do, we will notify you by posting the new policy on this page. It is your responsibility to review this privacy policy periodically for any changes.`
  String get updateNotificationDesc {
    return Intl.message(
      'We may update our privacy policy from time to time. When we do, we will notify you by posting the new policy on this page. It is your responsibility to review this privacy policy periodically for any changes.',
      name: 'updateNotificationDesc',
      desc: '',
      args: [],
    );
  }

  /// `Your Consent`
  String get yourConsent {
    return Intl.message(
      'Your Consent',
      name: 'yourConsent',
      desc: '',
      args: [],
    );
  }

  /// `By using our app, you consent to our privacy policy.`
  String get yourConsentDesc {
    return Intl.message(
      'By using our app, you consent to our privacy policy.',
      name: 'yourConsentDesc',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contactUs {
    return Intl.message('Contact Us', name: 'contactUs', desc: '', args: []);
  }

  /// `If you have any questions about this privacy policy, please contact us at support@veticare.com.`
  String get contactUsDesc {
    return Intl.message(
      'If you have any questions about this privacy policy, please contact us at support@veticare.com.',
      name: 'contactUsDesc',
      desc: '',
      args: [],
    );
  }

  /// `© 2024 VetICare. All rights reserved.`
  String get copyright2 {
    return Intl.message(
      '© 2024 VetICare. All rights reserved.',
      name: 'copyright2',
      desc: '',
      args: [],
    );
  }

  /// `Email copied to clipboard`
  String get emailCopied {
    return Intl.message(
      'Email copied to clipboard',
      name: 'emailCopied',
      desc: '',
      args: [],
    );
  }

  /// `Personalization`
  String get personalization {
    return Intl.message(
      'Personalization',
      name: 'personalization',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Set the app language`
  String get setLanguage {
    return Intl.message(
      'Set the app language',
      name: 'setLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Choose view mode`
  String get chooseViewMode {
    return Intl.message(
      'Choose view mode',
      name: 'chooseViewMode',
      desc: '',
      args: [],
    );
  }

  /// `Notifications Alert`
  String get notificationsAlert {
    return Intl.message(
      'Notifications Alert',
      name: 'notificationsAlert',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message('Other', name: 'other', desc: '', args: []);
  }

  /// `Share App`
  String get shareApp {
    return Intl.message('Share App', name: 'shareApp', desc: '', args: []);
  }

  /// `Help us to share the app`
  String get helpShare {
    return Intl.message(
      'Help us to share the app',
      name: 'helpShare',
      desc: '',
      args: [],
    );
  }

  /// `Contact us in case of any problem`
  String get contactProblem {
    return Intl.message(
      'Contact us in case of any problem',
      name: 'contactProblem',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to log out?`
  String get logoutConfirm {
    return Intl.message(
      'Do you want to log out?',
      name: 'logoutConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Arabic`
  String get arabic {
    return Intl.message('Arabic', name: 'arabic', desc: '', args: []);
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Your profile`
  String get yourProfile {
    return Intl.message(
      'Your profile',
      name: 'yourProfile',
      desc: '',
      args: [],
    );
  }

  /// `Update successfully`
  String get updateSuccess {
    return Intl.message(
      'Update successfully',
      name: 'updateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept {
    return Intl.message('Accept', name: 'accept', desc: '', args: []);
  }

  /// `Ignore`
  String get ignore {
    return Intl.message('Ignore', name: 'ignore', desc: '', args: []);
  }

  /// `The follow request you\'re looking for is no longer available. '\n                      'It may have been cancelled, expired, or already accepted.`
  String get expiredRequest {
    return Intl.message(
      'The follow request you\\\'re looking for is no longer available. \'\n                      \'It may have been cancelled, expired, or already accepted.',
      name: 'expiredRequest',
      desc: '',
      args: [],
    );
  }

  /// `Follow Request`
  String get followRequest {
    return Intl.message(
      'Follow Request',
      name: 'followRequest',
      desc: '',
      args: [],
    );
  }

  /// `Follow Request Unavailable`
  String get followRequestUnAvailable {
    return Intl.message(
      'Follow Request Unavailable',
      name: 'followRequestUnAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Pets in vetIcare clinic`
  String get petsVetICare {
    return Intl.message(
      'Pets in vetIcare clinic',
      name: 'petsVetICare',
      desc: '',
      args: [],
    );
  }

  /// `No pets are available in this clinic, or they have already been added to SQueak`
  String get noPetsInVetICare {
    return Intl.message(
      'No pets are available in this clinic, or they have already been added to SQueak',
      name: 'noPetsInVetICare',
      desc: '',
      args: [],
    );
  }

  /// `Add to squeak`
  String get addToSqueak {
    return Intl.message(
      'Add to squeak',
      name: 'addToSqueak',
      desc: '',
      args: [],
    );
  }

  /// `Link another pet`
  String get linkAnotherPet {
    return Intl.message(
      'Link another pet',
      name: 'linkAnotherPet',
      desc: '',
      args: [],
    );
  }

  /// `Your SQueak Pet`
  String get yourPets {
    return Intl.message(
      'Your SQueak Pet',
      name: 'yourPets',
      desc: '',
      args: [],
    );
  }

  /// `Complete the register from vetIcare invitation`
  String get compeleteSqueakRegister {
    return Intl.message(
      'Complete the register from vetIcare invitation',
      name: 'compeleteSqueakRegister',
      desc: '',
      args: [],
    );
  }

  /// `Please select a pet to start service`
  String get selectPet {
    return Intl.message(
      'Please select a pet to start service',
      name: 'selectPet',
      desc: '',
      args: [],
    );
  }

  /// `Please select boarding Type name`
  String get pleaseSelectBoarding {
    return Intl.message(
      'Please select boarding Type name',
      name: 'pleaseSelectBoarding',
      desc: '',
      args: [],
    );
  }

  /// `Please select Cage`
  String get pleaseSelectCage {
    return Intl.message(
      'Please select Cage',
      name: 'pleaseSelectCage',
      desc: '',
      args: [],
    );
  }

  /// `Boarding Type`
  String get boardingType {
    return Intl.message(
      'Boarding Type',
      name: 'boardingType',
      desc: '',
      args: [],
    );
  }

  /// `Select Boarding Type name`
  String get selectBoarding {
    return Intl.message(
      'Select Boarding Type name',
      name: 'selectBoarding',
      desc: '',
      args: [],
    );
  }

  /// `Note that you select boarding price in hours`
  String get boardingTypeNoteHour {
    return Intl.message(
      'Note that you select boarding price in hours',
      name: 'boardingTypeNoteHour',
      desc: '',
      args: [],
    );
  }

  /// `Note that you select boarding price in days`
  String get boardingTypeNoteDay {
    return Intl.message(
      'Note that you select boarding price in days',
      name: 'boardingTypeNoteDay',
      desc: '',
      args: [],
    );
  }

  /// `Cage`
  String get boardingCage {
    return Intl.message('Cage', name: 'boardingCage', desc: '', args: []);
  }

  /// `Select Cage`
  String get cageSelect {
    return Intl.message('Select Cage', name: 'cageSelect', desc: '', args: []);
  }

  /// `Entry Date`
  String get entryDate {
    return Intl.message('Entry Date', name: 'entryDate', desc: '', args: []);
  }

  /// `Exit Date`
  String get exitDate {
    return Intl.message('Exit Date', name: 'exitDate', desc: '', args: []);
  }

  /// `Initial cost`
  String get boardingPrice {
    return Intl.message(
      'Initial cost',
      name: 'boardingPrice',
      desc: '',
      args: [],
    );
  }

  /// `Boarding By`
  String get boardingBy {
    return Intl.message('Boarding By', name: 'boardingBy', desc: '', args: []);
  }

  /// `Select Doctor`
  String get selectBoardingBy {
    return Intl.message(
      'Select Doctor',
      name: 'selectBoardingBy',
      desc: '',
      args: [],
    );
  }

  /// `Share Images Pet`
  String get ShareImagesPet {
    return Intl.message(
      'Share Images Pet',
      name: 'ShareImagesPet',
      desc: '',
      args: [],
    );
  }

  /// `Search for pets...`
  String get findPotentialMates {
    return Intl.message(
      'Search for pets...',
      name: 'findPotentialMates',
      desc: '',
      args: [],
    );
  }

  /// `Find Pet Friends`
  String get findPetFriends {
    return Intl.message(
      'Find Pet Friends',
      name: 'findPetFriends',
      desc: '',
      args: [],
    );
  }

  /// `First Switch Profile`
  String get switchTitle {
    return Intl.message(
      'First Switch Profile',
      name: 'switchTitle',
      desc: '',
      args: [],
    );
  }

  /// `Complete Pet Profile`
  String get CompletePetProfile {
    return Intl.message(
      'Complete Pet Profile',
      name: 'CompletePetProfile',
      desc: '',
      args: [],
    );
  }

  /// `Profile Incomplete`
  String get profile_incomplete {
    return Intl.message(
      'Profile Incomplete',
      name: 'profile_incomplete',
      desc: '',
      args: [],
    );
  }

  /// `Your pet profile needs additional information to unlock all features`
  String get profile_incomplete_desc {
    return Intl.message(
      'Your pet profile needs additional information to unlock all features',
      name: 'profile_incomplete_desc',
      desc: '',
      args: [],
    );
  }

  /// `Missing Information:`
  String get missing_information {
    return Intl.message(
      'Missing Information:',
      name: 'missing_information',
      desc: '',
      args: [],
    );
  }

  /// `Maybe Later`
  String get maybe_later {
    return Intl.message('Maybe Later', name: 'maybe_later', desc: '', args: []);
  }

  /// `Complete Now`
  String get complete_now {
    return Intl.message(
      'Complete Now',
      name: 'complete_now',
      desc: '',
      args: [],
    );
  }

  /// `All required fields are complete!`
  String get all_required_complete {
    return Intl.message(
      'All required fields are complete!',
      name: 'all_required_complete',
      desc: '',
      args: [],
    );
  }

  /// `Required`
  String get required {
    return Intl.message('Required', name: 'required', desc: '', args: []);
  }

  /// `Features you'll unlock:`
  String get features_unlock {
    return Intl.message(
      'Features you\'ll unlock:',
      name: 'features_unlock',
      desc: '',
      args: [],
    );
  }

  /// `Pet Friendship`
  String get pet_friendship {
    return Intl.message(
      'Pet Friendship',
      name: 'pet_friendship',
      desc: '',
      args: [],
    );
  }

  /// `Mating Features`
  String get mating_features {
    return Intl.message(
      'Mating Features',
      name: 'mating_features',
      desc: '',
      args: [],
    );
  }

  /// `Health Tracking`
  String get health_tracking {
    return Intl.message(
      'Health Tracking',
      name: 'health_tracking',
      desc: '',
      args: [],
    );
  }

  /// `Community Access`
  String get community_access {
    return Intl.message(
      'Community Access',
      name: 'community_access',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get edit_profile {
    return Intl.message(
      'Edit Profile',
      name: 'edit_profile',
      desc: '',
      args: [],
    );
  }

  /// `Navigate to profile editing screen...`
  String get navigate_edit_profile {
    return Intl.message(
      'Navigate to profile editing screen...',
      name: 'navigate_edit_profile',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Pet Name`
  String get missing_field_pet_name {
    return Intl.message(
      'Pet Name',
      name: 'missing_field_pet_name',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get missing_field_gender {
    return Intl.message(
      'Gender',
      name: 'missing_field_gender',
      desc: '',
      args: [],
    );
  }

  /// `Species`
  String get missing_field_species {
    return Intl.message(
      'Species',
      name: 'missing_field_species',
      desc: '',
      args: [],
    );
  }

  /// `Breed`
  String get missing_field_breed {
    return Intl.message(
      'Breed',
      name: 'missing_field_breed',
      desc: '',
      args: [],
    );
  }

  /// `Profile Photo`
  String get missing_field_photo {
    return Intl.message(
      'Profile Photo',
      name: 'missing_field_photo',
      desc: '',
      args: [],
    );
  }

  /// `Birth Date`
  String get missing_field_birth_date {
    return Intl.message(
      'Birth Date',
      name: 'missing_field_birth_date',
      desc: '',
      args: [],
    );
  }

  /// `Available For Mating`
  String get availableForMating {
    return Intl.message(
      'Available For Mating',
      name: 'availableForMating',
      desc: '',
      args: [],
    );
  }

  /// `Not Available For Mating`
  String get notAvailableForMating {
    return Intl.message(
      'Not Available For Mating',
      name: 'notAvailableForMating',
      desc: '',
      args: [],
    );
  }

  /// `Update Pet Status`
  String get update_pet_status {
    return Intl.message(
      'Update Pet Status',
      name: 'update_pet_status',
      desc: '',
      args: [],
    );
  }

  /// `Change {petName}'s relationship status`
  String change_pet_status_for(Object petName) {
    return Intl.message(
      'Change $petName\'s relationship status',
      name: 'change_pet_status_for',
      desc: '',
      args: [petName],
    );
  }

  /// `Update Status`
  String get update_status {
    return Intl.message(
      'Update Status',
      name: 'update_status',
      desc: '',
      args: [],
    );
  }

  /// `Single`
  String get single {
    return Intl.message('Single', name: 'single', desc: '', args: []);
  }

  /// `Not looking for mating`
  String get single_desc {
    return Intl.message(
      'Not looking for mating',
      name: 'single_desc',
      desc: '',
      args: [],
    );
  }

  /// `Available for Mating`
  String get available_for_mating {
    return Intl.message(
      'Available for Mating',
      name: 'available_for_mating',
      desc: '',
      args: [],
    );
  }

  /// `Ready to find a partner`
  String get available_for_mating_desc {
    return Intl.message(
      'Ready to find a partner',
      name: 'available_for_mating_desc',
      desc: '',
      args: [],
    );
  }

  /// `On Mating`
  String get on_mating {
    return Intl.message('On Mating', name: 'on_mating', desc: '', args: []);
  }

  /// `Currently in a mating relationship`
  String get on_mating_desc {
    return Intl.message(
      'Currently in a mating relationship',
      name: 'on_mating_desc',
      desc: '',
      args: [],
    );
  }

  /// `Previously Mated`
  String get previously_mated {
    return Intl.message(
      'Previously Mated',
      name: 'previously_mated',
      desc: '',
      args: [],
    );
  }

  /// `Has completed mating`
  String get previously_mated_desc {
    return Intl.message(
      'Has completed mating',
      name: 'previously_mated_desc',
      desc: '',
      args: [],
    );
  }

  /// `Pregnant`
  String get pregnant {
    return Intl.message('Pregnant', name: 'pregnant', desc: '', args: []);
  }

  /// `Expecting babies`
  String get pregnant_desc {
    return Intl.message(
      'Expecting babies',
      name: 'pregnant_desc',
      desc: '',
      args: [],
    );
  }

  /// `Has Set Its Baby`
  String get has_set_its_baby {
    return Intl.message(
      'Has Set Its Baby',
      name: 'has_set_its_baby',
      desc: '',
      args: [],
    );
  }

  /// `Now a parent`
  String get has_set_its_baby_desc {
    return Intl.message(
      'Now a parent',
      name: 'has_set_its_baby_desc',
      desc: '',
      args: [],
    );
  }

  /// `Divorced`
  String get divorced {
    return Intl.message('Divorced', name: 'divorced', desc: '', args: []);
  }

  /// `Single again after mating`
  String get divorced_desc {
    return Intl.message(
      'Single again after mating',
      name: 'divorced_desc',
      desc: '',
      args: [],
    );
  }

  /// `Merge`
  String get mergePets {
    return Intl.message('Merge', name: 'mergePets', desc: '', args: []);
  }

  /// `Selected`
  String get selected {
    return Intl.message('Selected', name: 'selected', desc: '', args: []);
  }

  /// `Available Pets for Mating`
  String get avaPetTOMating {
    return Intl.message(
      'Available Pets for Mating',
      name: 'avaPetTOMating',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Squeak!`
  String get welcomeToSqueak {
    return Intl.message(
      'Welcome to Squeak!',
      name: 'welcomeToSqueak',
      desc: '',
      args: [],
    );
  }

  /// `Find the perfect match for your beloved pets. Connect, chat, and create beautiful families together.`
  String get welcomeSubtitle {
    return Intl.message(
      'Find the perfect match for your beloved pets. Connect, chat, and create beautiful families together.',
      name: 'welcomeSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Create Pet Profile`
  String get createPetProfile {
    return Intl.message(
      'Create Pet Profile',
      name: 'createPetProfile',
      desc: '',
      args: [],
    );
  }

  /// `Add your pet's details and photos`
  String get createPetProfileSub {
    return Intl.message(
      'Add your pet\'s details and photos',
      name: 'createPetProfileSub',
      desc: '',
      args: [],
    );
  }

  /// `Find Matches`
  String get findMatches {
    return Intl.message(
      'Find Matches',
      name: 'findMatches',
      desc: '',
      args: [],
    );
  }

  /// `Discover compatible pets nearby`
  String get findMatchesSub {
    return Intl.message(
      'Discover compatible pets nearby',
      name: 'findMatchesSub',
      desc: '',
      args: [],
    );
  }

  /// `Start Chatting`
  String get startChatting {
    return Intl.message(
      'Start Chatting',
      name: 'startChatting',
      desc: '',
      args: [],
    );
  }

  /// `Connect with other pet owners`
  String get startChattingSub {
    return Intl.message(
      'Connect with other pet owners',
      name: 'startChattingSub',
      desc: '',
      args: [],
    );
  }

  /// `Pets looking for love in your area`
  String get petsLookingInArea {
    return Intl.message(
      'Pets looking for love in your area',
      name: 'petsLookingInArea',
      desc: '',
      args: [],
    );
  }

  /// `Viewing {petName}'s profile`
  String viewProfileSnack(Object petName) {
    return Intl.message(
      'Viewing $petName\'s profile',
      name: 'viewProfileSnack',
      desc: '',
      args: [petName],
    );
  }

  /// `Little Friend`
  String get littleFriend {
    return Intl.message(
      'Little Friend',
      name: 'littleFriend',
      desc: '',
      args: [],
    );
  }

  /// `View Profile`
  String get viewProfile {
    return Intl.message(
      'View Profile',
      name: 'viewProfile',
      desc: '',
      args: [],
    );
  }

  /// `Send a Lovely Mating Request 💞`
  String get sendLovelyRequestTitle {
    return Intl.message(
      'Send a Lovely Mating Request 💞',
      name: 'sendLovelyRequestTitle',
      desc: '',
      args: [],
    );
  }

  /// `Let’s help your little friend connect with {petName} and start a beautiful friendship!`
  String sendLovelyRequestSubtitle(Object petName) {
    return Intl.message(
      'Let’s help your little friend connect with $petName and start a beautiful friendship!',
      name: 'sendLovelyRequestSubtitle',
      desc: '',
      args: [petName],
    );
  }

  /// `Send`
  String get sendRequest {
    return Intl.message('Send', name: 'sendRequest', desc: '', args: []);
  }

  /// `Cancel Request`
  String get cancelRequest {
    return Intl.message(
      'Cancel Request',
      name: 'cancelRequest',
      desc: '',
      args: [],
    );
  }

  /// `Mating request sent to {petName}! 💕`
  String requestSent(Object petName) {
    return Intl.message(
      'Mating request sent to $petName! 💕',
      name: 'requestSent',
      desc: '',
      args: [petName],
    );
  }

  /// `Manage Mating Requests`
  String get mangeMatingRequests {
    return Intl.message(
      'Manage Mating Requests',
      name: 'mangeMatingRequests',
      desc: '',
      args: [],
    );
  }

  /// `Mating Requests for {profile}`
  String matingRequestsFor(Object profile) {
    return Intl.message(
      'Mating Requests for $profile',
      name: 'matingRequestsFor',
      desc: '',
      args: [profile],
    );
  }

  /// `Manage incoming and outgoing mating requests`
  String get manageIncomingOutgoing {
    return Intl.message(
      'Manage incoming and outgoing mating requests',
      name: 'manageIncomingOutgoing',
      desc: '',
      args: [],
    );
  }

  /// `Received`
  String get received {
    return Intl.message('Received', name: 'received', desc: '', args: []);
  }

  /// `Sent`
  String get sent {
    return Intl.message('Sent', name: 'sent', desc: '', args: []);
  }

  /// `Reject`
  String get reject {
    return Intl.message('Reject', name: 'reject', desc: '', args: []);
  }

  /// `Open Chat`
  String get openChat {
    return Intl.message('Open Chat', name: 'openChat', desc: '', args: []);
  }

  /// `Waiting for response...`
  String get waitingForResponse {
    return Intl.message(
      'Waiting for response...',
      name: 'waitingForResponse',
      desc: '',
      args: [],
    );
  }

  /// `Opening chat...`
  String get openingChat {
    return Intl.message(
      'Opening chat...',
      name: 'openingChat',
      desc: '',
      args: [],
    );
  }

  /// `{count}m ago`
  String minutesAgo(Object count) {
    return Intl.message(
      '${count}m ago',
      name: 'minutesAgo',
      desc: '',
      args: [count],
    );
  }

  /// `{count}h ago`
  String hoursAgo(Object count) {
    return Intl.message(
      '${count}h ago',
      name: 'hoursAgo',
      desc: '',
      args: [count],
    );
  }

  /// `{count}d ago`
  String daysAgo(Object count) {
    return Intl.message(
      '${count}d ago',
      name: 'daysAgo',
      desc: '',
      args: [count],
    );
  }

  /// `just now`
  String get justNow {
    return Intl.message('just now', name: 'justNow', desc: '', args: []);
  }

  /// `yesterday`
  String get yesterday {
    return Intl.message('yesterday', name: 'yesterday', desc: '', args: []);
  }

  /// `No requests found`
  String get noRequests {
    return Intl.message(
      'No requests found',
      name: 'noRequests',
      desc: '',
      args: [],
    );
  }

  /// `No received requests`
  String get noReceivedRequests {
    return Intl.message(
      'No received requests',
      name: 'noReceivedRequests',
      desc: '',
      args: [],
    );
  }

  /// `No sent requests`
  String get noSentRequests {
    return Intl.message(
      'No sent requests',
      name: 'noSentRequests',
      desc: '',
      args: [],
    );
  }

  /// `الطلبات النشطة`
  String get activeRequests {
    return Intl.message(
      'الطلبات النشطة',
      name: 'activeRequests',
      desc: '',
      args: [],
    );
  }

  /// `النشاط الحديث`
  String get recentActivity {
    return Intl.message(
      'النشاط الحديث',
      name: 'recentActivity',
      desc: '',
      args: [],
    );
  }

  /// `Mating Activity`
  String get matingActivity {
    return Intl.message(
      'Mating Activity',
      name: 'matingActivity',
      desc: '',
      args: [],
    );
  }

  /// `View All`
  String get viewAll {
    return Intl.message('View All', name: 'viewAll', desc: '', args: []);
  }

  /// `Respond`
  String get respond {
    return Intl.message('Respond', name: 'respond', desc: '', args: []);
  }

  /// `Match Found!`
  String get matchFound {
    return Intl.message('Match Found!', name: 'matchFound', desc: '', args: []);
  }

  /// `Start Conversation`
  String get startConversation {
    return Intl.message(
      'Start Conversation',
      name: 'startConversation',
      desc: '',
      args: [],
    );
  }

  /// `When you receive mating requests, they will appear here`
  String get noReceivedRequestsSub {
    return Intl.message(
      'When you receive mating requests, they will appear here',
      name: 'noReceivedRequestsSub',
      desc: '',
      args: [],
    );
  }

  /// `All Chats`
  String get AllChats {
    return Intl.message('All Chats', name: 'AllChats', desc: '', args: []);
  }

  /// `Block`
  String get block {
    return Intl.message('Block', name: 'block', desc: '', args: []);
  }

  /// `Mating Chats`
  String get matingChats {
    return Intl.message(
      'Mating Chats',
      name: 'matingChats',
      desc: '',
      args: [],
    );
  }

  /// `Rename Chat`
  String get renameChat {
    return Intl.message('Rename Chat', name: 'renameChat', desc: '', args: []);
  }

  /// `Chat Name`
  String get chatName {
    return Intl.message('Chat Name', name: 'chatName', desc: '', args: []);
  }

  /// `Enter chat name`
  String get enterChatName {
    return Intl.message(
      'Enter chat name',
      name: 'enterChatName',
      desc: '',
      args: [],
    );
  }

  /// `Max {count} characters`
  String maxCharacters(Object count) {
    return Intl.message(
      'Max $count characters',
      name: 'maxCharacters',
      desc: '',
      args: [count],
    );
  }

  /// `Chat renamed successfully`
  String get chatRenamedSuccessfully {
    return Intl.message(
      'Chat renamed successfully',
      name: 'chatRenamedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Block Chat`
  String get blockChat {
    return Intl.message('Block Chat', name: 'blockChat', desc: '', args: []);
  }

  /// `Are you sure you want to block this chat? You will not be able to send or receive messages.`
  String get blockChatConfirmation {
    return Intl.message(
      'Are you sure you want to block this chat? You will not be able to send or receive messages.',
      name: 'blockChatConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Unblock Chat`
  String get unblockChat {
    return Intl.message(
      'Unblock Chat',
      name: 'unblockChat',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to unblock this chat?`
  String get unblockChatConfirmation {
    return Intl.message(
      'Are you sure you want to unblock this chat?',
      name: 'unblockChatConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Unblock`
  String get unblock {
    return Intl.message('Unblock', name: 'unblock', desc: '', args: []);
  }

  /// `Chat blocked successfully`
  String get chatBlocked {
    return Intl.message(
      'Chat blocked successfully',
      name: 'chatBlocked',
      desc: '',
      args: [],
    );
  }

  /// `Chat unblocked successfully`
  String get chatUnblocked {
    return Intl.message(
      'Chat unblocked successfully',
      name: 'chatUnblocked',
      desc: '',
      args: [],
    );
  }

  /// `Mark as Mating Started`
  String get markAsMatingStarted {
    return Intl.message(
      'Mark as Mating Started',
      name: 'markAsMatingStarted',
      desc: '',
      args: [],
    );
  }

  /// `Mark this chat as mating started? This will enable mating tracking features.`
  String get startMatingConfirmation {
    return Intl.message(
      'Mark this chat as mating started? This will enable mating tracking features.',
      name: 'startMatingConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Start Mating`
  String get startMating {
    return Intl.message(
      'Start Mating',
      name: 'startMating',
      desc: '',
      args: [],
    );
  }

  /// `Mating started successfully`
  String get matingStarted {
    return Intl.message(
      'Mating started successfully',
      name: 'matingStarted',
      desc: '',
      args: [],
    );
  }

  /// `Clear Chat`
  String get clearChat {
    return Intl.message('Clear Chat', name: 'clearChat', desc: '', args: []);
  }

  /// `Clear Chat Messages`
  String get clearChatMessages {
    return Intl.message(
      'Clear Chat Messages',
      name: 'clearChatMessages',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to clear all messages in this chat? This action cannot be undone.`
  String get clearChatConfirmation {
    return Intl.message(
      'Are you sure you want to clear all messages in this chat? This action cannot be undone.',
      name: 'clearChatConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to end this chat? This action cannot be reversed.`
  String get endChatConfirmation {
    return Intl.message(
      'Are you sure you want to end this chat? This action cannot be reversed.',
      name: 'endChatConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Chat ended successfully`
  String get chatEnded {
    return Intl.message(
      'Chat ended successfully',
      name: 'chatEnded',
      desc: '',
      args: [],
    );
  }

  /// `Finish Mating`
  String get finishMating {
    return Intl.message(
      'Finish Mating',
      name: 'finishMating',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to finish mating? This will archive the chat.`
  String get finishMatingConfirmation {
    return Intl.message(
      'Are you sure you want to finish mating? This will archive the chat.',
      name: 'finishMatingConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `I confirm that mating has been completed`
  String get confirmMatingCompletion {
    return Intl.message(
      'I confirm that mating has been completed',
      name: 'confirmMatingCompletion',
      desc: '',
      args: [],
    );
  }

  /// `Partner has confirmed`
  String get partnerConfirmed {
    return Intl.message(
      'Partner has confirmed',
      name: 'partnerConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `Note: Both partners need to confirm mating completion`
  String get finishMatingNote {
    return Intl.message(
      'Note: Both partners need to confirm mating completion',
      name: 'finishMatingNote',
      desc: '',
      args: [],
    );
  }

  /// `Mating completed! Chat has been archived.`
  String get matingCompletedChatArchived {
    return Intl.message(
      'Mating completed! Chat has been archived.',
      name: 'matingCompletedChatArchived',
      desc: '',
      args: [],
    );
  }

  /// `You will receive pregnancy notifications if applicable`
  String get pregnancyNotificationInfo {
    return Intl.message(
      'You will receive pregnancy notifications if applicable',
      name: 'pregnancyNotificationInfo',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `This chat has been archived and is read-only`
  String get chatArchivedReadOnly {
    return Intl.message(
      'This chat has been archived and is read-only',
      name: 'chatArchivedReadOnly',
      desc: '',
      args: [],
    );
  }

  /// `This chat is blocked. No messages can be sent or received.`
  String get chatBlockedNoMessages {
    return Intl.message(
      'This chat is blocked. No messages can be sent or received.',
      name: 'chatBlockedNoMessages',
      desc: '',
      args: [],
    );
  }

  /// `has blocked you. You cannot send messages until he unblock you.`
  String get chatBlockedByOther {
    return Intl.message(
      'has blocked you. You cannot send messages until he unblock you.',
      name: 'chatBlockedByOther',
      desc: '',
      args: [],
    );
  }

  /// `Profile Blocked`
  String get profileBlocked {
    return Intl.message(
      'Profile Blocked',
      name: 'profileBlocked',
      desc: '',
      args: [],
    );
  }

  /// `You have blocked this user. You cannot view this profile while you are blocked.`
  String get youBlockedThisUserCannotViewProfile {
    return Intl.message(
      'You have blocked this user. You cannot view this profile while you are blocked.',
      name: 'youBlockedThisUserCannotViewProfile',
      desc: '',
      args: [],
    );
  }

  /// `This user has blocked you. You cannot view this profile.`
  String get thisUserBlockedYouCannotViewProfile {
    return Intl.message(
      'This user has blocked you. You cannot view this profile.',
      name: 'thisUserBlockedYouCannotViewProfile',
      desc: '',
      args: [],
    );
  }

  /// `Okay`
  String get okay {
    return Intl.message('Okay', name: 'okay', desc: '', args: []);
  }

  /// `No messages yet`
  String get noMessagesYet {
    return Intl.message(
      'No messages yet',
      name: 'noMessagesYet',
      desc: '',
      args: [],
    );
  }

  /// `Type a message...`
  String get typeMessage {
    return Intl.message(
      'Type a message...',
      name: 'typeMessage',
      desc: '',
      args: [],
    );
  }

  /// `Choose Attachment`
  String get chooseAttachment {
    return Intl.message(
      'Choose Attachment',
      name: 'chooseAttachment',
      desc: '',
      args: [],
    );
  }

  /// `Photo`
  String get photo {
    return Intl.message('Photo', name: 'photo', desc: '', args: []);
  }

  /// `Video`
  String get video {
    return Intl.message('Video', name: 'video', desc: '', args: []);
  }

  /// `Audio`
  String get audio {
    return Intl.message('Audio', name: 'audio', desc: '', args: []);
  }

  /// `Photo picker not implemented yet`
  String get photoPickerNotImplemented {
    return Intl.message(
      'Photo picker not implemented yet',
      name: 'photoPickerNotImplemented',
      desc: '',
      args: [],
    );
  }

  /// `Video picker not implemented yet`
  String get videoPickerNotImplemented {
    return Intl.message(
      'Video picker not implemented yet',
      name: 'videoPickerNotImplemented',
      desc: '',
      args: [],
    );
  }

  /// `Audio recorder not implemented yet`
  String get audioRecorderNotImplemented {
    return Intl.message(
      'Audio recorder not implemented yet',
      name: 'audioRecorderNotImplemented',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `Active`
  String get active {
    return Intl.message('Active', name: 'active', desc: '', args: []);
  }

  /// `Mating`
  String get onMating {
    return Intl.message('Mating', name: 'onMating', desc: '', args: []);
  }

  /// `Completed`
  String get completed {
    return Intl.message('Completed', name: 'completed', desc: '', args: []);
  }

  /// `Not Completed`
  String get not_completed {
    return Intl.message(
      'Not Completed',
      name: 'not_completed',
      desc: '',
      args: [],
    );
  }

  /// `Blocked`
  String get blocked {
    return Intl.message('Blocked', name: 'blocked', desc: '', args: []);
  }

  /// `No chats found`
  String get noChatsFound {
    return Intl.message(
      'No chats found',
      name: 'noChatsFound',
      desc: '',
      args: [],
    );
  }

  /// `No active chats`
  String get noActiveChats {
    return Intl.message(
      'No active chats',
      name: 'noActiveChats',
      desc: '',
      args: [],
    );
  }

  /// `No mating chats`
  String get noMatingChats {
    return Intl.message(
      'No mating chats',
      name: 'noMatingChats',
      desc: '',
      args: [],
    );
  }

  /// `No completed chats`
  String get noCompletedChats {
    return Intl.message(
      'No completed chats',
      name: 'noCompletedChats',
      desc: '',
      args: [],
    );
  }

  /// `No blocked chats`
  String get noBlockedChats {
    return Intl.message(
      'No blocked chats',
      name: 'noBlockedChats',
      desc: '',
      args: [],
    );
  }

  /// `No chats in this category`
  String get noChatsInThisCategory {
    return Intl.message(
      'No chats in this category',
      name: 'noChatsInThisCategory',
      desc: '',
      args: [],
    );
  }

  /// `Show All Chats`
  String get showAllChats {
    return Intl.message(
      'Show All Chats',
      name: 'showAllChats',
      desc: '',
      args: [],
    );
  }

  /// `Start a new conversation to see it here!`
  String get startNewConversation {
    return Intl.message(
      'Start a new conversation to see it here!',
      name: 'startNewConversation',
      desc: '',
      args: [],
    );
  }

  /// `Mating`
  String get mating {
    return Intl.message('Mating', name: 'mating', desc: '', args: []);
  }

  /// `All Chats`
  String get allChats {
    return Intl.message('All Chats', name: 'allChats', desc: '', args: []);
  }

  /// `Fetching your pet chats...`
  String get fetchingPetChats {
    return Intl.message(
      'Fetching your pet chats...',
      name: 'fetchingPetChats',
      desc: '',
      args: [],
    );
  }

  /// `Oops! Something went wrong`
  String get somethingWentWrong {
    return Intl.message(
      'Oops! Something went wrong',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Error:`
  String get errorColon {
    return Intl.message('Error:', name: 'errorColon', desc: '', args: []);
  }

  /// `Try Again`
  String get tryAgain {
    return Intl.message('Try Again', name: 'tryAgain', desc: '', args: []);
  }

  /// `No chats yet!`
  String get noChatsYet {
    return Intl.message(
      'No chats yet!',
      name: 'noChatsYet',
      desc: '',
      args: [],
    );
  }

  /// `Start matching with other pets to begin chatting`
  String get startMatchingToChat {
    return Intl.message(
      'Start matching with other pets to begin chatting',
      name: 'startMatchingToChat',
      desc: '',
      args: [],
    );
  }

  /// `Enter new name`
  String get enterNewName {
    return Intl.message(
      'Enter new name',
      name: 'enterNewName',
      desc: '',
      args: [],
    );
  }

  /// `Rate Your Experience`
  String get rateYourExperience {
    return Intl.message(
      'Rate Your Experience',
      name: 'rateYourExperience',
      desc: '',
      args: [],
    );
  }

  /// `How was the mating session?`
  String get howWasMatingSession {
    return Intl.message(
      'How was the mating session?',
      name: 'howWasMatingSession',
      desc: '',
      args: [],
    );
  }

  /// `Tap to Rate`
  String get tapToRate {
    return Intl.message('Tap to Rate', name: 'tapToRate', desc: '', args: []);
  }

  /// `Share Your Thoughts`
  String get shareYourThoughts {
    return Intl.message(
      'Share Your Thoughts',
      name: 'shareYourThoughts',
      desc: '',
      args: [],
    );
  }

  /// `Tell us about the mating experience...`
  String get tellUsAboutExperience {
    return Intl.message(
      'Tell us about the mating experience...',
      name: 'tellUsAboutExperience',
      desc: '',
      args: [],
    );
  }

  /// `Submit Rating`
  String get submitRating {
    return Intl.message(
      'Submit Rating',
      name: 'submitRating',
      desc: '',
      args: [],
    );
  }

  /// `Please select a rating`
  String get pleaseSelectRating {
    return Intl.message(
      'Please select a rating',
      name: 'pleaseSelectRating',
      desc: '',
      args: [],
    );
  }

  /// `Poor Experience`
  String get poorExperience {
    return Intl.message(
      'Poor Experience',
      name: 'poorExperience',
      desc: '',
      args: [],
    );
  }

  /// `Below Average`
  String get belowAverage {
    return Intl.message(
      'Below Average',
      name: 'belowAverage',
      desc: '',
      args: [],
    );
  }

  /// `Good Experience`
  String get goodExperience {
    return Intl.message(
      'Good Experience',
      name: 'goodExperience',
      desc: '',
      args: [],
    );
  }

  /// `Great Experience`
  String get greatExperience {
    return Intl.message(
      'Great Experience',
      name: 'greatExperience',
      desc: '',
      args: [],
    );
  }

  /// `Excellent!`
  String get excellentExperience {
    return Intl.message(
      'Excellent!',
      name: 'excellentExperience',
      desc: '',
      args: [],
    );
  }

  /// `Mating Session`
  String get matingSession {
    return Intl.message(
      'Mating Session',
      name: 'matingSession',
      desc: '',
      args: [],
    );
  }

  /// `Mating Shows`
  String get matingShows {
    return Intl.message(
      'Mating Shows',
      name: 'matingShows',
      desc: '',
      args: [],
    );
  }

  /// `Manage Pets`
  String get managePets {
    return Intl.message('Manage Pets', name: 'managePets', desc: '', args: []);
  }

  /// `Age`
  String get age {
    return Intl.message('Age', name: 'age', desc: '', args: []);
  }

  /// `Unknown`
  String get unknown {
    return Intl.message('Unknown', name: 'unknown', desc: '', args: []);
  }

  /// `Matches`
  String get matches {
    return Intl.message('Matches', name: 'matches', desc: '', args: []);
  }

  /// `Posts`
  String get posts {
    return Intl.message('Posts', name: 'posts', desc: '', args: []);
  }

  /// `History`
  String get history {
    return Intl.message('History', name: 'history', desc: '', args: []);
  }

  /// `Ratings`
  String get ratings {
    return Intl.message('Ratings', name: 'ratings', desc: '', args: []);
  }

  /// `Pending`
  String get pending {
    return Intl.message('Pending', name: 'pending', desc: '', args: []);
  }

  /// `Accepted`
  String get accepted {
    return Intl.message('Accepted', name: 'accepted', desc: '', args: []);
  }

  /// `Rejected`
  String get rejected {
    return Intl.message('Rejected', name: 'rejected', desc: '', args: []);
  }

  /// `Your sent mating requests will appear here`
  String get emptyMatingRequests {
    return Intl.message(
      'Your sent mating requests will appear here',
      name: 'emptyMatingRequests',
      desc: '',
      args: [],
    );
  }

  /// `Finish Mating Process`
  String get finishMatingProcess {
    return Intl.message(
      'Finish Mating Process',
      name: 'finishMatingProcess',
      desc: '',
      args: [],
    );
  }

  /// `Block User`
  String get blockUser {
    return Intl.message('Block User', name: 'blockUser', desc: '', args: []);
  }

  /// `Unblock User`
  String get unblockUser {
    return Intl.message(
      'Unblock User',
      name: 'unblockUser',
      desc: '',
      args: [],
    );
  }

  /// `Rating Mating`
  String get ratingMating {
    return Intl.message(
      'Rating Mating',
      name: 'ratingMating',
      desc: '',
      args: [],
    );
  }

  /// `Name cannot be empty`
  String get nameCannotBeEmpty {
    return Intl.message(
      'Name cannot be empty',
      name: 'nameCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to unblock this user?`
  String get areYouSureYouWantToUnblock {
    return Intl.message(
      'Are you sure you want to unblock this user?',
      name: 'areYouSureYouWantToUnblock',
      desc: '',
      args: [],
    );
  }

  /// `You won't receive messages anymore from this user.`
  String get youWontReceiveMessagesAnymore {
    return Intl.message(
      'You won\'t receive messages anymore from this user.',
      name: 'youWontReceiveMessagesAnymore',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to block`
  String get wantBlockUser {
    return Intl.message(
      'Do you want to block',
      name: 'wantBlockUser',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get finish {
    return Intl.message('Finish', name: 'finish', desc: '', args: []);
  }

  /// `Share Post`
  String get sharePost {
    return Intl.message('Share Post', name: 'sharePost', desc: '', args: []);
  }

  /// `You cannot contact again until you unblock the user.`
  String get YouCannotContactAgain {
    return Intl.message(
      'You cannot contact again until you unblock the user.',
      name: 'YouCannotContactAgain',
      desc: '',
      args: [],
    );
  }

  /// `Will be added to block list.`
  String get addedToBlockedList {
    return Intl.message(
      'Will be added to block list.',
      name: 'addedToBlockedList',
      desc: '',
      args: [],
    );
  }

  /// `Will be removed from friends list.`
  String get removedFromFreiendList {
    return Intl.message(
      'Will be removed from friends list.',
      name: 'removedFromFreiendList',
      desc: '',
      args: [],
    );
  }

  /// `Chat between you will be closed.`
  String get chatWillBeEnded {
    return Intl.message(
      'Chat between you will be closed.',
      name: 'chatWillBeEnded',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to block this user?`
  String get areYouSureYouWantToBlock {
    return Intl.message(
      'Are you sure you want to block this user?',
      name: 'areYouSureYouWantToBlock',
      desc: '',
      args: [],
    );
  }

  /// `No messages yet`
  String get NoMessagesYet {
    return Intl.message(
      'No messages yet',
      name: 'NoMessagesYet',
      desc: '',
      args: [],
    );
  }

  /// `Start a new conversation`
  String get StartConversation {
    return Intl.message(
      'Start a new conversation',
      name: 'StartConversation',
      desc: '',
      args: [],
    );
  }

  /// `Blocked Pets`
  String get blockedPets {
    return Intl.message(
      'Blocked Pets',
      name: 'blockedPets',
      desc: '',
      args: [],
    );
  }

  /// `No pets blocked`
  String get noPetsBlocked {
    return Intl.message(
      'No pets blocked',
      name: 'noPetsBlocked',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to unblock`
  String get areYouSureYouWantToUnblockThisPet {
    return Intl.message(
      'Are you sure you want to unblock',
      name: 'areYouSureYouWantToUnblockThisPet',
      desc: '',
      args: [],
    );
  }

  /// `owned by`
  String get ownedBy {
    return Intl.message('owned by', name: 'ownedBy', desc: '', args: []);
  }

  /// `They will be able to interact with your pets again.`
  String get ableToInteract {
    return Intl.message(
      'They will be able to interact with your pets again.',
      name: 'ableToInteract',
      desc: '',
      args: [],
    );
  }

  /// `Please select a pet profile to view blocked pets.`
  String get selectPetProfile {
    return Intl.message(
      'Please select a pet profile to view blocked pets.',
      name: 'selectPetProfile',
      desc: '',
      args: [],
    );
  }

  /// `These pets can't interact with yours.`
  String get interactWithyourPet {
    return Intl.message(
      'These pets can\'t interact with yours.',
      name: 'interactWithyourPet',
      desc: '',
      args: [],
    );
  }

  /// `You haven't blocked any pets yet.`
  String get youBlockedAnyPets {
    return Intl.message(
      'You haven\'t blocked any pets yet.',
      name: 'youBlockedAnyPets',
      desc: '',
      args: [],
    );
  }

  /// `BlockedAt`
  String get blockedAt {
    return Intl.message('BlockedAt', name: 'blockedAt', desc: '', args: []);
  }

  /// `Month`
  String get month {
    return Intl.message('Month', name: 'month', desc: '', args: []);
  }

  /// `Months`
  String get months {
    return Intl.message('Months', name: 'months', desc: '', args: []);
  }

  /// `Week`
  String get week {
    return Intl.message('Week', name: 'week', desc: '', args: []);
  }

  /// `Weeks`
  String get weeks {
    return Intl.message('Weeks', name: 'weeks', desc: '', args: []);
  }

  /// `Year`
  String get year {
    return Intl.message('Year', name: 'year', desc: '', args: []);
  }

  /// `Years`
  String get years {
    return Intl.message('Years', name: 'years', desc: '', args: []);
  }

  /// `Days`
  String get days {
    return Intl.message('Days', name: 'days', desc: '', args: []);
  }

  /// `Day`
  String get day {
    return Intl.message('Day', name: 'day', desc: '', args: []);
  }

  /// `Are you sure you want to cancel this friend ?`
  String get wantToCancelThisFriend {
    return Intl.message(
      'Are you sure you want to cancel this friend ?',
      name: 'wantToCancelThisFriend',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get sendMessage {
    return Intl.message('Message', name: 'sendMessage', desc: '', args: []);
  }

  /// `Delete Message`
  String get deleteMessage {
    return Intl.message(
      'Delete Message',
      name: 'deleteMessage',
      desc: '',
      args: [],
    );
  }

  /// `Delete Message for Everyone`
  String get deleteMessageForEveryone {
    return Intl.message(
      'Delete Message for Everyone',
      name: 'deleteMessageForEveryone',
      desc: '',
      args: [],
    );
  }

  /// `Delete Message for me`
  String get deleteMessageForMe {
    return Intl.message(
      'Delete Message for me',
      name: 'deleteMessageForMe',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete`
  String get deletePetConfirmation {
    return Intl.message(
      'Are you sure you want to delete',
      name: 'deletePetConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Delete Pet`
  String get deletePet {
    return Intl.message('Delete Pet', name: 'deletePet', desc: '', args: []);
  }

  /// `Appointment Doctor`
  String get appointmentDoctor {
    return Intl.message(
      'Appointment Doctor',
      name: 'appointmentDoctor',
      desc: '',
      args: [],
    );
  }

  /// `QR Code Status`
  String get qrCodeStatus {
    return Intl.message(
      'QR Code Status',
      name: 'qrCodeStatus',
      desc: '',
      args: [],
    );
  }

  /// `This pet is already linked to a QR code`
  String get linkedToQr {
    return Intl.message(
      'This pet is already linked to a QR code',
      name: 'linkedToQr',
      desc: '',
      args: [],
    );
  }

  /// `QR Not Linked`
  String get qrNotLinked {
    return Intl.message(
      'QR Not Linked',
      name: 'qrNotLinked',
      desc: '',
      args: [],
    );
  }

  /// `This pet is not linked to a QR code. You can link it now or learn more about how it works.`
  String get youCanLinkQrNow {
    return Intl.message(
      'This pet is not linked to a QR code. You can link it now or learn more about how it works.',
      name: 'youCanLinkQrNow',
      desc: '',
      args: [],
    );
  }

  /// `Try Now`
  String get learnHow {
    return Intl.message('Try Now', name: 'learnHow', desc: '', args: []);
  }

  /// `Link QR`
  String get linkQrCode {
    return Intl.message('Link QR', name: 'linkQrCode', desc: '', args: []);
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
