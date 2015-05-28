// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.src.vdom.vnode;

import 'dart:collection';
import 'dart:html' as html;
import 'anchor.dart';
import 'namespace.dart';
import 'attr.dart';
import 'style.dart';
import '../assert.dart';
import '../container.dart';
import '../component.dart';

/// Virtual DOM Node.
class VNode {
  /// Flag indicating that VNode is [html.Text].
  static const int textFlag = 1;
  /// Flag indicating that VNode is [html.Element].
  static const int elementFlag = 1 << 1;
  /// Flag indicating that VNode is [Component].
  static const int componentFlag = 1 << 2;
  /// Flag indicating that VNode is a root element of the [Component].
  static const int rootFlag = 1 << 3;
  /// Flag indicating that VNode represents node that is in svg namespace.
  static const int svgFlag = 1 << 4;
  /// Flag indicating that children lifecycle is controlled by [Container].
  static const int contentFlag = 1 << 5;

  /// Flags.
  final int flags;

  /// Key that should be unique among its siblings. If the key is `null`,
  /// it means that the key is implicit.
  /// When key is implicit, all siblings should also have implicit keys,
  /// otherwise it will result in undefined behaviour in "production" mode,
  /// or runtime error in "development" mode.
  final Object key;

  /// Tag should contain tag name if VNode represents an element, or
  /// reference to the [componentConstructor] if it represents a
  /// [Component].
  final dynamic/*<String | componentConstructor>*/ tag;

  /// Data that should be passed to [Component]s. Data is transferred to the
  /// [Component] using `set data(P data)` setter.
  ///
  /// When VNode represents an element, [data] is used as a cache for
  /// className string that was built from [type] and [classes] properties.
  dynamic data;

  /// Type represents an immutable class name. It is also used as an
  /// additional rule for finding similar nodes when all children
  /// have implicit keys.
  String type;

  /// Attributes.
  Map<int, dynamic> attrs;

  /// Custom Attributes.
  Map<String, String> customAttrs;

  /// Styles.
  Map<int, String> style;

  /// Classes.
  List<String> classes;

  /// List of children nodes. When VNode represents a [Component], children
  /// nodes are transferred to the [Component] using
  /// `set children(List<VNode> children)` setter.
  List<VNode> children;

  Anchor anchor;

  /// Reference to the [html.Node]. It will be available after VNode is
  /// [create]d or [update]d. Each time VNode is updated, reference to the
  /// [html.Node] is passed from the previous node to the new one.
  html.Node ref;

  /// Reference to the [CDescriptor]. It will be available after VNode is
  /// [create]d or [update]d. Each time [VNode] is updated, reference to the
  /// [CDescriptor] is passed from the previous node to the new one.
  CNode cdref;

  /// Reference to the [Component].
  Component get cref => cdref.component;

  VNode(this.flags, {this.key, this.tag, this.data, this.type, this.attrs, this.customAttrs,
        this.style, this.classes, this.children, this.anchor});

  VNode.text(this.data, {this.key})
      : flags = textFlag,
        tag = null;

  VNode.element(this.tag, {this.key, this.type, this.attrs, this.customAttrs,
      this.style, this.classes, this.children, this.anchor, bool content: false})
      : flags = content ? elementFlag | contentFlag
                        : elementFlag;

  VNode.svgElement(this.tag, {this.key, this.type, this.attrs, this.customAttrs,
      this.style, this.classes, this.children, this.anchor, bool content: false})
      : flags = content ? elementFlag | svgFlag | contentFlag
                        : elementFlag | svgFlag;

  VNode.component(this.tag, {this.flags: componentFlag, this.key, this.data,
      this.type, this.attrs, this.customAttrs, this.style, this.classes,
      this.children, this.anchor});

  VNode.root({this.type, this.attrs, this.customAttrs, this.style, this.classes,
      this.children, bool content: false})
      : flags = content ? rootFlag | contentFlag
                        : rootFlag,
        key = null, tag = null;

  /// Helper method for children assignment using call operator.
  ///
  /// ```dart
  /// vElement('div')([vElement('span'), vElement('span')]);
  /// ```
  VNode call(c) {
    if (c is List) {
      children = c;
    } else if (c is Iterable) {
      children = c.toList();
    } else if (c is String) {
      children = [new VNode.text(c)];
    } else {
      children = [c];
    }
    return this;
  }

  /// Check if VNodes have the same type.
  ///
  /// VNode can be updated only when it have the same type as [other] VNode.
  bool _sameType(VNode other) => (flags == other.flags && tag == other.tag && type == other.type);

