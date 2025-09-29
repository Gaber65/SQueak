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

  /// `Date of birth`
  String get birthdate {
    return Intl.message('Date of birth', name: 'birthdate', desc: '', args: []);
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
