import 'package:flutter/cupertino.dart';
import 'package:styled_widget/styled_widget.dart';

import '../theme.dart';

class Tile extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  final bool expand;

  Tile({@required this.child, this.onPressed, this.onLongPress, Key key, this.expand = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget button = CupertinoButton(
      child: DefaultTextStyle(style: getTextStyle(), child: child),
      onPressed: onPressed ?? () => {},
    );

    Widget widget = button.center().aspectRatio(aspectRatio: 1.05);

    if (onLongPress != null) {
      widget = GestureDetector(
        onLongPress: onLongPress,
        child: widget,
      );
    }

    if (expand) {
      widget = widget.expanded();
    }

    return widget;
  }
}
