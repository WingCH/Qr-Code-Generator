import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:seo_renderer/seo_renderer.dart';

import 'firebase_options.dart';
import 'pages/home/view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = AppObserver();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorage.webStorageDirectory,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RobotDetector(
      debug: false,
      child: MaterialApp(
        title: 'Qr Code Generator',
        home: const HomePage(),
        navigatorObservers: [seoRouteObserver],
        // Made for FlexColorScheme version 7.0.5. Make sure you
        // use same or higher package version, but still same major version.
        // If you use a lower version, some properties may not be supported.
        // In that case remove them after copying this theme to your app.
        theme: FlexThemeData.light(
          scheme: FlexScheme.hippieBlue,
          surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
          blendLevel: 7,
          appBarStyle: FlexAppBarStyle.primary,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 10,
            blendOnColors: false,
            useM2StyleDividerInM3: true,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          swapLegacyOnMaterial3: true,
          fontFamily: GoogleFonts.notoSans().fontFamily,
        ),
        // darkTheme: FlexThemeData.dark(
        //   scheme: FlexScheme.hippieBlue,
        //   surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        //   blendLevel: 13,
        //   subThemesData: const FlexSubThemesData(
        //     blendOnLevel: 20,
        //     useM2StyleDividerInM3: true,
        //   ),
        //   visualDensity: FlexColorScheme.comfortablePlatformDensity,
        //   useMaterial3: true,
        //   swapLegacyOnMaterial3: true,
        //   fontFamily: GoogleFonts.notoSans().fontFamily,
        // ),
        themeMode: ThemeMode.light,
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
