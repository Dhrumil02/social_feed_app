import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feed_app/app/core/constants/app_constants.dart';
import 'package:feed_app/app/core/injection/injection_container.dart' as di;
import 'package:feed_app/app/export.dart';
import 'package:feed_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/core/services/supbase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  await di.init();
  await SupabaseService.initializeBuckets();

  runApp(FeedApp());
}