  /// Create root level element of the VNode object, or [Component] for
  /// component nodes.
  void create(CNode owner) {
    assert(anchor == null || anchor.isEmpty);

    if ((flags & textFlag) != 0) {
      ref = new html.Text(data);
    } else if ((flags & elementFlag) != 0) {
      if ((flags & svgFlag) == 0) {
        ref = html.document.createElement(tag);
      } else {
        ref = html.document.createElementNS(svgNamespace, tag);
      }
    } else if ((flags & componentFlag) != 0) {
      final Component c = (tag as componentConstructor)();
      cdref = c.descriptor;
      cdref.parent = owner;
      c.data = data;
      c.children = children;
      c.create();
      c.init();
      ref = c.element;
    }
  }

  /// Mount VNode on top of the existing html [node].
  void mount(html.Node node, CNode parent) {
    assert(invariant(node != null, 'Cannot mount on top of null Node'));

    ref = node;
    if (anchor != null) {
      anchor.node = this;
    }

    if ((flags & componentFlag) != 0) {
      final Component c = (tag as componentConstructor)();
      cdref = c.descriptor;
      cdref.parent = parent;
      c.data = data;
      c.children = children;
      c.mount(node);
      c.init();
    } else {
      if ((flags & elementFlag) != 0) {
        String className = type;
        if (classes != null) {
          final classesString = classes.join(' ');
          className = className == null ? classesString : className + ' ' + classesString;
        }
        if (className != null) {
          data = className;
        }
      }
      if (children != null && children.length > 0) {
        html.Node child = node.childNodes.first;
        for (int i = 0; i < children.length; i++) {
          children[i].mount(child, parent);
          child = child.nextNode;
        }
      }
    }
    attached();
  }

  /// Render internal representation of the VNode.
  void render(CNode parent) {
    if ((flags & (elementFlag | componentFlag | rootFlag)) != 0) {
      final html.Element r = ref;

      if (attrs != null) {
        attrs.forEach((int k, v) {
          if (v != null) {
            _setAttr(k, v);
          }
        });
      }

      if (customAttrs != null) {
        customAttrs.forEach((String k, String v) {
          if (v != null) {
            r.setAttribute(k, v);
          }
        });
      }

      if (style != null) {
        final html.CssStyleDeclaration refStyle = r.style;
        style.forEach((int k, String v) {
          if (v != null) {
            refStyle.setProperty(StyleInfo.fromId[k].name, v);
          }
        });
      }

      if ((flags & (elementFlag | componentFlag)) != 0) {
        String className = type;
        if (classes != null) {
          final classesString = classes.join(' ');
          className = className == null ? classesString : className + ' ' + classesString;
        }
        if (className != null) {
          if ((flags & elementFlag) != 0) {
            data = className;
          }
          r.className = className;
        }
      } else {
//        html.DomTokenList classList;
        html.CssClassSet classList;

        if (type != null) {
//          classList = r.classList;
          classList = r.classes;
          classList.add(type);
        }

        if (classes != null) {
          if (classList == null) {
//            classList = r.classList;
            classList = r.classes;
          }
          for (var i = 0; i < classes.length; i++) {
            classList.add(classes[i]);
          }
        }

//        if ((flags & componentFlag) != 0) {
//          cdref.update();
//        }
      }

      if ((flags & componentFlag) == 0) {
        if (children != null) {
          assert(() {
            if (children.isNotEmpty) {
              final key = children[0].key;
              for (var i = 1; i < children.length; i++) {
                if ((key == null && children[i].key != null) ||
                (key != null && children[i].key == null)) {
                  throw
                  'All children inside of the Virtual DOM Node should have '
                  'either explicit, or implicit keys.\n'
                  'Child at position 0 has key $key\n'
                  'Child at position $i has key ${children[i].key}\n'
                  'Children: $children';
                }
              }
            }
            return true;
          }());

          for (int i = 0; i < children.length; i++) {
            _insertChild(children[i], null, parent);
          }
        }
      }
    }
  }

  /// Perform a diff and patch between `this` VNode and [other].
  void update(VNode other, CNode parent) {
    assert(invariant(_sameType(other), 'VNode objects with different types cannot be updated.'));
    assert(invariant(other.ref == null || identical(ref, other.ref), 'VNode objects cannot be reused.'));
    assert(invariant(key == other.key, 'VNode objects with different keys cannot be updated.'));

    other.ref = ref;
    if (other.anchor != null) {
      other.anchor.node = this;
    }
    if ((flags & textFlag) != 0) {
      if (data != other.data) {
        ref.text = other.data;
      }
    } else if ((flags & (elementFlag | componentFlag | rootFlag)) != 0) {
      final html.Element r = ref;

      if (!identical(attrs, other.attrs)) {
        updateAttrs(attrs, other.attrs, this);
      }

      if (!identical(customAttrs, other.customAttrs)) {
        updateCustomAttrs(customAttrs, other.customAttrs, this);
      }

      if (!identical(style, other.style)) {
        updateStyle(style, other.style, r.style);
      }

      if ((flags & elementFlag) != 0) {
        if (!identical(classes, other.classes)) {
          if (other.data == null) {
            String className = other.type;
            if (other.classes != null) {
              final classesString = other.classes.join(' ');
              className = className == null ? classesString : className + ' ' + classesString;
            }
            other.data = className;
          }
          if ((data as String) != (other.data as String)) {
            if (other.data == null) {
              r.className = '';
            } else {
              r.className = (other.data as String);
            }
          }
        } else {
          other.data = data;
        }
      } else if (!identical(classes, other.classes)) {
//        updateClasses(classes, other.classes, r.classList);
        updateClasses(classes, other.classes, r.classes);
      }

      if ((flags & componentFlag) != 0) {
        other.cdref = cdref;
        cdref.component.data = other.data;
        cdref.component.children = other.children;
//        cdref.update();
      } else {
        if (!identical(children, other.children)) {
          updateChildren(this, children, other.children, parent);
        }
      }
    }
  }

