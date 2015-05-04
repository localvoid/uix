import 'dart:html' as html;
import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';
import 'package:uix/uix.dart';

void injectVNodeSync(VNode node, html.Node container) {
  node.create(const VContext(false));
  container.append(node.ref);
  node.attached();
  node.render(const VContext(true));
}

VNode deepCopy(VNode n) {
  final children = n.children == null ? null : n.children.map((c) => deepCopy(c)).toList();
  return new VNode(n.flags, key: n.key, tag: n.tag, data: n.data, type: n.type, attrs: n.attrs, style: n.style,
      classes: n.classes, children: children);
}

VNode ee(Object key, [Object c = null]) =>
    (c == null) ? vElement('div', key: key) : vElement('div', key: key)(c);
VNode ei([Object c = null]) =>
    (c == null) ? vElement('div') : vElement('div')(c);
final ve = vElement;

/// Generate list of [VNode] element from simple integers.
///
/// For example, list `[0, 1, [2, [0, 1, 2]], 3]` will create
/// list with 4 [VNode]s and the 2nd element will have key `2` and 3 childrens
/// of its own.
List<VNode> gen(List items, [bool keys = true]) {
  final result = [];
  for (var i in items) {
    if (i is List) {
      result.add(keys ? ee(i[0], gen(i[1], keys)) : ei(gen(i[1], keys)));
    } else {
      result.add(keys ? ee('text_$i', i.toString()) : ei(i.toString()));
    }
  }
  return result;
}

void checkInnerHtmlEquals(VNode a, VNode b) {
  final aDiv = new html.DocumentFragment();
  final bDiv = new html.DocumentFragment();
  injectVNodeSync(a, aDiv);
  injectVNodeSync(deepCopy(b), bDiv);

  final bHtml = bDiv.innerHtml;

  a.update(b, const VContext(true));
  final aHtml = aDiv.innerHtml;

  if (aHtml != bHtml) {
    throw new TestFailure('Expected: "$bHtml" Actual: "$aHtml"');
  }
}

