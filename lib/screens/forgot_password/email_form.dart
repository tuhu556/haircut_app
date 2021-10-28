import 'package:flutter/material.dart';
import 'package:haircut_app/components/form_error.dart';
import 'package:haircut_app/components/rounded_button.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/constants/validator.dart';
import 'package:haircut_app/screens/forgot_password/verify_code_forgot_pass_screen.dart';
import 'package:haircut_app/screens/forgot_password/verify_code_screen.dart';
import 'package:haircut_app/utils/api.dart';
import 'package:http/http.dart' as http;

class EmailForm extends StatefulWidget {
  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final _formKey = GlobalKey<FormState>();
  late String email;
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
          FormError(errors: errors),
          SizedBox(
            height: size.height * 0.05,
          ),
          RoundedButton(
              text: "Next",
              press: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final url = Uri.parse('${Api.url}/sendEmail');
                  Map<String, String> body = {
                    'cusEmail': email,
                  };
                  final response = await http.post(url, body: body);
                  if (response.statusCode == 201) {
                    Navigator.pushNamed(
                      context,
                      VerifyCodeForgotPassScreen.routeName,
                      arguments: {
                        'email': email,
                      },
                    );
                  } else if (response.statusCode == 404) {
                    addError(error: kNotFoundEmailError);
                  }
                }
              },
              color: AppColors.color3E3E3E,
              textColor: Colors.white),
        ],
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
