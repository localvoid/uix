import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';
import 'package:uix/uix.dart';

class DNode extends DataNode {}
class ONode extends ObservableNode {}
class LNode extends ListenerNode {
  bool invalidated = false;

  invalidate() {
    invalidated = true;
  }
}

void main() {
  useHtmlEnhancedConfiguration();

  group('DataNode', () {
    group('isNewer', () {
      test('1 | 2', () {
        final a = new DNode()
          ..rev = 1;
        final b = new DNode()
          ..rev = 2;

        expect(a.isNewer(b), isFalse);
        expect(b.isNewer(a), isTrue);
      });

      test('1 | 1', () {
        final a = new DNode()
          ..rev = 1;
        final b = new DNode()
          ..rev = 1;

        expect(a.isNewer(b), isFalse);
        expect(b.isNewer(a), isFalse);
      });
    });
  });

  group('Observables', () {
    test('Observable init', () {
      final a = new ONode();
      expect(a.listeners, isNull);
    });

    test('Listener init', () {
      final a = new LNode();
      expect(a.dependencies, isNull);
    });

    test('addListener', () {
      final a = new ONode();
      final b = new LNode();
      a.addListener(b);
      expect(a.listeners.length, equals(1));
      expect(b.dependencies, isNull);
      expect(a.listeners.first, equals(b));
    });

    test('removeListener', () {
      final a = new ONode();
      final b = new LNode();
      a.addListener(b);
      a.removeListener(b);
      expect(a.listeners, isEmpty);
      expect(b.dependencies, isNull);
    });

    test('removeListener: 2 => 1 [1]', () {
      final a = new ONode();
      final b = new LNode();
      final c = new LNode();
      a.addListener(b);
      a.addListener(c);
      a.removeListener(b);
      a.removeListener(c);
      expect(a.listeners, isEmpty);
      expect(b.dependencies, isNull);
    });

    test('removeListener: 2 => 1 [2]', () {
      final a = new ONode();
      final b = new LNode();
      final c = new LNode();
      a.addListener(b);
      a.addListener(c);
      a.removeListener(c);
      expect(a.listeners.length, equals(1));
      expect(a.listeners.first, equals(b));
      expect(b.dependencies, isNull);
    });

    test('removeListener: 2 => 1 [3]', () {
      final a = new ONode();
      final b = new LNode();
      final c = new LNode();
      a.addListener(b);
      a.addListener(c);
      a.removeListener(b);
      expect(a.listeners.length, equals(1));
      expect(a.listeners.first, equals(c));
      expect(b.dependencies, isNull);
    });

    test('listen', () {
      final a = new ONode();
      final b = new LNode();
      b.listen(a);
      expect(a.listeners.length, equals(1));
      expect(b.dependencies.length, equals(1));
      expect(a.listeners.first, equals(b));
      expect(b.dependencies.first, equals(a));
    });

    test('invalidate empty', () {
      final a = new ONode();
      a.invalidateListeners();
      expect(a.listeners, isNull);
    });

    test('invalidate 1', () {
      final a = new ONode();
      final b = new LNode();
      b.listen(a);
      a.invalidateListeners();
      expect(a.listeners, isNull);
      expect(b.invalidated, isTrue);
    });

    test('invalidate 2', () {
      final a = new ONode();
      final b = new LNode();
      final c = new LNode();
      b.listen(a);
      c.listen(a);
      a.invalidateListeners();
      expect(a.listeners, isNull);
      expect(b.invalidated, isTrue);
      expect(c.invalidated, isTrue);
    });

    test('resetDepencencies empty', () {
      final b = new LNode();
      b.resetDependencies();
      expect(b.dependencies, isNull);
    });

    test('resetDepencencies 1', () {
      final a = new ONode();
      final b = new LNode();
      b.listen(a);
      b.resetDependencies();
      expect(a.listeners, isEmpty);
      expect(b.dependencies, isNull);
    });

    test('resetDepencencies 2', () {
      final a = new ONode();
      final b = new ONode();
      final c = new LNode();
      c.listen(a);
      c.listen(b);
      c.resetDependencies();
      expect(a.listeners, isEmpty);
      expect(b.listeners, isEmpty);
      expect(c.dependencies, isNull);
    });
  });
}