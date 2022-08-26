import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_forms/models/app_form_state.dart';

class FormInput extends HookWidget {
  const FormInput({
    required this.formState,
    required this.formStateKey,
    required this.labelText,
    required this.validator,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters = const [],
    this.textInputType = TextInputType.text,
    this.maxLines = 1,
    this.readOnly,
    this.obscureText = false,
    this.errorColor = Colors.red,
    this.focusBorderColor = const Color(0xFF000000),
    this.obscureIconColor,
    this.onChanged,
    this.prefixIcon,
    this.fontSize,
    this.textStyle,
    this.contentPadding,
    this.isCollapsed = false,
    this.isDense,
    this.textAlignVertical,
    Key? key,
  }) : super(key: key);

  final AppFormState formState;
  final String formStateKey;

  final bool? isDense;
  final int maxLines;
  final bool? readOnly;
  final String labelText;
  final bool obscureText;
  final double? fontSize;
  final bool isCollapsed;
  final Widget? prefixIcon;
  final TextStyle? textStyle;
  final EdgeInsets? contentPadding;
  final TextInputType textInputType;
  final Iterable<String>? autofillHints;
  final TextAlignVertical? textAlignVertical;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter> inputFormatters;

  final Color errorColor;
  final Color? obscureIconColor;
  final Color focusBorderColor;

  final Function(String? val)? onChanged;
  final String? Function(String? val)? validator;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final toggleHidePassword = useState(obscureText);
    return ValueListenableBuilder(
      valueListenable: formState.getNotifier(formStateKey),
      builder: (context, value, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.text = formState[formStateKey].toString();
          controller.selection = TextSelection.fromPosition(
            TextPosition(
              offset: controller.text.length,
            ),
          );
        });

        return TextFormField(
          controller: controller,
          readOnly: readOnly ?? false,
          keyboardType: textInputType,
          maxLines: maxLines,
          autocorrect: false,
          obscureText: toggleHidePassword.value,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          autofillHints: autofillHints,
          style: textStyle ??
              TextStyle(
                fontSize: fontSize,
              ),
          textAlignVertical: textAlignVertical,
          decoration: InputDecoration(
            isDense: isDense,
            isCollapsed: isCollapsed,
            contentPadding: contentPadding,
            prefixIcon: prefixIcon,
            suffixIcon: obscureText
                ? IconButton(
                    onPressed: () {
                      toggleHidePassword.value = !toggleHidePassword.value;
                    },
                    icon: Icon(
                      toggleHidePassword.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: obscureIconColor,
                    ),
                  )
                : null,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: labelText,
            labelStyle: const TextStyle(
              color: Colors.black87,
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: errorColor,
                width: 2.0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: errorColor,
                width: 2.0,
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 0.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: focusBorderColor,
                width: 2.0,
              ),
            ),
            fillColor: Colors.white,
            filled: true,
          ),
          onChanged: (String? val) {
            onChanged?.call(val);
            formState.updateFormOnly(formStateKey, val!);
          },
          validator: validator,
        );
      },
    );
  }
}
