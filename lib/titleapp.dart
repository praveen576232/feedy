// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutterapppp/filesaver.dart';

// import 'package:flutterapppp/save.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'dart:async';
// import 'ashramapage.dart';
// void main()=>runApp(AppBarPages());
// class AppBarPages extends StatefulWidget{
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return _AppBarPages();
//   }

// }
// class _AppBarPages extends State<AppBarPages>
// {
//   List<String>names=[];
//   List<String>nearplaces=[];
//   List<String>images=[];
//   StreamSubscription<QuerySnapshot>_streamSubscription;
//   List<DocumentSnapshot>_list=[];
//   CollectionReference _collectionReference=Firestore.instance.collection("ashrama");
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
     
//     _streamSubscription=_collectionReference.snapshots().listen((data){
//       setState(() {
//         _list=data.documents;
//       });
//     });
//   }
//   @override
//   void dispose() {
//     _streamSubscription.cancel();
//     // TODO: implement dispose
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//    for(int i=0;i<_list.length;i++)
//      {
//        names.add(_list[i].data['name']);
//        nearplaces.add(_list[i].data['near']);
//        images.add(_list[i].data['img']);
//      }
//     return Container(
//      // color: Colors.purple,
//       child: Row(
//         children: <Widget>[
//           Text("FEEDIE BHARATH"),
          
//           IconButton(icon: Icon(Icons.search),
//               padding: EdgeInsets.only(left:80),
//               onPressed: (){
//                 showSearch(context: context, delegate: serching(names.toSet(),nearplaces.toSet(),images.toSet()));
//               })
//         ],
//       ),
//     );
//   }

// }
// class serching extends SearchDelegate<String>
// {
//  List<String> allnames=[];
//   List<String> names=[];
//  List<String> images=[];
//  List<String> nearplaces=[];
//  List<String> searchimg=[];
//  List<String> serachnear=[];
//  Set<String>ms;
//  Set<String>ss;
//    List<String> img=[];
//    List<String> near=[];
//   serching(Set<String> names, Set<String> nearplaces,Set<String> images){
//     this.names=names.toList();
//   this.nearplaces=nearplaces.toList();
//   this.images=images.toList();

//   }

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [IconButton(icon: Icon(Icons.clear), onPressed: (){query='';})];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     // TODO: implement buildLeading
//   return IconButton(
//       icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
//       onPressed: (){close(context, null);});
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     // TODO: implement buildResults
//    return Container(

//    );
    
    
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//   allnames=names.toList();
//    allnames.sort((a,b)=>a.substring(0).compareTo(b.substring(0)));
       
//    Set<String> temp1=names.toSet();
//    Set<String> temp2=images.toSet();
//    Set<String> temp3=nearplaces.toSet();
//    print("names length is ${temp1.length}");
//      print("image length is ${temp2.length}");
//        print("near length is ${temp3.length}");
// //   final suggestion=query.isEmpty?allnames:names.where((p)=>p.startsWith(query)).toList();
// //    if(serachnear!=null)
// //      serachnear.clear();
// //      if(searchimg!=null)
// //      searchimg.clear();
// //      if(near!=null)
// //     near.clear();
// //     if(img!=null)
// //     img.clear();
// //     if(ms!=null)
// //     ms.clear();
// //     if(ss!=null)
// //     ss.clear();
// //    print(suggestion.length);
// //     print(names.length);
// //    // int i=0;
// // for(int i=0;i<names?.length;i++)
// // {
// //   if(suggestion.contains(names[i]))
// //   {
// //      searchimg.add(images[i]);
// //     // serachnear.add(nearplaces[i]);
// //   }
  
// // }
// //  //ms =serachnear.toSet();
// //   ss=searchimg.toSet();
  
// //   //near=ms.toList();
// //  img=ss.toList();
 
//    return Container();
//   }
  
//   }
//   Future savedialog(BuildContext context,String name,String near,String img) async
//   {
//     return showDialog(
//       barrierDismissible: true,
//         context: context,
//         builder: (context){
//           return AlertDialog(
//          title: Text("save"),
//          content: Text("save in offline"),
//          actions: <Widget>[
//            FlatButton(
//            child: Text("yes"),
//            onPressed: (){
//              Navigator.of(context).pop();

//              Storefiles.savedata(name,near,img);
//               Fluttertoast.showToast(
//                        msg: "saved",
//                         toastLength: Toast.LENGTH_LONG,
//                         timeInSecForIos: 16,
//                         gravity: ToastGravity.BOTTOM

//                       );
             
              
//            },
//          ),
//          ],
//           );
//         }
//     );
//   }




import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterapppp/filesaver.dart';

