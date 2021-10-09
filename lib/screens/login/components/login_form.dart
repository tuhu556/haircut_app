import 'dart:async';
import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:haircut_app/components/form_error.dart';
import 'package:haircut_app/components/rounded_button.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/constants/validator.dart';
import 'package:haircut_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:haircut_app/screens/home/home_screen.dart';
import 'package:haircut_app/utils/api.dart';
import 'package:http/http.dart' as http;


class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late String email;
  late String password;
  bool? remember = false;
  bool isLoading = false;
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  var loading = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      CircularProgressIndicator(),
      Text(" Authenticating ... Please wait")
    ],
  );
    
  Future _submit() async {
    setState((){
      isLoading = true;
    });
    if (!_formKey.currentState!.validate()) {
      //invalid
      setState((){
        isLoading = false;
      });
      return;
    }
    _formKey.currentState!.save();
    final url = Uri.parse('${Api.url}/customerLogin');
    Map<String, String> body = {
    'cusEmail': email,
    'password': password,
    };
    final response = await http.post(url,
      body: body
    );
    
    if (response.statusCode == 200) {
      Navigator.pushNamed(context, HomeScreen.routeName);
    } else {
      Flushbar(
        title: "Failed Login",
        message: "Wrong email or password",
        duration: Duration(seconds: 3),
      ).show(context);
    }
    setState((){
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          emailForm(),
          SizedBox(
            height: size.height * 0.03,
          ),
          passwordForm(),
          SizedBox(
            height: size.height * 0.03,
          ),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: AppColors.color3E3E3E,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              Text("Remenber me"),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    ForgotPasswordScreen.routeName,
                  );
                },
                child: Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(
            height: size.height * 0.05,
          ),
          !isLoading ? new RoundedButton(
              text: "Next",
              press: () {
                _submit();
              },
              color: AppColors.color3E3E3E,
              textColor: Colors.white) : Center(
                      child: CircularProgressIndicator(),
                    ),
        ],
      ),
    );
  }

  TextFormField passwordForm() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue ?? "",
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length < 1) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 1) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        labelText: "Password",
        hintText: "Enter your Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(
          Icons.lock_outline,
        ),
      ),
    );
  }

  TextFormField emailForm() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue ?? "",
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        labelText: "Email",
        hintText: "Enter your email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.email_outlined),
      ),
    );
  }
}
