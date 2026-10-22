
import 'package:flutter_test/flutter_test.dart';
import 'package:iklc_anime_verse/main.dart';

void main() {
  testWidgets('AnimeVerse app renders without crashing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(tester.takeException(), isNull);
  });
}
