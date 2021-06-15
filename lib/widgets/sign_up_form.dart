import 'package:flutter/material.dart';
import 'package:insta_clone/constants/auth_input_decor.dart';
import 'package:insta_clone/constants/common_size.dart';
import 'package:insta_clone/home_page.dart';
import 'package:insta_clone/models/fire_base_auth_state.dart';
import 'package:provider/provider.dart';

import 'or_divider.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwController = TextEditingController();
  TextEditingController _cpwController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    _cpwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(common_gap),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(
                height: common_l_gap,
              ),
              Image.asset('assets/images/insta_text_logo.png'),
              TextFormField(
                controller: _emailController,
                decoration: inputDecoration('Email'),
                cursorColor: Colors.black54,
                validator: (text) {
                  if (text.isNotEmpty && text.contains('@')) {
                    return null;
                  } else {
                    return 'correct Email';
                  }
                },
              ),
              SizedBox(
                height: common_s_gap,
              ),
              TextFormField(
                controller: _pwController,
                decoration: inputDecoration('Password'),
                cursorColor: Colors.black54,
                obscureText: true,
                validator: (text) {
                  if (text.isNotEmpty && text.length > 5) {
                    return null;
                  } else {
                    return 'correct Password';
                  }
                },
              ),
              SizedBox(
                height: common_s_gap,
              ),
              TextFormField(
                controller: _cpwController,
                decoration: inputDecoration('Confirm Password'),
                cursorColor: Colors.black54,
                obscureText: true,
                validator: (text) {
                  if (text.isNotEmpty && _pwController.text == text) {
                    return null;
                  } else {
                    return 'not Samed';
                  }
                },
              ),
              SizedBox(
                height: common_s_gap,
              ),
              _submitButton(context),
              SizedBox(
                height: common_s_gap,
              ),
              OrDivider(),
              FlatButton.icon(
                onPressed: () {
                  Provider.of<FirebaseAuthState>(context, listen: false)
                      .changeFirebaseAuthStatus(FirebaseAuthStatus.signin);
                },
                icon: ImageIcon(AssetImage('assets/images/facebook.png')),
                label: Text('Login with Facebook'),
                textColor: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  FlatButton _submitButton(BuildContext context) {
    return FlatButton(
      color: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      onPressed: () {
        if (_formKey.currentState.validate()) {
          print('validation success');
          Provider.of<FirebaseAuthState>(context, listen: false).registerUser(
            context, email: _emailController.text, password: _pwController.text);
        }
      },
      child: Text(
        'Join',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
