// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.example.canvas.main;

import 'dart:math' as math;
import 'dart:html' as html;
import 'package:uix/uix.dart';

$Canvas() => new Canvas();
class Canvas extends Component {
  final tag = 'canvas';
  html.CanvasRenderingContext2D ctx;
  int width = -1;
  int height = -1;
  html.Point p = const html.Point(0, 0);

  init() {
    ctx = (element as html.CanvasElement).context2D;
    element.onMouseMove.listen(_handleMove);

    addSubscription(html.window.onResize.listen(_handleResize));
  }

  void _handleMove(html.MouseEvent e) {
    p = e.client - element.offset.topLeft;
    invalidate();
  }

  void _handleResize(html.Event e) {
    width = -1;
    height = -1;
    invalidate();
  }

  updateView() async {
    if (width == -1) {
      await scheduler.currentFrame.read();
      width = element.client.width;
      height = element.client.height;
      element.setAttribute('width', width.toString());
      element.setAttribute('height', height.toString());
      await scheduler.currentFrame.write();
    }
    ctx.globalCompositeOperation = 'source-over';
    ctx.fillStyle = 'rgba(0, 0, 0, 1)';
    ctx.fillRect(0, 0, width, height);

    ctx.globalCompositeOperation = 'lighter';
    ctx.beginPath();

    final gradient = ctx.createRadialGradient(p.x, p.y, 0, p.x, p.y, 30);
    gradient.addColorStop(0, 'white');
    gradient.addColorStop(0.4, 'white');
    gradient.addColorStop(0.4, 'red');
    gradient.addColorStop(1, 'black');
    ctx.fillStyle = gradient;

    ctx.arc(p.x, p.y , 30, 0, math.PI*2, false);
    ctx.fill();
  }
}

class App extends Component {
  updateView() {
    updateRoot(vRoot(type: 'App')(vComponent($Canvas, type: 'Canvas')));
  }
}

void main() {
  initUix();

  injectComponent(new App(), html.document.body);
}
