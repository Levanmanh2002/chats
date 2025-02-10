import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/line_widget.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../main.dart';

class CustomTextField extends StatefulWidget {
  final String titleText;
  final String hintText;
  final String? labelText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final bool isPassword;
  final bool isStatus;
  final ValueChanged<String>? onChanged;
  final Function? onSubmit;
  final bool isEnabled;
  final int maxLines;
  final TextCapitalization capitalization;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextAlign textAlign;
  final bool isAmount;
  final bool isNumber;
  final bool showBorder;
  final double iconSize;
  final bool isPhone;
  final bool showStar;
  final double? borderRadius;
  final Color? colorStyle;
  final Color? colorBorder;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final List<TextInputFormatter>? formatter;
  final bool readOnly;
  final VoidCallback? onTap;
  final String Function(String)? onValidate;
  final Future<String> Function(String)? onValidateAsync;
  final int? maxLength;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final String errorText;
  final TextStyle? titleStyle;
  final String iconInput;
  final AlignmentGeometry? alignmentError;
  final Color? colorLine;
  final bool showLine;

  const CustomTextField({
    super.key,
    this.titleText = '',
    this.hintText = '',
    this.labelText,
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.isEnabled = true,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.maxLines = 1,
    this.onSubmit,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.capitalization = TextCapitalization.none,
    this.isPassword = false,
    this.isStatus = false,
    this.textAlign = TextAlign.start,
    this.isAmount = false,
    this.isNumber = false,
    this.showBorder = true,
    this.iconSize = 18,
    this.isPhone = false,
    this.showStar = true,
    this.borderRadius,
    this.colorStyle,
    this.colorBorder,
    this.fillColor,
    this.contentPadding,
    this.textStyle,
    this.hintStyle,
    this.formatter,
    this.readOnly = false,
    this.onTap,
    this.onValidate,
    this.maxLength,
    this.onValidateAsync,
    this.floatingLabelBehavior,
    this.errorText = '',
    this.titleStyle,
    this.iconInput = '',
    this.alignmentError,
    this.colorLine,
    this.showLine = true,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  final ValueNotifier<String> _validate = ValueNotifier<String>('');
  final ValueNotifier<bool> _obscureText = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _isStatus = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_updateLineColor);
  }

