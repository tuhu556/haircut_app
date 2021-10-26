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

class CodeForm extends StatefulWidget {
  @override
  _CodeFormState createState() => _CodeFormState();
}

class _CodeFormState extends State<CodeForm> {
  final _formKey = GlobalKey<FormState>();
  late String code;
  late String email;
  late String password;
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
      final url2 = Uri.parse('${Api.url}/customerLogin');
      Map<String, String> body = {
        'cusEmail': email,
        'password': password,
      };
      final response2 = await http.post(url2, body: body);
      if (response2.statusCode == 200) {
        Customer userData = Customer.formJson(json.decode(response2.body));
        var _save = json.encode(userData.toJson());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("user_data", _save);
        prefs.setString("email", email);
        prefs.setString("token", userData.token);
        String? token = prefs.getString("token");
        print(token);
        Navigator.pushNamed(context, HomeScreen.routeName);
      }
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
      password = arguments['password'];
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
                /* if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Navigator.pushNamed(
                    context,
                    ChangePasswordScreen.routeName,
                  );
                } */
                _submit();
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
