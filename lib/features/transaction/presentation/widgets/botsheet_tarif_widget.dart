// import 'package:flutter/material.dart';
// import '../../../../../core/design_system/tokens/app_colors.dart';
// import '../../../../../core/design_system/tokens/app_typography.dart';
// import '../../../home/data/models/tarif/tarif_model.dart';

// class BottomSheetTarifParkir extends StatelessWidget {
//   final List<TarifModel> tarifList;
//   final bool isFree;
//   final Function(TarifModel) onTap;

//   const BottomSheetTarifParkir({
//     super.key,
//     required this.tarifList,
//     required this.isFree,
//     required this.onTap,
//   });

//   static void show(
//     BuildContext context, {
//     required List<TarifModel> tarifList,
//     required bool isFree,
//     required Function(TarifModel) onTap,
//   }) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return BottomSheetTarifParkir(
//           tarifList: tarifList,
//           isFree: isFree,
//           onTap: onTap,
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Container(
//       padding: const EdgeInsets.fromLTRB(
//         16,
//         16,
//         16,
//         24,
//       ), // 🚀 UX: Padding bawah lebih besar untuk area aman (Safe Area)
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 40,
//             height: 4,
//             margin: const EdgeInsets.only(bottom: 16),
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),

//           const Text("Pilih Tarif Parkir", style: AppTypography.heading5),
//           const SizedBox(height: 16),
//           ConstrainedBox(
//             constraints: BoxConstraints(
//               maxHeight: screenHeight * 0.4, // Maksimal 40% dari tinggi layar
//             ),
//             child: Scrollbar(
//               radius: const Radius.circular(8),
//               thickness: 4,
//               child: ListView.separated(
//                 shrinkWrap: true,
//                 physics: const BouncingScrollPhysics(),
//                 itemCount: tarifList.length,
//                 separatorBuilder: (_, __) =>
//                     const Divider(color: AppColors.border),
//                 itemBuilder: (context, index) {
//                   final item = tarifList[index];

//                   return ListTile(
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                     ), // Sedikit padding agar text tidak menempel ke garis pinggir
//                     title: Text(
//                       item.jenisTarif,
//                       style: AppTypography.bodySemiBold,
//                     ),
//                     subtitle: Text(
//                       isFree ? "Rp0 (GRATIS)" : "Rp ${item.tarif.toInt()}",
//                       style: AppTypography.caption.copyWith(
//                         color: isFree ? Colors.green : AppColors.textSecondary,
//                       ),
//                     ),
//                     onTap: () {
//                       onTap(item);
//                       Navigator.pop(context);
//                     },
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
