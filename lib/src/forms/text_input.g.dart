// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-24T08:00:56.281Z

part of uix.src.forms.input;

// **************************************************************************
// Generator: UixGenerator
// Target: class TextInput
// **************************************************************************

TextInput createTextInput([String data, Component parent]) {
  return new TextInput()
    ..parent = parent
    ..data = data
    ..init();
}
VNode vTextInput({String data, Object key, String type,
    Map<String, String> attrs, Map<String, String> style, List<String> classes,
    List<VNode> children}) => new VNode.component(createTextInput,
    flags: VNode.componentFlag,
    key: key,
    data: data,
    type: type,
    attrs: attrs,
    style: style,
    classes: classes,
    children: children);
