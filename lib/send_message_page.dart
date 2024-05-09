import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rsa/input_filed.dart';
import 'package:rsa/message_domain.dart';
import 'package:rsa/providers.dart';

final formProvider = Provider.autoDispose((ref) => FormGroup({
      "messag": FormControl<String>(),
      "messagInt": FormControl<List<int>>(),
      "publicKey": FormControl<String>(),
      "EncMessag": FormControl<String>(),
      "encMessageList": FormControl<List<int>>()
    }));

class SendMessagePage extends StatelessWidget {
  const SendMessagePage({super.key, required this.to});
  final To to;
  List<int> stringToAscii(String text) {
    List<int> asciiCodes = [];
    for (int i = 0; i < text.length; i++) {
      asciiCodes.add(text.codeUnitAt(i));
    }
    return asciiCodes;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("message to ${to.name}"),
      content: Consumer(builder: (context, ref, child) {
        return ReactiveForm(
          formGroup: ref.read(formProvider),
          child: ReactiveFormConsumer(builder: (context, formGroup, child) {
            return SizedBox(
              width: 500,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DynamicInput(
                        title: "message",
                        control: "messag",
                        description: "",
                        inputFormatters: [
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            if (newValue.text.length > 8) {
                              return oldValue;
                            } else {
                              return newValue;
                            }
                          })
                        ],
                        placeholder: ""),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      children: [
                        Text("Message in ascii Code: "),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ReactiveFormConsumer(builder: (context, formGroup, child) {
                      final message =
                          formGroup.control("messag").value?.toString() ?? "";
                      final messageList = stringToAscii(message);
                      return Row(
                        children: messageList.isEmpty
                            ? [
                                const SizedBox(
                                  height: 35,
                                )
                              ]
                            : messageList
                                .map((e) => Container(
                                      padding: const EdgeInsets.all(4),
                                      margin: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          color: Colors.blueAccent,
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: Text(e.toString()),
                                    ))
                                .toList(),
                      );
                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    DynamicInput(
                      placeholder: "",
                      title: "public key",
                      control: "publicKey",
                      description:
                          "enter public key from ${to == To.A ? "B" : "A"} user",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          final messageString =
                              formGroup.control("messag").value?.toString() ??
                                  "";
                          final publickKey = formGroup
                                  .control("publicKey")
                                  .value
                                  ?.toString() ??
                              "";
                          final messageList = stringToAscii(messageString);

                          final encriptionKey = ref.read(
                              encriptionStringByPublicKey(
                                  (publickKey, messageList)));
                          String encText = String.fromCharCodes(encriptionKey);
                          formGroup.control("EncMessag").value = encText;
                          formGroup.control("encMessageList").value = encriptionKey;
                        },
                        child: Text(
                            "Generate message Encr with public key of ${to.name}")),
                    const SizedBox(
                      height: 30,
                    ),
                    const DynamicInput(
                      title: "encode the message",

                      placeholder: "",
                      // multiLine: true,
                      control: "EncMessag",
                    ),
                    const Row(
                      children: [
                        Text("Enc Message in ascii Code: "),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ReactiveFormConsumer(builder: (context, formGroup, child) {
                      final encMessageList = formGroup
                              .control("encMessageList")
                              .value as List<int>? ??
                          [];

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
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: Text(e.toString()),
                                    ))
                                .toList(),
                      );
                    }),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          final pk = formGroup
                                  .control("publicKey")
                                  .value
                                  ?.toString() ??
                              "";
                          final encriptionList = formGroup
                                  .control("encMessageList")
                                  .value as List<int>? ??
                              [];
                          final encriptionMessage =
                              formGroup.control("EncMessag").value as String? ?? "";
                          final message = Message(
                              valuesMessageEncription: encriptionList,
                              message: encriptionMessage,
                              publicKey: pk,
                              to: to,
                              date: DateTime.now());
                          ref
                              .read(messageNotifierProvider(to).notifier)
                              .addMessage(message);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text("send")),
                  ],
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}
