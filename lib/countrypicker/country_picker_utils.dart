import 'package:flutter/material.dart';

import '../src/bottomsheet/country_bottom_sheet.dart';
import 'CountryModel.dart';

class CountryPickerUtils {
  void showCountryPicker(
    BuildContext context, {
    required Function(CountryModel? value) onItemClick,
  }) {
    showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CountryBottomSheet(
          onItemClick: (value) {
            Navigator.of(context).pop();
            onItemClick(value);
          },
        );
      },
    );
  }
}
