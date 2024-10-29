import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:provider/provider.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

import '../components/loader.dart';
import '../utils/appprovider.dart';
import 'home.dart';

class VerificationPage extends StatefulWidget {
  static const String route = '/verification';
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  int endTime =
      DateTime.now().millisecondsSinceEpoch + 1000 * 30; // 30 seconds from now
  bool _isResendButtonActive = false;
  String _smsCode = '';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final intRegex = RegExp(r'\d+', multiLine: true);
  TextEditingController textEditingController = TextEditingController(text: "");
  String _otpCode = '';
  bool _enableButton = false;
  final int _otpCodeLength = 6;

  @override
  void initState() {
    super.initState();
    _startListeningSms();
  }

  @override
  void dispose() {
    super.dispose();
    SmsVerification.stopListening();
  }

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Theme.of(context).primaryColor),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  /// listen sms
  _startListeningSms() {
    SmsVerification.startListeningSms().then((message) {
      setState(() {
        _smsCode = SmsVerification.getCode(message, intRegex);
        textEditingController.text = _smsCode;
        _onOtpCallBack(_smsCode, true);
      });
    });
  }

  _onSubmitOtp() {
    setState(() {
      _verifyOtpCode();
    });
  }

  _onClickRetry() {
    _startListeningSms();
  }

  _onOtpCallBack(String otpCode, bool isAutofill) {
    setState(() {
      _otpCode = otpCode;
      if (otpCode.length == _otpCodeLength && isAutofill) {
        _enableButton = false;

        _verifyOtpCode();
      } else if (otpCode.length == _otpCodeLength && !isAutofill) {
        _enableButton = true;
      } else {
        _enableButton = false;
      }
    });
  }

  _verifyOtpCode() async {
    FocusScope.of(context).requestFocus(FocusNode());
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    CustomLoader.show(context);

    try {
      // Get the verification id from the arguments
      final String verificationId = appProvider.verificationId;
      print("verificationId: $verificationId");

      // Create a PhoneAuthCredential with the verification id and the sms code
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: _otpCode,
      );

      // Sign in with the credential
      await FirebaseAuth.instance.signInWithCredential(credential);

      // If the sign in is successful, navigate to the home page
      Navigator.pushReplacementNamed(context, HomePage.route);
    } catch (e) {
      // If the sign in is not successful, show an error message
      showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text('${e.toString()}'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      CustomLoader.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.green.withOpacity(0.3),
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                  width: size.width,
                  height: size.height,
                  child: Image.asset(
                    'assets/images/girl.jpg',
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
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

                        Container(
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Enter the 6-digit code sent to your phone',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontFamily: 'Roboto'),
                                ),
                                const SizedBox(height: 30),
                                TextFieldPin(
                                  textController: textEditingController,
                                  autoFocus: true,
                                  codeLength: 6,
                                  alignment: MainAxisAlignment.center,
                                  defaultBoxSize: 46.0,
                                  margin: 2,
                                  selectedBoxSize: 46.0,
                                  textStyle: const TextStyle(fontSize: 16),
                                  defaultDecoration: _pinPutDecoration.copyWith(
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.6))),
                                  selectedDecoration: _pinPutDecoration,
                                  onChange: (code) {
                                    if (code.length == _otpCodeLength) {
                                      setState(() {
                                        _otpCode = code;
                                      });
                                      _verifyOtpCode();
                                    }
                                  },
                                ),
                                CountdownTimer(
                                  endTime: endTime,
                                  onEnd: () {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      setState(() {
                                        _isResendButtonActive = true;
                                      });
                                    });
                                  },
                                  textStyle: const TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                                const SizedBox(height: 10),
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
                                  onPressed: _isResendButtonActive
                                      ? _onSubmitOtp
                                      : null,
                                  child: const Text('RESEND',
                                      style: TextStyle(fontSize: 20)),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.03),
                              ],
                            ),
                          ),
                        ),
                        //   ),
                        // ),
                      ],
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
