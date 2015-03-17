// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-17T09:43:06.033Z

part of uix.example.hello.main;

// **************************************************************************
// Generator: UixGenerator
// Target: class Main
// **************************************************************************

Main createMain([String data]) {
  final r = new Main()..data = data;
  return r;
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
