import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:qrcode_diff/src/home/home_view.dart';
import 'package:qrcode_diff/src/scan/scan_controller.dart';
import 'package:qrcode_diff/src/scan/scan_view.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.scanController
  });

  final ScanController scanController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'app',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
      ],
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appTitle,
      theme: ThemeData(
        colorSchemeSeed: Colors.black45,
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (BuildContext context) {
            switch (routeSettings.name) {
              case ScanView.routeName:
                return ScanView(controller: scanController,);
              default:
                return const HomeView();
            }
          },
        );
      },
    );
  }
}