void main() {
  useHtmlEnhancedConfiguration();

  group('Render', () {
    group('Basic', () {
      test('Create empty div', () {
        final frag = new html.DocumentFragment();
        final n = ve('div');
        injectVNodeSync(n, frag);
        expect(frag.innerHtml, equals('<div></div>'));
      });

      test('Create empty span', () {
        final frag = new html.DocumentFragment();
        final n = ve('span');
        injectVNodeSync(n, frag);
        expect(frag.innerHtml, equals('<span></span>'));
      });
    });
    group('Attributes', () {
      test('Create div with 1 attribute', () {
        final frag = new html.DocumentFragment();
        final n = ve('div', attrs: {'id': 'test-id'});
        injectVNodeSync(n, frag);
        expect(frag.innerHtml, equals('<div id="test-id"></div>'));
      });

      test('Create div with 2 attributes', () {
        final frag = new html.DocumentFragment();
        final n = ve('div', attrs: {'id': 'test-id', 'data-test': 'test-data'});
        injectVNodeSync(n, frag);
        expect(frag.innerHtml,
            equals('<div id="test-id" data-test="test-data"></div>'));
      });

      test('Create textarea with numeric attributes', () {
        final frag = new html.DocumentFragment();
        final n = ve('textarea', attrs: {'rows': 2, 'cols': 20});
        injectVNodeSync(n, frag);
        expect(frag.innerHtml, equals('<textarea rows="2" cols="20"></textarea>'));
      });

      test('Create checkbox with boolean attribute', () {
        final frag = new html.DocumentFragment();
        final n = ve('input', attrs: {'type': 'checkbox', 'checked': true});
        injectVNodeSync(n, frag);
        expect(frag.innerHtml, equals('<input type="checkbox" checked="">'));

        final frag2 = new html.DocumentFragment();
        final n2 = ve('input', attrs: {'type': 'checkbox', 'checked': false});
        injectVNodeSync(n2, frag2);
        expect(frag2.innerHtml, equals('<input type="checkbox">'));
      });
    });

    group('Styles', () {
      test('Create div with 1 style', () {
        final frag = new html.DocumentFragment();
        final n = ve('div', style: {'top': '10px'});
        injectVNodeSync(n, frag);
        expect(frag.innerHtml, equals('<div style="top: 10px;"></div>'));
      });

      test('Create div with 2 styles', () {
        final frag = new html.DocumentFragment();
        final n = ve('div', style: {'top': '10px', 'left': '20px'});
        injectVNodeSync(n, frag);
        expect(frag.innerHtml,
            equals('<div style="top: 10px; left: 20px;"></div>'));
      });
    });

    group('Classes', () {
      test('Create div with 1 class', () {
        final frag = new html.DocumentFragment();
        final n = ve('div', classes: ['button']);
        injectVNodeSync(n, frag);
        expect(frag.innerHtml, equals('<div class="button"></div>'));
      });

      test('Create div with 2 classes', () {
        final frag = new html.DocumentFragment();
        final n = ve('div', classes: ['button', 'button.important']);
        injectVNodeSync(n, frag);
        expect(frag.innerHtml,
            equals('<div class="button button.important"></div>'));
      });
    });

    group('Children', () {
      test('Create div with 1 child', () {
        final frag = new html.DocumentFragment();
        final n = ve('div')([ve('span')]);
        injectVNodeSync(n, frag);
        expect(frag.innerHtml, equals('<div><span></span></div>'));
      });

      test('Create div with 2 children', () {
        final frag = new html.DocumentFragment();
        final n = ve('div')([ve('span'), ve('span')]);
        injectVNodeSync(n, frag);
        expect(frag.innerHtml, equals('<div><span></span><span></span></div>'));
      });
    });
  });

  group('Update children with explicit keys', () {
    group('No modifications', () {
      test('No childrens', () {
        final a = ee(0);
        final b = ee(0);
        checkInnerHtmlEquals(a, b);
      });

      test('Same child', () {
        final a = ee(0, gen([0]));
        final b = ee(0, gen([0]));
        checkInnerHtmlEquals(a, b);
      });

      test('Same children', () {
        final a = ee(0, gen([0, 1, 2]));
        final b = ee(0, gen([0, 1, 2]));
        checkInnerHtmlEquals(a, b);
      });
    });

    group('Basic inserts', () {
      group('Into empty list', () {
        final a = ee(0, []);

        final tests = [
          {'name': 'One item', 'b': [1]},
          {'name': 'Two items', 'b': [4, 9]},
          {'name': 'Five items', 'b': [9, 3, 6, 1, 0]}
        ];

        for (var t in tests) {
          final testFn = t['solo'] == true ? solo_test : test;
          final name = t['name'] == null ? '[] => ${t['b']}' : t['name'];

          testFn(name, () {
            final b = ee(0, gen(t['b']));
            checkInnerHtmlEquals(a, b);
          });
        }
      });

      group('Into one element list', () {
        final a = ee(0, gen([999]));

        final tests = [
          {'b': [1]},
          {'b': [1, 999]},
          {'b': [999, 1]},
          {'b': [4, 9, 999]},
          {'b': [999, 4, 9]},
          {'b': [9, 3, 6, 1, 0, 999]},
          {'b': [999, 9, 3, 6, 1, 0]},
          {'b': [0, 999, 1]},
          {'b': [0, 3, 999, 1, 4]},
          {'b': [0, 999, 1, 4, 5]}
        ];

        for (var t in tests) {
          final testFn = t['solo'] == true ? solo_test : test;
          final name = t['name'] == null ? '[999] => ${t['b']}' : t['name'];

          testFn(name, () {
            final b = ee(0, gen(t['b']));

            checkInnerHtmlEquals(a, b);
          });
        }
      });

      group('Into two elements list', () {
        final a = ee(0, gen([998, 999]));

        final tests = [
          {'b': [1, 998, 999]},
          {'b': [998, 999, 1]},
          {'b': [998, 1, 999]},
          {'b': [1, 2, 998, 999]},
          {'b': [998, 999, 1, 2]},
          {'b': [1, 998, 999, 2]},
          {'b': [1, 998, 2, 999, 3]},
          {'b': [1, 4, 998, 2, 5, 999, 3, 6]},
          {'b': [1, 998, 2, 999]},
          {'b': [998, 1, 999, 2]},
          {'b': [1, 2, 998, 3, 4, 999]},
          {'b': [998, 1, 2, 999, 3, 4]},
          {'b': [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 998, 999]},
          {'b': [998, 999, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9]},
          {'b': [0, 1, 2, 3, 4, 998, 999, 5, 6, 7, 8, 9]},
          {'b': [0, 1, 2, 998, 3, 4, 5, 6, 999, 7, 8, 9]},
          {'b': [0, 1, 2, 3, 4, 998, 5, 6, 7, 8, 9, 999]},
          {'b': [998, 0, 1, 2, 3, 4, 999, 5, 6, 7, 8, 9]}
        ];

        for (var t in tests) {
          final testFn = t['solo'] == true ? solo_test : test;
          final name =
              t['name'] == null ? '[998, 999] => ${t['b']}' : t['name'];

          testFn(name, () {
            final b = ee(0, gen(t['b']));
            checkInnerHtmlEquals(a, b);
          });
        }
      });
    });

    group('Basic removes', () {
      group('1 item', () {
        final tests = [
          {'a': [1], 'b': []},
          {'a': [1, 2], 'b': [2]},
          {'a': [1, 2], 'b': [1]},
          {'a': [1, 2, 3], 'b': [2, 3]},
          {'a': [1, 2, 3], 'b': [1, 2]},
          {'a': [1, 2, 3], 'b': [1, 3]},
          {'a': [1, 2, 3, 4, 5], 'b': [2, 3, 4, 5]},
          {'a': [1, 2, 3, 4, 5], 'b': [1, 2, 3, 4]},
          {'a': [1, 2, 3, 4, 5], 'b': [1, 2, 4, 5]}
        ];

        for (var t in tests) {
          final testFn = t['solo'] == true ? solo_test : test;
          final name = t['name'] == null ? '${t['a']} => ${t['b']}' : t['name'];

          testFn(name, () {
            final a = ee(0, gen(t['a']));
            final b = ee(0, gen(t['b']));
            checkInnerHtmlEquals(a, b);
          });
        }
      });

      group('2 items', () {
        final tests = [
          {'a': [1, 2], 'b': []},
          {'a': [1, 2, 3], 'b': [3]},
          {'a': [1, 2, 3], 'b': [1]},
          {'a': [1, 2, 3, 4], 'b': [3, 4]},
          {'a': [1, 2, 3, 4], 'b': [1, 2]},
          {'a': [1, 2, 3, 4], 'b': [1, 4]},
          {'a': [1, 2, 3, 4, 5, 6], 'b': [2, 3, 4, 5]},
          {'a': [1, 2, 3, 4, 5, 6], 'b': [2, 3, 5, 6]},
          {'a': [1, 2, 3, 4, 5, 6], 'b': [1, 2, 3, 5]},
          {'a': [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 'b': [2, 3, 4, 5, 6, 7, 8, 9]},
          {'a': [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 'b': [0, 1, 2, 3, 4, 5, 6, 7]},
          {'a': [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 'b': [1, 2, 3, 4, 6, 7, 8, 9]},
          {'a': [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 'b': [0, 1, 2, 3, 4, 6, 7, 8]},
          {'a': [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 'b': [0, 1, 2, 4, 6, 7, 8, 9]}
        ];

        for (var t in tests) {
          final testFn = t['solo'] == true ? solo_test : test;
          final name = t['name'] == null ? '${t['a']} => ${t['b']}' : t['name'];

          testFn(name, () {
            final a = ee(0, gen(t['a']));
            final b = ee(0, gen(t['b']));
            checkInnerHtmlEquals(a, b);
          });
        }
      });
    });

    group('Basic moves', () {
      final tests = [
        {'a': [0, 1], 'b': [1, 0]},
        {'a': [0, 1, 2, 3], 'b': [3, 2, 1, 0]},
        {'a': [0, 1, 2, 3, 4], 'b': [1, 2, 3, 4, 0]},
        {'a': [0, 1, 2, 3, 4], 'b': [4, 0, 1, 2, 3]},
        {'a': [0, 1, 2, 3, 4], 'b': [1, 0, 2, 3, 4]},
        {'a': [0, 1, 2, 3, 4], 'b': [2, 0, 1, 3, 4]},
        {'a': [0, 1, 2, 3, 4], 'b': [0, 1, 4, 2, 3]},
        {'a': [0, 1, 2, 3, 4], 'b': [0, 1, 3, 4, 2]},
        {'a': [0, 1, 2, 3, 4], 'b': [0, 1, 3, 2, 4]},
        {'a': [0, 1, 2, 3, 4, 5, 6], 'b': [2, 1, 0, 3, 4, 5, 6]},
        {'a': [0, 1, 2, 3, 4, 5, 6], 'b': [0, 3, 4, 1, 2, 5, 6]},
        {'a': [0, 1, 2, 3, 4, 5, 6], 'b': [0, 2, 3, 5, 6, 1, 4]},
        {'a': [0, 1, 2, 3, 4, 5, 6], 'b': [0, 1, 5, 3, 2, 4, 6]},
        {
          'a': [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
          'b': [8, 1, 3, 4, 5, 6, 0, 7, 2, 9]
        },
        {
          'a': [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
          'b': [9, 5, 0, 7, 1, 2, 3, 4, 6, 8]
        }
      ];

      for (var t in tests) {
        final a0 = t['a'];
        final b0 = t['b'];
        final name = t['name'] == null ? '$a0 => $b0' : t['name'];

        final testFn = t['solo'] == true ? solo_test : test;

        testFn(name, () {
          final a = ee(0, gen(a0));
          final b = ee(0, gen(b0));
          checkInnerHtmlEquals(a, b);
        });
      }
    });

    group('Insert and Move', () {
      final tests = [
        {'a': [0, 1], 'b': [2, 1, 0]},
        {'a': [0, 1], 'b': [1, 0, 2]},
        {'a': [0, 1, 2], 'b': [3, 0, 2, 1]},
        {'a': [0, 1, 2], 'b': [0, 2, 1, 3]},
        {'a': [0, 1, 2], 'b': [0, 2, 3, 1]},
        {'a': [0, 1, 2], 'b': [1, 2, 3, 0]},
        {'a': [0, 1, 2, 3, 4], 'b': [5, 4, 3, 2, 1, 0]},
        {'a': [0, 1, 2, 3, 4], 'b': [5, 4, 3, 6, 2, 1, 0]},
        {'a': [0, 1, 2, 3, 4], 'b': [5, 4, 3, 6, 2, 1, 0, 7]}
      ];
      for (var t in tests) {
        final a0 = t['a'];
        final b0 = t['b'];
        final name = t['name'] == null ? '$a0 => $b0' : t['name'];

        final testFn = t['solo'] == true ? solo_test : test;

        testFn(name, () {
          final a = ee(0, gen(a0));
          final b = ee(0, gen(b0));
          checkInnerHtmlEquals(a, b);
        });
      }
    });

    group('Remove and Move', () {
      final tests = [
        {'a': [0, 1, 2], 'b': [1, 0]},
        {'a': [2, 0, 1], 'b': [1, 0]},
        {'a': [7, 0, 1, 8, 2, 3, 4, 5, 9], 'b': [7, 5, 4, 8, 3, 2, 1, 0]},
        {'a': [7, 0, 1, 8, 2, 3, 4, 5, 9], 'b': [5, 4, 8, 3, 2, 1, 0, 9]},
        {'a': [7, 0, 1, 8, 2, 3, 4, 5, 9], 'b': [7, 5, 4, 3, 2, 1, 0, 9]},
        {'a': [7, 0, 1, 8, 2, 3, 4, 5, 9], 'b': [5, 4, 3, 2, 1, 0, 9]},
        {'a': [7, 0, 1, 8, 2, 3, 4, 5, 9], 'b': [5, 4, 3, 2, 1, 0]}
      ];

      for (var t in tests) {
        final a0 = t['a'];
        final b0 = t['b'];
        final name = t['name'] == null ? '$a0 => $b0' : t['name'];

        final testFn = t['solo'] == true ? solo_test : test;

        testFn(name, () {
          final a = ee(0, gen(a0));
          final b = ee(0, gen(b0));
          checkInnerHtmlEquals(a, b);
        });
      }
    });

    group('Insert and Remove', () {
      final tests = [
        {'a': [0], 'b': [1]},
        {'a': [0], 'b': [1, 2]},
        {'a': [0, 2], 'b': [1]},
        {'a': [0, 2], 'b': [1, 2]},
        {'a': [0, 2], 'b': [2, 1]},
        {'a': [0, 1, 2], 'b': [3, 4, 5]},
        {'a': [0, 1, 2], 'b': [2, 4, 5]},
        {'a': [0, 1, 2, 3, 4, 5], 'b': [6, 7, 8, 9, 10, 11]},
        {'a': [0, 1, 2, 3, 4, 5], 'b': [6, 1, 7, 3, 4, 8]},
        {'a': [0, 1, 2, 3, 4, 5], 'b': [6, 7, 3, 8]}
      ];

      for (var t in tests) {
        final a0 = t['a'];
        final b0 = t['b'];
        final name = t['name'] == null ? '$a0 => $b0' : t['name'];

        final testFn = t['solo'] == true ? solo_test : test;

        testFn(name, () {
          final a = ee(0, gen(a0));
          final b = ee(0, gen(b0));
          checkInnerHtmlEquals(a, b);
        });
      }
    });

    group('Insert, Remove and Move', () {
      final tests = [
        {'a': [0, 1, 2], 'b': [3, 2, 1]},
        {'a': [0, 1, 2], 'b': [2, 1, 3]},
        {'a': [1, 2, 0], 'b': [2, 1, 3]},
        {'a': [1, 2, 0], 'b': [3, 2, 1]},
        {'a': [0, 1, 2, 3, 4, 5], 'b': [6, 1, 3, 2, 4, 7]},
        {'a': [0, 1, 2, 3, 4, 5], 'b': [6, 1, 7, 3, 2, 4]},
        {'a': [0, 1, 2, 3, 4, 5], 'b': [6, 7, 3, 2, 4]},
        {'a': [0, 2, 3, 4, 5], 'b': [6, 1, 7, 3, 2, 4]}
      ];
      for (var t in tests) {
        final a0 = t['a'];
        final b0 = t['b'];
        final name = t['name'] == null ? '$a0 => $b0' : t['name'];

        final testFn = t['solo'] == true ? solo_test : test;

        testFn(name, () {
          final a = ee(0, gen(a0));
          final b = ee(0, gen(b0));
          checkInnerHtmlEquals(a, b);
        });
      }
    });

    group('Modified children', () {
      final tests = [
        {'a': [[0, [0]]], 'b': [0]},
        {'a': [0, 1, [2, [0]]], 'b': [2]},
        {'a': [0], 'b': [1, 2, [0, [0]]]},
        {'a': [0, [1, [0, 1]], 2], 'b': [3, 2, [1, [1, 0]]]},
        {'a': [0, [1, [0, 1]], 2], 'b': [2, [1, [1, 0]], 3]},
        {
          'a': [[1, [0, 1]], [2, [0, 1]], 0],
          'b': [[2, [1, 0]], [1, [1, 0]], 3]
        },
        {'a': [[1, [0, 1]], 2, 0], 'b': [3, [2, [1, 0]], 1]},
        {'a': [0, 1, 2, [3, [1, 0]], 4, 5], 'b': [6, [1, [0, 1]], 3, 2, 4, 7]},
        {
          'a': [0, 1, 2, 3, 4, 5],
          'b': [6, [1, [1]], 7, [3, [1]], [2, [1]], [4, [1]]]
        },
        {'a': [0, 1, [2, [0]], 3, [4, [0]], 5], 'b': [6, 7, 3, 2, 4]},
        {'a': [0, [2, [0]], [3, [0]], [4, [0]], 5], 'b': [6, 1, 7, 3, 2, 4]}
      ];
      for (var t in tests) {
        final a0 = t['a'];
        final b0 = t['b'];
        final name = t['name'] == null ? '$a0 => $b0' : t['name'];

        final testFn = t['solo'] == true ? solo_test : test;

        testFn(name, () {
          final a = ee(0, gen(a0));
          final b = ee(0, gen(b0));
          checkInnerHtmlEquals(a, b);
        });
      }
    });

    group('Null children', () {
      test('Add item', () {
        final a = ee(0, null);
        final b = ee(0, gen([1]));
        checkInnerHtmlEquals(a, b);
      });

      test('Add two items', () {
        final a = ee(0, null);
        final b = ee(0, gen([1, 2]));
        checkInnerHtmlEquals(a, b);
      });

      test('Remove item', () {
        final a = ee(0, gen([1]));
        final b = ee(0, null);
        checkInnerHtmlEquals(a, b);
      });

      test('Remove two items', () {
        final a = ee(0, gen([1, 2]));
        final b = ee(0, null);
        checkInnerHtmlEquals(a, b);
      });
    });
  });

  group('Update children with implicit keys', () {
    group('No modifications', () {
      test('No childrens', () {
        final a = ei();
        final b = ei();
        checkInnerHtmlEquals(a, b);
      });

      test('Same child', () {
        final a = ei(gen([0], false));
        final b = ei(gen([0], false));
        checkInnerHtmlEquals(a, b);
      });

      test('Same children', () {
        final a = ei(gen([0, 1, 2], false));
        final b = ei(gen([0, 1, 2], false));
        checkInnerHtmlEquals(a, b);
      });
    });

    group('Basic inserts', () {
      group('Into empty list', () {
        final a = ee(0, []);

        final tests = [
          {'name': 'One item', 'b': [1]},
          {'name': 'Two items', 'b': [4, 9]},
          {'name': 'Five items', 'b': [9, 3, 6, 1, 0]}
        ];

        for (var t in tests) {
          final testFn = t['solo'] == true ? solo_test : test;
          final name = t['name'] == null ? '[] => ${t['b']}' : t['name'];

          testFn(name, () {
            final b = ee(0, gen(t['b'], false));
            checkInnerHtmlEquals(a, b);
          });
        }
      });

      group('Into one element list', () {
        final a = ee(0, gen([999], false));

        final tests = [
          {'b': [1]},
          {'b': [1, 999]},
          {'b': [999, 1]},
          {'b': [4, 9, 999]},
          {'b': [999, 4, 9]},
          {'b': [9, 3, 6, 1, 0, 999]},
          {'b': [999, 9, 3, 6, 1, 0]},
          {'b': [0, 999, 1]},
          {'b': [0, 3, 999, 1, 4]},
          {'b': [0, 999, 1, 4, 5]}
        ];

        for (var t in tests) {
          final testFn = t['solo'] == true ? solo_test : test;
          final name = t['name'] == null ? '[999] => ${t['b']}' : t['name'];

          testFn(name, () {
            final b = ee(0, gen(t['b'], false));

            checkInnerHtmlEquals(a, b);
          });
        }
      });

      group('Into two elements list', () {
        final a = ee(0, gen([998, 999], false));

        final tests = [
          {'b': [1, 998, 999]},
          {'b': [998, 999, 1]},
          {'b': [998, 1, 999]},
          {'b': [1, 2, 998, 999]},
          {'b': [998, 999, 1, 2]},
          {'b': [1, 998, 999, 2]},
          {'b': [1, 998, 2, 999, 3]},
          {'b': [1, 4, 998, 2, 5, 999, 3, 6]},
          {'b': [1, 998, 2, 999]},
          {'b': [998, 1, 999, 2]},
          {'b': [1, 2, 998, 3, 4, 999]},
          {'b': [998, 1, 2, 999, 3, 4]},
          {'b': [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 998, 999]},
          {'b': [998, 999, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9]},
          {'b': [0, 1, 2, 3, 4, 998, 999, 5, 6, 7, 8, 9]},
          {'b': [0, 1, 2, 998, 3, 4, 5, 6, 999, 7, 8, 9]},
          {'b': [0, 1, 2, 3, 4, 998, 5, 6, 7, 8, 9, 999]},
          {'b': [998, 0, 1, 2, 3, 4, 999, 5, 6, 7, 8, 9]}
        ];

        for (var t in tests) {
          final testFn = t['solo'] == true ? solo_test : test;
          final name =
              t['name'] == null ? '[998, 999] => ${t['b']}' : t['name'];

          testFn(name, () {
            final b = ee(0, gen(t['b'], false));
            checkInnerHtmlEquals(a, b);
          });
        }
      });
    });

    group('Basic removes', () {
      group('1 item', () {
        final tests = [
          {'a': [1], 'b': []},
          {'a': [1, 2], 'b': [2]},
          {'a': [1, 2], 'b': [1]},
          {'a': [1, 2, 3], 'b': [2, 3]},
          {'a': [1, 2, 3], 'b': [1, 2]},
          {'a': [1, 2, 3], 'b': [1, 3]},
          {'a': [1, 2, 3, 4, 5], 'b': [2, 3, 4, 5]},
          {'a': [1, 2, 3, 4, 5], 'b': [1, 2, 3, 4]},
          {'a': [1, 2, 3, 4, 5], 'b': [1, 2, 4, 5]}
        ];

        for (var t in tests) {
          final testFn = t['solo'] == true ? solo_test : test;
          final name = t['name'] == null ? '${t['a']} => ${t['b']}' : t['name'];

          testFn(name, () {
            final a = ee(0, gen(t['a'], false));
            final b = ee(0, gen(t['b'], false));
            checkInnerHtmlEquals(a, b);
          });
        }
      });

      group('2 items', () {
        final tests = [
          {'a': [1, 2], 'b': []},
          {'a': [1, 2, 3], 'b': [3]},
          {'a': [1, 2, 3], 'b': [1]},
          {'a': [1, 2, 3, 4], 'b': [3, 4]},
          {'a': [1, 2, 3, 4], 'b': [1, 2]},
          {'a': [1, 2, 3, 4], 'b': [1, 4]},
          {'a': [1, 2, 3, 4, 5, 6], 'b': [2, 3, 4, 5]},
          {'a': [1, 2, 3, 4, 5, 6], 'b': [2, 3, 5, 6]},
          {'a': [1, 2, 3, 4, 5, 6], 'b': [1, 2, 3, 5]},
          {'a': [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 'b': [2, 3, 4, 5, 6, 7, 8, 9]},
          {'a': [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 'b': [0, 1, 2, 3, 4, 5, 6, 7]},
          {'a': [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 'b': [1, 2, 3, 4, 6, 7, 8, 9]},
          {'a': [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 'b': [0, 1, 2, 3, 4, 6, 7, 8]},
          {'a': [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 'b': [0, 1, 2, 4, 6, 7, 8, 9]}
        ];

        for (var t in tests) {
          final testFn = t['solo'] == true ? solo_test : test;
          final name = t['name'] == null ? '${t['a']} => ${t['b']}' : t['name'];

          testFn(name, () {
            final a = ee(0, gen(t['a'], false));
            final b = ee(0, gen(t['b'], false));
            checkInnerHtmlEquals(a, b);
          });
        }
      });
    });

    group('Basic moves', () {
      final tests = [
        {'a': [0, 1], 'b': [1, 0]},
        {'a': [0, 1, 2, 3], 'b': [3, 2, 1, 0]},
        {'a': [0, 1, 2, 3, 4], 'b': [1, 2, 3, 4, 0]},
        {'a': [0, 1, 2, 3, 4], 'b': [4, 0, 1, 2, 3]},
        {'a': [0, 1, 2, 3, 4], 'b': [1, 0, 2, 3, 4]},
        {'a': [0, 1, 2, 3, 4], 'b': [2, 0, 1, 3, 4]},
        {'a': [0, 1, 2, 3, 4], 'b': [0, 1, 4, 2, 3]},
        {'a': [0, 1, 2, 3, 4], 'b': [0, 1, 3, 4, 2]},
        {'a': [0, 1, 2, 3, 4], 'b': [0, 1, 3, 2, 4]},
        {'a': [0, 1, 2, 3, 4, 5, 6], 'b': [2, 1, 0, 3, 4, 5, 6]},
        {'a': [0, 1, 2, 3, 4, 5, 6], 'b': [0, 3, 4, 1, 2, 5, 6]},
        {'a': [0, 1, 2, 3, 4, 5, 6], 'b': [0, 2, 3, 5, 6, 1, 4]},
        {'a': [0, 1, 2, 3, 4, 5, 6], 'b': [0, 1, 5, 3, 2, 4, 6]},
        {
          'a': [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
          'b': [8, 1, 3, 4, 5, 6, 0, 7, 2, 9]
        },
        {
          'a': [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
          'b': [9, 5, 0, 7, 1, 2, 3, 4, 6, 8]
        }
      ];

      for (var t in tests) {
        final a0 = t['a'];
        final b0 = t['b'];
        final name = t['name'] == null ? '$a0 => $b0' : t['name'];

        final testFn = t['solo'] == true ? solo_test : test;

        testFn(name, () {
          final a = ee(0, gen(a0, false));
          final b = ee(0, gen(b0, false));
          checkInnerHtmlEquals(a, b);
        });
      }
    });

    group('Insert and Move', () {
      final tests = [
        {'a': [0, 1], 'b': [2, 1, 0]},
        {'a': [0, 1], 'b': [1, 0, 2]},
        {'a': [0, 1, 2], 'b': [3, 0, 2, 1]},
        {'a': [0, 1, 2], 'b': [0, 2, 1, 3]},
        {'a': [0, 1, 2], 'b': [0, 2, 3, 1]},
        {'a': [0, 1, 2], 'b': [1, 2, 3, 0]},
        {'a': [0, 1, 2, 3, 4], 'b': [5, 4, 3, 2, 1, 0]},
        {'a': [0, 1, 2, 3, 4], 'b': [5, 4, 3, 6, 2, 1, 0]},
        {'a': [0, 1, 2, 3, 4], 'b': [5, 4, 3, 6, 2, 1, 0, 7]}
      ];
      for (var t in tests) {
        final a0 = t['a'];
        final b0 = t['b'];
        final name = t['name'] == null ? '$a0 => $b0' : t['name'];

        final testFn = t['solo'] == true ? solo_test : test;

        testFn(name, () {
          final a = ee(0, gen(a0, false));
          final b = ee(0, gen(b0, false));
          checkInnerHtmlEquals(a, b);
        });
      }
    });

    group('Remove and Move', () {
      final tests = [
        {'a': [0, 1, 2], 'b': [1, 0]},
        {'a': [2, 0, 1], 'b': [1, 0]},
        {'a': [7, 0, 1, 8, 2, 3, 4, 5, 9], 'b': [7, 5, 4, 8, 3, 2, 1, 0]},
        {'a': [7, 0, 1, 8, 2, 3, 4, 5, 9], 'b': [5, 4, 8, 3, 2, 1, 0, 9]},
        {'a': [7, 0, 1, 8, 2, 3, 4, 5, 9], 'b': [7, 5, 4, 3, 2, 1, 0, 9]},
        {'a': [7, 0, 1, 8, 2, 3, 4, 5, 9], 'b': [5, 4, 3, 2, 1, 0, 9]},
        {'a': [7, 0, 1, 8, 2, 3, 4, 5, 9], 'b': [5, 4, 3, 2, 1, 0]}
      ];

      for (var t in tests) {
        final a0 = t['a'];
        final b0 = t['b'];
        final name = t['name'] == null ? '$a0 => $b0' : t['name'];

        final testFn = t['solo'] == true ? solo_test : test;

        testFn(name, () {
          final a = ee(0, gen(a0, false));
          final b = ee(0, gen(b0, false));
          checkInnerHtmlEquals(a, b);
        });
      }
    });

    group('Insert and Remove', () {
      final tests = [
        {'a': [0], 'b': [1]},
        {'a': [0], 'b': [1, 2]},
        {'a': [0, 2], 'b': [1]},
        {'a': [0, 2], 'b': [1, 2]},
        {'a': [0, 2], 'b': [2, 1]},
        {'a': [0, 1, 2], 'b': [3, 4, 5]},
        {'a': [0, 1, 2], 'b': [2, 4, 5]},
        {'a': [0, 1, 2, 3, 4, 5], 'b': [6, 7, 8, 9, 10, 11]},
        {'a': [0, 1, 2, 3, 4, 5], 'b': [6, 1, 7, 3, 4, 8]},
        {'a': [0, 1, 2, 3, 4, 5], 'b': [6, 7, 3, 8]}
      ];

      for (var t in tests) {
        final a0 = t['a'];
        final b0 = t['b'];
        final name = t['name'] == null ? '$a0 => $b0' : t['name'];

        final testFn = t['solo'] == true ? solo_test : test;

        testFn(name, () {
          final a = ee(0, gen(a0, false));
          final b = ee(0, gen(b0, false));
          checkInnerHtmlEquals(a, b);
        });
      }
    });

    group('Insert, Remove and Move', () {
      final tests = [
        {'a': [0, 1, 2], 'b': [3, 2, 1]},
        {'a': [0, 1, 2], 'b': [2, 1, 3]},
        {'a': [1, 2, 0], 'b': [2, 1, 3]},
        {'a': [1, 2, 0], 'b': [3, 2, 1]},
        {'a': [0, 1, 2, 3, 4, 5], 'b': [6, 1, 3, 2, 4, 7]},
        {'a': [0, 1, 2, 3, 4, 5], 'b': [6, 1, 7, 3, 2, 4]},
        {'a': [0, 1, 2, 3, 4, 5], 'b': [6, 7, 3, 2, 4]},
        {'a': [0, 2, 3, 4, 5], 'b': [6, 1, 7, 3, 2, 4]}
      ];
      for (var t in tests) {
        final a0 = t['a'];
        final b0 = t['b'];
        final name = t['name'] == null ? '$a0 => $b0' : t['name'];

        final testFn = t['solo'] == true ? solo_test : test;

        testFn(name, () {
          final a = ee(0, gen(a0, false));
          final b = ee(0, gen(b0, false));
          checkInnerHtmlEquals(a, b);
        });
      }
    });

    group('Modified children', () {
      final tests = [
        {'a': [[0, [0]]], 'b': [0]},
        {'a': [0, 1, [2, [0]]], 'b': [2]},
        {'a': [0], 'b': [1, 2, [0, [0]]]},
        {'a': [0, [1, [0, 1]], 2], 'b': [3, 2, [1, [1, 0]]]},
        {'a': [0, [1, [0, 1]], 2], 'b': [2, [1, [1, 0]], 3]},
        {
          'a': [[1, [0, 1]], [2, [0, 1]], 0],
          'b': [[2, [1, 0]], [1, [1, 0]], 3]
        },
        {'a': [[1, [0, 1]], 2, 0], 'b': [3, [2, [1, 0]], 1]},
        {'a': [0, 1, 2, [3, [1, 0]], 4, 5], 'b': [6, [1, [0, 1]], 3, 2, 4, 7]},
        {
          'a': [0, 1, 2, 3, 4, 5],
          'b': [6, [1, [1]], 7, [3, [1]], [2, [1]], [4, [1]]]
        },
        {'a': [0, 1, [2, [0]], 3, [4, [0]], 5], 'b': [6, 7, 3, 2, 4]},
        {'a': [0, [2, [0]], [3, [0]], [4, [0]], 5], 'b': [6, 1, 7, 3, 2, 4]}
      ];
      for (var t in tests) {
        final a0 = t['a'];
        final b0 = t['b'];
        final name = t['name'] == null ? '$a0 => $b0' : t['name'];

        final testFn = t['solo'] == true ? solo_test : test;

        testFn(name, () {
          final a = ee(0, gen(a0, false));
          final b = ee(0, gen(b0, false));
          checkInnerHtmlEquals(a, b);
        });
      }
    });

    group('Null children', () {
      test('Add item', () {
        final a = ee(0, null);
        final b = ee(0, gen([1], false));
        checkInnerHtmlEquals(a, b);
      });

      test('Add two items', () {
        final a = ee(0, null);
        final b = ee(0, gen([1, 2], false));
        checkInnerHtmlEquals(a, b);
      });

      test('Remove item', () {
        final a = ee(0, gen([1], false));
        final b = ee(0, null);
        checkInnerHtmlEquals(a, b);
      });

      test('Remove two items', () {
        final a = ee(0, gen([1, 2], false));
        final b = ee(0, null);
        checkInnerHtmlEquals(a, b);
      });
    });

    group('Different Types', () {
      test('[span] => [div]', () {
        final a = ve('div')([ve('span')]);
        final b = ve('div')([ve('div')]);
        checkInnerHtmlEquals(a, b);
      });

      test('[span][div] => [div][span]', () {
        final a = ve('div')([ve('span'), ve('div')]);
        final b = ve('div')([ve('div'), ve('span')]);
        checkInnerHtmlEquals(a, b);
      });

      test('[div] => [span][div]', () {
        final a = ve('div')([ve('div')]);
        final b = ve('div')([ve('span'), ve('div')]);
        checkInnerHtmlEquals(a, b);
      });

      test('[div] => [div][span]', () {
        final a = ve('div')([ve('div')]);
        final b = ve('div')([ve('div'), ve('span')]);
        checkInnerHtmlEquals(a, b);
      });

      test('[div][span] => [div]', () {
        final a = ve('div')([ve('div'), ve('span')]);
        final b = ve('div')([ve('div')]);
        checkInnerHtmlEquals(a, b);
      });

      test('[div][span] => [span]', () {
        final a = ve('div')([ve('div'), ve('span')]);
        final b = ve('div')([ve('span')]);
        checkInnerHtmlEquals(a, b);
      });

      test('[h1][h2][h3][h4][h5] => [h5][h4][h3][h2][h1]', () {
        final a = ve('div')([ve('h1'), ve('h2'), ve('h3'), ve('h4'), ve('h5')]);
        final b = ve('div')([ve('h5'), ve('h4'), ve('h3'), ve('h2'), ve('h1')]);
        checkInnerHtmlEquals(a, b);
      });

      test('[h1][h3][h3][h3][h5] => [h5][h3][h3][h3][h1]', () {
        final a = ve('div')([ve('h1'), ve('h3'), ve('h3'), ve('h3'), ve('h5')]);
        final b = ve('div')([ve('h5'), ve('h3'), ve('h3'), ve('h3'), ve('h1')]);
        checkInnerHtmlEquals(a, b);
      });

      test('[h1][h3][h3][h3][h5] => [h5][h3][h3][h1]', () {
        final a = ve('div')([ve('h1'), ve('h3'), ve('h3'), ve('h3'), ve('h5')]);
        final b = ve('div')([ve('h5'), ve('h3'), ve('h3'), ve('h1')]);
        checkInnerHtmlEquals(a, b);
      });

      test('[h1][h3][h3][h5] => [h5][h3][h3][h3][h1]', () {
        final a = ve('div')([ve('h1'), ve('h3'), ve('h3'), ve('h5')]);
        final b = ve('div')([ve('h5'), ve('h3'), ve('h3'), ve('h3'), ve('h1')]);
        checkInnerHtmlEquals(a, b);
      });
    });
  });

  group('Update Attributes', () {
    test('null => null', () {
      final f = new html.DocumentFragment();
      final a = ve('div');
      final b = ve('div');
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).attributes.isEmpty, isTrue);
    });

    test('null => {}', () {
      final f = new html.DocumentFragment();
      final a = ve('div');
      final b = ve('div', attrs: {});
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).attributes.isEmpty, isTrue);
    });

    test('{} => null', () {
      final f = new html.DocumentFragment();
      final a = ve('div', attrs: {});
      final b = ve('div');
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).attributes.isEmpty, isTrue);
    });

    test('{} => {}', () {
      final f = new html.DocumentFragment();
      final a = ve('div', attrs: {});
      final b = ve('div', attrs: {});
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).attributes.isEmpty, isTrue);
    });

    test('null => {a: 1}', () {
      final f = new html.DocumentFragment();
      final a = ve('div');
      final b = ve('div', attrs: {'a': '1'});
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).attributes.isNotEmpty, isTrue);
      expect((f.firstChild as html.Element).attributes.length, 1);
      expect((f.firstChild as html.Element).attributes['a'], equals('1'));
    });

    test('{} => {a: 1}', () {
      final f = new html.DocumentFragment();
      final a = ve('div', attrs: {});
      final b = ve('div', attrs: {'a': '1'});
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).attributes.isNotEmpty, isTrue);
      expect((f.firstChild as html.Element).attributes.length, 1);
      expect((f.firstChild as html.Element).attributes['a'], equals('1'));
    });

    test('{} => {a: 1, b: 2}', () {
      final f = new html.DocumentFragment();
      final a = ve('div', attrs: {});
      final b = ve('div', attrs: {'a': '1', 'b': '2'});
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).attributes.isNotEmpty, isTrue);
      expect((f.firstChild as html.Element).attributes.length, 2);
      expect((f.firstChild as html.Element).attributes['a'], equals('1'));
      expect((f.firstChild as html.Element).attributes['b'], equals('2'));
    });

    test('{} => {a: 1, b: 2, c: 3}', () {
      final f = new html.DocumentFragment();
      final a = ve('div', attrs: {});
      final b = ve('div', attrs: {'a': '1', 'b': '2', 'c': '3'});
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).attributes.isNotEmpty, isTrue);
      expect((f.firstChild as html.Element).attributes.length, 3);
      expect((f.firstChild as html.Element).attributes['a'], equals('1'));
      expect((f.firstChild as html.Element).attributes['b'], equals('2'));
      expect((f.firstChild as html.Element).attributes['c'], equals('3'));
    });

    test('{a: 1} => null', () {
      final f = new html.DocumentFragment();
      final a = ve('div', attrs: {'a': '1'});
      final b = ve('div');
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).attributes.isEmpty, isTrue);
    });

    test('{a: 1} => {}', () {
      final f = new html.DocumentFragment();
      final a = ve('div', attrs: {'a': '1'});
      final b = ve('div', attrs: {});
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).attributes.isEmpty, isTrue);
    });

    test('{a: 1, b: 2} => {}', () {
      final f = new html.DocumentFragment();
      final a = ve('div', attrs: {'a': '1', 'b': '2'});
      final b = ve('div', attrs: {});
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).attributes.isEmpty, isTrue);
    });

    test('{a: 1} => {b: 2}', () {
      final f = new html.DocumentFragment();
      final a = ve('div', attrs: {'a': '1'});
      final b = ve('div', attrs: {'b': '2'});
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).attributes.isNotEmpty, isTrue);
      expect((f.firstChild as html.Element).attributes.length, 1);
      expect((f.firstChild as html.Element).attributes['b'], equals('2'));
    });

    test('{a: 1, b: 2} => {c: 3, d: 4}', () {
      final f = new html.DocumentFragment();
      final a = ve('div', attrs: {'a': '1', 'b': '2'});
      final b = ve('div', attrs: {'c': '3', 'd': '4'});
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).attributes.isNotEmpty, isTrue);
      expect((f.firstChild as html.Element).attributes.length, 2);
      expect((f.firstChild as html.Element).attributes['c'], equals('3'));
      expect((f.firstChild as html.Element).attributes['d'], equals('4'));
    });

    test('{a: 1} => {a: 10}', () {
      final f = new html.DocumentFragment();
      final a = ve('div', attrs: {'a': '1'});
      final b = ve('div', attrs: {'a': '10'});
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).attributes.isNotEmpty, isTrue);
      expect((f.firstChild as html.Element).attributes.length, 1);
      expect((f.firstChild as html.Element).attributes['a'], equals('10'));
    });

    test('{a: 1, b: 2} => {a: 10, b: 20}', () {
      final f = new html.DocumentFragment();
      final a = ve('div', attrs: {'a': '1', 'b': '2'});
      final b = ve('div', attrs: {'a': '10', 'b': '20'});
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).attributes.isNotEmpty, isTrue);
      expect((f.firstChild as html.Element).attributes.length, 2);
      expect((f.firstChild as html.Element).attributes['a'], equals('10'));
      expect((f.firstChild as html.Element).attributes['b'], equals('20'));
    });
  });

  group('Update Style', () {
    test('null => null', () {
      final f = new html.DocumentFragment();
      final a = ve('div');
      final b = ve('div');
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).style.cssText, isEmpty);
    });

    test('null => {}', () {
      final f = new html.DocumentFragment();
      final a = ve('div');
      final b = ve('div', style: {});
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).style.cssText, isEmpty);
    });

    test('{} => null', () {
      final f = new html.DocumentFragment();
      final a = ve('div', style: {});
      final b = ve('div');
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).style.cssText, isEmpty);
    });

    test('{} => {}', () {
      final f = new html.DocumentFragment();
      final a = ve('div', style: {});
      final b = ve('div', style: {});
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).style.cssText, isEmpty);
    });

    test('null => {top: 10px}', () {
      final f = new html.DocumentFragment();
      final a = ve('div');
      final b = ve('div', style: {'top': '10px'});
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).style.top, equals('10px'));
    });

    test('{} => {top: 10px}', () {
      final f = new html.DocumentFragment();
      final a = ve('div', style: {});
      final b = ve('div', style: {'top': '10px'});
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).style.top, equals('10px'));
    });

    test('{} => {top: 10px, left: 20px}', () {
      final f = new html.DocumentFragment();
      final a = ve('div', style: {});
      final b = ve('div', style: {'top': '10px', 'left': '20px'});
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).style.top, equals('10px'));
      expect((f.firstChild as html.Element).style.left, equals('20px'));
    });

    test('{top: 10px} => null', () {
      final f = new html.DocumentFragment();
      final a = ve('div', style: {'top': '10px'});
      final b = ve('div');
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).style.top, equals(''));
    });

    test('{top: 10px} => {}', () {
      final f = new html.DocumentFragment();
      final a = ve('div', style: {'top': '10px'});
      final b = ve('div', style: {});
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).style.top, equals(''));
    });

    test('{top: 10px, left: 20px} => {}', () {
      final f = new html.DocumentFragment();
      final a = ve('div', style: {'top': '10px', 'left': '20px'});
      final b = ve('div', style: {});
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).style.top, equals(''));
      expect((f.firstChild as html.Element).style.left, equals(''));
    });

    test('{top: 10px} => {left: 20px}', () {
      final f = new html.DocumentFragment();
      final a = ve('div', style: {'top': '10px'});
      final b = ve('div', style: {'left': '20px'});
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).style.top, equals(''));
      expect((f.firstChild as html.Element).style.left, equals('20px'));
    });

    test('{top: 10px, left: 20px} => {right: 30px, bottom: 40px}', () {
      final f = new html.DocumentFragment();
      final a = ve('div', style: {'top': '10px', 'left': '20px'});
      final b = ve('div', style: {'right': '30px', 'bottom': '40px'});
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).style.top, equals(''));
      expect((f.firstChild as html.Element).style.left, equals(''));
      expect((f.firstChild as html.Element).style.right, equals('30px'));
      expect((f.firstChild as html.Element).style.bottom, equals('40px'));
    });

    test('{top: 10px} => {top: 100px}', () {
      final f = new html.DocumentFragment();
      final a = ve('div', style: {'top': '10px'});
      final b = ve('div', style: {'top': '100px'});
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).style.top, equals('100px'));
    });

    test('{top: 10px, left: 20px} => {top: 100px, left: 200px}', () {
      final f = new html.DocumentFragment();
      final a = ve('div', style: {'top': '10px', 'left': '20px'});
      final b = ve('div', style: {'top': '100px', 'left': '200px'});
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).style.top, equals('100px'));
    });
  });

  group('Update Classes', () {
    test('null => null', () {
      final f = new html.DocumentFragment();
      final a = ve('div');
      final b = ve('div');
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).classes, isEmpty);
    });

    test('null => []', () {
      final f = new html.DocumentFragment();
      final a = ve('div');
      final b = ve('div', classes: []);
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).classes, isEmpty);
    });

    test('[] => null', () {
      final f = new html.DocumentFragment();
      final a = ve('div', classes: []);
      final b = ve('div');
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).classes, isEmpty);
    });

    test('[] => []', () {
      final f = new html.DocumentFragment();
      final a = ve('div', classes: []);
      final b = ve('div', classes: []);
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).classes, isEmpty);
    });

    test('null => [1]', () {
      final f = new html.DocumentFragment();
      final a = ve('div');
      final b = ve('div', classes: ['1']);
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).classes.length, equals(1));
      expect((f.firstChild as html.Element).classes.contains('1'), isTrue);
    });

    test('[] => [1]', () {
      final f = new html.DocumentFragment();
      final a = ve('div', classes: []);
      final b = ve('div', classes: ['1']);
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).classes.length, equals(1));
      expect((f.firstChild as html.Element).classes.contains('1'), isTrue);
    });

    test('[] => [1, 2]', () {
      final f = new html.DocumentFragment();
      final a = ve('div', classes: []);
      final b = ve('div', classes: ['1', '2']);
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).classes.length, equals(2));
      expect((f.firstChild as html.Element).classes.contains('1'), isTrue);
      expect((f.firstChild as html.Element).classes.contains('2'), isTrue);
    });

    test('[1] => null', () {
      final f = new html.DocumentFragment();
      final a = ve('div', classes: ['1']);
      final b = ve('div');
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).classes, isEmpty);
    });

    test('[1] => []', () {
      final f = new html.DocumentFragment();
      final a = ve('div', classes: ['1']);
      final b = ve('div', classes: []);
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).classes, isEmpty);
    });

    test('[1, 2] => []', () {
      final f = new html.DocumentFragment();
      final a = ve('div', classes: ['1', '2']);
      final b = ve('div', classes: []);
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).classes, isEmpty);
    });

    test('[1, 2] => [10, 20]', () {
      final f = new html.DocumentFragment();
      final a = ve('div', classes: ['1', '2']);
      final b = ve('div', classes: ['10', '20']);
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).classes.length, equals(2));
      expect((f.firstChild as html.Element).classes.contains('10'), isTrue);
      expect((f.firstChild as html.Element).classes.contains('20'), isTrue);
    });

    test('[1, 2] => [20, 10]', () {
      final f = new html.DocumentFragment();
      final a = ve('div', classes: ['1', '2']);
      final b = ve('div', classes: ['20', '10']);
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).classes.length, equals(2));
      expect((f.firstChild as html.Element).classes.contains('10'), isTrue);
      expect((f.firstChild as html.Element).classes.contains('20'), isTrue);
    });

    test('[1, 2] => [20, 10, 1]', () {
      final f = new html.DocumentFragment();
      final a = ve('div', classes: ['1', '2']);
      final b = ve('div', classes: ['20', '10', '1']);
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).classes.length, equals(3));
      expect((f.firstChild as html.Element).classes.contains('10'), isTrue);
      expect((f.firstChild as html.Element).classes.contains('20'), isTrue);
      expect((f.firstChild as html.Element).classes.contains('1'), isTrue);
    });

    test('[1, 2, 3, 4, 5] => [10, 20, 30, 40, 50]', () {
      final f = new html.DocumentFragment();
      final a = ve('div', classes: ['1', '2', '3', '4', '5']);
      final b = ve('div', classes: ['10', '20', '30', '40', '50']);
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).classes.length, equals(5));
      expect((f.firstChild as html.Element).classes.contains('10'), isTrue);
      expect((f.firstChild as html.Element).classes.contains('20'), isTrue);
      expect((f.firstChild as html.Element).classes.contains('30'), isTrue);
      expect((f.firstChild as html.Element).classes.contains('40'), isTrue);
      expect((f.firstChild as html.Element).classes.contains('50'), isTrue);
    });

    test('[1, 2, 3, 4, 5] => [10, 20, 30, 40, 50, 1]', () {
      final f = new html.DocumentFragment();
      final a = ve('div', classes: ['1', '2', '3', '4', '5']);
      final b = ve('div', classes: ['10', '20', '30', '40', '50', '1']);
      injectVNodeSync(a, f);
      a.update(b, const VContext(true));
      expect((f.firstChild as html.Element).classes.length, equals(6));
      expect((f.firstChild as html.Element).classes.contains('10'), isTrue);
      expect((f.firstChild as html.Element).classes.contains('20'), isTrue);
      expect((f.firstChild as html.Element).classes.contains('30'), isTrue);
      expect((f.firstChild as html.Element).classes.contains('40'), isTrue);
      expect((f.firstChild as html.Element).classes.contains('50'), isTrue);
      expect((f.firstChild as html.Element).classes.contains('1'), isTrue);
    });
  });

  group('To Html String', () {
    group(('Basic nodes'), () {
      test('simple text', () {
        final b = new StringBuffer();
        vText('Hello Test').writeHtmlString(b);
        expect(b.toString(), equals('Hello Test'));
      });

      test('div element', () {
        final b = new StringBuffer();
        ve('div').writeHtmlString(b);
        expect(b.toString(), equals('<div></div>'));
      });

      test('span element', () {
        final b = new StringBuffer();
        ve('span').writeHtmlString(b);
        expect(b.toString(), equals('<span></span>'));
      });

      test('span element with text', () {
        final b = new StringBuffer();
        ve('span')('test').writeHtmlString(b);
        expect(b.toString(), equals('<span>test</span>'));
      });

      test('div element with 2 children', () {
        final b = new StringBuffer();
        ve('div')([ve('span'), ve('img')]).writeHtmlString(b);
        expect(b.toString(), equals('<div><span></span><img></img></div>'));
      });
    });

    group(('Attributes'), () {
      test('{}', () {
        final b = new StringBuffer();
        ve('div', attrs: {}).writeHtmlString(b);
        expect(b.toString(), equals('<div></div>'));
      });

      test('{a: 1}', () {
        final b = new StringBuffer();
        ve('div', attrs: {'a': '1'}).writeHtmlString(b);
        expect(b.toString(), equals('<div a="1"></div>'));
      });

      test('{a: 1, b: 2, c: 3}', () {
        final b = new StringBuffer();
        ve('div', attrs: {'a': '1', 'b': '2', 'c': '3'}).writeHtmlString(b);
        expect(b.toString(), equals('<div a="1" b="2" c="3"></div>'));
      });
    });

    group(('Style'), () {
      test('{}', () {
        final b = new StringBuffer();
        ve('div', style: {}).writeHtmlString(b);
        expect(b.toString(), equals('<div></div>'));
      });

      test('{top: 10px}', () {
        final b = new StringBuffer();
        ve('div', style: {'top': '10px'}).writeHtmlString(b);
        expect(b.toString(), equals('<div style="top: 10px;"></div>'));
      });

      test('{top: 10px, left: 20px, right: 30px}', () {
        final b = new StringBuffer();
        ve('div', style: {'top': '10px', 'left': '20px', 'right': '30px'}).writeHtmlString(b);
        expect(b.toString(), equals('<div style="top: 10px;left: 20px;right: 30px;"></div>'));
      });
    });

    group(('Type'), () {
      test('a', () {
        final b = new StringBuffer();
        ve('div', type: 'a').writeHtmlString(b);
        expect(b.toString(), equals('<div class="a"></div>'));
      });

      test('a []', () {
        final b = new StringBuffer();
        ve('div', type: 'a', classes: []).writeHtmlString(b);
        expect(b.toString(), equals('<div class="a"></div>'));
      });

      test('a [b, c]', () {
        final b = new StringBuffer();
        ve('div', type: 'a', classes: ['b', 'c']).writeHtmlString(b);
        expect(b.toString(), equals('<div class="a b c"></div>'));
      });
    });

    group(('Classes'), () {
      test('[]', () {
        final b = new StringBuffer();
        ve('div', classes: []).writeHtmlString(b);
        expect(b.toString(), equals('<div></div>'));
      });

      test('[a]', () {
        final b = new StringBuffer();
        ve('div', classes: ['a']).writeHtmlString(b);
        expect(b.toString(), equals('<div class="a"></div>'));
      });

      test('[a, b, c]', () {
        final b = new StringBuffer();
        ve('div', classes: ['a', 'b', 'c']).writeHtmlString(b);
        expect(b.toString(), equals('<div class="a b c"></div>'));
      });
    });
  });
}
