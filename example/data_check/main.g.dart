// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-24T18:08:39.260Z

part of uix.example.timer.main;

// **************************************************************************
// Generator: UixGenerator
// Target: class CounterProps
// **************************************************************************

abstract class _CounterPropsShallowEqOperator {
  int get value;
  bool operator ==(CounterProps other) =>
      (identical(this, other) || ((value == other.value)));
}

// **************************************************************************
// Generator: UixGenerator
// Target: class Counter
// **************************************************************************

Counter createCounter([CounterProps data, Component parent]) {
  return new Counter()
    ..parent = parent
    ..data = data
    ..init();
}
VNode vCounter({CounterProps data, Object key, String type,
    Map<String, String> attrs, Map<String, String> style, List<String> classes,
    List<VNode> children}) => new VNode.component(createCounter,
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

Main createMain([dynamic data, Component parent]) {
  return new Main()
    ..parent = parent
    ..data = data
    ..init();
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
