import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterapppp/displaytermsandcondtion.dart';
import 'package:flutterapppp/homepage.dart';
import 'package:flutterapppp/main.dart';
import 'package:flutterapppp/secondpage.dart';



class SignInPage extends StatelessWidget {
bool accept=false;
SignInPage(this.accept);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:SignInPagehome(accept)
      
    );
  }
}


class SignInPagehome extends StatefulWidget{
  bool accept=false;
  SignInPagehome(this.accept);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignInPage();
  }

}



class _SignInPage extends State<SignInPagehome>{
  final _formkey=GlobalKey<FormState>();
  final formkey=GlobalKey<FormState>();
  bool check=true;
  TextEditingController _textEditingController;
  TextEditingController textEditingController;
  FirebaseAuth _auth =FirebaseAuth.instance;
  String phno;
  String verficationid;
  String smscode;
  
  bool varification=false;
  bool lock=false;
  String text=" on premises owned or managed by the Charity...";
  Future<void> signinwithphno(BuildContext context) async {
       print(phno);
    final PhoneCodeAutoRetrievalTimeout autoretrival = (String verid) {
      this.verficationid = verid;
        
    
    };
    final PhoneCodeSent smscodesent = (String verid, [int forceCodeResend]) {
      this.verficationid = verid;
      print("box send");
      smsentybox(context);
    };
    final PhoneVerificationCompleted onCompleted = (AuthCredential authcredicial) {
      _auth.signInWithCredential(authcredicial).whenComplete((){
       
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LandingPage()),  (Route<dynamic> route)=>false);
       
      });
  setState(() {
     AuthStatus.Botomnavigation;
       check=true;
  });
    
