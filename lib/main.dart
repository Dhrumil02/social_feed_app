import 'package:feed_app/app/core/injection/injection_container.dart' as di;
import 'package:feed_app/app/export.dart';
import 'package:feed_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);



  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  await di.init();

  runApp(FeedApp());
}
