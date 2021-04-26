import 'package:flutter/widgets.dart';

class ManualTextEditingController extends TextEditingController {
  ManualTextEditingController() : super(text: "") {
    value = value.copyWith(selection: TextSelection.collapsed(offset: 0));
  }

  void addText(String insertedText, [int forward = 1]) {
    final text = value.text;

    int baseOffset = value.selection.baseOffset;
    if (baseOffset == -1) {
      baseOffset = text.length;
    }

    value = value.copyWith(
      text: text.substring(0, baseOffset) +
          insertedText +
          text.substring(baseOffset),
      selection: TextSelection.collapsed(offset: baseOffset + forward),
    );
  }

  void remove([int trailing = 1]) {
    final text = value.text;

    int baseOffset = value.selection.baseOffset;
    if (baseOffset == -1) {
      baseOffset = text.length;
    }

    if (baseOffset == 0) {
      return;
    }

    value = value.copyWith(
      text:
          text.substring(0, baseOffset - trailing) + text.substring(baseOffset),
      selection: TextSelection.collapsed(offset: baseOffset - trailing),
    );
  }

  void clear() {
    text = "";
  }
}
