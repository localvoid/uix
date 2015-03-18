// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.src.data.node;

import '../env.dart';

abstract class DataNode {
  int rev = 0;

  bool isNewer(DataNode other) => rev > other.rev;
}

abstract class ObservableNode {
  List<ListenerNode> listeners;

  void addListener(ListenerNode n) {
    if (listeners == null) {
      listeners = [];
    }
    listeners.add(n);
  }

  void removeListener(ListenerNode n) {
    if (listeners != null) {
      listeners[listeners.indexOf(n)] = listeners.last;
      listeners.removeLast();
    }
  }

  void invalidateListeners() {
    if (listeners != null) {
      final tmp = listeners;
      listeners = null;
      for (var i = 0; i < tmp.length; i++) {
        tmp[i].invalidate();
      }
    }
  }
}

abstract class ListenerNode {
  List<ObservableNode> dependencies;

  void listen(ObservableNode n) {
    if (dependencies == null) {
      dependencies = [];
    }
    dependencies.add(n);
    n.addListener(this);
  }

  void resetDependencies() {
    if (dependencies != null) {
      for (var i = 0; i < dependencies.length; i++) {
        dependencies[i].removeListener(this);
      }
      dependencies = null;
    }
  }

  void invalidate();
}

abstract class StoreNode extends DataNode with ObservableNode {
  void commit() {
    rev = scheduler.clock;
    invalidateListeners();
  }
}

abstract class CacheNode extends DataNode with ObservableNode, ListenerNode {
  bool isDirty = false;

  void invalidate() {
    if (!isDirty) {
      isDirty = true;

      resetDependencies();
      invalidateListeners();

      invalidated();
    }
  }

  void invalidated() {}
}
