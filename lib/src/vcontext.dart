// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.src.vcontext;

class VContext {
  final bool _isAttached;
  final int _depth = 0;

  bool get isAttached => _isAttached;
  int get depth => _depth;

  const VContext([this._isAttached = false]);
}
