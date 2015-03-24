// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-24T08:00:56.219Z

part of uix.example.state_diff.main;

// **************************************************************************
// Generator: UixGenerator
// Target: class CounterView
// **************************************************************************

CounterView createCounterView([dynamic data, Component parent]) {
  return new CounterView()
    ..parent = parent
    ..data = data
    ..init();
}
VNode vCounterView({dynamic data, Object key, String type,
    Map<String, String> attrs, Map<String, String> style, List<String> classes,
    List<VNode> children}) => new VNode.component(createCounterView,
    flags: VNode.componentFlag | VNode.dirtyCheckFlag,
    key: key,
    data: data,
    type: type,
    attrs: attrs,
    style: style,
    classes: classes,
    children: children);
