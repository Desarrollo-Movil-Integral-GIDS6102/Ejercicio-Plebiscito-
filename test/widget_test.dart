import 'package:flutter_test/flutter_test.dart';
import 'package:vota_dolores_hidalgo/main.dart';

void main() {
  testWidgets('permite emitir un voto y consultar el resultado', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const VotaDoloresApp());

    expect(find.textContaining('Que obra prioritaria'), findsOneWidget);
    expect(find.text('Votos registrados: 0'), findsOneWidget);

    await tester.tap(find.text('Votar por esta opcion').first);
    await tester.pumpAndSettle();

    expect(find.text('Votos registrados: 1'), findsOneWidget);
    expect(find.text('Gracias, tu voto ya fue registrado.'), findsOneWidget);
    expect(find.text('Votar por esta opcion'), findsNothing);

    await tester.tap(find.text('Ver resultado del plebiscito'));
    await tester.pumpAndSettle();
    expect(find.textContaining('La opcion ganadora es:'), findsOneWidget);
  });
}
