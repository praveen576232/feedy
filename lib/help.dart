import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapppp/ashramapage.dart';
import 'package:flutterapppp/filesaver.dart';
void main()=>runApp(Help());
class Help extends StatefulWidget
{
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  List<DocumentSnapshot>sapshot=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdatahelp();
  }
   getdatahelp()async
  {
    print("object");
    final userphno=await Storefiles.getuser();
   
     Firestore.instance.collection("help").getDocuments().then((onValue){
       if(onValue.documents.isNotEmpty)
       {
         for (int i = 0; i < onValue.documents.length; i++) {
           if(userphno==(onValue.documents[i].data['phno']))
           {
             print("help");
             print(userphno);
             print(onValue.documents[i].data['phno']);
             sapshot.add(onValue.documents[i]);
           }
         }
       }
     });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("HELP"),),
        body:sapshot.length!=null ?ListView.builder(
              itemCount: sapshot?.length,
              itemBuilder: (context,index)
              {
                  String name=sapshot[index].data['ashramaname'];
            String myimg=sapshot[index].data['image'];
           
             String date=sapshot[index].data['date'];
                      return ListTile(
       
                       leading:Container(
                            width: 75.0,
                            height: 75.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(myimg))
                            ),
                          ),
                       title: name!=null? 
                       Text(name):Text("user not update"),
                       subtitle: Text(date),
                      
                        onTap: (){
                          var listimg=sapshot[index].data['img1'];
                          GeoPoint loc=sapshot[index].data['location'];
                          List<String>all=listimg.cast<String>().toList();
                           Navigator.of(context).push(MaterialPageRoute(
                               builder:(context)=>Ashramapage(ashramaname:name,ashramaimg:myimg,ashramaAddr:'',username: '',allimg: all,ashramalatitude: loc.latitude,ashramalongitude: loc.longitude,)));
                      
                        },

                      );
                      
                     },
    
              
        ):Center(
          child:Text("not at help"))
      ),
    );
  }
}