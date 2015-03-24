// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-24T18:08:58.615Z

part of uix.example.inheritance.main;

// **************************************************************************
// Generator: UixGenerator
// Target: class ButtonBaseData
// **************************************************************************

abstract class _ButtonBaseDataShallowEqOperator {
  bool get disabled;
  bool operator ==(ButtonBaseData other) =>
      (identical(this, other) || ((disabled == other.disabled)));
}

// **************************************************************************
// Generator: UixGenerator
// Target: class ButtonData
// **************************************************************************

abstract class _ButtonDataShallowEqOperator {
  bool get disabled;
  String get color;
  bool operator ==(ButtonData other) => (identical(this, other) ||
      ((disabled == other.disabled) && (color == other.color)));
}

// **************************************************************************
// Generator: UixGenerator
// Target: class Button
// **************************************************************************

Button createButton([ButtonData data, Component parent]) {
  return new Button()
    ..parent = parent
    ..data = data
    ..init();
}
VNode vButton({ButtonData data, Object key, String type,
    Map<String, String> attrs, Map<String, String> style, List<String> classes,
    List<VNode> children}) => new VNode.component(createButton,
    flags: VNode.componentFlag | VNode.dirtyCheckFlag,
    key: key,
    data: data,
    type: type,
    attrs: attrs,
    style: style,
    classes: classes,
    children: children);

// **************************************************************************
// Generator: UixGenerator
// Target: class App
// **************************************************************************

App createApp([dynamic data, Component parent]) {
  return new App()
    ..parent = parent
    ..data = data
    ..init();
}
VNode vApp({dynamic data, Object key, String type, Map<String, String> attrs,
    Map<String, String> style, List<String> classes,
    List<VNode> children}) => new VNode.component(createApp,
    flags: VNode.componentFlag | VNode.dirtyCheckFlag,
    key: key,
    data: data,
    type: type,
    attrs: attrs,
    style: style,
    classes: classes,
    children: children);