  void _insertChild(VNode node, VNode next, CNode parent) {
    if ((flags & contentFlag) == 0) {
      final nextRef = next == null ? null : next.ref;
      if (node.anchor == null || node.anchor.isEmpty) {
        node.create(parent);
        ref.insertBefore(node.ref, nextRef);
        node.attached();
        node.render(parent);
        if (node.anchor != null) {
          node.anchor.node = node;
        }
      } else {
        ref.insertBefore(node.anchor.node.ref, nextRef);
        node.anchor.node.update(node, parent);
        if (!node.anchor.attached) {
          node.attach();
        }
      }
    } else {
      (parent as Container).insertChild(this, node, next);
    }
  }

  void _moveChild(VNode node, VNode next, CNode parent) {
    if ((flags & contentFlag) == 0) {
      final nextRef = next == null ? null : next.ref;
      ref.insertBefore(node.ref, nextRef);
    } else {
      (parent as Container).moveChild(this, node, next);
    }
  }

  void _removeChild(VNode node, CNode parent) {
    if ((flags & contentFlag) == 0) {
      if (node.anchor == null) {
        node.ref.remove();
        node.dispose();
      } else if (identical(node.anchor.node, node)) {
        node.ref.remove();
        node.detach();
      }
    } else {
      (parent as Container).removeChild(this, node);
    }
  }

  void _updateChild(VNode aNode, VNode bNode, CNode parent) {
    if ((flags & contentFlag) == 0) {
      aNode.update(bNode, parent);
    } else {
      (parent as Container).updateChild(this, aNode, bNode);
    }
  }

  void dispose() {
    if ((flags & componentFlag) != 0) {
      cdref.dispose();
    } else if (children != null) {
      for (var i = 0; i < children.length; i++) {
        children[i].dispose();
      }
    }
  }

  void attach() {
    attached();
    if (((flags & componentFlag) == 0) && (children != null)) {
      for (var i = 0; i < children.length; i++) {
        children[i].attach();
      }
    }
  }

  void detach() {
    if (((flags & componentFlag) == 0) && (children != null)) {
      for (var i = 0; i < children.length; i++) {
        children[i].detach();
      }
    }
    detached();
  }

  void attached() {
    if (anchor != null) {
      anchor.attached = true;
    }
    if ((flags & componentFlag) != 0) {
      cdref.attach();
    }
  }

  void detached() {
    if (anchor != null) {
      anchor.attached = false;
    }
    if ((flags & componentFlag) != 0) {
      cdref.detach();
    }
  }

  String toHtmlString() {
    final b = new StringBuffer();
    writeHtmlString(b);
    return b.toString();
  }

  void writeHtmlString(StringBuffer b) {
    if ((flags & textFlag) != 0) {
      b.write(data as String);
    } else if ((flags & elementFlag) != 0) {
      b.write('<$tag');
      if (attrs != null) {
        writeAttrsToHtmlString(b, attrs);
      }
      if (customAttrs != null) {
        writeCustomAttrsToHtmlString(b, customAttrs);
      }
      if (type != null || (classes != null && classes.isNotEmpty)) {
        b.write(' class="');
        if (type != null) {
          b.write(type);
        }
        if (classes != null && classes.isNotEmpty) {
          if (type != null) {
            b.write(' ');
          }
          writeClassesToHtmlString(b, classes);
        }
        b.write('"');
      }
      if (style != null && style.isNotEmpty) {
        b.write(' style="');
        writeStyleToHtmlString(b, style);
        b.write('"');
      }
      b.write('>');
      if (children != null) {
        for (var i = 0; i < children.length; i++) {
          children[i].writeHtmlString(b);
        }
      }
      b.write('</$tag>');
    } else if ((flags & componentFlag) != 0) {
      return cdref.component.writeHtmlString(b, this);
    }
  }

