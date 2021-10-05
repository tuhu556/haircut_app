import 'package:flutter/material.dart';
import 'package:haircut_app/components/form_error.dart';
import 'package:haircut_app/components/rounded_button.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/constants/validator.dart';
import 'package:haircut_app/screens/forgot_password/change_password_screen.dart';
import 'package:haircut_app/screens/home/home_screen.dart';

class CodeForm extends StatefulWidget {
  @override
  _CodeFormState createState() => _CodeFormState();
}

class _CodeFormState extends State<CodeForm> {
  final _formKey = GlobalKey<FormState>();
  String? code;
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
          codeForm(),
          SizedBox(
            height: size.height * 0.03,
          ),
          FormError(errors: errors),
          SizedBox(
            height: size.height * 0.05,
          ),
          RoundedButton(
              text: "Next",
              press: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Navigator.pushNamed(
                    context,
                    ChangePasswordScreen.routeName,
                  );
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
      onSaved: (newValue) => code = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kCodeNullError);
        }
        return null;
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
