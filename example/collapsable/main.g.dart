// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-17T07:27:38.024Z

part of uix.example.hello.collapsable;

// **************************************************************************
// Generator: UixGenerator
// Target: class Collapsable
// **************************************************************************

Collapsable createCollapsable([bool data]) {
  final r = new Collapsable()..data = data;
  return r;
}
VNode vCollapsable({bool data, Object key, String type,
    Map<String, String> attrs, Map<String, String> style, List<String> classes,
    List<VNode> children}) => new VNode.component(createCollapsable,
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
  return r;
}
VNode vMain({dynamic data, Object key, String type, Map<String, String> attrs,
    Map<String, String> style, List<String> classes,
    List<VNode> children}) => new VNode.component(createMain,
    key: key,
    data: data,
    type: type,
    attrs: attrs,
    style: style,
    classes: classes,
    children: children);
