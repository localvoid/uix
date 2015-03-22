// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-22T11:06:34.575Z

part of uix.src.forms.check_box;

// **************************************************************************
// Generator: UixGenerator
// Target: class CheckedInput
// **************************************************************************

CheckedInput createCheckedInput([bool data, Component parent]) {
  final r = new CheckedInput()
    ..parent = parent
    ..data = data;
  r.init();
  return r;
}
VNode vCheckedInput({bool data, Object key, String type,
    Map<String, String> attrs, Map<String, String> style, List<String> classes,
    List<VNode> children}) => new VNode.component(createCheckedInput,
    flags: VNode.componentFlag,
    key: key,
    data: data,
    type: type,
    attrs: attrs,
    style: style,
    classes: classes,
    children: children);
