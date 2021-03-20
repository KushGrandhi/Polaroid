import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth=FirebaseAuth.instance;
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          'Polaroid',
                          style: TextStyle(
                            color: Theme.of(context).accentTextTheme.title.color,
                            fontSize: 50,
                            fontFamily: 'Anton',
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;
  @override
  void initState() {
    super.initState();
    _controller=AnimationController(vsync: this,duration: Duration(milliseconds: 300));
    _slideAnimation=Tween<Offset>(begin:Offset(0,-1.5),end:Offset(0,0)).
    animate(CurvedAnimation(parent: _controller,curve: Curves.fastOutSlowIn));
    //_heightAnimation.addListener(()=>setState((){}));
    _opacityAnimation=Tween(begin: 0.0,end: 1.0).animate(CurvedAnimation(parent: _controller,
        curve: Curves.easeIn));
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message,String head){
    showDialog(context: context,builder: (ctx)=>AlertDialog(
      title: Text(head),
      content: Text(message),
      actions: <Widget>[
        FlatButton(child: Text('Okay'),onPressed: (){
          Navigator.of(ctx).pop();
        },)
      ],
    ));
  }
  Future<void> _submit() async{
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try{
      if (_authMode == AuthMode.Login) {
        // Log user in

        UserCredential usercred=await FirebaseAuth.instance.signInWithEmailAndPassword
          (email:_authData['email'], password:_authData['password']);


        Navigator.of(context).pushNamed('/BottomNavigator');
        print("Successfully created");
      } else {
        // Sign user up

        UserCredential userCred=await FirebaseAuth.instance.createUserWithEmailAndPassword
          (email:_authData['email'], password:_authData['password']);
        _showErrorDialog("Signed up! login back","Successful");
        print("successfully signed up");
      }
    } on HttpException catch(error){
      var errorMessage=error.toString();
      // if(error.toString().contains('EMAIL_EXISTS')){
      //   errorMessage='This email address is already in use';
      // }
      // else if(error.toString().contains('INVALID_EMAIL')){
      //   errorMessage='This is not a valid email address';
      // }
      // else if(error.toString().contains('WEAK_PASSWORD')){
      //   errorMessage='Password is too weak';
      // }
      // else if(error.toString().contains('EMAIL_NOT_FOUND')){
      //   errorMessage='Could not find a user with that email';
      // }
      // else if(error.toString().contains('INVALID_PASSWORD')){
      //   errorMessage='Invalid password';
      // }
      _showErrorDialog(errorMessage,"An error occurred");
    }
    catch(error){
      const errorMessage='Could not authenticate you. Please try again later.';
      print(error);
      _showErrorDialog(errorMessage,"An error occurred");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.Signup ? 320 : 260,
        //height: _heightAnimation.value.height,
        constraints:
        BoxConstraints(minHeight:_authMode == AuthMode.Signup ? 320 : 260 ),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child:Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),

                AnimatedContainer(
                  constraints: BoxConstraints(minHeight: _authMode==AuthMode.Signup?60:0,
                      maxHeight:_authMode==AuthMode.Signup?1200:0 ),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity:_opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        enabled: _authMode == AuthMode.Signup,
                        decoration: InputDecoration(labelText: 'Confirm Password'),
                        obscureText: true,
                        validator: _authMode == AuthMode.Signup
                            ? (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match!';
                          }
                          return null;
                        }
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child:
                    Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                    EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}