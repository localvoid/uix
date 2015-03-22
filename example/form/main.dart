// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.example.form.main;

import 'dart:html' as html;
import 'package:uix/uix.dart';
import 'package:uix/forms.dart';

part 'main.g.dart';

@ComponentMeta()
class Main extends Component {
  String username = '';
  String password = '';
  String email = '';
  bool checked = false;

  init() {
    element.onInput
      ..matches('.UserNameInput').listen((e) {
        username = e.matchingTarget.value;
        invalidate();
      })
      ..matches('.EmailInput').listen((e) {
        email = e.matchingTarget.value;
        invalidate();
      })
      ..matches('.PasswordInput').listen((e) {
        password = e.matchingTarget.value;
        invalidate();
      });

    element.onChange.matches('.CheckedInput').listen((e) {
      checked = e.matchingTarget.checked;
      invalidate();
    });
  }

  updateView() {
    updateRoot(vRoot()([
      vElement('section', type: 'DisplaySection')([
        vElement('div')('Username: $username'),
        vElement('div')('Email: $email'),
        vElement('div')('Password: $password'),
        vElement('div')('Checked: $checked')
      ]),
      vElement('section', type: 'FormSection')([
        vTextInput(data: username, type: 'UserNameInput', attrs: const {'type': 'text', 'placeholder': 'Username'}),
        vTextInput(data: email, type: 'EmailInput', attrs: const {'type': 'email', 'placeholder': 'Email'}),
        vTextInput(data: password, type: 'PasswordInput', attrs: const {'type': 'password', 'placeholder': 'Password'}),
        vCheckedInput(data: checked, type: 'CheckedInput', attrs: const {'type': 'checkbox'})
      ])
    ]));
  }
}

main() {
  initUix();

  injectComponent(createMain(), html.document.body);
}
