// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-18T12:13:03.764Z

part of uix.example.state_diff.main;

// **************************************************************************
// Generator: UixGenerator
// Target: class CounterView
// **************************************************************************

CounterView createCounterView([dynamic data]) {
  final r = new CounterView()..data = data;
  return r;
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
