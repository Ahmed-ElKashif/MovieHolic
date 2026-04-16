import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:filmflow/main.dart';
import 'package:filmflow/providers/auth_provider.dart';
import 'package:filmflow/providers/movie_provider.dart';

void main() {
  testWidgets('App should build successfully smoke test', (
    WidgetTester tester,
  ) async {
    // Build our app wrapped in its required providers
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Authprovider()),
          ChangeNotifierProvider(create: (_) => MovieProvider()),
        ],
        child: const MovieHolicApp(),
      ),
    );

    // Verify that the MaterialApp successfully built
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
