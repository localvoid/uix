// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.src.vdom.style;

class Style {
  static const int alignItems = 0;
  static const int animation = 1;
  static const int azimuth = 2;
  static const int background = 3;
  static const int backgroundAttachment = 4;
  static const int backgroundColor = 5;
  static const int backgroundImage = 6;
  static const int backgroundPosition = 7;
  static const int backgroundRepeat = 8;
  static const int border = 9;
  static const int borderBottom = 10;
  static const int borderBottomColor = 11;
  static const int borderBottomStyle = 12;
  static const int borderBottomWidth = 13;
  static const int borderCollapse = 14;
  static const int borderColor = 15;
  static const int borderLeft = 16;
  static const int borderLeftColor = 17;
  static const int borderLeftStyle = 18;
  static const int borderLeftWidth = 19;
  static const int borderRadius = 20;
  static const int borderRight = 21;
  static const int borderRightColor = 22;
  static const int borderRightStyle = 23;
  static const int borderRightWidth = 24;
  static const int borderSpacing = 25;
  static const int borderStyle = 26;
  static const int borderTop = 27;
  static const int borderTopColor = 28;
  static const int borderTopStyle = 29;
  static const int borderTopWidth = 30;
  static const int borderWidth = 31;
  static const int bottom = 32;
  static const int boxShadow = 33;
  static const int boxSizing = 34;
  static const int captionSide = 35;
  static const int clear = 36;
  static const int clip = 37;
  static const int color = 38;
  static const int content = 39;
  static const int counterIncrement = 40;
  static const int counterReset = 41;
  static const int cue = 42;
  static const int cueAfter = 43;
  static const int cueBefore = 44;
  static const int cursor = 45;
  static const int direction = 46;
  static const int display = 47;
  static const int elevation = 48;
  static const int emptyCells = 49;
  static const int fill = 50;
  static const int flex = 51;
  static const int float = 52;
  static const int font = 53;
  static const int fontFamily = 54;
  static const int fontSize = 55;
  static const int fontSizeAdjust = 56;
  static const int fontStretch = 57;
  static const int fontStyle = 58;
  static const int fontVariant = 59;
  static const int fontWeight = 60;
  static const int height = 61;
  static const int inputPlaceholder = 62;
  static const int justifyContent = 63;
  static const int left = 64;
  static const int letterSpacing = 65;
  static const int lineHeight = 66;
  static const int listStyle = 67;
  static const int listStyleImage = 68;
  static const int listStylePosition = 69;
  static const int listStyleType = 70;
  static const int margin = 71;
  static const int marginBottom = 72;
  static const int marginLeft = 73;
  static const int marginRight = 74;
  static const int marginTop = 75;
  static const int markerOffset = 76;
  static const int marks = 77;
  static const int maxHeight = 78;
  static const int maxWidth = 79;
  static const int minHeight = 80;
  static const int minWidth = 81;
  static const int opacity = 82;
  static const int orphans = 83;
  static const int outline = 84;
  static const int outlineColor = 85;
  static const int outlineStyle = 86;
  static const int outlineWidth = 87;
  static const int overflow = 88;
  static const int padding = 89;
  static const int paddingBottom = 90;
  static const int paddingLeft = 91;
  static const int paddingRight = 92;
  static const int paddingTop = 93;
  static const int page = 94;
  static const int pageBreakAfter = 95;
  static const int pageBreakBefore = 96;
  static const int pageBreakInside = 97;
  static const int pause = 98;
  static const int pauseAfter = 99;
  static const int pauseBefore = 100;
  static const int pitch = 101;
  static const int pitchRange = 102;
  static const int playDuring = 103;
  static const int pointerEvents = 104;
  static const int position = 105;
  static const int quotes = 106;
  static const int richness = 107;
  static const int right = 108;
  static const int size = 109;
  static const int speak = 110;
  static const int speakHeader = 111;
  static const int speakNumeral = 112;
  static const int speakPunctuation = 113;
  static const int speechRate = 114;
  static const int stress = 115;
  static const int tableLayout = 116;
  static const int textAlign = 117;
  static const int textDecoration = 118;
  static const int textIndent = 119;
  static const int textShadow = 120;
  static const int textTransform = 121;
  static const int top = 122;
  static const int touchAction = 123;
  static const int transform = 124;
  static const int transition = 125;
  static const int transitionProperty = 126;
  static const int unicodeBidi = 127;
  static const int userSelect = 128;
  static const int verticalAlign = 129;
  static const int visibility = 130;
  static const int voiceFamily = 131;
  static const int volume = 132;
  static const int whiteSpace = 133;
  static const int widows = 134;
  static const int width = 135;
  static const int willChange = 136;
  static const int wordSpacing = 137;
  static const int zIndex = 138;
}

