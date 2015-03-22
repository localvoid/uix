// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-22T11:30:08.390Z

part of uix.example.form.main;

// **************************************************************************
// Generator: UixGenerator
// Target: class Main
// **************************************************************************

Main createMain([dynamic data, Component parent]) {
  final r = new Main()
    ..parent = parent
    ..data = data;
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
