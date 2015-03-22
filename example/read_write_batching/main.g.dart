// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-22T11:06:34.552Z

part of uix.example.read_write_batching.main;

// **************************************************************************
// Generator: UixGenerator
// Target: class OuterBox
// **************************************************************************

OuterBox createOuterBox([dynamic data, Component parent]) {
  final r = new OuterBox()
    ..parent = parent
    ..data = data;
  r.init();
  return r;
}
VNode vOuterBox({dynamic data, Object key, String type,
    Map<String, String> attrs, Map<String, String> style, List<String> classes,
    List<VNode> children}) => new VNode.component(createOuterBox,
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
// Target: class InnerBox
// **************************************************************************

InnerBox createInnerBox([dynamic data, Component parent]) {
  final r = new InnerBox()
    ..parent = parent
    ..data = data;
  r.init();
  return r;
}
VNode vInnerBox({dynamic data, Object key, String type,
    Map<String, String> attrs, Map<String, String> style, List<String> classes,
    List<VNode> children}) => new VNode.component(createInnerBox,
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
// Target: class Box
// **************************************************************************

Box createBox([dynamic data, Component parent]) {
  final r = new Box()
    ..parent = parent
    ..data = data;
  r.init();
  return r;
}
VNode vBox({dynamic data, Object key, String type, Map<String, String> attrs,
    Map<String, String> style, List<String> classes,
    List<VNode> children}) => new VNode.component(createBox,
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
