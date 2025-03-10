import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';

import 'app_text_field.dart';

typedef ItemSelectionCallBack = void Function(
    List<SelectedListItem> selectedItems);

typedef ListItemBuilder = Widget Function(int index);

typedef BottomSheetListener = bool Function(
    DraggableScrollableNotification draggableScrollableNotification);

class DropDown {
  /// This will give the list of data.
  final List<SelectedListItem> data;

  /// This will give the call back to the selected items from list.
  /// TODO: Remove [selectedItems] in next release

  @Deprecated('Change to onSelected')
  final ItemSelectionCallBack? selectedItems;

  final ItemSelectionCallBack? onSelected;

  /// [listItemBuilder] will gives [index] as a function parameter and you can return your own widget based on that item.
  final ListItemBuilder? listItemBuilder;

  /// This will give selection choice for single or multiple for list.
  final bool enableMultipleSelection;

  /// This will give the radio button visibility.
  final bool showRadioButton;

  /// This gives the bottom sheet title.
  final Widget? bottomSheetTitle;

  /// You can set your custom submit button when the multiple selection is enabled.
  final Widget? submitButtonChild;

  /// You can set your custom clear button when the multiple selection is enabled.
  final Widget? clearButtonChild;

  /// [searchWidget] is use to show the text box for the searching.
  /// If you are passing your own widget then you must have to add [TextEditingController] for the [TextFormField].
  final TextFormField? searchWidget;

  /// [isSearchVisible] flag use to manage the search widget visibility
  /// by default it is [True] so widget will be visible.
  final bool isSearchVisible;

  /// [isSelectAllVisible] flag use to manage the select all widget visibility.
  /// by default it is [True] so widget will be visible.
  /// Required [enableMultipleSelection] to be true.
  final bool isSelectAllVisible;

  final InputDecoration? searchInputDecoration;

  /// You can set your custom select all text button when the multiple selection and isSelectAllVisible is enabled.
  final Widget? selectAllTextButtonChild;

  /// You can set your custom deselect all text button when the multiple selection and isSelectAllVisible is enabled.
  final Widget? deSelectAllTextButtonChild;

  /// This will set the background color to the dropdown.
  final Color dropDownBackgroundColor;

  /// [searchHintText] is use to show the hint text into the search widget.
  /// by default it is [Search] text.
  final String? searchHintText;

  /// This will be the fill color to the input.
  /// by default it is [Colors.black12] color.
  final Color? searchFillColor;

  /// This will be the cursor color to the input.
  /// by default it is [Colors.black] color.
  final Color? searchCursorColor;

  /// [isDismissible] Specifies whether the bottom sheet will be dismissed when user taps on the scrim.
  /// If true, the bottom sheet will be dismissed when user taps on the scrim.
  /// by default it is [True].
  final bool isDismissible;

  /// [bottomSheetListener] that listens for BottomSheet bubbling up the tree.
  final BottomSheetListener? bottomSheetListener;

  /// Specifies whether a modal bottom sheet should be displayed using the root navigator.
  /// by default it is [False].
  final bool useRootNavigator;

  /// Number of items that can be selected when multiple selection is enabled.
  final int? maxSelectedItems;
  
  /// Internal Padding for item List
  final EdgeInsetsGeometry? itemPadding;

  /// Internal Padding for container
  final EdgeInsetsGeometry? containerPadding;

  final Widget? dividerWidget;

  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;

  final bool showSubtitle;
  

  DropDown({
    Key? key,
    required this.data,
    this.maxSelectedItems,
    this.selectedItems,
    this.itemPadding,
    this.containerPadding,
    this.onSelected,
    this.listItemBuilder,
    this.enableMultipleSelection = false,
    this.showRadioButton = false,
    this.bottomSheetTitle,
    this.isDismissible = true,
    this.showSubtitle = false,
    this.submitButtonChild,
    this.clearButtonChild,
    this.searchWidget,
    this.searchHintText = 'Search',
    this.searchFillColor = Colors.black12,
    this.searchCursorColor = Colors.black,
    this.searchInputDecoration,
    this.isSearchVisible = true,
    this.isSelectAllVisible = true,
    this.selectAllTextButtonChild,
    this.deSelectAllTextButtonChild,
    this.dropDownBackgroundColor = Colors.transparent,
    this.bottomSheetListener,
    this.useRootNavigator = false,
    this.dividerWidget,
    this.titleTextStyle,
    this.subtitleTextStyle
  });
}

class DropDownState {
  DropDown dropDown;
  double? heightOfBottomSheet;

  DropDownState(this.dropDown, {this.heightOfBottomSheet = 600});

  /// This gives the bottom sheet widget.
  void showModal(context) {
    showModalBottomSheet(
      useRootNavigator: dropDown.useRootNavigator,
      constraints: BoxConstraints.loose(
          Size(MediaQuery.of(context).size.width, heightOfBottomSheet!)),
      // <= this is set to 3/4 of screen size.
      isScrollControlled: true,
      enableDrag: dropDown.isDismissible,
      isDismissible: dropDown.isDismissible,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets, 
              child: MainBody(dropDown: dropDown)
            );
          },
        );
      },
    );
  }
}

/// This is main class to display the bottom sheet body.
class MainBody extends StatefulWidget {
  final DropDown dropDown;

  const MainBody({required this.dropDown, super.key});

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  /// This list will set when the list of data is not available.
  List<SelectedListItem> mainList = [];

  @override
  void initState() {
    super.initState();
    mainList = widget.dropDown.data;
    _setSearchWidgetListener();
  }

