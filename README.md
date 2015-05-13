# uix

[![Build Status](https://travis-ci.org/localvoid/uix.svg?branch=master)](https://travis-ci.org/localvoid/uix)
[![Join the chat at https://gitter.im/localvoid/uix](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/localvoid/uix?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Library to build Web User Interfaces in [Dart](https://dartlang.org)
inspired by [React](http://facebook.github.io/react/).

### Virtual DOM

Virtual DOM simplifies the way to manage DOM mutations, just describe
how your Component should look at any point in time.

uix library has a highly optimized virtual dom implementation,
[see benchmarks below](#benchmarks).

### Scheduler

Scheduler is responsible for running tasks that update visual
representation of the Components, and business logic of web app
services.

### Misc

- Automatic management of Dart
[streams](https://www.dartlang.org/docs/tutorials/streams/) with
`addSubscription(StreamSubscription s)`,
`addTransientSubscription(StreamSubscription s)` methods. Transient
subscriptions simplifies the way to manage subscriptions the same way
virtual dom simplifies DOM mutations, just describe which dependencies
should be active at any point in time.

```dart
// Code from TodoMVC[Observable] example

$Entry() => new Entry();
class Entry extends Component<int> {
  updateState() {
    _entry = entryStore.get(data);

    // each time Component is invalidated, old subscription will be
    // automatically canceled, so we just register a new one when
    // something is changed.
    addTransientSubscription(_entry.onChange.listen(invalidate));

    return true;
  }
  ...
}
```

- revisioned nodes for fast "dirty checking" of mutable data
structures. Just update revision when data is changed and check if
view has an older revision, for example:

```dart
class LineView extends Component<RichLine> {
  List<VNode> _fragments;

  set data(RichLine newData) {
    if (identical(data, newData)) {
      if (data.isNewer(this)) {
        invalidate();
      }
    } else {
      data_ = newData;
      invalidate();
    }
  }
  ...
}
```

- Lifecycle control of children virtual nodes to implement complex
  animations. For example:
  [CssTransitionContainer](https://github.com/localvoid/uix_css_transition_container)

- Mount on top of existing html
  document. [Mount example](https://github.com/localvoid/uix/tree/master/example/mount)

- Moving html nodes and components between different parents and
  preserving internal state with Virtual DOM api using `Anchor`
  objects. [Anchor example](https://github.com/localvoid/uix/tree/master/example/anchor)

## Quick Start

Requirements:

 - Dart SDK 1.9.1 or greater

#### 1. Create a new Dart Web Project
#### 2. Add uix library in `pubspec.yaml` file:

```yaml
dependencies:
  uix: any
```

#### 3. Install dependencies

```sh
$ pub get
```

#### 4. Create `web/index.html` file:

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hello uix</title>
  </head>
  <body>
    <script type="application/dart" src="main.dart"></script>
    <script src="packages/browser/dart.js"></script>
  </body>
</html>
```

#### 5. Create `web/main.dart` file:

```dart
library main;

import 'dart:html' as html;
import 'package:uix/uix.dart';

// Function to create new Box instances, it is used as an argument for
// virtual nodes that represent components.
// In the future, when metaclasses will be implemented in Dart, it
// won't be necessary to create this functions. Right now it is just a
// convention that will make it easier to migrate in the future by
// removing '$' prefix in all 'vComponent' invocations.
$Box() => new Box();

// Component<T> type parameter is used to specify type of the input data
// (props in React terms).
class Box extends Component<String> {
  // Tag name of the root element for this Component. Default tag 'div'.
  final tag = 'span';

  // Each time when Component is invalidated (new data is passed,
  // or invalidate() method is called), it will be updated during
  // writeDom phase.
  //
  // API is designed this way intentionally to improve developer
  // experience and get better stack traces when something is
  // failing, that is why there is no method like render() in
  // React.
  updateView() {
    // updateRoot method is used to update internal representation
    // using Virtual DOM API.
    //
    // vRoot node is used to represent root element.
    //
    // Call operator is overloaded for all virtual nodes and is used
    // to assign children, it accepts Lists, Iterables, VNodes and
    // Strings.
    updateRoot(vRoot()(
      vElement('span')(data)
    ));
  }
}

class Main extends Component<String> {
  updateView() {
    updateRoot(vRoot()([
      vElement('span')('Hello '),
      vComponent($Box, data: data)
    ]));
  }
}

main() {
  // Initialize uix library.
  initUix();

  final component = new Main()..data = 'uix';

  // Inject component into document body.
  injectComponent(component, html.document.body);
}
```

## Examples

- [Hello](https://github.com/localvoid/uix/tree/master/example/hello)
- [Timer](https://github.com/localvoid/uix/tree/master/example/timer)
- [Collapsable](https://github.com/localvoid/uix/tree/master/example/collapsable)
- [Form](https://github.com/localvoid/uix_forms/tree/master/example)
- [State Diff](https://github.com/localvoid/uix/tree/master/example/state_diff)
- [Read/Write DOM Batching](https://github.com/localvoid/uix/tree/master/example/read_write_batching)
- [Component Inheritance](https://github.com/localvoid/uix/tree/master/example/inheritance)
- [SVG](https://github.com/localvoid/uix/tree/master/example/svg)
- [Canvas](https://github.com/localvoid/uix/tree/master/example/canvas)
- [Css Transition Container](https://github.com/localvoid/uix_css_transition_container/tree/master/example)
- [TodoMVC (observable)](https://github.com/localvoid/uix_todomvc/)
- [TodoMVC (persistent)](https://github.com/localvoid/uix_todomvc_persistent/)
- [MineSweeper Game](https://github.com/localvoid/uix_minesweeper/)
- [Snake Game](https://github.com/localvoid/uix_snake/)
- [Dual N-Back Game](https://github.com/localvoid/dual_nback/)

## VDom Benchmark
<a name="benchmarks"></a>

- [Run](http://vdom-benchmark.github.io/vdom-benchmark/)

## DBMonster Benchmark

- [Run](http://localvoid.github.io/uix_dbmon/)
- [Run](http://localvoid.github.io/uix_dbmon/classlist2) (compiled with [patched dart-sdk](https://code.google.com/p/dart/issues/detail?id=23012))

## Server-Side rendering

uix library with
[simple tweaks](https://github.com/localvoid/uix_standalone) is fully
capable to render components on the server and mounting on top of the
existing html tree. Unfortunately Dart doesn't support any usable way
to build uix Components this way. There are several proposals for
Configured Imports [1](https://github.com/lrhn/dep-configured-imports)
[2](https://github.com/eernstg/dep-configured-imports)
[3](https://github.com/munificent/dep-external-libraries/blob/master/Proposal.md)
that will solve some problems, but it is still not enough to provide a
good developer experience for users of this library. Conditional
compilation will be way much better to write "isomorphic" Components.
