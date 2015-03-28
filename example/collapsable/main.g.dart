// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-28T09:55:09.416Z

part of uix.example.collapsable.main;

// **************************************************************************
// Generator: UixGenerator
// Target: class Collapsable
// **************************************************************************

Collapsable createCollapsable(
    [bool data, List<VNode> children, Component parent]) {
  return new Collapsable()
    ..parent = parent
    ..data = data
    ..children = children;
}
VNode vCollapsable({bool data, Object key, String type,
    Map<String, String> attrs, Map<String, String> style, List<String> classes,
    List<VNode> children}) => new VNode.component(createCollapsable,
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
// Target: class Main
// **************************************************************************

Main createMain([dynamic data, List<VNode> children, Component parent]) {
  return new Main()
    ..parent = parent
    ..data = data
    ..children = children;
}
VNode vMain({dynamic data, Object key, String type, Map<String, String> attrs,
    Map<String, String> style, List<String> classes,
    List<VNode> children}) => new VNode.component(createMain,
    flags: VNode.componentFlag,
    key: key,
    data: data,
    type: type,
    attrs: attrs,
    style: style,
    classes: classes,
    children: children);
