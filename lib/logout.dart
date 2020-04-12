import 'package:firebase_auth/firebase_auth.dart';

class logoutClass
{
 
  static logout() async{
     FirebaseAuth _auth = FirebaseAuth.instance;
     _auth.signOut();
        
  }
}