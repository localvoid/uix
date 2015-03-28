// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-28T09:57:44.507Z

part of uix.example.timer.main;

// **************************************************************************
// Generator: UixGenerator
// Target: class Counter
// **************************************************************************

Counter createCounter(
    [CounterProps data, List<VNode> children, Component parent]) {
  return new Counter()
    ..parent = parent
    ..data = data
    ..children = children;
}
VNode vCounter({CounterProps data, Object key, String type,
    Map<String, String> attrs, Map<String, String> style, List<String> classes,
    List<VNode> children}) => new VNode.component(createCounter,
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
