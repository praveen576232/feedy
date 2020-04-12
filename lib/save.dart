
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'ashramapage.dart';
import 'filesaver.dart';


void main()=>runApp(SaveAshrama());
class SaveAshrama extends StatefulWidget {
  @override
  _SaveAshramaState createState() => _SaveAshramaState();
}
class _SaveAshramaState extends State<SaveAshrama> {
  String emtye="NO ASHRAMA WAS SAVED";
  StreamSubscription<QuerySnapshot> listsubscription;
  List<DocumentSnapshot> savednames=[];
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updating();
  }
  updating()async
  {
    String s=await Storefiles.getuser();
    print(s);
  CollectionReference mycollection=Firestore.instance.collection("save").document(s).collection("saveddata");
listsubscription = mycollection.snapshots().listen((dataimg) {
      setState(() {
        print("in save button");
        print(mycollection);
                print(dataimg.documents);
        savednames =dataimg.documents;
        emtye=null;
      });
    });
    
  }
  @override
  void dispose() {
    listsubscription.cancel();
    // TODO: implement dispose
    super.dispose();
  }
  Future deleted(String ss) async
  {
    String s=await Storefiles.getuser(); 
  setState(() {
  Firestore.instance.collection("save").document(s).collection("saveddata").document(ss).delete();
  });
   if(savednames.isEmpty)
   {
     setState(() {
      emtye="NO ASHRAMA WAS SAVED";
     });
    if(emtye!=null)
    {
      print("not ulll$emtye");
       Center(
          child: Text(emtye,
          style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
          ),
     );
    }
   }
  }
  @override
  Widget build(BuildContext context) {
    
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home: Scaffold(
        appBar: AppBar(title: Text("Save Ashrama",style: TextStyle(color: Colors.black),),backgroundColor: Colors.white,),
        body: emtye==null?
        savednames.isNotEmpty?
         ListView.builder(
          itemCount: savednames.length,
          itemBuilder: (context,index){
            String name=savednames[index].data['savename'];
            String myimg=savednames[index].data['image'];
            String near=savednames[index].data['near'];
            String allimg1=savednames[index].data['img1'];
            String loc1=savednames[index].data['location'];
            return Dismissible(
              key: Key(UniqueKey().toString()),
              onDismissed: (direction){
                Key(name[index]);
              
                
                deleted(savednames[index].documentID);
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text("$name item deleted"),
                    action: SnackBarAction(
                      label:"UNDO" ,
                      onPressed: (){
                       List<String>allimg=allimg1.split(",");
                       GeoPoint loc=GeoPoint(double.parse(loc1.split(",")[0]), double.parse(loc1.split(",")[1]));
                       
                       
                        Storefiles.savedata(name,near, myimg,allimg,loc);
                      },
                    ),
                    ));
              },
                  child: ListTile(
              leading: Container(
                height: 150.0,
                width: 70.0,
                padding: EdgeInsets.only(top: 30.0),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    image: NetworkImage(myimg),
                    fit: BoxFit.fill
                  )
                ),
              ),
               title: Text(name),
               subtitle: Text(near),
                    onTap: (){
                         var all=savednames[index].data['img1'].toString().split(",");
                        GeoPoint loc=GeoPoint(double.parse(loc1.split(",")[0]), double.parse(loc1.split(",")[1]));
                         Navigator.pop(context);
                          Navigator.of(context).push(
                         MaterialPageRoute(
                             builder:(context)=>Ashramapage(ashramaname:name,ashramaimg:myimg,ashramaAddr:near,allimg: all,ashramalatitude: loc.latitude,ashramalongitude: loc.longitude,)));
                    },
                    
            ),
            );
          },
        ): Center(
          child: Text("NO Ashrama  Saved",
          style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
          ),
      ): Center(
          child: Text("NO Ashrama  Saved",
          style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
          ),
      ),
    ),
    );
  }
}
