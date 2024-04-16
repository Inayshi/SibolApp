import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:urban_farming/google_fb_api/firebasefunctions.dart';
import 'package:urban_farming/widgets/note_button.dart';
import 'package:urban_farming/widgets/note_form_field.dart';
import 'package:urban_farming/widgets/note_icon_button_outlined.dart';
import '../change_notifiers/registration_controller.dart';
import '../core/constants.dart';
import '../core/validator.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late final RegistrationController registrationController;

  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController addressController;
  late final TextEditingController locationController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();

    registrationController = context.read();

    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    addressController = TextEditingController();
    locationController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    formKey = GlobalKey();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    addressController.dispose();
    locationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Selector<RegistrationController, bool>(
            selector: (_, controller) => controller.isRegisterMode,
            builder: (_, isRegisterMode, __) {
              final backgroundColor = isRegisterMode ? null : Colors.green[400];
              return Container(
                color: backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Selector<RegistrationController, bool>(
                      selector: (_, controller) => controller.isRegisterMode,
                      builder: (_, isRegisterMode, __) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                          color: !isRegisterMode
                              ? const Color.fromARGB(255, 235, 235, 235)
                              : null,
                        ),
                        height: !isRegisterMode
                            ? MediaQuery.of(context).size.height * 0.6
                            : null,
                        alignment: isRegisterMode
                            ? Alignment.center
                            : Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: SingleChildScrollView(
                            child: Form(
                              key: formKey,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: isRegisterMode
                                      ? MainAxisAlignment.center
                                      : MainAxisAlignment.end,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: 4),
                                    if (isRegisterMode) ...[
                                      NoteFormField(
                                        controller: firstNameController,
                                        labelText: 'First Name',
                                        fillColor: white,
                                        filled: true,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        textInputAction: TextInputAction.next,
                                        validator: Validator.nameValidator,
                                        onChanged: (newValue) {
                                          registrationController.firstName =
                                              newValue;
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      NoteFormField(
                                        controller: lastNameController,
                                        labelText: 'Last Name',
                                        fillColor: white,
                                        filled: true,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        textInputAction: TextInputAction.next,
                                        validator: Validator.nameValidator,
                                        onChanged: (newValue) {
                                          registrationController.lastName =
                                              newValue;
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      NoteFormField(
                                        controller: addressController,
                                        labelText: 'Address',
                                        fillColor: white,
                                        filled: true,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        textInputAction: TextInputAction.next,
                                        validator: Validator.nameValidator,
                                        onChanged: (newValue) {
                                          registrationController.address =
                                              newValue;
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      NoteFormField(
                                        controller: locationController,
                                        labelText: 'Location',
                                        fillColor: white,
                                        filled: true,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        textInputAction: TextInputAction.next,
                                        validator: Validator.nameValidator,
                                        onChanged: (newValue) {
                                          registrationController.location =
                                              newValue;
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                    NoteFormField(
                                      controller: emailController,
                                      labelText: 'Email address',
                                      fillColor: !isRegisterMode
                                          ? Colors.green[200]
                                          : white,
                                      filled: true,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      validator: Validator.emailValidator,
                                      onChanged: (newValue) {
                                        registrationController.email = newValue;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    Selector<RegistrationController, bool>(
                                      selector: (_, controller) =>
                                          controller.isPasswordHidden,
                                      builder: (_, isPasswordHidden, __) =>
                                          NoteFormField(
                                        controller: passwordController,
                                        labelText: 'Password',
                                        fillColor: !isRegisterMode
                                            ? Colors.green[200]
                                            : white,
                                        filled: true,
                                        obscureText: isPasswordHidden,
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            registrationController
                                                    .isPasswordHidden =
                                                !isPasswordHidden;
                                          },
                                          child: Icon(isPasswordHidden
                                              ? FontAwesomeIcons.eye
                                              : FontAwesomeIcons.eyeSlash),
                                        ),
                                        validator: Validator.passwordValidator,
                                        onChanged: (newValue) {
                                          registrationController.password =
                                              newValue;
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    if (isRegisterMode) ...[
                                      Selector<RegistrationController, bool>(
                                        selector: (_, controller) =>
                                            controller.isPasswordHidden,
                                        builder: (_, isPasswordHidden, __) =>
                                            NoteFormField(
                                          controller: confirmPasswordController,
                                          labelText: 'Confirm Password',
                                          fillColor: !isRegisterMode
                                              ? Colors.green[200]
                                              : white,
                                          filled: true,
                                          obscureText: isPasswordHidden,
                                          suffixIcon: GestureDetector(
                                            onTap: () {
                                              registrationController
                                                      .isPasswordHidden =
                                                  !isPasswordHidden;
                                            },
                                            child: Icon(isPasswordHidden
                                                ? FontAwesomeIcons.eye
                                                : FontAwesomeIcons.eyeSlash),
                                          ),
                                          validator: (confirmPassword) {
                                            return Validator
                                                .confirmPasswordValidator(
                                              passwordController
                                                  .text, // Password value
                                              confirmPassword, // Confirm password value
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 32),
                                    Row(
                                      children: [
                                        const Expanded(child: Divider()),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Text(isRegisterMode
                                              ? 'Or register with'
                                              : 'Or sign in with'),
                                        ),
                                        const Expanded(child: Divider()),
                                      ],
                                    ),
                                    const SizedBox(height: 32),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: NoteIconButtonOutlined(
                                            icon: FontAwesomeIcons.google,
                                            onPressed: () {
                                              registrationController
                                                  .authenticateWithGoogle(
                                                      context: context);
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: NoteIconButtonOutlined(
                                            icon: FontAwesomeIcons.facebook,
                                            onPressed: () {
                                              signInWithFacebook();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      height: 48,
                                      child: Selector<RegistrationController,
                                          bool>(
                                        selector: (_, controller) =>
                                            controller.isLoading,
                                        builder: (_, isLoading, __) =>
                                            NoteButton(
                                          onPressed: isLoading
                                              ? null
                                              : () {
                                                  if (formKey.currentState
                                                          ?.validate() ??
                                                      false) {
                                                    registrationController
                                                        .authenticateWithEmailAndPassword(
                                                            context: context);
                                                  }
                                                },
                                          child: isLoading
                                              ? const SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: white),
                                                )
                                              : Text(isRegisterMode
                                                  ? 'Create my account'
                                                  : 'Log in'),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 32),
                                    Text.rich(
                                      TextSpan(
                                        text: isRegisterMode
                                            ? 'Already have an account? '
                                            : 'Don\'t have an account? ',
                                        style: const TextStyle(color: gray700),
                                        children: [
                                          TextSpan(
                                            text: isRegisterMode
                                                ? 'Sign in'
                                                : 'Register',
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                registrationController
                                                        .isRegisterMode =
                                                    !isRegisterMode;
                                              },
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
