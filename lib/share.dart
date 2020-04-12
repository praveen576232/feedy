import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:share/share.dart';

void main()=>runApp(ShareApp());
class ShareApp extends StatefulWidget
{
  @override
  _ShareAppState createState() => _ShareAppState();
}

class _ShareAppState extends State<ShareApp> {
   String share;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      Firestore.instance.collection('share').document('sharimg').get().then((onValue){
print(" shre vinfgf ");
setState(() {
    share=onValue.data['img'];
});
    
      print("img:$share");

   });
  }
  @override
  Widget build(BuildContext context) {
    
  
    return  Scaffold(
        appBar: AppBar(
         
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(

               padding: EdgeInsets.only(left: MediaQuery.of(context).size.width-80),
              icon: Icon(Icons.share),
              color: Colors.black87,
              onPressed: (){
                   Share.share(share);  
              },
            )
          ],
          
          ),
          body:share!=null ?Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image:DecorationImage(image: NetworkImage(share))
            ),
          ):Container(child: Center(child: SpinKitCircle(color: Colors.blue,size: 35,),),)
    
    );
  }
}