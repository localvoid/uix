// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-24T08:00:56.272Z

part of uix.src.forms.check_box;

// **************************************************************************
// Generator: UixGenerator
// Target: class CheckedInput
// **************************************************************************

CheckedInput createCheckedInput([bool data, Component parent]) {
  return new CheckedInput()
    ..parent = parent
    ..data = data
    ..init();
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
