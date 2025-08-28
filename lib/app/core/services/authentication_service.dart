import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feed_app/app/core/injection/injection_container.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService{


  final FirebaseAuth _auth = sl<FirebaseAuth>();
  final FirebaseFirestore _fireStore = sl<FirebaseFirestore>();

}