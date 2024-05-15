import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rsa/input_filed.dart';
import 'package:rsa/message_domain.dart';
import 'package:rsa/providers.dart';

class DecodeMessagePage extends ConsumerWidget {
  const DecodeMessagePage({super.key, required this.message});
  final Message message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = FormGroup({
      "prKey": FormControl<String>(),
      "messag": FormControl<String>(),
      "messagList": FormControl<List<int>>()
    });
    return AlertDialog(
      content: ReactiveForm(
        formGroup: form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Message: ${message.message}"),
            const DynamicInput(
                control: "prKey",
                title: "Enter The Private Key",
                placeholder: ""),
            const SizedBox(
              height: 10,
            ),
            const Text("Message List int:"),
            Row(
              children: message.valuesMessageEncription.isEmpty
                  ? [
                      const SizedBox(
                        height: 35,
                      )
                    ]
                  : message.valuesMessageEncription
                      .map((e) => Container(
                            padding: const EdgeInsets.all(4),
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(4)),
                            child: Text(e.toString()),
                          ))
                      .toList(),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  final prKey = form.control("prKey").value?.toString() ?? "";
                  final listMessag = message.valuesMessageEncription;
                  final messageListUscii = ref
                      .read(encriptionStringByPublicKey((prKey, listMessag)));
                  form.control("messag").value =messageListUscii.length==1?messageListUscii.first.toString():
                      String.fromCharCodes(messageListUscii);
                  form.control("messagList").value = messageListUscii;
                },
                child: const Text("Decode")),
            const SizedBox(
              height: 10,
            ),
            const DynamicInput(
                multiLine: true,
                control: "messag",
                title: "Real Message",
                placeholder: ""),
            ReactiveFormConsumer(builder: (context, formGroup, child) {
              final encMessageList =
                  formGroup.control("messagList").value as List<int>? ?? [];

              return Row(
                children: encMessageList.isEmpty
                    ? [
                        const SizedBox(
                          height: 35,
                        )
                      ]
                    : encMessageList
                        .map((e) => Container(
                              padding: const EdgeInsets.all(4),
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(4)),
                              child: Text(e.toString()),
                            ))
                        .toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
