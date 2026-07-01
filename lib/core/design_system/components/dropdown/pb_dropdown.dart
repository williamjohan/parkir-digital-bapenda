import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';

class PbDropdown<T> extends StatefulWidget {
  final String? title;
  final String? hintText;

  /// value yang dipilih
  final T? value;

  /// OPTIONAL items (kalau mau dropdown default)
  final List<T>? items;

  /// label builder
  final String Function(T item)? itemLabel;

  /// callback kalau pakai dropdown default
  final void Function(T value)? onChanged;

  /// CUSTOM ON TAP (misalnya buka bottomsheet sendiri)
  final VoidCallback? onTap;

  final Widget? prefix;
  final Widget? suffix;

  final bool enabled;
  final String? errorText;

  const PbDropdown({
    super.key,
    this.title,
    this.hintText,
    this.value,
    this.items,
    this.itemLabel,
    this.onChanged,
    this.onTap,
    this.prefix,
    this.suffix,
    this.enabled = true,
    this.errorText,
  });

  @override
  State<PbDropdown<T>> createState() => _PbDropdownState<T>();
}

class _PbDropdownState<T> extends State<PbDropdown<T>> {
  bool _isFocused = false;

  bool get _hasError =>
      widget.errorText != null && widget.errorText!.isNotEmpty;

  bool get _hasValue => widget.value != null;

  Color get _fillColor {
    if (_isFocused || _hasValue) {
      return Colors.white;
    }
    return AppColors.surface;
  }

  void _handleTap() {
    if (!widget.enabled) return;

    /// PRIORITY: custom onTap dulu
    if (widget.onTap != null) {
      widget.onTap!();
      return;
    }

    /// fallback: default dropdown behavior
    if (widget.items == null || widget.itemLabel == null) return;

    setState(() => _isFocused = true);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: widget.items!.length,
          itemBuilder: (context, index) {
            final item = widget.items![index];

            return ListTile(
              title: Text(widget.itemLabel!(item)),
              onTap: () {
                widget.onChanged?.call(item);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() => _isFocused = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayText = widget.value == null
        ? null
        : widget.itemLabel != null
        ? widget.itemLabel!(widget.value as T)
        : widget.value.toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null && widget.title!.isNotEmpty) ...[
          Text(
            widget.title!,
            style: AppTypography.bodyRegular.copyWith(
              color: widget.enabled ? Colors.black : AppColors.disabled,
            ),
          ),
          const SizedBox(height: 4),
        ],

        GestureDetector(
          onTap: _handleTap,
          child: AbsorbPointer(
            child: TextField(
              readOnly: true,
              enabled: widget.enabled,
              controller: TextEditingController(text: displayText),
              style: AppTypography.bodyRegular,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: AppTypography.bodyRegular.copyWith(
                  color: AppColors.textHint,
                ),
                prefixIcon: widget.prefix,
                suffixIcon:
                    widget.suffix ??
                    const Icon(Icons.keyboard_arrow_down_rounded),
                filled: true,
                fillColor: _fillColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                border: _border(),
                enabledBorder: _border(),
                focusedBorder: _focusedBorder(),
                errorBorder: _errorBorder(),
                focusedErrorBorder: _errorBorder(),
              ),
            ),
          ),
        ),

        if (_hasError) ...[
          const SizedBox(height: 6),
          Text(
            widget.errorText!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
      ],
    );
  }

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: _hasError ? AppColors.error : AppColors.border,
      ),
    );
  }

  OutlineInputBorder _focusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: _hasError ? AppColors.error : AppColors.primaryLight,
      ),
    );
  }

  OutlineInputBorder _errorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.error),
    );
  }
}
