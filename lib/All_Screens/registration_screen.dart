import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/All_Screens/login_screen.dart';
import 'package:rider_app/All_Screens/main_screen.dart';
import 'package:rider_app/All_Widgets/progress_dialog_bar.dart';
import 'package:rider_app/main.dart';
// ignore: must_be_immutable
class RegistrationScreen extends StatelessWidget {
  static const String idScreen="register";
  TextEditingController nameTextEditingController=TextEditingController();
  TextEditingController emailTextEditingController=TextEditingController();
  TextEditingController phoneTextEditingController=TextEditingController();
  TextEditingController passwordTextEditingController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 45.0,),
              Image(
                image: AssetImage("images/logo.png"),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),
              SizedBox(height: 1.0,),
              Text("Register as a Rider",
                style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: "Brand Bold",),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(

                            fontSize: 14.0,
                          )
                      ),
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(
                      height: 1.0,
                    ),

                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(

                            fontSize: 14.0,
                          )
                      ),
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          labelText: "Phone",
                          labelStyle: TextStyle(

                            fontSize: 14.0,
                          )
                      ),
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(
                      height: 1.0,
                    ),


                    SizedBox(height: 1.0,),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(
                          fontSize: 14.0
                      ),
                    ),

                    SizedBox(height: 10.0,),
                    // ignore: deprecated_member_use
                    RaisedButton(
                        color: Colors.yellow,
                        textColor: Colors.white,
                        child:Container(
                          height: 50.0,
                          child: Center(
                            child: Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: "Brand Bold",
                              ),
                            ),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        onPressed: (){
                          if(nameTextEditingController.text.length < 3){
                            displayToastMessage("Name must be atleast 3 character", context);


                          }else if(!emailTextEditingController.text.contains("@"))
                            {
                              displayToastMessage("Email Address is not Valid", context);
                            }
                          else if(phoneTextEditingController.text.isEmpty)
                          {
                            displayToastMessage("Phone Number is mandatory", context);
                          }else if(passwordTextEditingController.text.length < 6)
                          {
                            displayToastMessage("Password Must Be Atleast 6 Characters", context);
                          }else{
                            registerNewUser(context);
                          }





                        }
                    ),
                  ],

                ),
              ),
              // ignore: deprecated_member_use
              FlatButton(
                onPressed:(){
                  Navigator.pushNamedAndRemoveUntil(context,LoginScreen.idScreen, (route) => false);
                },
                child: Text(
                    "Already have an Account? Login Here."

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
        {
          return ProgressDialog(message: "Authenticating Please wait...",);
        }
    );
   final User firebaseUser=(await _firebaseAuth
       .createUserWithEmailAndPassword(
       email: emailTextEditingController.text,
       password: passwordTextEditingController.text
   ).catchError((errMsg){
     Navigator.pop(context);
     displayToastMessage("Error:"+errMsg.toString(), context);
   })).user;
   if(firebaseUser !=null)
   {
    // save user info to database

     Map userDataMap={

       "name":nameTextEditingController.text.trim(),
       "email":emailTextEditingController.text.trim(),
       "phone":phoneTextEditingController.text.trim(),

  };
     usersRef.child(firebaseUser.uid).set(userDataMap);
     displayToastMessage("Congratulations, your account has been created", context);
     Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
   }
   else{
     Navigator.pop(context);
     displayToastMessage("New User Account Has Not been created", context);
   }

  }
  displayToastMessage(String message,BuildContext context){
   Fluttertoast.showToast(msg: message);

  }
}

