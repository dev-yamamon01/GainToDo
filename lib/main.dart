import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gain_to_do/presentation/router/router.dart';
import 'package:gain_to_do/data/providers/isar_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isar = await initializeIsar();

  runApp(ProviderScope(
    overrides: [
      isarProvider.overrideWithValue(isar),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
