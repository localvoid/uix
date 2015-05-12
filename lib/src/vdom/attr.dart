// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.src.vdom.attr;

import 'namespace.dart';

class Attr {
  static const int accept = 0;
  static const int acceptCharset = 1;
  static const int accessKey = 2;
  static const int action = 3;
  static const int allowFullScreen = 4;
  static const int allowTransparency = 5;
  static const int alt = 6;
  static const int async = 7;
  static const int autoComplete = 8;
  static const int autoFocus = 9;
  static const int autoPlay = 10;
  static const int cellPadding = 11;
  static const int cellSpacing = 12;
  static const int charSet = 13;
  static const int checked = 14;
  static const int classID = 15;
  static const int className = 16;
  static const int cols = 17;
  static const int colSpan = 18;
  static const int content = 19;
  static const int contentEditable = 20;
  static const int contextMenu = 21;
  static const int controls = 22;
  static const int coords = 23;
  static const int crossOrigin = 24;
  static const int data = 25;
  static const int dateTime = 26;
  static const int defer = 27;
  static const int dir = 28;
  static const int disabled = 29;
  static const int download = 30;
  static const int draggable = 31;
  static const int encType = 32;
  static const int form = 33;
  static const int formAction = 34;
  static const int formEncType = 35;
  static const int formMethod = 36;
  static const int formNoValidate = 37;
  static const int formTarget = 38;
  static const int frameBorder = 39;
  static const int headers = 40;
  static const int height = 41;
  static const int hidden = 42;
  static const int high = 43;
  static const int href = 44;
  static const int hrefLang = 45;
  static const int htmlFor = 46;
  static const int httpEquiv = 47;
  static const int icon = 48;
  static const int id = 49;
  static const int label = 50;
  static const int lang = 51;
  static const int list = 52;
  static const int loop = 53;
  static const int low = 54;
  static const int manifest = 55;
  static const int marginHeight = 56;
  static const int marginWidth = 57;
  static const int max = 58;
  static const int maxLength = 59;
  static const int media = 60;
  static const int mediaGroup = 61;
  static const int method = 62;
  static const int min = 63;
  static const int multiple = 64;
  static const int muted = 65;
  static const int name = 66;
  static const int noValidate = 67;
  static const int open = 68;
  static const int optimum = 69;
  static const int pattern = 70;
  static const int placeholder = 71;
  static const int poster = 72;
  static const int preload = 73;
  static const int radioGroup = 74;
  static const int readOnly = 75;
  static const int rel = 76;
  static const int required = 77;
  static const int role = 78;
  static const int rows = 79;
  static const int rowSpan = 80;
  static const int sandbox = 81;
  static const int scope = 82;
  static const int scoped = 83;
  static const int scrolling = 84;
  static const int seamless = 85;
  static const int selected = 86;
  static const int shape = 87;
  static const int size = 88;
  static const int sizes = 89;
  static const int span = 90;
  static const int spellCheck = 91;
  static const int src = 92;
  static const int srcDoc = 93;
  static const int srcSet = 94;
  static const int start = 95;
  static const int step = 96;
  static const int style = 97;
  static const int tabIndex = 98;
  static const int target = 99;
  static const int title = 100;
  static const int type = 101;
  static const int useMap = 102;
  static const int value = 103;
  static const int width = 104;
  static const int wmode = 105;
  static const int xmlns = 106;
  static const int autoCapitalize = 107; // keyboard hints on Mobile Safari.
  static const int autoCorrect = 108; // keyboard hints on Mobile Safari.
  static const int itemProp = 109; // Microdata: http://schema.org/docs/gs.html
  static const int itemScope = 110; // Microdata: http://schema.org/docs/gs.html
  static const int itemType = 111; // Microdata: http://schema.org/docs/gs.html
  static const int itemID = 112; // Microdata: https://html.spec.whatwg.org/multipage/microdata.html#microdata-dom-api
  static const int itemRef = 113; // Microdata: https://html.spec.whatwg.org/multipage/microdata.html#microdata-dom-api
  static const int unselectable = 114; // IE

