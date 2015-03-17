// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-17T10:03:47.845Z

part of uix.src.forms.input;

// **************************************************************************
// Generator: UixGenerator
// Target: class TextInput
// **************************************************************************

TextInput createTextInput([String data]) {
  final r = new TextInput()..data = data;
  return r;
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