  void _setAttr(int k, v) {
    final html.Element r = ref;
    final AttrInfo a = AttrInfo.fromId[k];
    String sval;
    if ((a.flags & AttrInfo.boolValueFlag) != 0) {
      if (v) {
        sval = '';
      }
    } else if ((a.flags & AttrInfo.numValueFlag != 0)) {
      sval = v.toString();
    } else {
      sval = v;
    }
    if (sval != null) {
      if ((a.flags & AttrInfo.namespaceFlag) == 0) {
        r.setAttribute(a.name, sval);
      } else {
        r.setAttributeNS(a.namespace, a.name, sval);
      }
    }
  }
}

/// Perform a diff/patch on children [a] and [b].
///
/// Mixing children with explicit and implicit keys will result in undefined
/// behaviour in "production" mode, and runtime error in "development" mode.
void updateChildren(VNode parent, List<VNode> a, List<VNode> b, CNode owner) {
  if (a != null && a.isNotEmpty) {
    if (b == null || b.isEmpty) {
      // when [b] is empty, it means that all children from list [a] were
      // removed
      for (int i = 0; i < a.length; i++) {
        parent._removeChild(a[i], owner);
      }
    } else {
      if (a.length == 1 && b.length == 1) {
        // fast path when [a] and [b] have just 1 child
        //
        // if both lists have child with the same key, then just diff them,
        // otherwise return patch with [a] child removed and [b] child
        // inserted
        final VNode aNode = a.first;
        final VNode bNode = b.first;

        assert(invariant(
            (aNode.key == null && bNode.key == null) ||
            (aNode.key != null && bNode.key != null), () =>
            'All children inside of the Virtual DOM Node should have '
            'either explicit, or implicit keys.\n'
            'Child at position old:0 has key ${aNode.key}\n'
            'Child at position new:0 has key ${bNode.key}\n'
            'Old children: $a\n'
            'New children: $b'));

        if ((aNode.key == null && aNode._sameType(bNode)) ||
            aNode.key != null && aNode.key == bNode.key) {
          parent._updateChild(aNode, bNode, owner);
        } else {
          parent._removeChild(aNode, owner);
          parent._insertChild(bNode, null, owner);
        }
      } else if (a.length == 1) {
        // fast path when [a] have 1 child
        final aNode = a.first;

        int i = 0;
        bool updated = false;

        if (aNode.key == null) {
          assert(() {
            for (var i = 0; i < b.length; i++) {
              if (b[i].key != null) {
                throw
                'All children inside of the Virtual DOM Node should have '
                'either explicit, or implicit keys.\n'
                'Child at position old:0 has implicit key\n'
                'Child at position new:$i has explicit key ${b[i].key}\n'
                'Old children: $a\n'
                'New children: $b';
              }
            }
            return true;
          }());

          while (i < b.length) {
            final VNode bNode = b[i++];
            if (aNode._sameType(bNode)) {
              parent._updateChild(aNode, bNode, owner);
              updated = true;
              break;
            }
            parent._insertChild(bNode, aNode, owner);
          }
        } else {
          assert(() {
            for (var i = 0; i < b.length; i++) {
              if (b[i].key == null) {
                throw
                'All children inside of the Virtual DOM Node should have '
                'either explicit, or implicit keys.\n'
                'Child at position old:0 has explicit key ${aNode.key}\n'
                'Child at position new:$i has implicit key\n'
                'Old children: $a\n'
                'New children: $b';
              }
            }
            return true;
          }());

          while (i < b.length) {
            final VNode bNode = b[i++];
            if (aNode.key == bNode.key) {
              parent._updateChild(aNode, bNode, owner);
              updated = true;
              break;
            }
            parent._insertChild(bNode, aNode, owner);
          }
        }

        if (updated) {
          while (i < b.length) {
            parent._insertChild(b[i++], null, owner);
          }
        } else {
          parent._removeChild(aNode, owner);
        }
      } else if (b.length == 1) {
        // fast path when [b] have 1 child
        final bNode = b.first;

        int i = 0;
        bool updated = false;

        if (bNode.key == null) {
          assert(() {
            for (var i = 0; i < a.length; i++) {
              if (a[i].key != null) {
                throw
                'All children inside of the Virtual DOM Node should have '
                'either explicit, or implicit keys.\n'
                'Child at position old:$i has explicit key ${a[i].key}\n'
                'Child at position new:0 has implicit key\n'
                'Old children: $a\n'
                'New children: $b';
              }
            }
            return true;
          }());

          while (i < a.length) {
            final VNode aNode = a[i++];
            if (aNode._sameType(bNode)) {
              parent._updateChild(aNode, bNode, owner);
              updated = true;
              break;
            }
            parent._removeChild(aNode, owner);
          }
        } else {
          assert(() {
            for (var i = 0; i < a.length; i++) {
              if (a[i].key == null) {
                throw
                'All children inside of the Virtual DOM Node should have '
                'either explicit, or implicit keys.\n'
                'Child at position old:$i has implicit key\n'
                'Child at position new:0 has explicit key ${bNode.key}\n'
                'Old children: $a\n'
                'New children: $b';
              }
            }
            return true;
          }());

          while (i < a.length) {
            final VNode aNode = a[i++];
            if (aNode.key == bNode.key) {
              parent._updateChild(aNode, bNode, owner);
              updated = true;
              break;
            }
            parent._removeChild(aNode, owner);
          }
        }
        if (updated) {
          while (i < a.length) {
            parent._removeChild(a[i++], owner);
          }
        } else {
          parent._insertChild(bNode, null, owner);
        }
      } else {
        // both [a] and [b] have more then 1 child, so we should handle
        // more complex situations with inserting/removing and repositioning
        // children.
        assert(() {
          final aKey = a[0].key;
          for (var i = 0; i < b.length; i++) {
            if ((aKey == null && b[i].key != null) ||
            (aKey != null && b[i].key == null)) {
              throw
              'All children inside of the Virtual DOM Node should have '
              'either explicit, or implicit keys.\n'
              'Child at position old:0 has key $aKey\n'
              'Child at position new:$i has key ${b[i].key}\n'
              'Old children: $a\n'
              'New children: $b';
            }
          }
          return true;
        }());

        if (a.first.key == null) {
          _updateImplicitChildren(parent, a, b, owner);
        } else {
          _updateExplicitChildren(parent, a, b, owner);
        }
      }
    }
  } else if (b != null && b.length > 0) {
    // all children from list [b] were inserted
    for (int i = 0; i < b.length; i++) {
      parent._insertChild(b[i], null, owner);
    }
  }
}

