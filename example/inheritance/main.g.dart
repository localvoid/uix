// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-24T06:57:26.303Z

part of uix.example.inheritance.main;

// **************************************************************************
// Generator: UixGenerator
// Target: abstract class ButtonBase
// **************************************************************************

ButtonBase createButtonBase([T data, Component parent]) {
  final r = new ButtonBase()
    ..parent = parent
    ..data = data;
  r.init();
  return r;
}
VNode vButtonBase({T data, Object key, String type, Map<String, String> attrs,
    Map<String, String> style, List<String> classes,
    List<VNode> children}) => new VNode.component(createButtonBase,
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
// Target: class Button
// **************************************************************************

Button createButton([ButtonData data, Component parent]) {
  final r = new Button()
    ..parent = parent
    ..data = data;
  r.init();
  return r;
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
  final r = new App()
    ..parent = parent
    ..data = data;
  r.init();
  return r;
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
