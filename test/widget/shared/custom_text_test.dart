import 'package:feed_app/app/shared/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomText Widget Tests', () {
    testWidgets('display provided text', (WidgetTester tester) async {
      const testText = 'Hello, World!';

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CustomText(testText))),
      );

      expect(find.text(testText), findsOneWidget);
    });

    testWidgets('custom fontSize', (WidgetTester tester) async {
      const testText = 'Test Text';
      const fontSize = 24.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CustomText(testText, fontSize: fontSize)),
        ),
      );

      final text = tester.widget<Text>(find.text(testText));
      expect(text.style?.fontSize, fontSize);
    });

    testWidgets('long text with maxLines', (WidgetTester tester) async {
      const longText = '''
        Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..
      ''';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200,
              child: CustomText(
                longText.trim(),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(
        find.textContaining('This is a very long text'),
      );
      expect(text.maxLines, 3);
      expect(text.overflow, TextOverflow.ellipsis);
    });
  });
}
