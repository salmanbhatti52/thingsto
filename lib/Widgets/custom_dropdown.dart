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

  const CustomDropdown({
    super.key,
    required this.itemList,
    required this.hintText,
    this.initialValue,
    required this.onChanged,
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialValue;
  }

  @override
  void didUpdateWidget(CustomDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.itemList != oldWidget.itemList) {
      setState(() {
        if (!widget.itemList.contains(_selectedItem)) {
          _selectedItem = null;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: DropdownButtonFormField<String>(
        icon: SvgPicture.asset(AppAssets.dropDown, width: 10,),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColor.secondaryColor,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            borderSide: BorderSide(
              color: AppColor.borderColor,
              width: 1,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            borderSide: BorderSide(
              color: AppColor.borderColor,
              width: 1,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            borderSide: BorderSide(
              color: AppColor.borderColor,
              width: 1,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            borderSide: BorderSide(
              color: AppColor.borderColor,
              width: 1,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          hintText: widget.hintText,
          hintStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColor.hintColor,
            fontWeight: FontWeight.w400,
          ),
          errorStyle: const TextStyle(
            fontSize: 14,
            color: AppColor.hintColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        borderRadius: BorderRadius.circular(10),
        items: widget.itemList.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: _selectedItem != null
                    ? AppColor.hintColor
                    : AppColor.blackColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        }).toList(),
        value: _selectedItem,
        onChanged: (value) {
          setState(() {
            _selectedItem = value;
            widget.onChanged(_selectedItem);
          });
          debugPrint("selectedItem: $_selectedItem");
        },
      ),
    );
  }
}
