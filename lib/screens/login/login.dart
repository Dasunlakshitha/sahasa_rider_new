import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sahasa_rider_new/api/api.dart';
import 'package:sahasa_rider_new/helpers/user_authentication_service.dart';
import 'package:sahasa_rider_new/models/login.dart';
import 'package:sahasa_rider_new/models/user.dart';
import 'package:sahasa_rider_new/screens/orders/orders_new.dart';
import 'package:sahasa_rider_new/toast.dart';
import '../../helpers/localvariables.dart';
import '../../helpers/sendfirebase.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool buttonLoading = false;
  final _formKey = GlobalKey<FormState>();
  Users result = Users();
  final LoginData loginData = LoginData();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(640, 1136),
        orientation: Orientation.portrait);
    return Scaffold(
      backgroundColor: Colors.white12,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _title(),
              const SizedBox(
                height: 20,
              ),
              _formWidget(),
              const SizedBox(height: 30),
              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  _login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (!buttonLoading) {
        setState(() {
          buttonLoading = true;
        });
        result = await Api().loginApi(
            loginData.username, loginData.password, loginData.subdomain);

        if (!result.done) {
          errorMessage(result.message);
          setState(() {
            buttonLoading = false;
          });
        } else {
          await saveStringValue('user', jsonEncode(result.body.user));
          if (await readStringValue('token') != '') {
            await SendUser().deleteDeviceToken();
          }
          await SendUser().saveDeviceToken(result.body.user.accountId);
          updateUserAuthPref(key: "ssUserAuth", data: result.body.user);
          setState(() {
            buttonLoading = false;
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrdersNew(
                screenNum: null,
              ),
            ),
          );
        }
      }
    }
  }

  Widget _title() {
    return Image.asset(
      "assets/images/logo.png",
      width: MediaQuery.of(context).size.width * 0.7,
    );
  }

  Widget _formWidget() {
    return Form(
        autovalidateMode: AutovalidateMode.disabled,
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Username',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.sp,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              controller: username,
              validator: (value) {
                if (value.isEmpty) {
                  // return errorMessage('Username Required.');
                }
                return null;
              },
              onSaved: (value) {
                setState(() {
                  loginData.username = value.toString();
                });
              },
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  fillColor: Colors.black,
                  hintStyle: TextStyle(fontSize: 20.sp, color: Colors.white70),
                  hintText: 'Username'),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Password',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.sp,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              controller: password,
              obscureText: true,
              validator: (value) {
                if (value.isEmpty) {
                  // return errorMessage('Password Required.');
                }
                return null;
              },
              onSaved: (value) {
                setState(() {
                  loginData.password = value.toString();
                });
              },
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                fillColor: Colors.black,
                hintStyle: TextStyle(fontSize: 20.sp, color: Colors.white70),
                hintText: 'Password',
                // suffixIcon:IconButton(onPressed: (){}, icon: Icon(Icons.visibility_off)),
              ),
            ),
          ],
        ));
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        _login();
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2.4,
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xff206BE2), Color(0xff206BE2)])),
        child: buttonLoading
            ? const CircularProgressIndicator(
                color: Colors.orange,
              )
            : Text(
                "Login",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35.sp,
                    color: Colors.white),
              ),
      ),
    );
  }
}