/// Update children with implicit keys.
///
/// Any heuristics that is used in this algorithm is an undefined behaviour,
/// external code should not rely on the knowledge of this algorithm, because
/// it can be changed in any time.
void _updateImplicitChildren(VNode parent, List<VNode> a, List<VNode> b, CNode owner) {
  int aStart = 0;
  int bStart = 0;
  int aEnd = a.length - 1;
  int bEnd = b.length - 1;

  // Update nodes with the same type at the beginning.
  while (aStart <= aEnd && bStart <= bEnd) {
    final aNode = a[aStart];
    final bNode = b[bStart];

    if (!aNode._sameType(bNode)) {
      break;
    }

    aStart++;
    bStart++;

    parent._updateChild(aNode, bNode, owner);
  }

  // Update nodes with the same type at the end.
  while (aStart <= aEnd && bStart <= bEnd) {
    final aNode = a[aEnd];
    final bNode = b[bEnd];

    if (!aNode._sameType(bNode)) {
      break;
    }

    aEnd--;
    bEnd--;

    parent._updateChild(aNode, bNode, owner);
  }

  // Iterate through the remaining nodes and if they have the same
  // type, then update, otherwise just remove the old node and insert
  // the new one.
  while (aStart <= aEnd && bStart <= bEnd) {
    final aNode = a[aStart++];
    final bNode = b[bStart++];
    if (aNode._sameType(bNode)) {
      parent._updateChild(aNode, bNode, owner);
    } else {
      parent._insertChild(bNode, aNode, owner);
      parent._removeChild(aNode, owner);
    }
  }

  // All nodes from [a] are updated, insert the rest from [b].
  while (aStart <= aEnd) {
    parent._removeChild(a[aStart++], owner);
  }

  final nextPos = bEnd + 1;
  final next = nextPos < b.length ? b[nextPos].ref : null;

  // All nodes from [b] are updated, remove the rest from [a].
  while (bStart <= bEnd) {
    parent._insertChild(b[bStart++], next, owner);
  }
}