import 'package:flutterapppp/save.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'ashramapage.dart';
void main()=>runApp(AppBarPages());
class AppBarPages extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AppBarPages();
  }

}
class _AppBarPages extends State<AppBarPages>
{
  List<String>names=[];
  List<String>nearplaces=[];
  List<String>images=[];
   List<List<String>>ashramaallimg=[];
 List<GeoPoint> ashramaloc=[];
  StreamSubscription<QuerySnapshot>_streamSubscription;
  List<DocumentSnapshot>_list=[];
  CollectionReference _collectionReference=Firestore.instance.collection("ashrama");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     
    _streamSubscription=_collectionReference.snapshots().listen((data){
      setState(() {
        _list=data.documents;
      });
    });
  }
  @override
  void dispose() {
    _streamSubscription.cancel();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
   for(int i=0;i<_list.length;i++)
     {
       names.add(_list[i].data['name']);
       nearplaces.add(_list[i].data['near']);
       images.add(_list[i].data['img']);
       List<String> temp=_list[i].data['img1'].cast<String>().toList();
       ashramaallimg.add(temp);
      ashramaloc.add(_list[i].data['location']);
     }
    return Container(
      
      child: Row(
        children: <Widget>[
          Text("FEEDIE BHARATH"),
          
          IconButton(icon: Icon(Icons.search),
              padding: EdgeInsets.only(left:80),
              onPressed: (){
                showSearch(context: context, delegate: serching(names.toSet(),nearplaces.toSet(),images.toSet(),ashramaallimg.toSet(),ashramaloc.toSet()));
              })
        ],
      ),
    );
  }

}
class serching extends SearchDelegate<String>
{
 Set<String> temp;
  List<String> names=[];
 List<String> images=[];
 List<String> nearplaces=[];
 List<String> searchimg=[];
 List<String> serachnear=[];
 List<List<String>>ashramaallimg=[];
 List<GeoPoint> ashramaloc=[];
  List<List<String>>searchashramaallimg=[];
 List<GeoPoint> searchashramaloc=[];
 Set<String>ss;
 Set<String>ms;
   List<String> img=[];
   List<String> near=[];
   List<String> city=[];
  serching(Set<String> names, Set<String> nearplaces,Set<String> images,Set<List<String>> ashtamalimg,Set<GeoPoint>ashramaloc){
    this.names=names.toList();
  this.nearplaces=nearplaces.toList();
  this.images=images.toList();
  this.ashramaallimg=ashtamalimg.toList();
this.ashramaloc=ashramaloc.toList();
  }


  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: (){query='';})];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
  return IconButton(
      icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: (){close(context, null);});
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
   return Container(

   );
    
    
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if(names.length>6){
    city=names.sublist(0,names.length-3);
    city.sort((a,b)=>a.length.compareTo(b.length));
    }
    final suggestion=query.isEmpty?city:names.where((p)=>p.startsWith(query)).toList();
    if(searchashramaallimg!=null)
    searchashramaallimg.clear();
    if(searchashramaloc!=null)
    searchashramaloc.clear();
   if(serachnear!=null)
     serachnear.clear();
     if(searchimg!=null)
     searchimg.clear();
     if(near!=null)
    near.clear();
    if(img!=null)
    img.clear();
    if(ms!=null)
    ms.clear();
    if(ss!=null)
    ss.clear();
   for(int i=0;i<suggestion.length;i++)
   {
         for(int j=0;j<names.length;j++)
           { 
             if(suggestion[i]==names[j])
             {
                searchimg.add(images[j]);
                serachnear.add(nearplaces[j]);
                searchashramaloc.add(ashramaloc[j]);
                searchashramaallimg.add(ashramaallimg[j]);
             }
           }
   }
 ms =serachnear.toSet();
  ss=searchimg.toSet();
  
  near=ms.toList();
 img=ss.toList();
 print(suggestion.length);
 print(suggestion);
  return SingleChildScrollView(
    
   child:
     ListView.builder(
      shrinkWrap: true,
        itemCount: suggestion?.length,
        itemBuilder: (BuildContext context,int index){
          String s=suggestion[index];
          String m=near[index];
          String mm=img[index];
         
       return   ListTile(
         
             leading: Container(
             width: 50.0,
             height: 50.0,
             decoration: BoxDecoration(
             shape: BoxShape.circle,
             image: DecorationImage(
             fit: BoxFit.fill,
             image: NetworkImage(mm)
             ),
      ),
      ),
      subtitle: Text(m),
      title: RichText(
          text:TextSpan(
            text:s.substring(0,query.length),
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold
            ),
              children: [
                TextSpan(text: s.substring(query.length),
                    style: TextStyle(
                        color: Colors.black,fontWeight: FontWeight.normal
                    )
                )
              ]
          )
      ),
       onTap: (){
         showResults(context);
        Navigator.pop(context);
             GeoPoint loc=ashramaloc[index];
                                          var as=ashramaallimg[index];
                                        List<String>allimg=as.cast<String>().toList();
           Navigator.of(context).push(
           MaterialPageRoute(
            
           builder:(context)=>Ashramapage(ashramaname:s,ashramaimg:mm,ashramaAddr:m,allimg:allimg,ashramalatitude: loc.latitude,ashramalongitude: loc.longitude,)));
      
       },
       onLongPress: (){
          GeoPoint loc=ashramaloc[index];
                                          var as=ashramaallimg[index];
                                        List<String>allimg=as.cast<String>().toList();
        Navigator.pop(context);
           savedialog(context,suggestion[index],near[index],img[index],allimg,loc);
          
       },
       
          );
        }
     
    ),
    
   
  );
  }
  Future savedialog(BuildContext context,String name,String near,String img,List<String> allimg,GeoPoint loc) async
  {
    return showDialog(
      barrierDismissible: true,
        context: context,
        builder: (context){
          return AlertDialog(
         title: Text("save"),
         content: Text("Save  Ashrama "),
         actions: <Widget>[
           FlatButton(
           child: Text("yes"),
           onPressed: (){
             Navigator.of(context).pop();

             Storefiles.savedata(name,near,img,allimg,loc);
              Fluttertoast.showToast(
                       msg: "saved",
                        toastLength: Toast.LENGTH_LONG,
                        timeInSecForIos: 16,
                        gravity: ToastGravity.BOTTOM

                      );
             
              
           },
         ),
         ],
          );
        }
    );
  }
}



//13.847583,74.630829
