import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapppp/filesaver.dart';
import 'package:flutterapppp/homepage.dart';

import 'package:url_launcher/url_launcher.dart';
void main()=>runApp(

 MaterialApp(
debugShowCheckedModeBanner: false,
home: Adminpage(),
 )
);
class Adminpage extends StatefulWidget
{
  String admin;
  String name;
  Adminpage({Key key,this.admin}):super(key:key);

  @override
  _AdminpageState createState() => _AdminpageState();
}

class _AdminpageState extends State<Adminpage> with SingleTickerProviderStateMixin{
 
TabController tabController;
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController=TabController(length: 2,vsync: this);
  }

  @override
  void dispose() {
    tabController?.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text(widget.admin),
      bottom: TabBar(
          controller: tabController,
            tabs: <Widget>[
              Tab(
               text: "conform",
              ),
              Tab(
                text: "Helped_person",
              )
            ],
          ) ,  
        ),

        body:TabBarView(
            
          children: <Widget>[
            
          RequestPage(widget.admin),
            SavedHelp(widget.admin)
          ],
           controller: tabController,
        
        ),
        
        
      ),
    );
  }
  
}


class RequestPage extends StatefulWidget
{
  String admin;
  
  RequestPage(this.admin);

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  StreamSubscription<QuerySnapshot> listsubscription;
List<DocumentSnapshot> conform=[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   
  updatedata();
      
}
updatedata() async
{
    CollectionReference mycollection=Firestore.instance.collection("help");
    listsubscription = mycollection.snapshots().listen((documet) {
      setState(() {
          if(documet.documents.isNotEmpty)
                     {
                       
                       for (int i = 0; i < documet.documents?.length; i++)
                        {
                         
                            if(widget.admin==(documet.documents[i].data['ashramaname']).toString())
                            { 
                              if((documet.documents[i].data['conform'])=='')
                              {
                                   conform.add(documet.documents[i]);
                                   
                              }
                             
                              
                             
                              }
                                 
                               
                            }
                       }
                     
                  });
      });
}
@override
  void dispose() {
listsubscription?.cancel();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   
    return    conform.length!=null?
              ListView.builder(
                   itemCount:conform?.length , 
                   shrinkWrap: true,
                     itemBuilder: (context,index){
                         String name=conform[index].data['username'];
            String myimg=conform[index].data['image'];
            String phno=conform[index].data['phno'];
              String date=conform[index].data['date'];
              String location=conform[index].data['user_location'];
                      return ListTile(
       
                       leading:Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(myimg))
                            ),
                          ),
                       title: name!=null? 
                       Text(name):Text("user not update"),
                       subtitle: Text(phno),
                       trailing: Text(date),
                         onTap: (){launch("tel:$phno");},
                         onLongPress: (){
                           showDialog(
                          context: context,
                          builder: (context)
                          {
                            return  AlertDialog(
                            title: Text("Reached food"),
                             actions: <Widget>[
                               FlatButton(
                                 child: Text("conform"),
                        
                                 
                                 onPressed: (){
                               
                                     Storefiles.help(widget.admin, myimg, "ok", name,conform[index],location.split(",")[0],location.split(",")[1]);
 
                              
                                   
                               Navigator.pop(context);
                             MyOneApp();
                               
                                 },
                               )
                             ],
                            );
                          }
                           );
                         },
                      );
                       
                     
                     },
            ):Container(child: Center(child: Text("help")),);
         
           
    
  }
}
class SavedHelp extends StatefulWidget
{
  String admin;
  
  SavedHelp(this.admin);

  @override
  _SavedHelp createState() => _SavedHelp();
}

class _SavedHelp extends State<SavedHelp> {
  StreamSubscription<QuerySnapshot> listsubscription;
List<DocumentSnapshot> conform=[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   
  updatedata();
      
}
updatedata() async
{
    CollectionReference mycollection=Firestore.instance.collection("help");
    listsubscription = mycollection.snapshots().listen((documet) {
      setState(() {
          if(documet.documents.isNotEmpty)
                     {
                       
                       for (int i = 0; i < documet.documents?.length; i++)
                        {
                         
                            if(widget.admin==(documet.documents[i].data['ashramaname']).toString())
                            { 
                              if((documet.documents[i].data['conform'])!='')
                              {
                                   conform.add(documet.documents[i]);
                                   
                              }
                             
                              
                            
                              }
                                 
                               
                            }
                       }
                     
                  });
      });
}
@override
  void dispose() {
listsubscription?.cancel();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   
    return    conform.length!=null?
              ListView.builder(
                   itemCount:conform?.length , 
                   shrinkWrap: true,
                     itemBuilder: (context,index){
                         String name=conform[index].data['username'];
            String myimg=conform[index].data['image'];
            String phno=conform[index].data['phno'];
              String date=conform[index].data['date'];
              String location=conform[index].data['user_location'];
                      return ListTile(
       
                       leading:Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(myimg))
                            ),
                          ),
                       title: name!=null? 
                       Text(name):Text("user not update"),
                       subtitle: Text(phno),
                       trailing: Text(date),
                         onTap: (){launch("tel:9110853123");},
                         onLongPress: (){
                           showDialog(
                          context: context,
                          builder: (context)
                          {
                            return  AlertDialog(
                            title: Text("Reached food"),
                             actions: <Widget>[
                               FlatButton(
                                 child: Text("conform"),
                        
                                 
                                 onPressed: (){
                               
                                     Storefiles.help(widget.admin, myimg, "ok", name,conform[index],location.split(",")[0],location.split(",")[1]);
 
                              
                                   
                               Navigator.pop(context);
                             MyOneApp();
                               
                                 },
                               )
                             ],
                            );
                          }
                           );
                         },
                      );
                       
                     
                     },
            ):Container(child: Center(child: Text("help")),);
         
           
    
  }
}