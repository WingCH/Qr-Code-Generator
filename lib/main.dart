import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:seo_renderer/seo_renderer.dart';

import 'firebase_options.dart';
import 'pages/home/view.dart';

// ISSUE: https://github.com/flutter/flutter/issues/126713
// cannot build now because of this issue

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = AppObserver();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorage.webStorageDirectory,
  );
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
        theme: FlexThemeData.light(
          colors: const FlexSchemeColor(
            primary: Color(0xff00296b),
            primaryContainer: Color(0xffa0c2ed),
            secondary: Color(0xffd26900),
            secondaryContainer: Color(0xffffd270),
            tertiary: Color(0xff5c5c95),
            tertiaryContainer: Color(0xffc8dbf8),
            appBarColor: Color(0xffc8dcf8),
            error: null,
          ),
          surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
          blendLevel: 20,
          appBarOpacity: 0.95,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 20,
            blendOnColors: false,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          // To use the playground font, add GoogleFonts package and uncomment
          // fontFamily: GoogleFonts.notoSans().fontFamily,
        ),
        darkTheme: FlexThemeData.dark(
          colors: const FlexSchemeColor(
            primary: Color(0xffb1cff5),
            primaryContainer: Color(0xff3873ba),
            secondary: Color(0xffffd270),
            secondaryContainer: Color(0xffd26900),
            tertiary: Color(0xffc9cbfc),
            tertiaryContainer: Color(0xff535393),
            appBarColor: Color(0xff00102b),
            error: null,
          ),
          surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
          blendLevel: 15,
          appBarStyle: FlexAppBarStyle.background,
          appBarOpacity: 0.90,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 30,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          // To use the playground font, add GoogleFonts package and uncomment
          fontFamily: GoogleFonts.notoSans().fontFamily,
        ),
        themeMode: ThemeMode.system,
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