  // SVG
  static const int cx = 115;
  static const int cy = 116;
  static const int d = 117;
  static const int dx = 118;
  static const int dy = 119;
  static const int fill = 120;
  static const int fillOpacity = 121;
  static const int fontFamily = 122;
  static const int fontSize = 123;
  static const int fx = 124;
  static const int fy = 125;
  static const int gradientTransform = 126;
  static const int gradientUnits = 127;
  static const int markerEnd = 128;
  static const int markerMid = 129;
  static const int markerStart = 130;
  static const int offset = 131;
  static const int opacity = 132;
  static const int patternContentUnits = 133;
  static const int patternUnits = 134;
  static const int points = 135;
  static const int preserveAspectRatio = 136;
  static const int r = 137;
  static const int rx = 138;
  static const int ry = 139;
  static const int spreadMethod = 140;
  static const int stopColor = 141;
  static const int stopOpacity = 142;
  static const int stroke = 143;
  static const int strokeDasharray = 144;
  static const int strokeLinecap = 145;
  static const int strokeOpacity = 146;
  static const int strokeWidth = 147;
  static const int textAnchor = 148;
  static const int transform = 149;
  static const int version = 150;
  static const int viewBox = 151;
  static const int x1 = 152;
  static const int x2 = 153;
  static const int x = 154;
  static const int xlinkActuate = 155;
  static const int xlinkArcrole = 156;
  static const int xlinkHref = 157;
  static const int xlinkRole = 158;
  static const int xlinkShow = 159;
  static const int xlinkTitle = 160;
  static const int xlinkType = 161;
  static const int xmlBase = 162;
  static const int xmlLang = 163;
  static const int xmlSpace = 164;
  static const int xmlnsXlink = 165;
  static const int y1 = 166;
  static const int y2 = 167;
  static const int y = 168;

  static const int ariaActiveDescendant = 169;
  static const int ariaAtomic = 170;
  static const int ariaBusy = 171;
  static const int ariaControls = 172;
  static const int ariaDescribedBy = 173;
  static const int ariaDropEffect = 174;
  static const int ariaExpanded = 175;
  static const int ariaFlowTo = 176;
  static const int ariaGrabbed = 177;
  static const int ariaHasPopup = 178;
  static const int ariaHidden = 179;
  static const int ariaLabel = 180;
  static const int ariaLabelledBy = 181;
  static const int ariaLevel = 182;
  static const int ariaLive = 183;
  static const int ariaOrientation = 184;
  static const int ariaOwns = 185;
  static const int ariaPosInset = 186;
  static const int ariaPressed = 187;
  static const int ariaRelevant = 188;
  static const int ariaSetSize = 189;
  static const int ariaSort = 190;
}

class AttrInfo {
  static const int namespaceFlag = 1;
  static const int boolValueFlag = 1 << 1;
  static const int numValueFlag = 1 << 2;

  final int id;
  final int flags;
  final String namespace;
  final String name;

  const AttrInfo(this.id, this.flags, this.namespace, this.name);

