
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter/material.dart';

import 'package:reactive_forms/reactive_forms.dart';


class ToggleState extends StateNotifier<bool> {
  ToggleState() : super(true);

  void toggle() {
    state = !state;
  }
}

final toggleProvider =
    StateNotifierProvider<ToggleState, bool>((ref) => ToggleState());


enum IconPosition {start,end}

class DynamicInput extends ConsumerWidget {
  const DynamicInput( {
    super.key,
    this.title,
    this.placeholderIcon,
    this.placeholderIconPosition = IconPosition.start,
    this.iconPosition = IconPosition.end,
    this.radius = 4,
    this.width = 300,
    this.height = 40,
    this.titleIcon,
    this.titleIconPosition = IconPosition.start,
    required this.placeholder,
    this.description,
    this.control,
    this.numreicFormat,
    this.dateFormat,
    this.multiLine = false,
    this.obscure = false,
    this.textInputAction = TextInputAction.next,
    this.crossAxisAlignment,
    this.autoFoucs = true,
    this.onchange,
    this.textDirection = TextDirection.ltr,
    this.validationMessages,
    this.lastDate,
    this.firstDate,
    this.inputFormatters
  });
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? control;
  final String? title;
  final Widget? titleIcon;
  final Widget? placeholderIcon;
  final Map<String, String Function(Object)>? validationMessages;
  final double radius;
  final double width;
  final double height;
  final IconPosition titleIconPosition;
  final IconPosition placeholderIconPosition;

  final String placeholder;
  final String? description;
  final intl.NumberFormat? numreicFormat;
  final intl.DateFormat? dateFormat;
  final bool? multiLine;
  final IconPosition iconPosition;
  final bool obscure;
  final TextInputAction? textInputAction;
  final TextDirection textDirection;
  final CrossAxisAlignment? crossAxisAlignment;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(FormControl<Object?>)? onchange;
  final bool autoFoucs;

  

  @override
  Widget build(BuildContext context, ref) {
    return ReactiveFormConsumer(
      builder: (BuildContext context, FormGroup formGroup, Widget? child) {
        bool enable = ref.watch(toggleProvider);

        return Column(
          crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    if (titleIconPosition == IconPosition.start &&
                        titleIcon != null)
                      titleIcon!,
                    Text(
                      title ?? '',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    if (titleIconPosition == IconPosition.end &&
                        titleIcon != null)
                      titleIcon!,
                  ],
                )),
             ReactiveTextField(
                 onChanged: onchange,                            
                 inputFormatters: inputFormatters,
                 autofocus: autoFoucs,
                 maxLines: multiLine == true ? 5 : 1,
                 style: Theme.of(context).textTheme.labelSmall,
                 formControlName: control,
                 keyboardType: TextInputType.text,
                 obscureText: obscure ? enable : false,
                 decoration: InputDecoration(
                   hintTextDirection:textDirection,
                   hintText: placeholder,
                   hintStyle: Theme.of(context).textTheme.bodyLarge,
                   contentPadding: const EdgeInsets.symmetric(
                       vertical: 10.0, horizontal: 16),
                   floatingLabelBehavior:
                       FloatingLabelBehavior.never,
                   suffixIcon:
                       placeholderIconPosition == IconPosition.start
                           ? placeholderIcon
                           : null,
                  
                   border: OutlineInputBorder(
                       borderSide: const BorderSide(
                           ),
                       borderRadius: BorderRadius.all(
                           Radius.circular(radius))),
                   fillColor:
                       Theme.of(context).colorScheme.onPrimary,
                   filled: true,
                 ),
                 validationMessages: validationMessages ??
                     {
                       ValidationMessage.required: (error) =>
                           'يرجى إدخال هذا الحقل',
                      
                     },
                 textInputAction: textInputAction,
                 textAlign: TextAlign.start,
                 textDirection: textDirection),
            description != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      description ?? '',
                      style: Theme.of(context).textTheme.labelSmall,
                      textDirection: TextDirection.ltr,
                    ),
                  )
                : const SizedBox()
          ],
        );
      },
    );
  }
}
