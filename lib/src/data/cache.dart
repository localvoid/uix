// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.src.data.cache;

import 'dart:async';
import 'node.dart';

abstract class CacheNode extends RevisionedNode with StreamListenerNode {
  StreamController _onChangeController = new StreamController.broadcast();
  Stream get onChange => _onChangeController.stream;

  bool isDirty = true;

  void invalidate([_]) {
    if (!isDirty) {
      isDirty = true;
      resetSubscriptionsOneShot();
      invalidated();
    }
  }

  void invalidated() {}

  void checkUpdates() {
    if (isDirty) {
      isDirty = false;
      if (update()) {
        updateRev();
      }
    }
  }

  bool update();
}
