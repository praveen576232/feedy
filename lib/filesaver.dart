
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Storefiles
{

  
  static Future<String> getuser() async
  {
     FirebaseAuth _auth=FirebaseAuth.instance;
     FirebaseUser user=await _auth.currentUser();
    
     return Future.value(user.phoneNumber);
  }
  
    static Future<void>savedata(String name,String near,String img,List<String> allimg,GeoPoint loc)async
    {
      String data;
       final firebaseUser=await getuser();
       if(allimg?.length!=0){
         for(int i=0;i<allimg.length;i++){
           if(data!=null)
data="$data,${allimg[i]}";
else if(data==null)
data=allimg[i];
         }
       }
        DocumentReference _document=Firestore.instance.collection("save").document("$firebaseUser/saveddata/$name");
       Map<String,String> map=<String,String>
       {
         "savename":name,
         "image":img,
         "near":near,
         "img1":data,
         "location":"${loc.latitude},${loc.longitude}"
       };
       _document.setData(map);
       
    }
     static Future<DocumentReference>help(String name,String img,String conform,String username,DocumentSnapshot doc,String lat,String log)async
    {
       var date=DateTime.now();
   String datetime=(formatDate(
     DateTime(
    date.year,date.month,date.day,date.hour,date.minute,date.second), [dd, '-', M, '-', yy,'/',hh,':',nn,':',am]));
     
       final firebaseUser=await getuser();
       String user=firebaseUser+date.year.toString()+date.day.toString()+date.month.toString()+date.hour.toString()+date.minute.toString()+date.second.toString();
      
        DocumentReference _document=Firestore.instance.collection("help").document(doc!=null?doc.documentID:user);
       Map<String,String> map=<String,String>
       {
         "ashramaname":name,
         "image":img,
         "date":datetime,
         "conform":conform,
         "phno":firebaseUser,
         "username" :username ,
         "user_location":"$lat,$log"
       };      
       _document.setData(map);   
       return _document;
    }
   static Future<String> useremail() async
   {
    final user=await getuser();
    DocumentReference documentReference=Firestore.instance.collection("userinfo").document(user);
    documentReference.snapshots().listen((mydata){
      print(mydata.data['email']);
       return Future.value(mydata.data['email']);
    });
   } 
static Future<String> getusername() async
{
  final user=await getuser();
  DocumentReference _document=Firestore.instance.collection("userinfo").document(user);
  _document.snapshots().listen((data){
    print("my dat a about user");
    print(data.data['name']);
    return Future.value(data.data['name']);
  });

}
      
    
    }