/// Update children with explicit keys.
void _updateExplicitChildren(VNode parent, List<VNode> a, List<VNode> b, CNode owner) {
  int aStart = 0;
  int bStart = 0;
  int aEnd = a.length - 1;
  int bEnd = b.length - 1;

  var aStartNode = a[aStart];
  var bStartNode = b[bStart];
  var aEndNode = a[aEnd];
  var bEndNode = b[bEnd];

  bool stop = false;

  // Algorithm that works on simple cases with basic list
  // transformations.
  //
  // It tries to reduce the diff problem by simultaneously iterating
  // from the beginning and the end of both lists, if keys are the
  // same, they're updated, if node is moved from the beginning to the
  // end of the current cursor positions or vice versa it just
  // performs move operation and continues to reduce the diff problem.
  outer: do {
    stop = true;

    // Update nodes with the same key at the beginning.
    while (aStartNode.key == bStartNode.key) {
      parent._updateChild(aStartNode, bStartNode, owner);

      aStart++;
      bStart++;
      if (aStart > aEnd || bStart > bEnd) {
        break outer;
      }

      aStartNode = a[aStart];
      bStartNode = b[bStart];

      stop = false;
    }

    // Update nodes with the same key at the end.
    while (aEndNode.key == bEndNode.key) {
      parent._updateChild(aEndNode, bEndNode, owner);

      aEnd--;
      bEnd--;
      if (aStart > aEnd || bStart > bEnd) {
        break outer;
      }

      aEndNode = a[aEnd];
      bEndNode = b[bEnd];

      stop = false;
    }

    // Move nodes from left to right.
    while (aStartNode.key == bEndNode.key) {
      parent._updateChild(aStartNode, bEndNode, owner);

      final nextPos = bEnd + 1;
      final next = nextPos < b.length ? b[nextPos] : null;
      parent._moveChild(bEndNode, next, owner);

      aStart++;
      bEnd--;
      if (aStart > aEnd || bStart > bEnd) {
        break outer;
      }

      aStartNode = a[aStart];
      bEndNode = b[bEnd];

      stop = false;
      continue outer;
    }

    // Move nodes from right to left.
    while (aEndNode.key == bStartNode.key) {
      parent._updateChild(aEndNode, bStartNode, owner);

      parent._moveChild(aEndNode, a[aStart], owner);

      aEnd--;
      bStart++;
      if (aStart > aEnd || bStart > bEnd) {
        break outer;
      }

      aEndNode = a[aEnd];
      bStartNode = b[bStart];

      stop = false;
    }
  } while (!stop && aStart <= aEnd && bStart <= bEnd);

  if (aStart > aEnd) {
    // All nodes from [a] are updated, insert the rest from [b].
    final nextPos = bEnd + 1;
    final next = nextPos < b.length ? b[nextPos] : null;
    while (bStart <= bEnd) {
      parent._insertChild(b[bStart++], next, owner);
    }
  } else if (bStart > bEnd) {
    // All nodes from [b] are updated, remove the rest from [a].
    while (aStart <= aEnd) {
      parent._removeChild(a[aStart++], owner);
    }
  } else {
    // Perform more complex update algorithm on the remaining nodes.
    //
    // We start by marking all nodes from [b] as inserted, then we try
    // to find all removed nodes and simultaneously perform updates on
    // the nodes that exists in both lists and replacing "inserted"
    // marks with the position of the node from the list [b] in list [a].
    // Then we just need to perform slightly modified LIS algorithm,
    // that ignores "inserted" marks and find common subsequence and
    // move all nodes that doesn't belong to this subsequence, or
    // insert if they have "inserted" mark.
    final aLength = aEnd - aStart + 1;
    final bLength = bEnd - bStart + 1;

    // -1 value means that it should be inserted.
    final sources = new List<int>.filled(bLength, -1);

    var moved = false;
    var removeOffset = 0;

    // when both lists are small, we are using naive O(M*N) algorithm to
    // find removed children.
    if (aLength * bLength <= 16) {
      var lastTarget = 0;

      for (var i = aStart; i <= aEnd; i++) {
        bool removed = true;
        final aNode = a[i];

        for (var j = bStart; j <= bEnd; j++) {
          final bNode = b[j];
          if (aNode.key == bNode.key) {
            sources[j - bStart] = i;

            if (lastTarget > j) {
              moved = true;
            } else {
              lastTarget = j;
            }

            parent._updateChild(aNode, bNode, owner);

            removed = false;
            break;
          }
        }

        if (removed) {
          parent._removeChild(aNode, owner);
          removeOffset++;
        }
      }
    } else {
      final keyIndex = new HashMap<Object, int>();
      var lastTarget = 0;

      for (var i = bStart; i <= bEnd; i++) {
        final node = b[i];
        keyIndex[node.key] = i;
      }

      for (var i = aStart; i <= aEnd; i++) {
        final aNode = a[i];
        final j = keyIndex[aNode.key];
        if (j != null) {
          final bNode = b[j];
          sources[j - bStart] = i;

          if (lastTarget > j) {
            moved = true;
          } else {
            lastTarget = j;
          }

          parent._updateChild(aNode, bNode, owner);
        } else {
          parent._removeChild(aNode, owner);
          removeOffset++;
        }
      }
    }

    if (moved) {
      final seq = _lis(sources);
      var j = seq.length - 1;

      // All modifications are performed from right to left, so we
      // can use insertBefore method and use reference to the html
      // element from the next VNode. All Nodes on the right side
      // should be in the correct state.
      for (var i = bLength - 1; i >= 0; i--) {
        if (sources[i] == -1) {
          final pos = i + bStart;
          final node = b[pos];
          final nextPos = pos + 1;
          final next = nextPos < b.length ? b[nextPos] : null;
          parent._insertChild(node, next, owner);
        } else {
          if (j < 0 || i != seq[j]) {
            final pos = i + bStart;
            final node = a[sources[i]];
            final nextPos = pos + 1;
            final next = nextPos < b.length ? b[nextPos] : null;
            parent._moveChild(node, next, owner);
          } else {
            j--;
          }
        }
      }
    } else if (aLength - removeOffset != bLength) {
      for (var i = bLength - 1; i >= 0; i--) {
        if (sources[i] == -1) {
          final pos = i + bStart;
          final node = b[pos];
          final nextPos = pos + 1;
          final next = nextPos < b.length ? b[nextPos] : null;
          parent._insertChild(node, next, owner);
        }
      }
    }
  }
}