  @override
  Widget build(BuildContext context) {
    final isSelectAll = mainList.fold(true, (p, e) => p && (e.isSelected));

    return NotificationListener<DraggableScrollableNotification>(
      onNotification: widget.dropDown.bottomSheetListener,
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.13,
        maxChildSize: 0.9,
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            color: widget.dropDown.dropDownBackgroundColor,
            padding: widget.dropDown.containerPadding,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// Bottom sheet title text
                      Expanded(
                          child:
                              widget.dropDown.bottomSheetTitle ?? Container()),

                      /// Done button
                      Visibility(
                        visible: widget.dropDown.enableMultipleSelection,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              List<SelectedListItem> selectedList = widget
                                  .dropDown.data
                                  .where((element) => element.isSelected)
                                  .toList();
                              List<SelectedListItem> selectedNameList = [];

                              for (var element in selectedList) {
                                selectedNameList.add(element);
                              }

                              // ignore: deprecated_member_use_from_same_package
                              (widget.dropDown.selectedItems ??
                                      widget.dropDown.onSelected)
                                  ?.call(selectedNameList);
                              _onUnFocusKeyboardAndPop();
                            },
                            child: widget.dropDown.submitButtonChild ??
                                const Text('Done'),
                          ),
                        ),
                      ),
                      widget.dropDown.enableMultipleSelection
                          ? Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  for (final element in mainList) {
                                    element.isSelected = false;
                                  }
                                  setState(() {});
                                },
                                child: widget.dropDown.clearButtonChild ??
                                    const Text('Clear'),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),

                /// A [TextField] that displays a list of suggestions as the user types with clear button.
                Visibility(
                  visible: widget.dropDown.isSearchVisible,
                  child: widget.dropDown.searchWidget ??
                      AppTextField(
                        dropDown: widget.dropDown,
                        onTextChanged: _buildSearchList,
                        searchHintText: widget.dropDown.searchHintText,
                        searchFillColor: widget.dropDown.searchFillColor,
                        searchCursorColor: widget.dropDown.searchCursorColor,
                        searchInputDecoration: widget.dropDown.searchInputDecoration,
                      ),
                ),

                /// Select or Deselect TextButton when enableMultipleSelection is enabled
                if (widget.dropDown.enableMultipleSelection &&
                    widget.dropDown.isSelectAllVisible &&
                    mainList.isNotEmpty)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: TextButton(
                        onPressed: () => setState(() {
                          for (var element in mainList) {
                            element.isSelected = !isSelectAll;
                          }
                        }),
                        child: isSelectAll
                            ? widget.dropDown.deSelectAllTextButtonChild ??
                                const Text('Deselect All')
                            : widget.dropDown.selectAllTextButtonChild ??
                                const Text('Select All'),
                      ),
                    ),
                  ),

                /// Listview (list of data with check box for multiple selection & on tile tap single selection)
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: mainList.length,
                    padding: widget.dropDown.itemPadding ?? EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      bool isSelected = mainList[index].isSelected;
                      return Container(
                        color: widget.dropDown.dropDownBackgroundColor,
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.all(0.0),
                              onTap: () {
                                if (widget.dropDown.enableMultipleSelection) {
                                  if (!isSelected &&
                                      widget.dropDown.maxSelectedItems != null) {
                                    if (mainList
                                            .where((e) => e.isSelected)
                                            .length >=
                                        widget.dropDown.maxSelectedItems!) {
                                      return;
                                    }
                                  }
                                  setState(() {
                                    mainList[index].isSelected = !isSelected;
                                  });
                                } else {
                                  // ignore: deprecated_member_use_from_same_package
                                  (widget.dropDown.selectedItems ??
                                          widget.dropDown.onSelected)
                                      ?.call([mainList[index]]);
                                  _onUnFocusKeyboardAndPop();
                                }
                              },
                              title:
                                  widget.dropDown.listItemBuilder?.call(index) ??
                                      Text(
                                        mainList[index].name,
                                        style: widget.dropDown.titleTextStyle,
                                      ),
                              subtitle: widget.dropDown.showSubtitle == true && mainList[index].subtitle != null ?
                                      Text(
                                        mainList[index].subtitle!,
                                        style: widget.dropDown.subtitleTextStyle,
                                      ) 
                                      : null,
                              trailing: widget.dropDown.enableMultipleSelection
                                  ? isSelected
                                      ? const Icon(Icons.check_box)
                                      : const Icon(Icons.check_box_outline_blank)
                                  : widget.dropDown.enableMultipleSelection == false && widget.dropDown.showRadioButton
                                    ? isSelected
                                      ? const Icon(Icons.radio_button_on_outlined)
                                      : const Icon(Icons.radio_button_off_outlined)
                                  : const SizedBox.shrink(),
                            ),
                            widget.dropDown.dividerWidget ?? const SizedBox.shrink()
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// This helps when search enabled & show the filtered data in list.
  _buildSearchList(String userSearchTerm) {
    final results = widget.dropDown.data
        .where((element) =>
            element.name.toLowerCase().contains(userSearchTerm.toLowerCase()) || (element.subtitle != null && element.subtitle!.toLowerCase().contains(userSearchTerm.toLowerCase())))
        .toList();
    if (userSearchTerm.isEmpty) {
      mainList = widget.dropDown.data;
    } else {
      mainList = results;
    }
    setState(() {});
  }

  /// This helps to UnFocus the keyboard & pop from the bottom sheet.
  _onUnFocusKeyboardAndPop() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }

  void _setSearchWidgetListener() {
    TextFormField? searchField = widget.dropDown.searchWidget;
    searchField?.controller?.addListener(() {
      _buildSearchList(searchField.controller?.text ?? '');
    });
  }
}
