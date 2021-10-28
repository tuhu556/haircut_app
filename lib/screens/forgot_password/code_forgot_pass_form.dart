import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:haircut_app/components/form_error.dart';
import 'package:haircut_app/components/rounded_button.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/constants/validator.dart';
import 'package:haircut_app/models/customer.dart';
import 'package:haircut_app/screens/forgot_password/change_password_screen.dart';
import 'package:haircut_app/screens/home/home_screen.dart';
import 'package:haircut_app/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CodeForgotPassForm extends StatefulWidget {
  @override
  _CodeForgotPassFormState createState() => _CodeForgotPassFormState();
}

class _CodeForgotPassFormState extends State<CodeForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  late String code;
  late String email;
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

  Future _submit() async {
    setState(() {
      isLoading = true;
      errors.clear();
    });
    if (!_formKey.currentState!.validate()) {
      //invalid
      setState(() {
        isLoading = false;
      });
      return;
    }

    final url =
        Uri.parse('${Api.url}/checkCode?cusEmail=${email}&code=${code}');
    final response = await http.get(url);

    print(response.statusCode);

    if (response.statusCode == 200) {
      Navigator.pushNamed(context, ChangePasswordScreen.routeName,
          arguments: {"email": email});
    } else if (response.statusCode == 204) {
      addError(error: "Your code didn't mismatch");
      /* Flushbar(
        title: "Error",
        message: "Email existed",
        duration: Duration(seconds: 3),
      ).show(context); */
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    if (arguments != null) {
      email = arguments['email'];
    }

    //email = arguments["email"];
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          codeForm(),
          SizedBox(
            height: size.height * 0.03,
          ),
          FormError(errors: errors),
          SizedBox(
            height: size.height * 0.05,
          ),
          RoundedButton(
              text: "Verify",
              press: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _submit();
                }
              },
              color: AppColors.color3E3E3E,
              textColor: Colors.white),
        ],
      ),
    );
  }

  TextFormField codeForm() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => code = newValue ?? "",
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kCodeNullError);
        }
        code = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kCodeNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        labelText: "Code",
        hintText: "Enter your code",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.admin_panel_settings_outlined),
      ),
    );
  }
}
