@TestOn('browser')

import 'dart:html' as html;
import 'package:test/test.dart';
import 'package:uix/uix.dart';

class TestComponent extends Component<int> {
  bool childrenNodes = true;
  int lifecycleCounter = 0;
  int checkCreate = -1;
  int checkInit = -1;
  int checkUpdateState = -1;
  int checkUpdateView = -1;
  int checkUpdated = -1;
  int checkInvalidated = -1;
  int checkAttached = -1;
  int checkDetached = -1;
  int checkDisposed = -1;

  init() { checkInit = lifecycleCounter++; }

  updateState() {
    checkUpdateState = lifecycleCounter++;
    return true;
  }

  updateView() {
    checkUpdateView = lifecycleCounter++;

    final d = data - 1;
    if (d > 0 && childrenNodes) {
      updateRoot(vRoot()([
        vComponent(() => new TestComponent(), data: d),
        vComponent(() => new TestComponent(), data: d),
        vComponent(() => new TestComponent(), data: d)
      ]));
    } else {
      updateRoot(vRoot());
    }
  }

  updated() { checkUpdated = lifecycleCounter++; }
  invalidated() { checkInvalidated = lifecycleCounter++; }
  attached() { checkAttached = lifecycleCounter++; }
  detached() { checkDetached = lifecycleCounter++; }
  disposed() { checkDisposed = lifecycleCounter++; }

  void removeNodes() {
    childrenNodes = false;
    invalidate();
  }
}

void main() {
  initUix();

  group('Lifecycle', () {
    test('Inject', () async {
      final f = new html.DocumentFragment();
      final c = new TestComponent()..data = 1;
      await injectComponent(c, f);
      await scheduler.currentFrame.after();
      expect(c.checkInit, equals(0));
      expect(c.checkAttached, equals(1));
      expect(c.checkUpdateState, equals(2));
      expect(c.checkUpdateView, equals(3));
      expect(c.checkUpdated, equals(4));
      expect(c.checkInvalidated, equals(-1));
      expect(c.checkDetached, equals(-1));
      expect(c.checkDisposed, equals(-1));
    });

    test('Inject > Remove Children', () async {
      final f = new html.DocumentFragment();
      final c = new TestComponent()..data = 2;
      await injectComponent(c, f);
      await scheduler.currentFrame.after();
      final child = c.root.children[0].cref;
      expect(child, const isInstanceOf<TestComponent>());
      c.removeNodes();
      await scheduler.nextFrame.after();
      expect(c.checkInvalidated, equals(5));
      expect(c.checkUpdateState, equals(6));
      expect(c.checkUpdateView, equals(7));
      expect(c.checkUpdated, equals(8));
      expect(c.checkInit, equals(0));
      expect(c.checkAttached, equals(1));
      expect(c.checkDetached, equals(-1));
      expect(c.checkDisposed, equals(-1));

      expect(child.checkInit, equals(0));
      expect(child.checkAttached, equals(1));
      expect(child.checkUpdateState, equals(2));
      expect(child.checkUpdateView, equals(3));
      expect(child.checkUpdated, equals(4));
      expect(child.checkInvalidated, equals(-1));
      expect(child.checkDetached, equals(5));
      expect(child.checkDisposed, equals(6));
    });
  });

  group('Invalidate', () {
    test('data', () async {
      final f = new html.DocumentFragment();
      final c = new TestComponent()..data = 2;
      await injectComponent(c, f);
      await scheduler.currentFrame.after();
      c.data = 1;
      expect(c.checkInvalidated, equals(5));
    });

    test('children', () async {
      final f = new html.DocumentFragment();
      final c = new TestComponent()..data = 2;
      await injectComponent(c, f);
      await scheduler.currentFrame.after();
      c.children = [vText('c')];
      expect(c.checkInvalidated, equals(5));
    });
  });
}