class StyleInfo {
  final int id;
  final String name;

  const StyleInfo(this.id, this.name);

  static const List<StyleInfo> fromId = const [
    const StyleInfo(0, 'align-items'),
    const StyleInfo(1, 'animation'),
    const StyleInfo(2, 'azimuth'),
    const StyleInfo(3, 'background'),
    const StyleInfo(4, 'background-attachment'),
    const StyleInfo(5, 'background-color'),
    const StyleInfo(6, 'background-image'),
    const StyleInfo(7, 'background-position'),
    const StyleInfo(8, 'background-repeat'),
    const StyleInfo(9, 'border'),
    const StyleInfo(10, 'border-bottom'),
    const StyleInfo(11, 'border-bottom-color'),
    const StyleInfo(12, 'border-bottom-style'),
    const StyleInfo(13, 'border-bottom-width'),
    const StyleInfo(14, 'border-collapse'),
    const StyleInfo(15, 'border-color'),
    const StyleInfo(16, 'border-left'),
    const StyleInfo(17, 'border-left-color'),
    const StyleInfo(18, 'border-left-style'),
    const StyleInfo(19, 'border-left-width'),
    const StyleInfo(20, 'border-radius'),
    const StyleInfo(21, 'border-right'),
    const StyleInfo(22, 'border-right-color'),
    const StyleInfo(23, 'border-right-style'),
    const StyleInfo(24, 'border-right-width'),
    const StyleInfo(25, 'border-spacing'),
    const StyleInfo(26, 'border-style'),
    const StyleInfo(27, 'border-top'),
    const StyleInfo(28, 'border-top-color'),
    const StyleInfo(29, 'border-top-style'),
    const StyleInfo(30, 'border-top-width'),
    const StyleInfo(31, 'border-width'),
    const StyleInfo(32, 'bottom'),
    const StyleInfo(33, 'box-shadow'),
    const StyleInfo(34, 'box-sizing'),
    const StyleInfo(35, 'caption-side'),
    const StyleInfo(36, 'clear'),
    const StyleInfo(37, 'clip'),
    const StyleInfo(38, 'color'),
    const StyleInfo(39, 'content'),
    const StyleInfo(40, 'counter-increment'),
    const StyleInfo(41, 'counter-reset'),
    const StyleInfo(42, 'cue'),
    const StyleInfo(43, 'cue-after'),
    const StyleInfo(44, 'cue-before'),
    const StyleInfo(45, 'cursor'),
    const StyleInfo(46, 'direction'),
    const StyleInfo(47, 'display'),
    const StyleInfo(48, 'elevation'),
    const StyleInfo(49, 'empty-cells'),
    const StyleInfo(50, 'fill'),
    const StyleInfo(51, 'flex'),
    const StyleInfo(52, 'float'),
    const StyleInfo(53, 'font'),
    const StyleInfo(54, 'font-family'),
    const StyleInfo(55, 'font-size'),
    const StyleInfo(56, 'font-size-adjust'),
    const StyleInfo(57, 'font-stretch'),
    const StyleInfo(58, 'font-style'),
    const StyleInfo(59, 'font-variant'),
    const StyleInfo(60, 'font-weight'),
    const StyleInfo(61, 'height'),
    const StyleInfo(62, 'input-placeholder'),
    const StyleInfo(63, 'justify-content'),
    const StyleInfo(64, 'left'),
    const StyleInfo(65, 'letter-spacing'),
    const StyleInfo(66, 'line-height'),
    const StyleInfo(67, 'list-style'),
    const StyleInfo(68, 'list-style-image'),
    const StyleInfo(69, 'list-style-position'),
    const StyleInfo(70, 'list-style-type'),
    const StyleInfo(71, 'margin'),
    const StyleInfo(72, 'margin-bottom'),
    const StyleInfo(73, 'margin-left'),
    const StyleInfo(74, 'margin-right'),
    const StyleInfo(75, 'margin-top'),
    const StyleInfo(76, 'marker-offset'),
    const StyleInfo(77, 'marks'),
    const StyleInfo(78, 'max-height'),
    const StyleInfo(79, 'max-width'),
    const StyleInfo(80, 'min-height'),
    const StyleInfo(81, 'min-width'),
    const StyleInfo(82, 'opacity'),
    const StyleInfo(83, 'orphans'),
    const StyleInfo(84, 'outline'),
    const StyleInfo(85, 'outline-color'),
    const StyleInfo(86, 'outline-style'),
    const StyleInfo(87, 'outline-width'),
    const StyleInfo(88, 'overflow'),
    const StyleInfo(89, 'padding'),
    const StyleInfo(90, 'padding-bottom'),
    const StyleInfo(91, 'padding-left'),
    const StyleInfo(92, 'padding-right'),
    const StyleInfo(93, 'padding-top'),
    const StyleInfo(94, 'page'),
    const StyleInfo(95, 'page-break-after'),
    const StyleInfo(96, 'page-break-before'),
    const StyleInfo(97, 'page-break-inside'),
    const StyleInfo(98, 'pause'),
    const StyleInfo(99, 'pause-after'),
    const StyleInfo(100, 'pause-before'),
    const StyleInfo(101, 'pitch'),
    const StyleInfo(102, 'pitch-range'),
    const StyleInfo(103, 'play-during'),
    const StyleInfo(104, 'pointer-events'),
    const StyleInfo(105, 'position'),
    const StyleInfo(106, 'quotes'),
    const StyleInfo(107, 'richness'),
    const StyleInfo(108, 'right'),
    const StyleInfo(109, 'size'),
    const StyleInfo(110, 'speak'),
    const StyleInfo(111, 'speak-header'),
    const StyleInfo(112, 'speak-numeral'),
    const StyleInfo(113, 'speak-punctuation'),
    const StyleInfo(114, 'speech-rate'),
    const StyleInfo(115, 'stress'),
    const StyleInfo(116, 'table-layout'),
    const StyleInfo(117, 'text-align'),
    const StyleInfo(118, 'text-decoration'),
    const StyleInfo(119, 'text-indent'),
    const StyleInfo(120, 'text-shadow'),
    const StyleInfo(121, 'text-transform'),
    const StyleInfo(122, 'top'),
    const StyleInfo(123, 'touch-action'),
    const StyleInfo(124, 'transform'),
    const StyleInfo(125, 'transition'),
    const StyleInfo(126, 'transition-property'),
    const StyleInfo(127, 'unicode-bidi'),
    const StyleInfo(128, 'user-select'),
    const StyleInfo(129, 'vertical-align'),
    const StyleInfo(130, 'visibility'),
    const StyleInfo(131, 'voice-family'),
    const StyleInfo(132, 'volume'),
    const StyleInfo(133, 'white-space'),
    const StyleInfo(134, 'widows'),
    const StyleInfo(135, 'width'),
    const StyleInfo(136, 'will-change'),
    const StyleInfo(137, 'word-spacing'),
    const StyleInfo(138, 'z-index'),
  ];
}