      print("completed");
      print("object");
     
                     
    };
    // ignore: non_constant_identifier_names
    final PhoneVerificationFailed verfictionFaile = (AuthException exp) {
     showDialog(context: context,
     builder: (context){
       return AlertDialog(
          title: Text("Validation Failed"),
          content: Text(exp.message),
          actions: <Widget>[
            FlatButton(onPressed: (){
               Navigator.pop(context);
                 Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>SignInPage(false)),  (Route<dynamic> route)=>false);
            }, child: Text("Try again"))
          ],
       );
     }
    );};
    await _auth.verifyPhoneNumber(
      phoneNumber: this.phno,
      timeout:const Duration(seconds: 5),
      verificationCompleted: onCompleted,
      verificationFailed: verfictionFaile,
      codeSent: smscodesent,
      codeAutoRetrievalTimeout: autoretrival,
    );
  }
  Future<bool>smsentybox(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("enter a OTP"),
            content: Form(
              key: formkey,
             child: TextFormField(
                decoration: InputDecoration(labelText: "OTP",border: OutlineInputBorder()),
                controller: textEditingController,
                   keyboardType: TextInputType.number,
                onChanged: (value){                 
                  this.smscode=value;
                },
                 validator: (String val){
                   if(val.isEmpty)
                     return "please enter a otp";
                   else if(val.length!=6)
                       return "please enter a currect  otp";
                     else if(val.trim().isEmpty)
                        return "please enter a otp ";
                    else if(val.compareTo(verficationid)!=0)
                    return "Invalid OTP";
                        return null;                  
                  },
                  

              ),
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              FlatButton(
                child: Text("Done"),
                onPressed: (){
                  if(formkey.currentState.validate())
                  {
 FirebaseAuth.instance.currentUser().then((user){
                    if(user!=null)
                    {
                     
                     
                    
                       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LandingPage()),  (Route<dynamic> route)=>false);
                    }
                    else{
                      Navigator.of(context).pop();
                      sign();
                    }
                  });
                  }
                 
                },
              )
            ],
          );
        });
  }

  sign() async{

    final AuthCredential credential=PhoneAuthProvider.getCredential(verificationId: verficationid, smsCode: smscode);

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    FirebaseUser cutrntuser=await _auth.currentUser();
   
    if(user!=null && cutrntuser.phoneNumber!=null)
    {
     
      
       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LandingPage()),  (Route<dynamic> route)=>false);
    }
    else {
      
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) =>LandingPage()));
              showDialog(
                    context: context,
                    builder: (context)
                    {
                      return AlertDialog(
                      content: Text("Login failed"),
                      title: Text("login failed due to techical error"),
                      );
                    }
              );
    }

  }
 
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("FEEDIE BHARATH",style: TextStyle(color: Colors.orange
        
        ,fontWeight: FontWeight.bold),),
      ),
      body:  SingleChildScrollView(
              child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
         
          children: <Widget>[
               Stack(
                 children: <Widget>[
                    Opacity(
                      opacity: 0.2,
                                        child: Container(
                        padding: EdgeInsets.only(left: 75.0),
              height: 500,
              width: 400,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      
                      image: AssetImage("assert/logo.jpg"),
                   
                  )
              ),
                 ),
                    ),
               
               Column(
             mainAxisAlignment: MainAxisAlignment.center,
             
                   children: <Widget>[
                      Container(
                        height: 500.0,
                                            child: check? Stack(
                  children: <Widget>[
                        Form(
                    key: _formkey,
                            child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        TextFormField(
                            
                            controller: _textEditingController,
                               keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold),
                              decoration: InputDecoration(labelText: 'enter a phone number', 
                                        labelStyle: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.purple), 
                                        
                                         border: OutlineInputBorder(
                                           
                                         ),
                                        
                                          
                              ),

                            onChanged: (value){
                              this.phno="+91"+value;
                            },
                              validator: (String val){
                               if(val.isEmpty)
                                 return "please enter a numbber";
                               else if(val.length!=10)
                                   return "please enter a numbber 10 digite";
                                 else if(val.trim().isEmpty)
                                    return "please enter a numbber ";
                                    else if(int.parse(val.substring(0))<6)
                                        return "please enter a numbber strat with (7-9) digite";
                               
                              },
                             
                          ),
                          Row(
                            children: <Widget>[
                              Checkbox(
                               
                                onChanged: (bool a){
                                 
  
    setState(() {
  widget. accept=a; 
    });
  
                                },
                              value:widget.accept,
                              ),
                            Text.rich(TextSpan(
                              text: text,
                              style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                              children:<TextSpan>[
                                TextSpan(text: "more",
                                 style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,color: Colors.blue),
                                 recognizer:TapGestureRecognizer()..onTap=(){
                                  
Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TermsAndCondtion()));
                                 }
                                )
                              ]
                            ))
                            
                            ],
                          ),
                     SizedBox(height: 50,),
                               Container(
                                 width: MediaQuery.of(context).size.width/2+20,
                                 height:50 ,
                                 child: FlatButton(
                                   hoverColor: Colors.green,
                                   
                                  child: Text("send OTP",style: TextStyle(fontSize: 25),),
                                  shape: StadiumBorder(),
                                 color: Colors.blue,
                                  onPressed: ()
                                  {
                                       if(_formkey.currentState.validate()){
                                          if(widget.accept)
                                    {
                                       signinwithphno(context);

                                       setState(() {
                                        check=false; 
                                       });
                                    }
                                    
                                    else{
                                      showDialog(
                                      context: context,
                                      builder: (context)
                                      {
                                        return AlertDialog(
                                          content: Text("please accept T&C"),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text("ok"),
                                              onPressed: (){
                                                 Navigator.pop(context);
                                              },

                                            )
                                          ],
                                        )
                                        ;
                                      
                                    }
                                      );
                                    }
                                    
                                       }

                                  }
                                  
                                 

                            ),
                               ),
                          
                        ],
                    ),
                  ),
                  ],
                     
              ):Center(child:CircularProgressIndicator()),
                      ),
                   ],
               ),
            
                 ],
               )
          ],
               
        ),
      ),
      
       
  
    );
  }
}
