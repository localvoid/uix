// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-24T08:00:56.036Z

part of uix.example.timer.main;

// **************************************************************************
// Generator: UixGenerator
// Target: class Main
// **************************************************************************

Main createMain([int data, Component parent]) {
  return new Main()
    ..parent = parent
    ..data = data
    ..init();
}
VNode vMain({int data, Object key, String type, Map<String, String> attrs,
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
