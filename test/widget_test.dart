import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:quranayat/main.dart';
import 'package:quranayat/views/ayah_list_screen.dart';

void main() {
  testWidgets('QuranAyatApp loads properly', (WidgetTester tester) async {
    await tester.pumpWidget(const QuranAyatApp());
    expect(find.byType(QuranAyatApp), findsOneWidget);
  });

  test('CosmicDustPainter handles Size.zero without throwing NaN', () {
    final painter = CosmicDustPainter(progress: 0.5);
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    expect(() => painter.paint(canvas, Size.zero), returnsNormally);
    expect(() => painter.paint(canvas, const Size(100, 200)), returnsNormally);
  });
}
