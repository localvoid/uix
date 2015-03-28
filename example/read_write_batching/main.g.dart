// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-28T09:55:09.377Z

part of uix.example.read_write_batching.main;

// **************************************************************************
// Generator: UixGenerator
// Target: class OuterBox
// **************************************************************************

OuterBox createOuterBox(
    [dynamic data, List<VNode> children, Component parent]) {
  return new OuterBox()
    ..parent = parent
    ..data = data
    ..children = children;
}
VNode vOuterBox({dynamic data, Object key, String type,
    Map<String, String> attrs, Map<String, String> style, List<String> classes,
    List<VNode> children}) => new VNode.component(createOuterBox,
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
// Target: class InnerBox
// **************************************************************************

InnerBox createInnerBox(
    [dynamic data, List<VNode> children, Component parent]) {
  return new InnerBox()
    ..parent = parent
    ..data = data
    ..children = children;
}
VNode vInnerBox({dynamic data, Object key, String type,
    Map<String, String> attrs, Map<String, String> style, List<String> classes,
    List<VNode> children}) => new VNode.component(createInnerBox,
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
// Target: class Box
// **************************************************************************

Box createBox([dynamic data, List<VNode> children, Component parent]) {
  return new Box()
    ..parent = parent
    ..data = data
    ..children = children;
}
VNode vBox({dynamic data, Object key, String type, Map<String, String> attrs,
    Map<String, String> style, List<String> classes,
    List<VNode> children}) => new VNode.component(createBox,
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