  static const List<AttrInfo> fromId = const [
    const AttrInfo(0, 0, null, 'accept'),
    const AttrInfo(1, 0, null, 'accept-charset'),
    const AttrInfo(2, 0, null, 'accessKey'),
    const AttrInfo(3, 0, null, 'action'),
    const AttrInfo(4, boolValueFlag, null, 'allowFullScreen'),
    const AttrInfo(5, 0, null, 'allowTransparency'),
    const AttrInfo(6, 0, null, 'alt'),
    const AttrInfo(7, boolValueFlag, null, 'async'),
    const AttrInfo(8, 0, null, 'autocomplete'),
    const AttrInfo(9, boolValueFlag, null, 'autofocus'),
    const AttrInfo(10, boolValueFlag, null, 'autoplay'),
    const AttrInfo(11, 0, null, 'cellPadding'),
    const AttrInfo(12, 0, null, 'cellSpacing'),
    const AttrInfo(13, 0, null, 'charSet'),
    const AttrInfo(14, boolValueFlag, null, 'checked'),
    const AttrInfo(15, 0, null, 'classID'),
    const AttrInfo(16, 0, null, 'class'),
    const AttrInfo(17, numValueFlag, null, 'cols'),
    const AttrInfo(18, 0, null, 'colSpan'),
    const AttrInfo(19, 0, null, 'content'),
    const AttrInfo(20, 0, null, 'contentEditable'),
    const AttrInfo(21, 0, null, 'contextMenu'),
    const AttrInfo(22, boolValueFlag, null, 'controls'),
    const AttrInfo(23, 0, null, 'coords'),
    const AttrInfo(24, 0, null, 'crossOrigin'),
    const AttrInfo(25, 0, null, 'date'),
    const AttrInfo(26, 0, null, 'dateTime'),
    const AttrInfo(27, boolValueFlag, null, 'defer'),
    const AttrInfo(28, 0, null, 'dir'),
    const AttrInfo(29, boolValueFlag, null, 'disabled'),
    const AttrInfo(30, 0, null, 'download'),
    const AttrInfo(31, 0, null, 'draggable'),
    const AttrInfo(32, 0, null, 'encoding'),
    const AttrInfo(33, 0, null, 'form'),
    const AttrInfo(34, 0, null, 'formAction'),
    const AttrInfo(35, 0, null, 'formEncType'),
    const AttrInfo(36, 0, null, 'formMethod'),
    const AttrInfo(37, boolValueFlag, null, 'formNoValidate'),
    const AttrInfo(38, 0, null, 'target'),
    const AttrInfo(39, 0, null, 'frameBorder'),
    const AttrInfo(40, 0, null, 'headers'),
    const AttrInfo(41, 0, null, 'height'),
    const AttrInfo(42, boolValueFlag, null, 'hidden'),
    const AttrInfo(43, 0, null, 'high'),
    const AttrInfo(44, 0, null, 'href'),
    const AttrInfo(45, 0, null, 'hreflang'),
    const AttrInfo(46, 0, null, 'for'),
    const AttrInfo(47, 0, null, 'http-equiv'),
    const AttrInfo(48, 0, null, 'icon'),
    const AttrInfo(49, 0, null, 'id'),
    const AttrInfo(50, 0, null, 'label'),
    const AttrInfo(51, 0, null, 'lang'),
    const AttrInfo(52, 0, null, 'list'),
    const AttrInfo(53, boolValueFlag, null, 'loop'),
    const AttrInfo(54, 0, null, 'low'),
    const AttrInfo(55, 0, null, 'manifest'),
    const AttrInfo(56, 0, null, 'marginHeight'),
    const AttrInfo(57, 0, null, 'marginWidth'),
    const AttrInfo(58, 0, null, 'max'),
    const AttrInfo(59, 0, null, 'maxLength'),
    const AttrInfo(60, 0, null, 'media'),
    const AttrInfo(61, 0, null, 'mediaGroup'),
    const AttrInfo(62, 0, null, 'method'),
    const AttrInfo(63, 0, null, 'min'),
    const AttrInfo(64, boolValueFlag, null, 'multiple'),
    const AttrInfo(65, boolValueFlag, null, 'muted'),
    const AttrInfo(66, 0, null, 'name'),
    const AttrInfo(67, boolValueFlag, null, 'NoValidate'),
    const AttrInfo(68, boolValueFlag, null, 'open'),
    const AttrInfo(69, 0, null, 'optimum'),
    const AttrInfo(70, 0, null, 'pattern'),
    const AttrInfo(71, 0, null, 'placeholder'),
    const AttrInfo(72, 0, null, 'poster'),
    const AttrInfo(73, 0, null, 'preload'),
    const AttrInfo(74, 0, null, 'radioGroup'),
    const AttrInfo(75, boolValueFlag, null, 'readOnly'),
    const AttrInfo(76, 0, null, 'rel'),
    const AttrInfo(77, boolValueFlag, null, 'required'),
    const AttrInfo(78, 0, null, 'role'),
    const AttrInfo(79, numValueFlag, null, 'rows'),
    const AttrInfo(80, 0, null, 'rowSpan'),
    const AttrInfo(81, 0, null, 'sandbox'),
    const AttrInfo(82, 0, null, 'scope'),
    const AttrInfo(83, boolValueFlag, null, 'scoped'),
    const AttrInfo(84, 0, null, 'scrolling'),
    const AttrInfo(85, boolValueFlag, null, 'seamless'),
    const AttrInfo(86, boolValueFlag, null, 'selected'),
    const AttrInfo(87, 0, null, 'shape'),
    const AttrInfo(88, numValueFlag, null, 'size'),
    const AttrInfo(89, 0, null, 'sizes'),
    const AttrInfo(90, numValueFlag, null, 'span'),
    const AttrInfo(91, 0, null, 'spellcheck'),
    const AttrInfo(92, 0, null, 'src'),
    const AttrInfo(93, 0, null, 'srcdoc'),
    const AttrInfo(94, 0, null, 'srcset'),
    const AttrInfo(95, numValueFlag, null, 'start'),
    const AttrInfo(96, 0, null, 'step'),
    const AttrInfo(97, 0, null, 'style'),
    const AttrInfo(98, 0, null, 'tabIndex'),
    const AttrInfo(99, 0, null, 'target'),
    const AttrInfo(100, 0, null, 'title'),
    const AttrInfo(101, 0, null, 'type'),
    const AttrInfo(102, 0, null, 'useMap'),
    const AttrInfo(103, 0, null, 'value'),
    const AttrInfo(104, 0, null, 'width'),
    const AttrInfo(105, 0, null, 'wmode'),
    const AttrInfo(106, namespaceFlag, xmlnsNamespace, 'xmlns'),
    const AttrInfo(107, 0, null, 'autocapitalize'),
    const AttrInfo(108, 0, null, 'autocorrect'),
    const AttrInfo(109, 0, null, 'itemProp'),
    const AttrInfo(110, boolValueFlag, null, 'itemScope'),
    const AttrInfo(111, 0, null, 'itemType'),
    const AttrInfo(112, 0, null, 'itemID'),
    const AttrInfo(113, 0, null, 'itemRef'),
    const AttrInfo(114, 0, null, 'unselectable'),

    const AttrInfo(115, 0, null, 'cx'),
    const AttrInfo(116, 0, null, 'cy'),
    const AttrInfo(117, 0, null, 'd'),
    const AttrInfo(118, 0, null, 'dx'),
    const AttrInfo(119, 0, null, 'dy'),
    const AttrInfo(120, 0, null, 'fill'),
    const AttrInfo(121, 0, null, 'fill-opacity'),
    const AttrInfo(122, 0, null, 'font-family'),
    const AttrInfo(123, 0, null, 'font-size'),
    const AttrInfo(124, 0, null, 'fx'),
    const AttrInfo(125, 0, null, 'fy'),
    const AttrInfo(126, 0, null, 'gradientTransform'),
    const AttrInfo(127, 0, null, 'gradientUnits'),
    const AttrInfo(128, 0, null, 'marker-end'),
    const AttrInfo(129, 0, null, 'marker-mid'),
    const AttrInfo(130, 0, null, 'marker-start'),
    const AttrInfo(131, 0, null, 'offset'),
    const AttrInfo(132, 0, null, 'opacity'),
    const AttrInfo(133, 0, null, 'patternContentUnits'),
    const AttrInfo(134, 0, null, 'patternUnits'),
    const AttrInfo(135, 0, null, 'points'),
    const AttrInfo(136, 0, null, 'preserveAspectRatio'),
    const AttrInfo(137, 0, null, 'r'),
    const AttrInfo(138, 0, null, 'rx'),
    const AttrInfo(139, 0, null, 'ry'),
    const AttrInfo(140, 0, null, 'spreadMethod'),
    const AttrInfo(141, 0, null, 'stop-color'),
    const AttrInfo(142, 0, null, 'stop-opacity'),
    const AttrInfo(143, 0, null, 'stroke'),
    const AttrInfo(144, 0, null, 'stroke-dasharray'),
    const AttrInfo(145, 0, null, 'stroke-linecap'),
    const AttrInfo(146, 0, null, 'stroke-opacity'),
    const AttrInfo(147, 0, null, 'stroke-width'),
    const AttrInfo(148, 0, null, 'text-anchor'),
    const AttrInfo(149, 0, null, 'transform'),
    const AttrInfo(150, 0, null, 'version'),
    const AttrInfo(151, 0, null, 'viewBox'),
    const AttrInfo(152, 0, null, 'x1'),
    const AttrInfo(153, 0, null, 'x2'),
    const AttrInfo(154, 0, null, 'x'),
    const AttrInfo(155, namespaceFlag, xlinkNamespace, 'xlink:actuate'),
    const AttrInfo(156, namespaceFlag, xlinkNamespace, 'xlink:arcrole'),
    const AttrInfo(157, namespaceFlag, xlinkNamespace, 'xlink:href'),
    const AttrInfo(158, namespaceFlag, xlinkNamespace, 'xlink:role'),
    const AttrInfo(159, namespaceFlag, xlinkNamespace, 'xlink:show'),
    const AttrInfo(160, namespaceFlag, xlinkNamespace, 'xlink:title'),
    const AttrInfo(161, namespaceFlag, xlinkNamespace, 'xlink:type'),
    const AttrInfo(162, namespaceFlag, xmlNamespace, 'xml:base'),
    const AttrInfo(163, namespaceFlag, xmlNamespace, 'xml:lang'),
    const AttrInfo(164, namespaceFlag, xmlNamespace, 'xml:space'),
    const AttrInfo(165, namespaceFlag, xmlnsNamespace, 'xmlns:xlink'),
    const AttrInfo(166, 0, null, 'y1'),
    const AttrInfo(167, 0, null, 'y2'),
    const AttrInfo(168, 0, null, 'y'),

    const AttrInfo(169, 0, null, 'aria-activedescendant'),
    const AttrInfo(170, 0, null, 'aria-atomic'),
    const AttrInfo(171, 0, null, 'aria-busy'),
    const AttrInfo(172, 0, null, 'aria-controls'),
    const AttrInfo(173, 0, null, 'aria-describedby'),
    const AttrInfo(174, 0, null, 'aria-dropeffect'),
    const AttrInfo(175, 0, null, 'aria-expanded'),
    const AttrInfo(176, 0, null, 'aria-flowto'),
    const AttrInfo(177, 0, null, 'aria-grabbed'),
    const AttrInfo(178, 0, null, 'aria-haspopup'),
    const AttrInfo(179, 0, null, 'aria-hidden'),
    const AttrInfo(180, 0, null, 'aria-label'),
    const AttrInfo(181, 0, null, 'aria-labelledby'),
    const AttrInfo(182, 0, null, 'aria-level'),
    const AttrInfo(183, 0, null, 'aria-live'),
    const AttrInfo(184, 0, null, 'aria-orientation'),
    const AttrInfo(185, 0, null, 'aria-owns'),
    const AttrInfo(186, 0, null, 'aria-posinset'),
    const AttrInfo(187, 0, null, 'aria-pressed'),
    const AttrInfo(188, 0, null, 'aria-relevant'),
    const AttrInfo(189, 0, null, 'aria-setsize'),
    const AttrInfo(190, 0, null, 'aria-sort'),
  ];
}
