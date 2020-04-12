import 'package:flutter/material.dart';
import 'package:flutter/services.dart'show rootBundle;
import 'package:flutterapppp/signinpage.dart';
class TermsAndCondtion extends StatefulWidget {
  @override
  _TermsAndCondtionState createState() => _TermsAndCondtionState();
}

class _TermsAndCondtionState extends State<TermsAndCondtion> {
  String data;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fechdata();
  }
  fechdata() async{
   String temp=await rootBundle.loadString("assert/terms_and_condition.txt");
   setState(() {
     data=temp;
   });
     }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: data!=null?SafeArea(
              child: SingleChildScrollView(
                child: Container(
            child: Column(
              children: <Widget>[
                Text(data),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FlatButton(
                   color: Colors.blue,
                    onPressed: (){
 Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>SignInPage(true))
                      , (Route<dynamic> route)=>false);
                  }, child: Text("I Agree")),
                )
              ],
            ),
          ),
        ),
      ):Container(child: Center(child: CircularProgressIndicator())),
    );
  }
}