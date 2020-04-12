import 'dart:async';
import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutterapppp/ashramapage.dart';
import 'package:flutterapppp/filesaver.dart';
import 'package:flutterapppp/homepage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyGoogleMap());

class MyGoogleMap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyGoogleMap();
  }
}

class _MyGoogleMap extends State<MyGoogleMap> {
  var geolocator = Geolocator();
  List<GeoPoint> ashramaloc = [];
  List<DocumentSnapshot> name = [];
  double latitude;
  double logtude;
  int count = 0;
  String phno = "";
  String addr;
  String dist = '3-6 Km';
  bool checkmarker = false;
  List<LatLng> marker = [];
  var location = Location();
  bool checklocation = false;
  bool alert=false;
  GoogleMapController _controller;
  PermissionHandler _permissionHandler = PermissionHandler();
  String user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Firestore.instance.collection("ashrama").getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; i++) {
          count++;
          ashramaloc.add(docs.documents[i].data['location']);

          setState(() {
            name.add(docs.documents[i]);
          });
        }
        print("in out i nit");
        print(ashramaloc[0].latitude);
        print(ashramaloc[0].longitude);
        print("in out i nit222");
        print(ashramaloc[1].latitude);
        print(ashramaloc[1].longitude);
      }
    });

    checking();
    getname();
  }

  checkpermisstion() async {
    if (!await location.hasPermission()) {
      await location.requestPermission();

      setState(() {
        checking();
      });
    }

    try {
      setState(() {
        locatio();
        checking();
      });
    } catch (e) {}
  }

  locatio() {
    location.onLocationChanged().listen((LocationData mylocation) {
      setState(() {
        latitude = mylocation.latitude;
        logtude = mylocation.longitude;
        checklocation = true;
      });
    });
  }

  checking() async {
    var permisstion = await _permissionHandler
        .checkPermissionStatus(PermissionGroup.location);
    if (permisstion == PermissionStatus.granted) {
      curretlocatio();
    } else {
      print("i checkig iformatio");

      setState(() {
        checkpermisstion();
      });
    }
  }

  curretlocatio() async {
    Position position = await geolocator.getCurrentPosition();
    setState(() {
      latitude = position.latitude;
      logtude = position.longitude;
      checklocation = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (checklocation && latitude != null)
        ? MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
                          body: SafeArea(
                child: Stack(
                  children: <Widget>[
                    Container(
                        height: MediaQuery.of(context).size.height - 80.0,
                        width: double.infinity,
                        child: GoogleMap(
                          minMaxZoomPreference: MinMaxZoomPreference(5.0, 20.0),
                          compassEnabled: true,
                          myLocationEnabled: true,
                          initialCameraPosition: CameraPosition(
                              target: LatLng(latitude, logtude), zoom: 13.0),
                          onMapCreated: (GoogleMapController controler) {
                            _controller = controler;
                            mapcontorler(2.0);
                          },
                        )),
                 !alert?   Positioned(
                      top: 70,
                      child: Container(
                        height: 70,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: <Widget>[
                            Container(
                             height: 70,
                        width: MediaQuery.of(context).size.width-70,  
                              
                              child: Text("Note :Distance is not about a rood distance its based on Stright line from your location to Ashrama location. We Improve the distance acuracy will be soon.  "),alignment: Alignment.centerLeft,),
                            IconButton(icon: Icon(Icons.cancel),
                            alignment: Alignment.topRight,
                             onPressed: (){
                              setState(() {
                                alert=true;
                              });
                            })
                          ],
                        ),
                        color: Colors.white70,
                      ),
                    ):Offstage(),
                    Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                            icon: Icon(
                              Icons.select_all,
                              color: Colors.deepPurple,
                            ),
                            onPressed: () {
                              List<String> menu = [
                                '3-6 Km',
                                '7-10 Km',
                                '11-15 Km',
                                '15-20 Km',
                                '20-25 Km',
                              ];
                              String select = dist;

                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                          "No Ashrama was found near please select a Distance $dist "),
                                      content: DropdownButton(
                                        hint: Text("chose near me"),
                                        items: menu.map((String val) {
                                          return DropdownMenuItem<String>(
                                            child: Text(val),
                                            value: val,
                                          );
                                        }).toList(),
                                        value: select,
                                        onChanged: (ss) {
                                          dist = ss;
                                          List<String> split = ss
                                              .toString()
                                              .split("-")
                                              .toString()
                                              .split(" ");
                                          split[2].toString().trimRight();

                                          Navigator.pop(context);

                                          mapcontorler(double.parse(split[1]));
                                        },
                                      ),
                                      actions: <Widget>[],
                                    );
                                  });
                            }))
                  ],
                ),
              ),
            ),
          )
         : Scaffold(
                          body: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Loding",
                    style: TextStyle(color: Colors.blue, fontSize: 25.0),
                  ),
                  SpinKitThreeBounce(
                    color: Colors.green,
                    size: 25.0,
                  ),
                ],
              )),
          
          );
  }

  mapcontorler(double distance) {
    List<String> dista = [];
    List<String> temp = [];

    if (ashramaloc?.length != 0) {
      for (int i = 0; i < ashramaloc?.length; i++) {
        geolocator
            .distanceBetween(latitude, logtude, ashramaloc[i].latitude,
                ashramaloc[i].longitude)
            .then((dist) {
          if (dist / 1000 < distance) {
            temp.add(name[i].data['name']);
            checkmarker = true;
            dista.add((dist / 1000).toStringAsFixed(2));

            _controller.addMarker(MarkerOptions(
              position: LatLng(ashramaloc[i].latitude, ashramaloc[i].longitude),
              infoWindowText: InfoWindowText(
                  (dist / 1000).toStringAsFixed(2) + "Km",
                  name[i].data['name']),
              visible: true,
            ));
          }
        });
      }
    }
    if (distance != 25) {
      print("object");
      Timer(Duration(seconds: 1), () {
        markerchecker();
      });
    } else {
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text("No Ashrama was found "),
              content: Text("No Ashrama was found at this Distance "),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MyOneApp()),
                          (Route<dynamic> route) => false);
                    },
                    child: Text("ok"))
              ],
            );
          });
    }
    _controller.onInfoWindowTapped.add((val) {
      String ashramaname;
      String image;
      String near;
      String distn;
      String dest;
      GeoPoint loc;
      var listimg;
      for (int i = 0; i < temp.length; i++) {
        if ("m$i" == val.id.toString()) {
          distn = dista[i];
          ashramaname = temp[i];
          image = name[i].data['img'];
          near = name[i].data['near'];
          phno = name[i].data['phone'].toString();
          addr = name[i].data['address'];
          listimg = name[i].data['img1'];
          loc=name[i].data['location'];
          dest = "${ashramaloc[i].latitude}, ${ashramaloc[i].longitude}";
        }
      }
      ashramaname != null
          ? showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      Text(ashramaname,
                          style: TextStyle(fontSize: 29.0, color: Colors.blue)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              height: 150.0,
                              width: 150.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                      image: NetworkImage(image),
                                      fit: BoxFit.fill)),
                            ),
                            onTap: () {
                              List<String> all =
                                  listimg.cast<String>().toList();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Ashramapage(
                                      ashramaname: ashramaname,
                                      ashramaimg: image,
                                      ashramaAddr: addr,
                                      phone: phno,
                                      username: user,
                                      allimg: all,
                                      ashramalatitude: loc.latitude,
                                      ashramalongitude: loc.longitude,
                                      )));
                            },
                          ),
                          Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    padding: EdgeInsets.only(left: 25.0),
                                    icon: Icon(Icons.call),
                                    iconSize: 35.0,
                                    color: Colors.blue,
                                    onPressed: () {
                                      launch("tel:$phno");
                                    },
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.only(left: 50.0),
                                    icon: Icon(Icons.directions),
                                    color: Colors.blue,
                                    iconSize: 35.0,
                                    onPressed: () {
                                      final AndroidIntent intent = new AndroidIntent(
                                          action: 'action_view',
                                          data: Uri.encodeFull(
                                              "https://www.google.com/maps/dir/?api=1&origin=" +
                                                  "$latitude,$logtude" +
                                                  "&destination=" +
                                                  dest +
                                                  "&travelmode=driving&dir_action=navigate"),
                                          package:
                                              'com.google.android.apps.maps');
                                      intent.launch();
                                    },
                                  ),
                                ],
                              ),
                              Text(
                                distn + " Km",
                                style:
                                    TextStyle(fontSize: 35, color: Colors.blue),
                              )
                            ],
                          )
                        ],
                      ),
                      Text(
                        addr,
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: 50.0,
                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: FlatButton(
                            //phone
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50.0,
                              child: Center(
                                  child: Text(
                                "conform",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 25.0),
                              )),
                            ),
                            color: Colors.green,
                            onPressed: () {
                              Storefiles.help(
                                      ashramaname, image, "", user, null,latitude.toString(),logtude.toString())
                                  .then((_) {
                                final AndroidIntent intent = new AndroidIntent(
                                    action: 'action_view',
                                    data: Uri.encodeFull(
                                        "https://www.google.com/maps/dir/?api=1&origin=" +
                                            "$latitude,$logtude" +
                                            "&destination=" +
                                            dest +
                                            "&travelmode=driving&dir_action=navigate"),
                                    package: 'com.google.android.apps.maps');
                                intent.launch();
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })
          : null;
    });
  }

  markerchecker() {
    List<String> menu = [
      '3-6 Km',
      '7-10 Km',
      '11-15 Km',
      '15-20 Km',
      '20-25 Km',
    ];
    String select = dist;
    if (!checkmarker) {
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text(
                  "No Ashrama was found near please select a Distance $dist "),
              content: DropdownButton(
                hint: Text("chose near me"),
                items: menu.map((String val) {
                  return DropdownMenuItem<String>(
                    child: Text(val),
                    value: val,
                  );
                }).toList(),
                value: select,
                onChanged: (ss) {
                  dist = ss;
                  List<String> split =
                      ss.toString().split("-").toString().split(" ");
                  split[2].toString().trimRight();

                  Navigator.pop(context);

                  mapcontorler(double.parse(split[1]));
                },
              ),
              actions: <Widget>[],
            );
          });
    }
  }

  getname() async {
    try {
      var firebaseUser = await Storefiles.getuser();

      DocumentReference _document =
          Firestore.instance.collection("userinfo").document(firebaseUser);
      _document.snapshots().listen((mydata) {
        setState(() {
          user = mydata.data['name'];
        });
      });
    } catch (e) {}
  }
}
