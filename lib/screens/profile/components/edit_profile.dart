import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:haircut_app/components/form_error.dart';
import 'package:haircut_app/components/rounded_button.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/constants/validator.dart';
import 'package:haircut_app/models/customer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  
  EditProfile({ Key? key }) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  String? email;
  String? fullName;
  String? phoneNumber;
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

  Future<bool> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Customer customer = Customer.formJson(json.decode(prefs.getString("user_data") ?? ""));
    email = customer.cusEmail;
    fullName = customer.cusName;
    phoneNumber = customer.phone;
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.color3E3E3E,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5.0),
                    bottomRight: Radius.circular(5.0),
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  height: 160,
                  child: Container(
                    alignment: Alignment(0.0,4.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 60.0,
                      child: CircleAvatar(
                        backgroundColor: Color(0xFF8EE4FA),
                        backgroundImage: NetworkImage(
                            "https://i.imgur.com/jc5noE0.png"
                        ),
                        radius: 55.0,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Form(
                  key: _formKey,
                  child: FutureBuilder(
                    future: getData(),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (!snapshot.hasData) {
                        return Container(
                          margin: const EdgeInsets.only(top: 80),
                          child: Center(
                            child: Text("You are employee", style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error'),
                        );
                      } else {
                        return Column(
                          children: [
                            SizedBox(height: 80,),
                            emailForm(),
                            SizedBox(height: 30,),
                            fullNameForm(),
                            SizedBox(height: 30,),
                            phoneNumberForm(),
                            FormError(errors: errors),
                            SizedBox(height: 30,),
                            !isLoading
                                ? new RoundedButton(
                                    text: "Update",
                                    press: () {
                                      
                                    },
                                    color: AppColors.color3E3E3E,
                                    textColor: Colors.white)
                                : Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  TextFormField emailForm() {
    return TextFormField(
      readOnly: true,
      initialValue: email,
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

  TextFormField fullNameForm() {
    return TextFormField(
      keyboardType: TextInputType.name,
      initialValue: fullName,
      onSaved: (newValue) => fullName = newValue ?? "",
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        labelText: "Full Name",
        hintText: "Enter your Full Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.contact_mail),
      ),
    );
  }

  TextFormField phoneNumberForm() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      initialValue: phoneNumber,
      onSaved: (newValue) => phoneNumber = newValue ?? "",
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        } else if (phoneValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidPhoneError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        } else if (!phoneValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidPhoneError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        labelText: "Phone",
        hintText: "Enter your Phone Number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.phone_android_rounded),
      ),
    );
  }
}