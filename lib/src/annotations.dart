// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.src.meta;

/// Each Component should have @ComponentMeta() annotation, it is used
/// by source_gen to generate additional code for Components:
///
/// - create${className}([data, children, parent]) - create Component
/// - v${className}(...) - create virtual dom node representing Component
///
class ComponentMeta {
  const ComponentMeta();
}
