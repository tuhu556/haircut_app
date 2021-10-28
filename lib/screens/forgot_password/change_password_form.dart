import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:haircut_app/components/form_error.dart';
import 'package:haircut_app/components/rounded_button.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/constants/validator.dart';
import 'package:haircut_app/screens/forgot_password/password_success_screen.dart';
import 'package:haircut_app/utils/api.dart';
import 'package:http/http.dart' as http;

class ChangePasswordForm extends StatefulWidget {
  @override
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  late String password;
  String? confirmPassword;
  bool _showPass = true;
  bool _showPass2 = true;
  late String email;
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print(email);
      print(password);
      final url = Uri.parse('${Api.url}/updateForgetPassword');
      Map<String, String> body = {
        'cusEmail': email,
        'newPassword': password,
      };
      final response = await http.put(url, body: body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        Navigator.pushNamed(context, PasswordSuccessScreen.routeName);
      } else {
        Flushbar(
          title: "Error",
          message: "Server Error",
          duration: Duration(seconds: 3),
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    if (arguments != null) {
      email = arguments['email'];
    }
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          passwordForm(),
          SizedBox(
            height: size.height * 0.03,
          ),
          confirmPassFormForm(),
          SizedBox(
            height: size.height * 0.03,
          ),
          FormError(errors: errors),
          SizedBox(
            height: size.height * 0.03,
          ),
          RoundedButton(
              text: "Next",
              press: () {
                _submit();
              },
              color: AppColors.color3E3E3E,
              textColor: Colors.white),
        ],
      ),
    );
  }

  TextFormField confirmPassFormForm() {
    return TextFormField(
      obscureText: _showPass2,
      onSaved: (newValue) => confirmPassword = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && password == confirmPassword) {
          removeError(error: kMatchPassError);
        }
        confirmPassword = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((password != value)) {
          print(password == value);
          print(password);
          print(value);

          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        labelText: "Confirm Password",
        hintText: "Re-enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: InkWell(
          child: _showPass2
              ? Icon(
                  Icons.visibility,
                )
              : Icon(Icons.visibility_off),
          onTap: () {
            setState(() {
              _showPass2 = !_showPass2;
            });
          },
        ),
      ),
    );
  }

  TextFormField passwordForm() {
    return TextFormField(
      obscureText: _showPass,
      onSaved: (newValue) => password = newValue ?? "",
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        password = value;
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
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
        suffixIcon: InkWell(
          child: _showPass
              ? Icon(
                  Icons.visibility,
                )
              : Icon(Icons.visibility_off),
          onTap: () {
            setState(() {
              _showPass = !_showPass;
            });
          },
        ),
      ),
    );
  }
}
