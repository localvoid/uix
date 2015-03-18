# uix

Library to build User Interfaces in [Dart](https://dartlang.org).

## Quick Start

Requirements:

 - Dart SDK 1.9 or greater

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

#### 4. Add `build.dart` file:

```dart
library build_file;

import 'package:source_gen/source_gen.dart';
import 'package:uix/generator.dart';

void main(List<String> args) {
  build(args, const [
    const ShallowEqGenerator(),
    const ComponentGenerator()
  ], librarySearchPaths: ['web']).then((msg) {
    print(msg);
  });
}
```

## Examples

- [Hello](https://github.com/localvoid/uix/tree/master/example/hello)
- [Timer](https://github.com/localvoid/uix/tree/master/example/timer)
- [Collapsable](https://github.com/localvoid/uix/tree/master/example/collapsable)
- [Form](https://github.com/localvoid/uix/tree/master/example/form)
- [State Diff](https://github.com/localvoid/uix/tree/master/example/state_diff)
- [TodoMVC](https://github.com/localvoid/uix_todomvc/)

## DBMonster Benchmark

[Run](http://localvoid.github.io/uix_dbmon/)

