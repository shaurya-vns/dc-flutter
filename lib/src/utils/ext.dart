import 'dart:core';
import 'app_utils.dart';

extension ListExtensions<T> on List<T> {
  Iterable<T> whereWithIndex(bool test(T element, int index)) {
    final List<T> result = [];
    for (var i = 0; i < this.length; i++) {
      if (test(this[i], i)) {
        result.add(this[i]);
      }
    }
    return result;
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(
    RegExp(' +'),
    ' ',
  ).split(' ').map((str) => str.toCapitalized()).join(' ');
}

extension Blank on String? {
  bool isBlank() {
    return this == null ||
        this?.trim() == null ||
        this?.trim() == '' ||
        this?.trim().length == 0;
  }
}

extension StringCheck on String? {
  String check() {
    if (this?.trim() == '' || this == null) {
      return 'NA';
    }
    return this ?? '';
  }
}

double? toDouble(dynamic value) {
  if (value == null) return null;
  return double.tryParse(value.toString());
}

int? toInt(dynamic value) {
  if (value == null) return null;
  return int.tryParse(value.toString());
}
