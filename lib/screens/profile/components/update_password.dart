import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:haircut_app/components/form_error.dart';
import 'package:haircut_app/components/rounded_button.dart';
import 'package:haircut_app/constants/color.dart';
import 'package:haircut_app/constants/validator.dart';
import 'package:haircut_app/utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({ Key? key }) : super(key: key);

  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final _formKey = GlobalKey<FormState>();
  late String password;
  late String newPassword;
  late String confirmNewPassword;
  bool _showPass = true;
  bool isLoading = false;
  var _passwordController = TextEditingController();
  var _newPasswordController = TextEditingController();
  var _confirmNewPasswordController = TextEditingController();
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

  void _submit() async {
    setState(() {
      isLoading = true;
    });
    if (!_formKey.currentState!.validate()) {
      //invalid
      setState(() {
        isLoading = false;
      });
      return;
    }
    //_formKey.currentState!.save();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('${Api.url}/updateCustomerPassword');
    Map<String, String> requestHeaders = {"Authorization": "${prefs.getString("token")}"};
    Map<String, String> body = {
      'cusEmail': prefs.getString("email") ?? "",
      'password': password,
      'newPassword': newPassword,
    };
    final response = await http.put(url, headers: requestHeaders, body: body);

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      _passwordController.clear();
      _newPasswordController.clear();
      _confirmNewPasswordController.clear();
      errors.clear();
      Flushbar(
        title: "Successful",
        message: "Password changed successfully",
        duration: Duration(seconds: 3),
      ).show(context);
    } else if (response.statusCode == 404) {
      Flushbar(
        title: "Failed",
        message: "Current password is incorrect",
        duration: Duration(seconds: 3),
      ).show(context);
    }
    
    /* if (response.statusCode == 200) {
      Customer userData = Customer.formJson(json.decode(response.body));
      var _save = json.encode(userData.toJson());
      
      prefs.setString("user_data", _save);
      prefs.setString("email", email);
      prefs.setString("name", userData.cusName);
      prefs.setString("token", userData.token);
      String? token = prefs.getString("token");
      print(token);
      final notificationModel =
          Provider.of<BadgeNotification>(context, listen: false);
      notificationModel.getTotalNotification();
      Navigator.pushNamed(context, HomeScreen.routeName);
    } else if (response.statusCode == 208) {
      Navigator.pushNamed(context, VerifyCodeScreen.routeName,
          arguments: {'email': email, 'password': password});
    } else {
      Flushbar(
        title: "Failed Login",
        message: "Wrong email or password",
        duration: Duration(seconds: 3),
      ).show(context);
    } */
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color3E3E3E,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                    top: 10.0, left: 30.0, right: 30.0, bottom: 7.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Update Password",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              /////////////////////////////////////
              Expanded(
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        Image.asset("assets/images/password.png", height: 100,),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              SizedBox(height: 35,),
                              passwordForm(),
                              SizedBox(height: 35,),
                              newPasswordForm(),
                              SizedBox(height: 35,),
                              newConfirmPasswordForm(),
                              SizedBox(height: 25,),
                              FormError(errors: errors),
                              SizedBox(height: 25,),
                              !isLoading ? new RoundedButton(
                                text: "Update",
                                press: () {
                                  _submit();
                                },
                                color: AppColors.color3E3E3E,
                                textColor: Colors.white)
                              : Center(
                                child: CircularProgressIndicator(),
                              ),
                            ]
                          )
                        )
                      ],
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  TextFormField passwordForm() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _showPass,
      onSaved: (newValue) => password = newValue ?? "",
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length < 1) {
          removeError(error: kShortPassError);
        }
        password = value;
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
        labelText: "Current Password",
        hintText: "Enter your current Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField newPasswordForm() {
    return TextFormField(
      controller: _newPasswordController,
      obscureText: _showPass,
      onSaved: (newValue) => newPassword = newValue ?? "",
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length < 1) {
          removeError(error: kShortPassError);
        }
        newPassword = value;
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
        labelText: "New Password",
        hintText: "Enter your new Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField newConfirmPasswordForm() {
    return TextFormField(
      obscureText: _showPass,
      controller: _confirmNewPasswordController,
      onSaved: (newValue) => confirmNewPassword = newValue ?? "",
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length < 1) {
          removeError(error: kShortPassError);
        }
        confirmNewPassword = value;
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((newPassword != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        errors.clear();
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        labelText: "Confirm New Password",
        hintText: "Enter your new Password again",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}