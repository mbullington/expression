import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:styled_widget/styled_widget.dart';

import '../history_controller.dart';
import '../math_controller.dart';
import '../theme.dart';

class HistoryPage extends StatelessWidget {
  final ScrollController controller;
  final HistoryController history;

  HistoryPage({@required this.controller, @required this.history, Key key})
      : super(key: key);

  Widget _buildItem(BuildContext context, int i) {
    final result = history.results[history.results.length - 1 - i];

    return <Widget>[
      Text(
        result.input,
        style: getTextStyle().copyWith(color: CupertinoColors.systemGrey),
        maxLines: 1,
      ).padding(all: 6.0, bottom: 6.0 + 15.0),
      CupertinoButton(
        child: Text(
          doubleToString(result.result),
          style: getResultTextStyle(),
          maxLines: 1,
        ),
        onPressed: () {
          Clipboard.setData(ClipboardData(text: doubleToString(result.result)));
        },
        padding: EdgeInsets.only(bottom: 15.0),
      ),
    ]
        .toColumn(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
        )
        .padding(left: 40.0, right: 40.0, top: 15.0)
        .border(bottom: 2.0, color: CupertinoColors.separator);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("History"),
        leading: CupertinoButton(
          child: Icon(CupertinoIcons.arrow_down),
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
      ),
      child: ListView.builder(
        itemBuilder: _buildItem,
        itemCount: history.results.length,
        controller: controller,
        reverse: false,
      ),
    );
  }
}
