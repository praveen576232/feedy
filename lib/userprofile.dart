import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import 'filesaver.dart';
void main()=>runApp(UserProfile());
class UserProfile extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UserProfile();
  }
  
}
class _UserProfile extends State<UserProfile>
{
  final _controller=TextEditingController();
final controller=TextEditingController();

  File _image;
  String name="enter your name";
  String email="enter your email";
  String url;
  bool upload;
  String img;
  bool bottoncheck=false;
  bool progressing=false;
  FirebaseAuth _auth =FirebaseAuth.instance;
  StreamSubscription _streamSubscription;
  List<DocumentSnapshot>_list;
   final formkey1=GlobalKey<FormState>();
   final formkey2=GlobalKey<FormState>();
 Future<void> updatename(BuildContext context) async
 {  
     
        return showDialog(
        context: context,
       
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("enter a name"),
            content: Form(
              key: formkey1,
                          child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(enabled: true,border: OutlineInputBorder(),labelText: "name"),
               validator: (String s){
                    if(s.trim().isEmpty)
                    return "please enter a name";
               },
               

              ),
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              FlatButton(
                child: Text("Done"), onPressed: () {
                  if(formkey1.currentState.validate())
                  {
                    setState(() {
                    name=_controller.text;
                       bottoncheck=true;
                        
                  });
                   Navigator.pop(context);
                  }
                   
                },
                  
              ),
            ]
          
          );
        });
 }
 Future<void> updateemail(BuildContext context) async
 {
  
        return showDialog(
        context: context,
       
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("enter a email"),
            content: Form(
              key: formkey2,
                          child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.emailAddress,
                   decoration: InputDecoration(enabled: true,border: OutlineInputBorder(),labelText: "name"),
               validator: (String s){
                 Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
                
                 
      if (!regex.hasMatch(s))
      return 'Enter Valid Email';
                   
                   
               },
              ),
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              FlatButton(
                child: Text("Done"), onPressed: () {
                  if(formkey2.currentState.validate())
                  {
                     setState(() {
                    email=controller.text;
                       bottoncheck=true;
                        
                  });
                   Navigator.pop(context);
                  
                  }
                   
                },
                  
              ),
            ]
          
          );
        });
 }
 Future saveuser(String uname,String uemail,String url) async
 {
    FirebaseUser cutrntuser=await _auth.currentUser();
   DocumentReference _documentReference=Firestore.instance.collection("userinfo").document(cutrntuser.phoneNumber);
  Map<String,String> data=<String,String>
  {
     "name":uname,
     "email":uemail,
     "url":url
     
  };
  _documentReference.setData(data).whenComplete((){
    print("upgayted");
  });
  

 }
 @override
  void initState() {
    
    // TODO: implement initState
    super.initState();
  getdefaluimg();
    getinfo();
    
    
  }
  getdefaluimg()async
  {
    final firebaseuser=await Storefiles.getuser();
    
      Firestore.instance.collection("userinfo").document(firebaseuser).get().then((onValue){
        if(onValue.exists)
        {
           setState(() {
          img=onValue.data['url'];
        });
        }
       
    });
  }
  Future getinfo() async
  {
  
    FirebaseUser user=await _auth.currentUser();
    Firestore.instance.collection("userinfo").document(user.phoneNumber).get().then((data){
       String myname=  data.data['name'];
        String myemail=data.data['email'];
        setState(() {
          name=myname;
          email=myemail;
        });
    });
  }
 getimage()async
 {
   var imag=await ImagePicker.pickImage(source: ImageSource.gallery);
   setState(() {
    _image=imag; 
   
   });
 storeimg();
 }
 storeimg()async
 {
   setState(() {
    progressing=true; 
   });
   if(_image!=null)
   {
     print("in image");
     
   String filename=await Storefiles.getuser();
StorageReference storageReference=FirebaseStorage.instance.ref().child(filename);
StorageUploadTask storageUploadTask=storageReference.putFile(_image);
StorageTaskSnapshot taskSnapshot=await storageUploadTask.onComplete;
   String myurl=await storageReference.getDownloadURL();
    setState(() {
   url=myurl;
   bottoncheck=true;
   print("doeloade url$url");
 });
   }
   setState(() {
    progressing=false; 
   });
 }
 
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body:SingleChildScrollView(
                  child: Builder(
           builder: (context)=>Container(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.stretch,
               children: <Widget>[
                 SizedBox(height: 35,),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        backgroundColor: Colors.green,
                        
                        radius: 100,
                        child: ClipOval(
                          child: SizedBox(
                            height: 185.0,
                            width: 185.0,
                            child:_image!=null?Image.file(_image,fit:BoxFit.fill):img!=null?Image.network(img,fit: BoxFit.fill,): Image.network(
                              "https://images.unsplash.com/photo-1441239372925-ac0b51c4c250?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                               fit: BoxFit.fill,
                        ),
                          ),
                        ),
                      ),
                    ),
                      IconButton(
                      icon: Icon(Icons.photo_camera),
                      onPressed: (){
                        
                                       getimage();
                      },
                    ) , 
                    
                   
                  ],
                 ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Text(
                    name,
                    style: TextStyle(fontWeight:FontWeight.bold,fontSize: 28.0),
                    
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: IconButton(icon: Icon(Icons.edit),iconSize: 28.0,onPressed: ()
                  {
                        updatename(context);
                 }),
                )
                 
                  ],
                 ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Text(
                    email,
                    style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15.0),
                    
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: IconButton(icon: Icon(Icons.edit),iconSize: 28.0,onPressed: ()
                  {
                        updateemail(context);
                 }),
                )
                 
                  ],
                 ),
                 SizedBox(height: 50.0,),
                 
                 
            Stack(children: <Widget>[
              Center(
                child: progressing?SpinKitDualRing(
                  color: Colors.orange,
                
                ):
             
      Center(
                  child: RaisedButton (
                     
                      color:bottoncheck? Colors.green:Colors.lightGreen,
                       child: Text("UPDATE PROFILE"),
                       onPressed: (){
                        
                         bottoncheck? saveuser(name,email,url):null;

                       
                         bottoncheck?  Fluttertoast.showToast(
                             msg: "saved",
                              toastLength: Toast.LENGTH_LONG,
                              timeInSecForIos: 16,
                              gravity: ToastGravity.BOTTOM

                            ):null;
                       },
                     ),
      ),
              ),
             ],
             ),
                       
             

               ],
             ),
           ),
          ),
        )
      ),
    );
  }
  
}