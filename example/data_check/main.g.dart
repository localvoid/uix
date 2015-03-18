// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-18T13:08:28.838Z

part of uix.example.timer.main;

// **************************************************************************
// Generator: UixGenerator
// Target: class CounterProps
// **************************************************************************

abstract class _CounterPropsShallowEqOperator {
  int get value;
  const _CounterPropsShallowEqOperator();
  bool operator ==(CounterProps other) =>
      (identical(this, other) || ((value == other.value)));
}

// **************************************************************************
// Generator: UixGenerator
// Target: class Counter
// **************************************************************************

Counter createCounter([CounterProps data]) {
  final r = new Counter()..data = data;
  return r;
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

Main createMain([dynamic data]) {
  final r = new Main()..data = data;
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