  void _updateLineColor() {
    if (widget.controller != null && widget.controller!.text.isNotEmpty) {
      _isStatus.value = true;
    } else {
      _isStatus.value = false;
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_updateLineColor);
    _validate.removeListener(_updateLineColor);
    _validate.dispose();
    _obscureText.dispose();
    _isStatus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.titleText.isNotEmpty
            ? Padding(
                padding: padding(bottom: 8),
                child: Row(
                  children: [
                    Text(widget.titleText, style: widget.titleStyle ?? StyleThemeData.size12Weight600()),
                    if (widget.showStar) ...[
                      SizedBox(width: 4.w),
                      Text('*', style: StyleThemeData.size12Weight600(color: appTheme.errorColor)),
                    ],
                  ],
                ),
              )
            : const SizedBox(),
        Row(
          children: [
            if (widget.iconInput.isNotEmpty) ...[
              ImageAssetCustom(imagePath: widget.iconInput, size: 20.w),
              SizedBox(width: 8.w),
            ],
            Flexible(
              child: ValueListenableBuilder<bool>(
                valueListenable: _obscureText,
                builder: (context, isObscured, child) {
                  return ValueListenableBuilder<String>(
                    valueListenable: _validate,
                    builder: (context, validateValue, child) {
                      return ValueListenableBuilder<bool>(
                        valueListenable: _isStatus,
                        builder: (context, statusSalue, child) {
                          return TextField(
                            maxLines: widget.maxLines,
                            controller: widget.controller,
                            readOnly: widget.readOnly,
                            onTap: widget.onTap,
                            focusNode: widget.focusNode,
                            textAlign: widget.textAlign,
                            style: widget.textStyle ?? StyleThemeData.size16Weight400(),
                            textInputAction: widget.inputAction,
                            keyboardType: widget.isAmount ? TextInputType.number : widget.inputType,
                            cursorColor: appTheme.appColor,
                            textCapitalization: widget.capitalization,
                            enabled: widget.isEnabled,
                            autofocus: false,
                            obscureText: widget.isPassword ? isObscured : false,
                            maxLength: widget.maxLength,
                            inputFormatters: widget.formatter ??
                                (widget.inputType == TextInputType.phone
                                    ? <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp('[0-9]'))]
                                    : widget.isAmount
                                        ? [FilteringTextInputFormatter.allow(RegExp(r'\d'))]
                                        : widget.isNumber
                                            ? [FilteringTextInputFormatter.allow(RegExp(r'\d'))]
                                            : null),
                            decoration: InputDecoration(
                              floatingLabelBehavior: widget.floatingLabelBehavior,
                              counterStyle: const TextStyle(height: double.minPositive),
                              counterText: "",
                              contentPadding: widget.contentPadding ?? padding(all: 16),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
                                borderSide: BorderSide(
                                  style: widget.showBorder ? BorderStyle.solid : BorderStyle.none,
                                  width: 1.w,
                                  color: (widget.errorText.isNotEmpty || validateValue.isNotEmpty)
                                      ? appTheme.errorColor
                                      : widget.colorBorder ?? appTheme.grayColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
                                borderSide: BorderSide(
                                  style: widget.showBorder ? BorderStyle.solid : BorderStyle.none,
                                  width: 1.w,
                                  color: (widget.errorText.isNotEmpty || validateValue.isNotEmpty)
                                      ? appTheme.errorColor
                                      : widget.colorBorder ?? appTheme.appColor,
                                ),
                              ),
                              border: widget.isEnabled == false
                                  ? InputBorder.none
                                  : OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
                                      borderSide: BorderSide(
                                        style: widget.showBorder ? BorderStyle.solid : BorderStyle.none,
                                        width: 1.w,
                                        color: (widget.errorText.isNotEmpty || validateValue.isNotEmpty)
                                            ? appTheme.errorColor
                                            : widget.colorBorder ?? appTheme.grayColor,
                                      ),
                                    ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
                                borderSide: BorderSide(
                                  style: widget.showBorder ? BorderStyle.solid : BorderStyle.none,
                                  width: 1.w,
                                  color: widget.colorBorder ?? appTheme.errorColor,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
                                borderSide: BorderSide(
                                  style: widget.showBorder ? BorderStyle.solid : BorderStyle.none,
                                  width: 1.w,
                                  color: widget.colorBorder ?? appTheme.errorColor,
                                ),
                              ),
                              isDense: true,
                              hintText: widget.hintText,
                              labelText: widget.labelText,
                              labelStyle: StyleThemeData.size12Weight400(color: appTheme.grayColor),
                              fillColor: widget.fillColor ?? appTheme.whiteColor,
                              hintStyle: widget.hintStyle ??
                                  StyleThemeData.size14Weight400(color: widget.colorStyle ?? appTheme.grayColor),
                              filled: true,
                              prefixIcon: (widget.prefixIcon != null) ? widget.prefixIcon : null,
                              suffixIcon: widget.isPassword
                                  ? IconButton(
                                      icon:
                                          SvgPicture.asset(isObscured ? IconsAssets.eyeSlashIcon : IconsAssets.eyeIcon),
                                      onPressed: _toggle,
                                    )
                                  : widget.isStatus
                                      ? IconButton(
                                          onPressed: null,
                                          icon: (widget.errorText.isEmpty && validateValue.isNotEmpty)
                                              ? SvgPicture.asset(IconsAssets.clearErrorIcon)
                                              : widget.errorText.isNotEmpty
                                                  ? SvgPicture.asset(IconsAssets.clearErrorIcon)
                                                  : (widget.errorText.isEmpty &&
                                                          validateValue.isEmpty &&
                                                          statusSalue == true)
                                                      ? SvgPicture.asset(IconsAssets.checkSuccessIcon)
                                                      : const SizedBox(),
                                        )
                                      : (widget.suffixIcon != null)
                                          ? widget.suffixIcon
                                          : null,
                            ),
                            onSubmitted: (text) => widget.nextFocus != null
                                ? FocusScope.of(context).requestFocus(widget.nextFocus)
                                : widget.onSubmit != null
                                    ? widget.onSubmit!(text)
                                    : null,
                            onChanged: (value) {
                              _onValidate(value);
                              return widget.onChanged?.call(value);
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        if (widget.showLine)
          ValueListenableBuilder<bool>(
              valueListenable: _isStatus,
              builder: (context, statusSalue, child) {
                return ValueListenableBuilder<String>(
                  valueListenable: _validate,
                  builder: (context, validateMessage, child) {
                    return LineWidget(
                      color: (widget.errorText.isEmpty && validateMessage.isNotEmpty)
                          ? appTheme.redColor
                          : widget.errorText.isNotEmpty
                              ? appTheme.redColor
                              : (widget.errorText.isEmpty && validateMessage.isEmpty && statusSalue == true)
                                  ? appTheme.greenColor
                                  : widget.colorLine ?? appTheme.appColor,
                    );
                  },
                );
              }),
        ValueListenableBuilder<String>(
          valueListenable: _validate,
          builder: (context, validateMessage, child) {
            return (widget.errorText.isEmpty && validateMessage.isNotEmpty)
                ? Padding(
                    padding: padding(top: 8.h),
                    child: Align(
                      alignment: widget.alignmentError ?? Alignment.centerLeft,
                      child: Text(
                        validateMessage,
                        style: StyleThemeData.size12Weight400(color: appTheme.errorColor),
                      ),
                    ),
                  )
                : widget.errorText.isNotEmpty
                    ? Padding(
                        padding: padding(top: 8.h),
                        child: Align(
                          alignment: widget.alignmentError ?? Alignment.centerLeft,
                          child: Text(
                            widget.errorText,
                            style: StyleThemeData.size12Weight400(color: appTheme.errorColor),
                          ),
                        ),
                      )
                    : const SizedBox();
          },
        ),
      ],
    );
  }

  void _toggle() {
    _obscureText.value = !_obscureText.value;
  }

  Future<void> _onValidate(String value) async {
    String validationMessage = '';
    if (widget.onValidate != null) {
      validationMessage = widget.onValidate!(value);
    } else if (widget.onValidateAsync != null) {
      validationMessage = await widget.onValidateAsync!(value);
    }
    if (_validate.value != validationMessage) {
      _validate.value = validationMessage;
    }
  }
}
