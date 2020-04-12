import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutterapppp/adminashrama.dart';
import 'package:flutterapppp/displayimage.dart';


import 'package:flutterapppp/help.dart';
import 'package:flutterapppp/mapview.dart';
import 'package:flutterapppp/share.dart';
import 'package:flutterapppp/signinpage.dart';
import 'package:url_launcher/url_launcher.dart';

import 'filesaver.dart';
import 'titleapp.dart';
import 'ashramapage.dart';
import 'userprofile.dart';
import 'save.dart';
import 'logout.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyOneApp());

class MyOneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomeApp(),
    );
  }
}

class MyHomeApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomeApp();
  }
}

class _MyHomeApp extends State<MyHomeApp> {
  StreamSubscription<ConnectivityResult> checkingnetwork;
  StreamSubscription<QuerySnapshot> listsubscription;
  List<DocumentSnapshot> ashramalist = [];
  CollectionReference mycollection = Firestore.instance.collection("ashrama");
  StreamSubscription<QuerySnapshot> subscription;
  Set<DocumentSnapshot> sliderimg;
  StreamSubscription<ConnectivityResult> streamSubscription;
  Connectivity connectivity;
  var firebaseUser;
  bool check = true;
  String admin;
  var adminname;
  String helpname;
  String helpimg;
  String helpdate;
  String helpcoform;
  List<String> namelist = [];
  List<String> images = [];
  List<String> nearplaces = [];
  List<String> location = [];
  List<String>allphno=[];
  List<DocumentSnapshot> listhelpuser = [];
  CollectionReference collectionReference =
      Firestore.instance.collection("imageslider");
       CollectionReference collectionReference1 =
      Firestore.instance.collection("admin");
      StreamSubscription mysub;
  ConnectivityResult connection = null;
  double opacity=1.0;
  double _backdropsigmax=0.0;
  double _backdropsigmay=0.0;
  String myname = "update profile";
  String myemailid = "user email";
  String imgid = "";
  String adminemail = "praveend2622@gmail.com";
  String fb = "praveen praveen";
  String insta = "praveen_d";
  DocumentSnapshot snapshot;
 bool lock=false;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    check = true;
    
   mysub=collectionReference1.snapshots().listen((onData){
     if(onData!=null && onData.documents?.length!=0){
      // print(onData.documents[0].data['lock']);
      
       bool lock=onData.documents[0].data['lock'];
         bool dimg=onData.documents[0].data['img'];
       bool msg=onData.documents[0].data['displymsg'];
       setState(() {
         snapshot=onData.documents[0];
       });
       print("msg $msg");
       print("lock $lock  , $dimg");
       if(lock || msg || dimg){
alertmsg(snapshot);
       }
     }
   });

    connectivity = Connectivity();
    streamSubscription = connectivity.onConnectivityChanged
        .listen((ConnectivityResult connectivity) {
      if (connectivity == ConnectivityResult.mobile ||
          connectivity == ConnectivityResult.wifi) {
        print(connectivity);
        setState(() {
          check = true;
        });
      } else {
        setState(() {
          check = false;
        });
      }
    });
    connectivity = Connectivity();
    checkingnetwork =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      print("conection is");
      print(result);
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        connected();
        getname();
        getemail();
        getprofileimg();
       

