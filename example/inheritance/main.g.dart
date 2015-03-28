// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-28T10:01:04.722Z

part of uix.example.inheritance.main;

// **************************************************************************
// Generator: UixGenerator
// Target: class Button
// **************************************************************************

Button createButton([ButtonData data, List<VNode> children, Component parent]) {
  return new Button()
    ..parent = parent
    ..data = data
    ..children = children;
}
VNode vButton({ButtonData data, Object key, String type,
    Map<String, String> attrs, Map<String, String> style, List<String> classes,
    List<VNode> children}) => new VNode.component(createButton,
    flags: VNode.componentFlag,
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

App createApp([dynamic data, List<VNode> children, Component parent]) {
  return new App()
    ..parent = parent
    ..data = data
    ..children = children;
}
VNode vApp({dynamic data, Object key, String type, Map<String, String> attrs,
    Map<String, String> style, List<String> classes,
    List<VNode> children}) => new VNode.component(createApp,
    flags: VNode.componentFlag,
    key: key,
    data: data,
    type: type,
    attrs: attrs,
    style: style,
    classes: classes,
    children: children);
