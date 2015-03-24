// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-24T08:00:56.080Z

part of uix.example.hello.main;

// **************************************************************************
// Generator: UixGenerator
// Target: class Main
// **************************************************************************

Main createMain([String data, Component parent]) {
  return new Main()
    ..parent = parent
    ..data = data
    ..init();
}
VNode vMain({String data, Object key, String type, Map<String, String> attrs,
    Map<String, String> style, List<String> classes,
    List<VNode> children}) => new VNode.component(createMain,
    flags: VNode.componentFlag | VNode.dirtyCheckFlag,
    key: key,
    data: data,
    type: type,
    attrs: attrs,
    style: style,
    classes: classes,
    children: children);
