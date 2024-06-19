import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lakasir/utils/colors.dart';

class MyBottomBarActions {
  const MyBottomBarActions({
    required this.onPressed,
    this.icon,
    this.label,
  });

  final void Function() onPressed;
  final Icon? icon;
  final String? label;
}

//   @override
//   Widget build(BuildContext context) {
//     return SpeedDialChild(
//       backgroundColor: error,
//     );
//     return Container(
//       margin: const EdgeInsets.only(top: 25),
//       child: Row(
//         children: [
//           MaterialButton(
//             minWidth: 0,
//             height: 0,
//             padding: const EdgeInsets.all(0),
//             onPressed: onPressed,
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(20)),
//             ),
//             child: Container(
//               padding: const EdgeInsets.all(15),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(9999),
//                 color: error,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     blurRadius: 1,
//                     spreadRadius: 1,
//                     offset: const Offset(2, 2),
//                     blurStyle: BlurStyle.normal,
//                   ),
//                 ],
//               ),
//               child: icon!,
//             ),
//           ),
//           InkWell(
//             onTap: onPressed,
//             splashColor: Colors.transparent,
//             highlightColor: Colors.transparent,
//             child: Container(
//               margin: const EdgeInsets.only(left: 10),
//               padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.7),
//                 borderRadius: BorderRadius.circular(3),
//               ),
//               child: Text(
//                 label!,
//                 style: const TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