/// Algorithm that finds longest increasing subsequence. With one little
/// modification that it ignores items with -1 value, they're representing
/// items that doesn't exist in the old list.
///
/// It is used to find minimum number of move operations in children list.
///
/// http://en.wikipedia.org/wiki/Longest_increasing_subsequence
List<int> _lis(List<int> a) {
  final p = new List<int>.from(a, growable: false);
  final result = [0];

  for (var i = 0; i < a.length; i++) {
    if (a[i] == -1) {
      continue;
    }
    if (a[result.last] < a[i]) {
      p[i] = result.last;
      result.add(i);
      continue;
    }

    var u = 0;
    var v = result.length - 1;
    while (u < v) {
      int c = (u + v) ~/ 2;

      if (a[result[c]] < a[i]) {
        u = c + 1;
      } else {
        v = c;
      }
    }

    if (a[i] < a[result[u]]) {
      if (u > 0) {
        p[i] = result[u - 1];
      }

      result[u] = i;
    }
  }
  var u = result.length;
  var v = result.last;

  while (u-- > 0) {
    result[u] = v;
    v = p[v];
  }

  return result;
}

/// Find changes between maps [a] and [b] and apply this changes to CssStyleDeclaration [n].
void updateStyle(Map<int, String> a, Map<int, String> b, html.CssStyleDeclaration style) {
  assert(style != null);

  if (a != null && a.length > 0) {
    if (b == null || b.length == 0) {
      // all keys removed
      for (final int i in a.keys) {
        style.removeProperty(StyleInfo.fromId[i].name);
      }
    } else {
      // find all modified and removed
      a.forEach((int key, String value) {
        final bValue = b[key];
        if (value != bValue) {
          final String styleName = StyleInfo.fromId[key].name;
          if (bValue == null) {
            style.removeProperty(styleName);
          } else {
            style.setProperty(styleName, bValue);
          }
        }
      });

      // find all inserted
      b.forEach((int key, String value) {
        if (!a.containsKey(key)) {
          style.setProperty(StyleInfo.fromId[key].name, value);
        }
      });
    }
  } else if (b != null && b.length > 0) {
    // all keys inserted
    b.forEach((int key, String value) {
      style.setProperty(StyleInfo.fromId[key].name, value);
    });
  }
}

/// Find changes between maps [a] and [b] and apply this changes to [n].
void updateAttrs(Map<int, dynamic> a, Map<int, dynamic> b, VNode n) {
  assert(n != null);
  final html.Element r = n.ref;
  final Map attrs = r.attributes;

  if (a != null && a.length > 0) {
    if (b == null || b.length == 0) {
      // all keys removed
      for (final k in a.keys) {
        attrs.remove(AttrInfo.fromId[k].name);
      }
    } else {
      // find all modified and removed
      a.forEach((int key, value) {
        final bValue = b[key];
        if (value != bValue) {
          final AttrInfo a = AttrInfo.fromId[key];
          if (bValue == null) {
            attrs.remove(a.name);
          } else {
            String sval;
            if ((a.flags & AttrInfo.boolValueFlag) != 0) {
              if (bValue) {
                sval = '';
              }
            } else if ((a.flags & AttrInfo.numValueFlag != 0)) {
              sval = bValue.toString();
            } else {
              sval = bValue;
            }
            if (sval == null) {
              attrs.remove(a.name);
            } else {
              if ((a.flags & AttrInfo.namespaceFlag) == 0) {
                r.setAttribute(a.name, sval);
              } else {
                r.setAttributeNS(a.namespace, a.name, sval);
              }
            }
          }
        }
      });

      // find all inserted
      b.forEach((key, value) {
        if (!a.containsKey(key)) {
          if (value != null) {
            n._setAttr(key, value);
          }
        }
      });
    }
  } else if (b != null && b.length > 0) {
    // all keys inserted
    b.forEach((key, value) {
      if (value != null) {
        n._setAttr(key, value);
      }
    });
  }
}

