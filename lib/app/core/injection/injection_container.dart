import 'package:feed_app/app/export.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';


final sl = GetIt.instance;

GlobalKey<NavigatorState> get navigatorKey => sl.get<GlobalKey<NavigatorState>>();

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  await Hive.openBox('feedApp');

  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Hive.box('feedApp'));


}