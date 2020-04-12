import 'package:android_intent/android_intent.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapppp/filesaver.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class Ashramapage extends StatefulWidget{
  String ashramaname;
  String ashramaimg;
  String ashramaAddr;
  String username;
  String phone;
   double ashramalatitude=0.0;
    
   double ashramalongitude=0.0;
  List<String> allimg=[];
  Ashramapage({Key key,@required this.ashramaname,@required this.ashramaimg,@required this.ashramaAddr, this.username,this.phone,@required this.allimg,@required this.ashramalatitude,@required this.ashramalongitude}):super(key:key);

  @override
  _AshramapageState createState() => _AshramapageState();
}

class _AshramapageState extends State<Ashramapage> {

  String mydistance;
  bool check=true;
   var geolocator = Geolocator();
   double latitude=0.0;
     DocumentReference document;
                       String id;
   double longitude=0.0;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
     if(widget.ashramaimg!=null){
  widget.allimg.add(widget.ashramaimg);
 }
    curretlocatio();
  }
   curretlocatio() async {
    Position position = await geolocator.getCurrentPosition();
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
     
    });
    distance();
    
  }
   distance()
  {
print("in dustance");
if(latitude!=0.0 && longitude!=0.0 && widget.ashramalatitude!=0.0 && widget.ashramalongitude!=0.0){
   Geolocator().distanceBetween(latitude, longitude, widget.ashramalatitude, widget.ashramalongitude).then((dist){
        print(dist/1000);
     double my=dist/1000;
    
setState(() {
  mydistance=my.toStringAsFixed(2);
  
 });
 });
}

 
  }
  ashramaimagedisplay(List<String> imgurl){
    return Carousel(
images: imgurl,
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  
   
  return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text(widget.ashramaname),),
        body: SingleChildScrollView(
                  child: Column(
            children: <Widget>[
                 Container(
                    height: MediaQuery.of(context).size.height*0.4,
                    child:widget.allimg?.length!=0? Carousel(
images: widget.allimg.map((f)=>f!=null ? NetworkImage(f)
                            : AssetImage("assert/background.jpeg")).toList(),
    ):Center(child:Text("No images"))
                ),
              
         
            
              Padding(
                padding: EdgeInsets.only(top:50),
                              child: Row(
                  children: <Widget>[
                    SizedBox(width: 20.0,),
                    FloatingActionButton(
                      heroTag: "bt1",
                      child: Icon(Icons.call),
                        onPressed: (){launch("tel:${widget.phone}");}),
                         SizedBox(width: 20.0,),
                    FloatingActionButton(
                      heroTag: "bt2",
                      child: Icon(Icons.directions),
                      
                        onPressed: (){
                        if(latitude!=0.0 && longitude!=0.0 && widget.ashramalatitude!=0.0 && widget.ashramalongitude!=0.0){
 String origin="$latitude, $longitude";  // lat,long like 123.34,68.56
String destination="${widget.ashramalatitude}, ${widget.ashramalongitude}";

      final AndroidIntent intent = new AndroidIntent(
            action: 'action_view',
            data: Uri.encodeFull(
                  "https://www.google.com/maps/dir/?api=1&origin=" +
                      origin + "&destination=" + destination + "&travelmode=driving&dir_action=navigate"),
            package: 'com.google.android.apps.maps');
      intent.launch();
                        }  else{              
                          showDialog(context: context,
                          builder: (context){
                            return AlertDialog(
                           content: Text("Distance Not Updated. We Update soon"),
                           actions: <Widget>[
                             FlatButton(onPressed: (){Navigator.pop(context);}, child: Text("Ok"))
                           ],
                            );
                          }
                          );
                        }
                         
  

     
   
                        }),
                        SizedBox(width: 50.0,),
                       mydistance!=null? Text("$mydistance Km",style: TextStyle(color: Colors.black87,fontSize: 25.0),):Offstage()
                              
                  ],
                ),
              ),
              SizedBox(height: 20.0,),
               Text(widget.ashramaAddr,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0 ),),
             
         
            ],

          ),
        ),
        bottomNavigationBar: Container(
          height: 50.0,
          child: Align(
                  alignment: FractionalOffset.bottomCenter,
                                child: FlatButton(
                           //phone
                    child:Container(
              
                      width: MediaQuery.of(context).size.width,
                   height: 50.0,
                      child:  Center(child: Text(check? "Conform":"Cancel",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 25.0 ),)),),
                    color: Colors.green,
                    onPressed: ()async{
                      
                      if(check){
            document=  await   Storefiles.help(widget.ashramaname, widget.ashramaimg,"",widget.username,null,latitude.toString(),longitude.toString());
                     Fluttertoast.showToast(msg: "Thank you",gravity: ToastGravity.CENTER);
                   
                   
                      setState(() {
                       check=false; 
                         id=document.documentID;
                      });
                      }
                      else{
                      
                        if(id!=null){
                        
                          Firestore.instance.collection("help").document(id).delete();
                          Fluttertoast.showToast(msg: "Cancel",gravity: ToastGravity.CENTER);
                          setState(() {
                            check=true;
                          });
                        }
                      }
                    },
                  ),
                ),
        ) ,
      ),
    );
   
 
     }
   }
  