        setState(() {
          connection = result;
        });
      }
    });
  }

  connected() {
    subscription = collectionReference.snapshots().listen((dataimg) {
      setState(() {
        sliderimg = (dataimg.documents).toSet();
      });
    });
    listsubscription = mycollection.snapshots().listen((data) {
      setState(() {
        ashramalist = data.documents;
      });
    });
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    checkingnetwork?.cancel();
    subscription?.cancel();
    mysub.cancel();
    listsubscription?.cancel();
    // TODO: implement dispose
    super.dispose();
  }
 alertmsg(DocumentSnapshot snap)async{
    String msg;
    String imgpath;
    String title;
     bool lock=snap.data['lock'];
       bool displaymsg=snap.data['displymsg'];
         bool img=snap.data['img'];
            msg=snap.data['message'];
               imgpath=snap.data['imgpath'];
               title=snap.data['title'];

   await Future.delayed(Duration(milliseconds: 60));

    showDialog(
     context: context,
     barrierDismissible: false,
     builder: (BuildContext context)=>AlertDialog(
       contentPadding: EdgeInsets.only(right: 0,left: 0),
  title: title!=null?Text(title,textAlign: TextAlign.center,):Text(""),
       content:img && imgpath!=null?Image.network(imgpath):displaymsg && msg!=null? Text(msg):Text("Welcome "),
       actions: <Widget>[
         FlatButton(onPressed: (){
           if(lock){
           SystemNavigator.pop();
           }else{
             Navigator.pop(context);
           }
         }, child: Text("Ok",style: TextStyle(fontSize: 22.0),))
       ],
       )
   );
 }
  getimg(BuildContext context) {
    try {
      List<String> ImgUrls = [];
   

      if (sliderimg.iterator != null) {
        Iterator<DocumentSnapshot> id = sliderimg.iterator;

        while (id.moveNext()) {
          ImgUrls.add(id.current.data['url']);
        }
       // ss = ImgUrls.iterator;
        return ImgUrls.length != 0
            ? Opacity(
              opacity:opacity,
                          child: Container(
                  padding: EdgeInsets.only(top: 70.0),
                  child: Carousel(
                    images: ImgUrls.map((f)=> f!=null? NetworkImage(f)
                            : AssetImage("assert/background.jpeg")).toList()
                    ,
                    dotSize: 1.0,
                    boxFit: BoxFit.fill,
                  ),
                ),
            )
            : Container(
                padding: EdgeInsets.only(top: 70.0),
                child: Carousel(
                  images: [AssetImage("assert/background.jpeg")],
                  dotSize: 1.0,
                  boxFit: BoxFit.fill,
                ));
      } else {
        return Container(
            padding: EdgeInsets.only(top: 70.0),
            child: Carousel(
              images: [AssetImage("assert/background.jpeg")],
              dotSize: 1.0,
              boxFit: BoxFit.fill,
            ));
      }
    } catch (Exception) {}
  }

  getname() async {
    try {
      firebaseUser = await Storefiles.getuser();
      print("myuser");
      print(firebaseUser);
      DocumentReference _document =
          Firestore.instance.collection("userinfo").document(firebaseUser);
      _document.snapshots().listen((mydata) {
        try {
          adminname = mydata.data['admin'];
        } catch (e) {}
        myname = mydata.data['name'];
        setState(() {
          myname = myname;
          if (adminname.trim().length != 0) {
            admin = adminname;
          } else {
            admin = null;
          }
        });
      });
    } catch (e) {}
  }

  Future getemail() async {
    try {
      final firebaseUser = await Storefiles.getuser();
      DocumentReference _document =
          Firestore.instance.collection("userinfo").document(firebaseUser);
      _document.snapshots().listen((userdata) {
        myemailid = userdata.data['email'];
        setState(() {
          myemailid = myemailid;
        });
      });
    } catch (e) {}
  }

  Future getprofileimg() async {
    try {
      final firebaseUser = await Storefiles.getuser();
      DocumentReference _document =
          Firestore.instance.collection("userinfo").document(firebaseUser);
      _document.snapshots().listen((userdata) {
        imgid = userdata.data['url'];
        setState(() {
          imgid = imgid;
        });
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  
    return  MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.lime,
            ),
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              drawer: Drawer(
                child: ListView(
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      accountName: Text(myname),
                      accountEmail: Text(myemailid),
                      currentAccountPicture: CircleAvatar(
                        radius: 150,
                        child: ClipOval(
                          child: SizedBox(
                            height: 180.0,
                            width: 180.0,
                            child: imgid != null
                                ? Image.network(imgid, fit: BoxFit.fill)
                                : Image.network(
                                    "https://images.unsplash.com/photo-1441239372925-ac0b51c4c250?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text("save"),
                      trailing: Icon(Icons.save),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SaveAshrama()));
                      },
                    ),
                    ListTile(
                      title: Text("near me"),
                      trailing: Icon(Icons.directions),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MyGoogleMap()));
                      },
                    ),
                    ListTile(
                        trailing: Icon(Icons.face),
                        title: Text("profile"),
                        onTap: () {
                          print("ontapesd");
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UserProfile()));
                        }),
                    ListTile(
                      title: Text("help"),
                      trailing: Icon(Icons.help),
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Help()));
                      },
                    ),
                    ListTile(
                      title: Text("share"),
                      trailing: Icon(Icons.share),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ShareApp()));
                      },
                    ),
                    ListTile(
                      title: Text("contact us"),
                      trailing: Icon(Icons.contacts),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Container(
                                        child: FlatButton(
                                      child: Text("send email"),
                                      color: Colors.orange,
                                      onPressed: () {
                                        launch('mailto:$adminemail');
                                      },
                                    )),
                                    Container(
                                        child: FlatButton(
                                      child: Text(
                                        "contact facebook",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      color: Colors.white,
                                      onPressed: () {},
                                    )),
                                    Container(
                                        child: FlatButton(
                                      child: Text("contact instagram"),
                                      color: Colors.green,
                                      onPressed: () {
                                        launch('mailto:$adminemail');
                                      },
                                    )),
                                  ],
                                ),
                              );
                            });
                      },
                    ),
                    ListTile(
                      title: Text("logout"),
                      trailing: Icon(Icons.settings),
                      onTap: () {
                        return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("LogOut"),
                                content: Text("Are You Sure ?"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("yes"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      logoutClass.logout();

 Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>SignInPage(false))
                  , (Route<dynamic> route)=>false);


                                    },
                                  )
                                ],
                              );
                            });
                      },
                    ),
                    admin != null
                        ? ListTile(
                            title: Text(admin),
                            trailing: Icon(Icons.contacts),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Adminpage(
                                        admin: admin,
                                      )));
                            },
                          )
                        : Container()
                  ],
                ),
              ),
              body: ashramalist?.length != 0
                  ?  Stack(
                    children: <Widget>[
                     CustomScrollView(
                        slivers: <Widget>[
                          SliverAppBar(
                            pinned: true,
                            backgroundColor: Colors.orange.withOpacity(opacity),
                            expandedHeight:
                                MediaQuery.of(context).size.height * 0.4,
                            title: AppBarPages(),
                            flexibleSpace:
                                FlexibleSpaceBar(background: getimg(context)),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, index) {
                              String s = ashramalist[index].data['name'];
                              String m = ashramalist[index].data['address'];
                              String mm = ashramalist[index].data['img'];
                              String n =
                                  "near :" + ashramalist[index].data['near'];
                                  String phno=ashramalist[index].data['phone'].toString();
                              //  print("$mm,$n,$s");
                              return mm != null && n != null && s != null
                                  ? ListTile(
                                      leading: GestureDetector(
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: _backdropsigmax, sigmaY: _backdropsigmay),
                                          child: Container(
                                            width: 50.0,
                                            height: 50.0,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(mm)
                                                    )
                                                    ),
                                                    
                                          ),
                                        ),
                                        onTap: ()async {
                                          setState(() {
                                            _backdropsigmax=10.0;
                                            _backdropsigmay=10.0;
                                            opacity=0.1;
                                          });
                                     await     showDialog(
                                              context: context,
                                              builder: (context) {
                                                return 
                                                                                                  AlertDialog(
                                                    title:Text(s,textAlign: TextAlign.center,) ,
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 0, 0, 0),
                                                    content: InkWell(
                                                                                                          child: Container(
                                                          child: Image.network(
                                                        mm,
                                                        fit: BoxFit.fill,
                                                      )),
                                                      onTap: (){
                                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DisplayImage(mm)));                      
                                                      },
                                                    ),
                                                  );
                                                 
                                              }).then((_){
                                                setState(() {
                                            _backdropsigmax=0.0;
                                            _backdropsigmay=0.0;
                                            opacity=1.0;
                                          });
                                              });
                                        },
                                        
                                       
                                      ),
                                      title: Text(s),
                                      subtitle: Text(n),
                                      onTap: () {
                                       var as=ashramalist[index].data['img1'];
                                        GeoPoint loc=ashramalist[index].data['location'];
                                        List<String>allimg=as.cast<String>().toList();
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) => Ashramapage(
                                                      ashramaname: s,
                                                      ashramaimg: mm,
                                                      ashramaAddr: m,
                                                      username: myname,
                                                      phone: phno,
                                                     allimg :allimg,
                                                     ashramalatitude: loc.latitude,
                                                     ashramalongitude: loc.longitude,
                                                    )));
                                      },
                                      onLongPress: () {
                                         GeoPoint loc=ashramalist[index].data['location'];
                                          var as=ashramalist[index].data['img1'];
                                        List<String>allimg=as.cast<String>().toList();
                                        savedialog(context, s, m, mm,allimg,loc);
                                      },
                                    )
                                  : Offstage();
                            }, childCount: ashramalist?.length),
                          ),
                        ],
                      ),
                      !check ?Align
                      (
                        alignment: Alignment.bottomCenter,
                                              child: Container(
                          height: 25,
                          width: MediaQuery.of(context).size.width,
                          color:!check ? Colors.red:Colors.green,
                          child:Center(child: Text("Offline, check your internet"))
                        ),
                      ):Offstage()
      

                    ],
                  )
                    
                 
                  : Container(
                      child: Center(
                          child: Text(
                              "No Ashrama was detected please try againe"))),
            ),
          );
       
  }

  Future savedialog(
      BuildContext context, String name, String near, String img,List<String>allimg,GeoPoint loc) async {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("save"),
            content: Text("Save Ashrama "),
            actions: <Widget>[
              FlatButton(
                child: Text("yes"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Storefiles.savedata(name, near, img,allimg,loc);
                  Fluttertoast.showToast(
                      msg: "saved",
                      toastLength: Toast.LENGTH_LONG,
                      timeInSecForIos: 16,
                      gravity: ToastGravity.BOTTOM);
                },
              ),
            ],
          );
        });
  }
}
