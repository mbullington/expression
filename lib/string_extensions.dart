
extension StringExtensions on String {
  String replace(int index, [String toReplaceWith = ""]) {
    if (index == length - 1) {
      // Special case.
      return substring(0, index) + toReplaceWith;
    }

    return substring(0, index) + toReplaceWith + substring(index + 1);
  }

  String remove(int index) => replace(index);

  String insert(int index, String toInsert) {
    if (index == 0) {
      return toInsert + this;
    }

    if (index == length) {
      return this + toInsert;
    }

    return substring(0, index) + toInsert + substring(index);
  }
}