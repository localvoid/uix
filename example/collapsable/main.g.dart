// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-20T09:49:07.613Z

part of uix.example.collapsable.main;

// **************************************************************************
// Generator: UixGenerator
// Target: class Collapsable
// **************************************************************************

Collapsable createCollapsable([bool data]) {
  final r = new Collapsable()..data = data;
  r.init();
  return r;
}
VNode vCollapsable({bool data, Object key, String type,
    Map<String, String> attrs, Map<String, String> style, List<String> classes,
    List<VNode> children}) => new VNode.component(createCollapsable,
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
// Target: class Main
// **************************************************************************

Main createMain([dynamic data]) {
  final r = new Main()..data = data;
  r.init();
  return r;
}
VNode vMain({dynamic data, Object key, String type, Map<String, String> attrs,
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
