import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project1/services/custom_firebase.dart';
import 'package:project1/shared/spinkit_screen.dart';
import 'package:project1/shared/text_field.dart';

// ignore: must_be_immutable
class SignUp extends StatefulWidget {
  SignUp({Key? key, required this.toggleView}) : super(key: key);
  Function toggleView;

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? _userPassword;
  String? _userEmail;
  String? _userUserName;
  bool ispressed = false;
  bool isSeen = true;
  final _formKey = GlobalKey<FormState>();

  final _auth = CustomFirebase.instance;

  @override
  Widget build(BuildContext context) {
    return ispressed
        ? SpinkitScreen()
        : Scaffold(
            backgroundColor: Colors.indigo,
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 120,
                    ),
                    Text(
                      "Sign Up With Email And Password",
                      style: GoogleFonts.aldrich(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: ((val) =>
                                setState(() => _userUserName = val)),
                            decoration:
                                txtField.copyWith(hintText: 'Enter Username'),
                            validator: ((val) =>
                                val!.isEmpty ? 'Provide valid username' : null),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: ((val) =>
                                setState(() => _userEmail = val)),
                            decoration:
                                txtField.copyWith(hintText: 'Enter Email'),
                            validator: ((val) =>
                                val!.isEmpty || !val.trim().contains('@')
                                    ? 'Provide valid email'
                                    : null),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            obscureText: isSeen,
                            textInputAction: TextInputAction.go,
                            keyboardType: TextInputType.visiblePassword,
                            onChanged: ((val) =>
                                setState(() => _userPassword = val)),
                            decoration: txtField.copyWith(
                              hintText: 'Enter Password',
                              suffixIcon: IconButton(
                                onPressed: () =>
                                    setState(() => isSeen = !isSeen),
                                icon: Icon(!isSeen
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                            ),
                            validator: ((val) =>
                                val!.length < 6 ? 'Password must be 6+' : null),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      width: double.infinity,
                      child: ElevatedButton(
                        autofocus: true,
                        focusNode: FocusNode(canRequestFocus: true),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              ispressed = true;
                            });
                            dynamic userState =
                                await _auth.createAccoutWithEmailAndPassword(
                              email: _userEmail.toString(),
                              password: _userPassword.toString(),
                              userName: _userUserName.toString(),
                            );
                            if (userState == null) {
                              print(_userEmail);
                              setState(() {
                                ispressed = false;
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.indigo),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      splashColor: Colors.indigo.shade600,
                      hoverColor: Colors.indigo.shade600,
                      highlightColor: Colors.indigo.shade600,
                      onTap: () {
                        dynamic user = _auth.googleSignIn(context);
                        setState(() {
                          ispressed = true;
                        });
                        if (user == null) {
                          setState(() {
                            ispressed = false;
                          });
                        }
                      },
                      child: Card(
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: ListTile(
                          leading: FaIcon(
                            FontAwesomeIcons.google,
                            color: Colors.indigo,
                          ),
                          title: Text(
                            'Sign In With Your google Account',
                            style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: 'Already have an account? '),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  widget.toggleView();
                                },
                              text: 'Sign In',
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      _auth.errorMess,
                      style: GoogleFonts.aldrich(
                        color: Colors.red,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
