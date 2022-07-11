import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:seo_renderer/seo_renderer.dart';

import 'firebase_options.dart';
import 'pages/home/view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final storage = await HydratedStorage.build(
    storageDirectory: HydratedStorage.webStorageDirectory,
  );

  HydratedBlocOverrides.runZoned(
    () => runApp(const MyApp()),
    blocObserver: AppObserver(),
    storage: storage,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RobotDetector(
      debug: true,
      child: MaterialApp(
        title: 'Qr Code Generator',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
        navigatorObservers: [seoRouteObserver],
      ),
    );
  }
}

class AppObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }
}
