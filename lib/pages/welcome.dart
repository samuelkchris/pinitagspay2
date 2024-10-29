import 'dart:ui';

import 'package:extended_phone_number_input/consts/enums.dart';
import 'package:extended_phone_number_input/phone_number_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinnitagpay/pages/sentlink.dart';
import 'package:provider/provider.dart';

import '../components/loader.dart';
import '../utils/appprovider.dart';

class WelcomePage extends StatefulWidget {
  static const String route = '/welcome';
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  double _sigmaX = 5;
  double _sigmaY = 5;
  double _opacity = 0.2;
  final _formKey = GlobalKey<FormState>();
  bool _isPhoneNumberValid = false;
  String _phoneNumber = '';

  Future<void> signInWithPhoneNumber(String phoneNumber) async {
    bool isVerificationSuccessful = false;
    CustomLoader.show(context);
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
          isVerificationSuccessful = true;
          UserCredential userCredential =
              await auth.signInWithCredential(credential);
          if (userCredential.additionalUserInfo!.isNewUser) {
            //if the user is new, create a new user in authentication
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          // authentication failed, do something
        },
        codeSent: (String verificationId, int? resendToken) async {
          // code sent to phone number, save verificationId for later use
          appProvider.setVerificationId(verificationId);
          CustomLoader.hide();
          Navigator.pushNamed(context, VerificationPage.route,
              arguments: [verificationId]);
          print('verificationId: $verificationId');
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      CustomLoader.hide();
      // Handle the exception
      print('Failed to verify phone number: $e');
    } finally {
      if (isVerificationSuccessful) {
        CustomLoader.hide();
      }
      // Code to be executed regardless of exception occurrence
      print('Verification process completed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.green.withOpacity(0.3),
        body: Container(
          height: size.height,
          width: size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/girl.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2),
                        Image.asset(
                          'assets/images/PinniSoft Logos-01.png',
                          width: 200,
                          height: 100,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                                sigmaX: _sigmaX, sigmaY: _sigmaY),
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: const Color.fromRGBO(0, 0, 0, 1)
                                      .withOpacity(_opacity),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30))),
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: Form(
                                key: _formKey,
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Lets get started',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03),
                                      const SizedBox(height: 20),
                                      PhoneNumberInput(
                                          errorText: 'Invalid phone number',
                                          initialCountry: 'UG',
                                          locale: 'en',
                                          allowPickFromContacts: false,
                                          countryListMode:
                                              CountryListMode.dialog,
                                          contactsPickerPosition:
                                              ContactsPickerPosition.suffix,
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Colors.white)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Colors.white)),
                                          onChanged: (value) {
                                            setState(() {
                                              _phoneNumber = value;
                                              //check if the phone number is valid
                                              if (value.length >= 9) {
                                                _isPhoneNumberValid = true;
                                              } else {
                                                _isPhoneNumberValid = false;
                                              }
                                            });
                                          }),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.deepPurple,
                                          minimumSize: const Size(150, 50),
                                          maximumSize: const Size(150, 50),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                          ),
                                        ),
                                        onPressed: _isPhoneNumberValid
                                            ? () async {
                                                print(
                                                    'phone number: $_phoneNumber');

                                                signInWithPhoneNumber(
                                                    _phoneNumber);
                                              }
                                            : null,
                                        child: const Text('NEXT',
                                            style: TextStyle(fontSize: 20)),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        ));
  }
}
