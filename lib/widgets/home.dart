import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Scaffold, PageView;
import 'package:flutter/services.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:scrolling_page_indicator/scrolling_page_indicator.dart';

import 'package:styled_widget/styled_widget.dart';

import './history_page.dart';
import './tile.dart';

import '../history_controller.dart';
import '../manual_text_editing_controller.dart';
import '../math_controller.dart';
import '../theme.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  ManualTextEditingController _controller;
  MathController _mathController;

  final HistoryController _historyController = HistoryController();
  final PageController _pageController = PageController(initialPage: 0);

  _onHistory() {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) {
          final scrollController = ModalScrollController.of(context);
          return HistoryPage(
            controller: scrollController,
            history: _historyController,
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _controller = ManualTextEditingController();
    _mathController = MathController(_controller);
  }

  void _onEquals() {
    final result = _mathController.value;

    if (!result.valid) {
      return;
    }

    final text = doubleToString(result.result);
    _historyController.results.add(result);
    _controller.text = text;
  }

  Widget _buildTextTile(
    String value, {
    String toInsert,
    int forward = 1,
    bool expand = true,
    Color color = CupertinoColors.white,
  }) {
    return Tile(
      child: Text(value).textColor(color),
      onPressed: () => _controller.addText(toInsert ?? value, forward),
      expand: expand,
    );
  }

  Widget _buildIconTile(
    IconData icon, {
    String value,
    VoidCallback onPressed,
    VoidCallback onLongPress,
    Color color,
  }) {
    assert(value != null || onPressed != null);

    return Tile(
      child: Icon(
        icon,
        color: color ?? TColors.red,
        size: 51,
      ),
      onPressed: value != null ? () => _controller.addText(value) : onPressed,
      onLongPress: onLongPress,
    );
  }

  Widget _buildMathResult(BuildContext context, MathResult result, _) {
    final textStyle = getResultTextStyle();

    if (!result.valid) {
      return Text(
        result.input,
        style: textStyle,
        maxLines: 1,
      ).opacity(lowEmphasis).padding(top: 15.0);
    }

    return Text(
      doubleToString(result.result),
      style: textStyle,
      maxLines: 1,
    ).padding(top: 15.0);
  }

  @override
  Widget build(BuildContext context) {
    final page1 = GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: <Widget>[
          <Widget>[
            _buildTextTile("7"),
            _buildTextTile("8"),
            _buildTextTile("9"),
            _buildIconTile(CupertinoIcons.divide_circle, value: "/"),
          ].toRow(),
          <Widget>[
            _buildTextTile("4"),
            _buildTextTile("5"),
            _buildTextTile("6"),
            _buildIconTile(CupertinoIcons.multiply_circle, value: "*"),
          ].toRow(),
          <Widget>[
            _buildTextTile("1"),
            _buildTextTile("2"),
            _buildTextTile("3"),
            _buildIconTile(CupertinoIcons.minus_circle, value: "-"),
          ].toRow(),
          <Widget>[
            _buildTextTile("."),
            _buildTextTile("0"),
            _buildIconTile(
              CupertinoIcons.delete_left,
              onPressed: _controller.remove,
              onLongPress: _controller.clear,
            ),
            _buildIconTile(CupertinoIcons.plus_circle, value: "+"),
          ].toRow(),
          <Widget>[
            _buildTextTile("^", color: CupertinoColors.systemGrey2),
            _buildTextTile("%", toInsert: "*0.01", color: CupertinoColors.systemGrey2),
            _buildTextTile("( )", toInsert: "()", color: CupertinoColors.systemGrey2),
            _buildIconTile(
              CupertinoIcons.equal_circle_fill,
              color: TColors.accent,
              onPressed: _onEquals,
            ),
          ].toRow(),
        ],
        mainAxisSize: MainAxisSize.min,
      )
          .padding(all: 40.0, top: 40.0 + 15.0)
          .border(top: 2.0, color: TColors.darker),
    );

    final page2 = CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 40.0) +
              EdgeInsets.only(top: 40.0),
          sliver: SliverGrid.count(
            crossAxisCount: 3,
            children: <Widget>[
              _buildTextTile("(", expand: false),
              _buildTextTile(")", expand: false),
              _buildTextTile("pi", forward: 2, expand: false),
            ],
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          sliver: SliverGrid.count(
            crossAxisCount: 3,
            children: <Widget>[
              _buildTextTile("ln", toInsert: "ln()", forward: 3, expand: false),
              _buildTextTile("log",
                  toInsert: "log()", forward: 4, expand: false),
              _buildTextTile("sqrt",
                  toInsert: "sqrt()", forward: 5, expand: false),
              _buildTextTile("sin",
                  toInsert: "sin()", forward: 4, expand: false),
              _buildTextTile("cos",
                  toInsert: "cos()", forward: 4, expand: false),
              _buildTextTile("tan",
                  toInsert: "tan()", forward: 4, expand: false),
            ],
          ),
        ),
      ],
    ).border(top: 2.0, color: TColors.darker);

    final height = MediaQuery.of(context).size.height;

    final root = DefaultTextStyle(
      style: getTextStyle(),
      child: Column(
        children: <Widget>[
          CupertinoNavigationBar(
            backgroundColor: CupertinoColors.black,
            trailing: CupertinoButton(
              child: Icon(CupertinoIcons.rectangle_stack, color: TColors.red),
              onPressed: _onHistory,
            ),
          ),
          Expanded(
            child: <Widget>[
              CupertinoTextField(
                controller: _controller,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    new RegExp(r"[ 0-9*\-\/\+\(\)a-z,]*"),
                  )
                ],
                style:
                    getTextStyle().copyWith(color: CupertinoColors.systemGrey),
                // Resets default decoration.
                decoration: BoxDecoration(),
                textAlign: TextAlign.end,
                padding:
                    const EdgeInsets.all(6.0) + EdgeInsets.only(bottom: 15.0),
              ),
              ValueListenableBuilder<MathResult>(
                valueListenable: _mathController,
                builder: _buildMathResult,
              ),
            ]
                .toColumn(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                )
                .padding(left: 40.0, right: 40.0)
                .alignment(Alignment(0, 0.5)),
          ),
          PageView(
            controller: _pageController,
            children: [page1, page2],
          ).height(height * 0.61803 - 15.0),
          ScrollingPageIndicator(
            dotColor: CupertinoColors.systemGrey,
            dotSelectedColor: CupertinoColors.white,
            dotSize: 7,
            dotSelectedSize: 10,
            dotSpacing: 15,
            controller: _pageController,
            itemCount: 2,
            orientation: Axis.horizontal,
          ).padding(bottom: 40.0),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: CupertinoColors.black,
      body: root,
    );
  }
}
