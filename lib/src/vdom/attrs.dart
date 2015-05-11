// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.src.vdom.attrs;

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

  final int flags;
  final String namespace;
  final String name;

  const AttrInfo(this.flags, this.namespace, this.name);

  static const List<AttrInfo> fromId = const [
    const AttrInfo(0, null, 'accept'),
    const AttrInfo(0, null, 'accept-charset'),
    const AttrInfo(0, null, 'accessKey'),
    const AttrInfo(0, null, 'action'),
    const AttrInfo(boolValueFlag, null, 'allowFullScreen'),
    const AttrInfo(0, null, 'allowTransparency'),
    const AttrInfo(0, null, 'alt'),
    const AttrInfo(boolValueFlag, null, 'async'),
    const AttrInfo(0, null, 'autocomplete'),
    const AttrInfo(boolValueFlag, null, 'autofocus'),
    const AttrInfo(boolValueFlag, null, 'autoplay'),
    const AttrInfo(0, null, 'cellPadding'),
    const AttrInfo(0, null, 'cellSpacing'),
    const AttrInfo(0, null, 'charSet'),
    const AttrInfo(boolValueFlag, null, 'checked'),
    const AttrInfo(0, null, 'classID'),
    const AttrInfo(0, null, 'class'),
    const AttrInfo(numValueFlag, null, 'cols'),
    const AttrInfo(0, null, 'colSpan'),
    const AttrInfo(0, null, 'content'),
    const AttrInfo(0, null, 'contentEditable'),
    const AttrInfo(0, null, 'contextMenu'),
    const AttrInfo(boolValueFlag, null, 'controls'),
    const AttrInfo(0, null, 'coords'),
    const AttrInfo(0, null, 'crossOrigin'),
    const AttrInfo(0, null, 'date'),
    const AttrInfo(0, null, 'dateTime'),
    const AttrInfo(boolValueFlag, null, 'defer'),
    const AttrInfo(0, null, 'dir'),
    const AttrInfo(boolValueFlag, null, 'disabled'),
    const AttrInfo(0, null, 'download'),
    const AttrInfo(0, null, 'draggable'),
    const AttrInfo(0, null, 'encoding'),
    const AttrInfo(0, null, 'form'),
    const AttrInfo(0, null, 'formAction'),
    const AttrInfo(0, null, 'formEncType'),
    const AttrInfo(0, null, 'formMethod'),
    const AttrInfo(boolValueFlag, null, 'formNoValidate'),
    const AttrInfo(0, null, 'target'),
    const AttrInfo(0, null, 'frameBorder'),
    const AttrInfo(0, null, 'headers'),
    const AttrInfo(0, null, 'height'),
    const AttrInfo(boolValueFlag, null, 'hidden'),
    const AttrInfo(0, null, 'high'),
    const AttrInfo(0, null, 'href'),
    const AttrInfo(0, null, 'hreflang'),
    const AttrInfo(0, null, 'for'),
    const AttrInfo(0, null, 'http-equiv'),
    const AttrInfo(0, null, 'icon'),
    const AttrInfo(0, null, 'id'),
    const AttrInfo(0, null, 'label'),
    const AttrInfo(0, null, 'lang'),
    const AttrInfo(0, null, 'list'),
    const AttrInfo(boolValueFlag, null, 'loop'),
    const AttrInfo(0, null, 'low'),
    const AttrInfo(0, null, 'manifest'),
    const AttrInfo(0, null, 'marginHeight'),
    const AttrInfo(0, null, 'marginWidth'),
    const AttrInfo(0, null, 'max'),
    const AttrInfo(0, null, 'maxLength'),
    const AttrInfo(0, null, 'media'),
    const AttrInfo(0, null, 'mediaGroup'),
    const AttrInfo(0, null, 'method'),
    const AttrInfo(0, null, 'min'),
    const AttrInfo(boolValueFlag, null, 'multiple'),
    const AttrInfo(boolValueFlag, null, 'muted'),
    const AttrInfo(0, null, 'name'),
    const AttrInfo(boolValueFlag, null, 'NoValidate'),
    const AttrInfo(boolValueFlag, null, 'open'),
    const AttrInfo(0, null, 'optimum'),
    const AttrInfo(0, null, 'pattern'),
    const AttrInfo(0, null, 'placeholder'),
    const AttrInfo(0, null, 'poster'),
    const AttrInfo(0, null, 'preload'),
    const AttrInfo(0, null, 'radioGroup'),
    const AttrInfo(boolValueFlag, null, 'readOnly'),
    const AttrInfo(0, null, 'rel'),
    const AttrInfo(boolValueFlag, null, 'required'),
    const AttrInfo(0, null, 'role'),
    const AttrInfo(numValueFlag, null, 'rows'),
    const AttrInfo(0, null, 'rowSpan'),
    const AttrInfo(0, null, 'sandbox'),
    const AttrInfo(0, null, 'scope'),
    const AttrInfo(boolValueFlag, null, 'scoped'),
    const AttrInfo(0, null, 'scrolling'),
    const AttrInfo(boolValueFlag, null, 'seamless'),
    const AttrInfo(boolValueFlag, null, 'selected'),
    const AttrInfo(0, null, 'shape'),
    const AttrInfo(numValueFlag, null, 'size'),
    const AttrInfo(0, null, 'sizes'),
    const AttrInfo(numValueFlag, null, 'span'),
    const AttrInfo(0, null, 'spellcheck'),
    const AttrInfo(0, null, 'src'),
    const AttrInfo(0, null, 'srcdoc'),
    const AttrInfo(0, null, 'srcset'),
    const AttrInfo(numValueFlag, null, 'start'),
    const AttrInfo(0, null, 'step'),
    const AttrInfo(0, null, 'style'),
    const AttrInfo(0, null, 'tabIndex'),
    const AttrInfo(0, null, 'target'),
    const AttrInfo(0, null, 'title'),
    const AttrInfo(0, null, 'type'),
    const AttrInfo(0, null, 'useMap'),
    const AttrInfo(0, null, 'value'),
    const AttrInfo(0, null, 'width'),
    const AttrInfo(0, null, 'wmode'),
    const AttrInfo(namespaceFlag, xmlnsNamespace, 'xmlns'),
    const AttrInfo(0, null, 'autocapitalize'),
    const AttrInfo(0, null, 'autocorrect'),
    const AttrInfo(0, null, 'itemProp'),
    const AttrInfo(boolValueFlag, null, 'itemScope'),
    const AttrInfo(0, null, 'itemType'),
    const AttrInfo(0, null, 'itemID'),
    const AttrInfo(0, null, 'itemRef'),
    const AttrInfo(0, null, 'unselectable'),

    const AttrInfo(0, null, 'cx'),
    const AttrInfo(0, null, 'cy'),
    const AttrInfo(0, null, 'd'),
    const AttrInfo(0, null, 'dx'),
    const AttrInfo(0, null, 'dy'),
    const AttrInfo(0, null, 'fill'),
    const AttrInfo(0, null, 'fill-opacity'),
    const AttrInfo(0, null, 'font-family'),
    const AttrInfo(0, null, 'font-size'),
    const AttrInfo(0, null, 'fx'),
    const AttrInfo(0, null, 'fy'),
    const AttrInfo(0, null, 'gradientTransform'),
    const AttrInfo(0, null, 'gradientUnits'),
    const AttrInfo(0, null, 'marker-end'),
    const AttrInfo(0, null, 'marker-mid'),
    const AttrInfo(0, null, 'marker-start'),
    const AttrInfo(0, null, 'offset'),
    const AttrInfo(0, null, 'opacity'),
    const AttrInfo(0, null, 'patternContentUnits'),
    const AttrInfo(0, null, 'patternUnits'),
    const AttrInfo(0, null, 'points'),
    const AttrInfo(0, null, 'preserveAspectRatio'),
    const AttrInfo(0, null, 'r'),
    const AttrInfo(0, null, 'rx'),
    const AttrInfo(0, null, 'ry'),
    const AttrInfo(0, null, 'spreadMethod'),
    const AttrInfo(0, null, 'stop-color'),
    const AttrInfo(0, null, 'stop-opacity'),
    const AttrInfo(0, null, 'stroke'),
    const AttrInfo(0, null, 'stroke-dasharray'),
    const AttrInfo(0, null, 'stroke-linecap'),
    const AttrInfo(0, null, 'stroke-opacity'),
    const AttrInfo(0, null, 'stroke-width'),
    const AttrInfo(0, null, 'text-anchor'),
    const AttrInfo(0, null, 'transform'),
    const AttrInfo(0, null, 'version'),
    const AttrInfo(0, null, 'viewBox'),
    const AttrInfo(0, null, 'x1'),
    const AttrInfo(0, null, 'x2'),
    const AttrInfo(0, null, 'x'),
    const AttrInfo(namespaceFlag, xlinkNamespace, 'xlink:actuate'),
    const AttrInfo(namespaceFlag, xlinkNamespace, 'xlink:arcrole'),
    const AttrInfo(namespaceFlag, xlinkNamespace, 'xlink:href'),
    const AttrInfo(namespaceFlag, xlinkNamespace, 'xlink:role'),
    const AttrInfo(namespaceFlag, xlinkNamespace, 'xlink:show'),
    const AttrInfo(namespaceFlag, xlinkNamespace, 'xlink:title'),
    const AttrInfo(namespaceFlag, xlinkNamespace, 'xlink:type'),
    const AttrInfo(namespaceFlag, xmlNamespace, 'xml:base'),
    const AttrInfo(namespaceFlag, xmlNamespace, 'xml:lang'),
    const AttrInfo(namespaceFlag, xmlNamespace, 'xml:space'),
    const AttrInfo(namespaceFlag, xmlnsNamespace, 'xmlns:xlink'),
    const AttrInfo(0, null, 'y1'),
    const AttrInfo(0, null, 'y2'),
    const AttrInfo(0, null, 'y'),

    const AttrInfo(0, null, 'aria-activedescendant'),
    const AttrInfo(0, null, 'aria-atomic'),
    const AttrInfo(0, null, 'aria-busy'),
    const AttrInfo(0, null, 'aria-controls'),
    const AttrInfo(0, null, 'aria-describedby'),
    const AttrInfo(0, null, 'aria-dropeffect'),
    const AttrInfo(0, null, 'aria-expanded'),
    const AttrInfo(0, null, 'aria-flowto'),
    const AttrInfo(0, null, 'aria-grabbed'),
    const AttrInfo(0, null, 'aria-haspopup'),
    const AttrInfo(0, null, 'aria-hidden'),
    const AttrInfo(0, null, 'aria-label'),
    const AttrInfo(0, null, 'aria-labelledby'),
    const AttrInfo(0, null, 'aria-level'),
    const AttrInfo(0, null, 'aria-live'),
    const AttrInfo(0, null, 'aria-orientation'),
    const AttrInfo(0, null, 'aria-owns'),
    const AttrInfo(0, null, 'aria-posinset'),
    const AttrInfo(0, null, 'aria-pressed'),
    const AttrInfo(0, null, 'aria-relevant'),
    const AttrInfo(0, null, 'aria-setsize'),
    const AttrInfo(0, null, 'aria-ort'),
  ];
}
