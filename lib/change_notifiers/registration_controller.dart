import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/dialogs.dart';
import '../services/auth_service.dart';

class RegistrationController extends ChangeNotifier {
  bool _isRegisterMode = false;
  bool get isRegisterMode => _isRegisterMode;
  set isRegisterMode(bool value) {
    _isRegisterMode = value;
    notifyListeners();
  }

  bool _isPasswordHidden = true;
  bool get isPasswordHidden => _isPasswordHidden;
  set isPasswordHidden(bool value) {
    _isPasswordHidden = value;
    notifyListeners();
  }

  String _firstName = '';
  set firstName(String value) {
    _firstName = value;
    notifyListeners();
  }

  String get firstName => _firstName.trim();

  String _lastName = '';
  set lastName(String value) {
    _lastName = value;
    notifyListeners();
  }

  String get lastName => _lastName.trim();

  String _location = '';
  set location(String value) {
    _location = value;
    notifyListeners();
  }

  String get location => _location.trim();

  String _email = '';
  set email(String value) {
    _email = value;
    notifyListeners();
  }

  String get email => _email.trim();

  String _password = '';
  set password(String value) {
    _password = value;
    notifyListeners();
  }

  String get password => _password;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> authenticateWithEmailAndPassword(
      {required BuildContext context}) async {
    isLoading = true;
    try {
      if (_isRegisterMode) {
        await AuthService.register(
          firstName: firstName,
          lastName: lastName,
          location: location,
          email: email,
          password: password,
        );
        await saveUserDataToFirestore();
        _firstName = '';
        _lastName = '';
        _location = '';
        _email = '';
        _password = '';

        showMessageDialog(
          context: context,
          message: 'Your account has been successfully registered!',
        );
      } else {
        await AuthService.login(email: email, password: password);
      }
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      showMessageDialog(
        context: context,
        message: authExceptionMapper[e.code] ?? 'An unknown error occurred!',
      );
    } catch (e) {
      if (!context.mounted) return;
      showMessageDialog(
        context: context,
        message: 'An unknown error occurred!',
      );
    } finally {
      isLoading = false;
    }
  }

  Future<void> saveUserDataToFirestore() async {
    try {
      final User? user = AuthService.getCurrentUser();

      if (user != null) {
        final userData = {
          'firstName': firstName,
          'lastName': lastName,
          'location': location,
        };

        final userDocRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        await userDocRef.set(userData);
        print('Success saving user data to Firestore');
      }
    } catch (e) {
      print('Error saving user data to Firestore: $e');
    }
  }

  Future<void> authenticateWithGoogle({required BuildContext context}) async {
    try {
      await AuthService.signInWithGoogle();
    } on NoGoogleAccountChosenException {
      return;
    } catch (e) {
      if (!context.mounted) return;
      showMessageDialog(
        context: context,
        message: 'An unknown error occurred!',
      );
    }
  }

  Future<void> resetPassword({
    required BuildContext context,
    required String email,
  }) async {
    isLoading = true;
    try {
      await AuthService.resetPassword(email: email);
      if (!context.mounted) return;
      showMessageDialog(
          context: context,
          message:
              'A reset password link has been sent to $email. Open the link to reset your password.');
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      showMessageDialog(
        context: context,
        message: authExceptionMapper[e.code] ?? 'An unknown error occurred!',
      );
    } catch (e) {
      if (!context.mounted) return;
      showMessageDialog(
        context: context,
        message: 'An unknown error occurred!',
      );
    } finally {
      isLoading = false;
    }
  }
}

class NoGoogleAccountChosenException implements Exception {
  const NoGoogleAccountChosenException();
}
