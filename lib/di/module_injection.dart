import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';


@module
abstract class ModuleInjection{
  FirebaseAuth get firebaseAuth=>FirebaseAuth.instance;
  FirebaseFirestore get firestore=>FirebaseFirestore.instance;
}