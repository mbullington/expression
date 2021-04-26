import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:math_expressions/math_expressions.dart';

import 'string_extensions.dart';

// doubleToString ported from platform_packages_apps_calculator.

final maxDigits = 12;
final roundingDigits = math.max(17 - maxDigits, 0);

String doubleToString(double result) {
  // https://github.com/hoijui/arity/blob/00cffe65b821041eecaa4e3fbb176251714afdc7/src/main/java/org/javia/arity/Util.java#L86
  final double absv = result.abs();
  String str = absv.toString();

  int roundingStart =
      (roundingDigits <= 0 || roundingDigits > 13) ? 17 : (16 - roundingDigits);

  int ePos = str.lastIndexOf('E');
  int exp = (ePos != -1) ? int.parse(str.substring(ePos + 1)) : 0;
  int len = ePos != -1 ? ePos : str.length;

  //remove dot
  int dotPos;
  for (dotPos = 0; dotPos < len && str[dotPos] != '.';) {
    ++dotPos;
  }
  exp += dotPos;
  if (dotPos < len) {
    str = str.remove(dotPos);
    --len;
  }

  //round
  for (int p = 0; p < len && str[p] == '0'; ++p) {
    ++roundingStart;
  }

  if (roundingStart < len) {
    if ((int.tryParse(str[roundingStart]) ?? 0) >= 5) {
      int p;
      for (p = roundingStart - 1; p >= 0 && str[p] == '9'; --p) {
        str = str.replace(p, '0');
      }
      if (p >= 0) {
        str = str.replace(p, ((int.tryParse(str[p]) ?? 0) + 1).toString());
      } else {
        str = str.insert(0, '1');
        ++roundingStart;
        ++exp;
      }
    }
  }

  //re-insert dot
  if ((exp < -5) || (exp > 10)) {
    str = str.insert(1, '.');
    --exp;
  } else {
    for (int i = len; i < exp; ++i) {
      str = str + '0';
    }
    for (int i = exp; i <= 0; ++i) {
      str = '0' + str;
    }
    str = str.insert((exp <= 0) ? 1 : exp, '.');
    exp = 0;
  }
  len = str.length;

  //remove trailing dot and 0s.
  int tail;
  for (tail = len - 1; tail >= 0 && str[tail] == '0'; --tail) {
    str = str.remove(tail);
  }
  if (tail >= 0 && str[tail] == '.') {
    str = str.remove(tail);
  }

  if (exp != 0) {
    str = str + 'E' + exp.toString();
  }
  if (result < 0) {
    str = '-' + str;
  }
  return str;
}

class MathResult {
  static const MathResult empty = MathResult(input: "", valid: false);

  final String input;
  final bool valid;

  final double result;

  const MathResult({
    @required this.input,
    @required this.valid,
    this.result,
  });
}

class MathController extends ValueNotifier<MathResult> {
  final Parser parser = Parser();
  final ContextModel model = ContextModel();

  final TextEditingController textController;

  MathController(this.textController) : super(MathResult.empty) {
    textController.addListener(_onUpdate);

    model.bindVariableName("pi", Number(math.pi));
  }

  void _onUpdate() {
    final input = textController.text;

    try {
      final exp = parser.parse(input);
      final double result = exp.evaluate(EvaluationType.REAL, model);

      value = MathResult(
        input: input,
        valid: true,
        result: result,
      );
    } catch (_) {
      value = MathResult(input: input, valid: false);
    }
  }
}
