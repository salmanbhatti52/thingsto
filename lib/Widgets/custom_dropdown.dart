import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';

// class CustomDropdown extends StatefulWidget {
//   final List<dynamic> itemList;
//   final String? initialValue;
//   final String hintText;
//   final Function(String?) onChanged;
//
//   const CustomDropdown({
//     super.key,
//     required this.itemList,
//     required this.hintText,
//     this.initialValue,
//     required this.onChanged,
//   });
//
//   @override
//   _CustomDropdownState createState() => _CustomDropdownState();
// }
//
// class _CustomDropdownState extends State<CustomDropdown> {
//   String? _selectedItem;
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedItem = widget.initialValue;
//   }
//
//   @override
//   void didUpdateWidget(CustomDropdown oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.itemList != oldWidget.itemList) {
//       setState(() {
//         if (!widget.itemList.contains(_selectedItem)) {
//           _selectedItem = null;
//         }
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width * 0.9,
//       height: MediaQuery.of(context).size.height * 0.058,
//       child: ButtonTheme(
//         alignedDropdown: true,
//         child: DropdownButtonHideUnderline(
//           child: DropdownButtonFormField(
//             icon: SvgPicture.asset(AppAssets.dropDown),
//             decoration: InputDecoration(
//               filled: true,
//               fillColor: AppColor.secondaryColor,
//               border: const OutlineInputBorder(
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(10),
//                 ),
//                 borderSide: BorderSide(
//                   color: AppColor.borderColor,
//                   width: 1,
//                 ),
//               ),
//               enabledBorder: const OutlineInputBorder(
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(10),
//                 ),
//                 borderSide: BorderSide(
//                   color: AppColor.borderColor,
//                   width: 1,
//                 ),
//               ),
//               focusedBorder: const OutlineInputBorder(
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(10),
//                 ),
//                 borderSide: BorderSide(
//                   color: AppColor.borderColor,
//                   width: 1,
//                 ),
//               ),
//               errorBorder: const OutlineInputBorder(
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(10),
//                 ),
//                 borderSide: BorderSide(
//                   color: AppColor.borderColor,
//                   width: 1,
//                 ),
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 15,
//                 vertical: 10,
//               ),
//               hintText: widget.hintText,
//               hintStyle: GoogleFonts.poppins(
//                 fontSize: 14,
//                 color: AppColor.hintColor,
//                 fontWeight: FontWeight.w400,
//               ),
//               errorStyle: const TextStyle(
//                 fontSize: 14,
//                 color: AppColor.hintColor,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//             borderRadius: BorderRadius.circular(10),
//             items: widget.itemList.map((item) {
//               return DropdownMenuItem<String>(
//                 value: item,
//                 child: Text(
//                   item,
//                   style: GoogleFonts.poppins(
//                     fontSize: 14,
//                     color: _selectedItem != null
//                         ? AppColor.hintColor
//                         : AppColor.blackColor,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               );
//             }).toList(),
//             value: _selectedItem,
//             onChanged: (value) {
//               setState(() {
//                 _selectedItem = value;
//                 widget.onChanged(_selectedItem);
//               });
//               debugPrint("selectedItem: $_selectedItem");
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

class CustomDropdown extends StatefulWidget {
  final List<dynamic> itemList;
  final String? initialValue;
  final String hintText;
  final Function(String?) onChanged;
  final Function()? onTap;

  const CustomDropdown({
    super.key,
    required this.itemList,
    required this.hintText,
    this.initialValue,
    this.onTap,
    required this.onChanged,
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  String? _selectedItem;
  List<dynamic> _filteredItemList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialValue;
    _filteredItemList = widget.itemList;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      if (_searchController.text.isEmpty) {
        _filteredItemList = widget.itemList;
      } else {
        _filteredItemList = widget.itemList
            .where((item) => item.toLowerCase().contains(_searchController.text.toLowerCase()))
            .toList();
      }
    });
  }

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _removeOverlay();
    }
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.itemList.length > 12)
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  ),
                ),
                SizedBox(
                  height: 200, // Adjust as needed
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: _filteredItemList.map((item) {
                      return ListTile(
                        title: Text(item),
                        onTap: () {
                          setState(() {
                            _selectedItem = item;
                            widget.onChanged(_selectedItem);
                          });
                          _removeOverlay();
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  @override
  void didUpdateWidget(CustomDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.itemList != oldWidget.itemList) {
      setState(() {
        if (!widget.itemList.contains(_selectedItem)) {
          _selectedItem = null;
        }
        _filteredItemList = widget.itemList;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: () {
          widget.itemList.isEmpty ? null : _toggleDropdown();
          if (widget.onTap != null) widget.onTap!();
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: AppColor.secondaryColor, // Update with your color
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColor.borderColor, // Update with your color
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedItem ?? widget.hintText,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey, // Update with your color
                  fontWeight: FontWeight.w400,
                ),
              ),
              SvgPicture.asset(AppAssets.dropDown, width: 10,),
            ],
          ),
        ),
      ),
    );
  }
}