import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/features/absensi/check_list_absensi/data/models/absensi_model.dart';
import 'package:parkir_digital_bapenda/features/absensi/check_list_absensi/presentation/screens/absensi_checklist_screen.dart';
import 'package:parkir_digital_bapenda/features/absensi/check_list_absensi/presentation/widgets/main_absensi_widget.dart';

class HomeAbsensiTestSection extends StatefulWidget {
  const HomeAbsensiTestSection({super.key});

  @override
  State<HomeAbsensiTestSection> createState() => _HomeAbsensiTestSectionState();
}

class _HomeAbsensiTestSectionState extends State<HomeAbsensiTestSection> {
  // ==== dummy local state, ganti ke cubit state nanti ====
  bool isCheckedIn = false;
  bool isCheckedOut = false;

  DateTime? checkInTime;
  AbsensiCheckListModel? checkInChecklist;

  DateTime? checkOutTime;
  AbsensiCheckListModel? checkOutChecklist;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: MainAbsensiWidget(
        isCheckedIn: isCheckedIn,
        isCheckedOut: isCheckedOut,
        checkInTime: checkInTime,
        checkInChecklist: checkInChecklist,
        checkOutTime: checkOutTime,
        checkOutChecklist: checkOutChecklist,
        onTapCheckIn: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ShiftFormScreen(
              type: ShiftFormType.checkIn,
              onSubmit: (result) {
                setState(() {
                  isCheckedIn = true;
                  checkInTime = DateTime.now();
                  checkInChecklist = result.checklist;
                });
              },
            ),
          ),
        ),
        onTapCheckOut: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ShiftFormScreen(
              type: ShiftFormType.checkOut,
              onSubmit: (result) {
                setState(() {
                  isCheckedOut = true;
                  checkOutTime = DateTime.now();
                  checkOutChecklist = result.checklist;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