/// Find changes between maps [a] and [b] and apply this changes to [n].
void updateCustomAttrs(Map<String, String> a, Map<String, String> b, VNode n) {
  assert(n != null);
  final html.Element r = n.ref;
  final Map attrs = r.attributes;

  if (a != null && a.length > 0) {
    if (b == null || b.length == 0) {
      // all keys removed
      for (final k in a.keys) {
        attrs.remove(k);
      }
    } else {
      // find all modified and removed
      a.forEach((String key, String value) {
        final bValue = b[key];
        if (value != bValue) {
          if (bValue == null) {
            attrs.remove(key);
          } else {
            r.setAttribute(key, bValue);
          }
        }
      });

      // find all inserted
      b.forEach((key, value) {
        if (!a.containsKey(key)) {
          if (value != null) {
            r.setAttribute(key, value);
          }
        }
      });
    }
  } else if (b != null && b.length > 0) {
    // all keys inserted
    b.forEach((key, value) {
      if (value != null) {
        r.setAttribute(key, value);
      }
    });
  }
}

/// Find changes between Lists [a] and [b] and apply this changes to
/// [classList].
// TODO: https://code.google.com/p/dart/issues/detail?id=23012
//void updateClasses(List<String> a, List<String> b, html.DomTokenList classList) {
void updateClasses(List<String> a, List<String> b, html.CssClassSet classList) {
  assert(classList != null);

  if (a != null && a.length != 0) {
    if (b == null || b.length == 0) {
      for (int i = 0; i < a.length; i++) {
        classList.remove(a[i]);
      }
    } else {
      if (a.length == 1 && b.length == 1) {
        final String aItem = a[0];
        final String bItem = b[0];
        if (aItem != bItem) {
          classList.remove(aItem);
          classList.add(bItem);
        }
      } else if (a.length == 1) {
        final String aItem = a[0];
        bool found = false;
        int i = 0;
        while (i < b.length) {
          final String bItem = b[i++];
          if (aItem == bItem) {
            found = true;
            break;
          } else {
            classList.add(bItem);
          }
        }
        if (found) {
          while (i < b.length) {
            classList.add(b[i++]);
          }
        } else {
          classList.remove(aItem);
        }
      } else if (b.length == 1) {
        final String bItem = b[0];
        bool found = false;
        int i = 0;
        while (i < a.length) {
          final String aItem = a[i++];
          if (aItem == bItem) {
            found = true;
            break;
          } else {
            classList.remove(aItem);
          }
        }
        if (found) {
          while (i < a.length) {
            classList.remove(a[i++]);
          }
        } else {
          classList.add(bItem);
        }
      } else {
        int aStart = 0;
        int bStart = 0;
        int aEnd = a.length - 1;
        int bEnd = b.length - 1;

        while (aStart <= aEnd && bStart <= bEnd) {
          if (a[aStart] != b[bStart]) {
            break;
          }
          aStart++;
          bStart++;
        }
        while (aStart <= aEnd && bStart <= bEnd) {
          if (a[aEnd] != b[bEnd]) {
            break;
          }
          aEnd--;
          bEnd--;
        }

        final int aLength = aEnd - aStart + 1;
        final int bLength = bEnd - bStart + 1;

        if (aLength * bLength <= 16) {
          final List<bool> visited = new List<bool>(bLength);

          for (int i = aStart; i <= aEnd; i++) {
            final String aItem = a[i];
            bool removed = true;

            for (int j = bStart; j <= bEnd; j++) {
              final String bItem = b[j];

              if (aItem == bItem) {
                removed = false;
                visited[j - bStart] = true;
                break;
              }
            }
            if (removed) {
              classList.remove(aItem);
            }
          }
          for (int i = bStart; i <= bEnd; i++) {
            if (visited[i - bStart] != true) {
              classList.add(b[i]);
            }
          }
        } else {
          final HashMap<String, bool> bIndex = new HashMap<String, bool>();

          for (int i = bStart; i <= bEnd; i++) {
            bIndex[b[i]] = false;
          }

          for (int i = aStart; i <= aEnd; i++) {
            final String aItem = a[i];

            if (!bIndex.containsKey(aItem)) {
              classList.remove(aItem);
            } else {
              bIndex[aItem] = true;
            }
          }

          bIndex.forEach((k, v) {
            if (v == false) {
              classList.add(k);
            }
          });
        }
      }
    }
  } else if (b != null && b.length > 0) {
    for (int i = 0; i < b.length; i++) {
      classList.add(b[i]);
    }
  }
}

void writeAttrsToHtmlString(StringBuffer b, Map<int, dynamic> attrs) {
  attrs.forEach((int k, v) {
    final String key = AttrInfo.fromId[k].name;
    b.write(' $key="$v"');
  });
}

void writeCustomAttrsToHtmlString(StringBuffer b, Map<String, String> attrs) {
  attrs.forEach((String k, String v) {
    b.write(' $k="$v"');
  });
}

void writeStyleToHtmlString(StringBuffer b, Map<int, String> attrs) {
  attrs.forEach((int k, String v) {
    b.write('${StyleInfo.fromId[k].name}: $v;');
  });
}

void writeClassesToHtmlString(StringBuffer b, List<String> classes) {
  b.write(classes.first);
  for (var i = 1; i < classes.length; i++) {
    b.write(' ');
    b.write(classes[i]);
  }
}
