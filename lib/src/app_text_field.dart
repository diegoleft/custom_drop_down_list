import 'package:flutter/material.dart';

import 'drop_down.dart';

/// This is search text field class.
class AppTextField extends StatefulWidget {
  final DropDown dropDown;
  final Function(String) onTextChanged;

  // [searchHintText] is use to show the hint text into the search widget.
  /// by default it is [Search] text.
  final String? searchHintText;
  final Color? searchFillColor;
  final Color? searchCursorColor;
  final InputDecoration? searchInputDecoration;

  const AppTextField({
    required this.dropDown,
    required this.onTextChanged,
    this.searchHintText,
    this.searchFillColor,
    this.searchCursorColor,
    this.searchInputDecoration,
    super.key,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        controller: _editingController,
        cursorColor: widget.searchCursorColor,
        onChanged: (value) {
          widget.onTextChanged(value);
        },
        decoration: widget.searchInputDecoration != null
        ? widget.searchInputDecoration!.copyWith(
          suffixIcon: GestureDetector(
            onTap: onClearTap,
            child: const Icon(
              Icons.cancel,
              color: Colors.grey,
            ),
          ),
        ) 
        : InputDecoration(
          filled: true,
          fillColor: widget.searchFillColor,
          contentPadding:
              const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 15),
          hintText: widget.searchHintText,
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          prefixIcon: const IconButton(
            icon: Icon(Icons.search),
            onPressed: null,
          ),
          suffixIcon: GestureDetector(
            onTap: onClearTap,
            child: const Icon(
              Icons.cancel,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  void onClearTap() {
    widget.onTextChanged("");
    _editingController.clear();
  }
}
