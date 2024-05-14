import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsa/decode_message_page.dart';
import 'package:rsa/generate_rsa_keys_page.dart';
import 'package:rsa/message_domain.dart';
import 'package:rsa/send_message_page.dart';
import 'package:rsa/providers.dart';

class UserBHomePage extends ConsumerWidget {
  const UserBHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rsaKeys =
        ref.watch(getRandomPrivteKeyAndPublicKeyValueProvider(To.B));
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.all(50),
            decoration: const BoxDecoration(
                color: Colors.cyan,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black, offset: Offset(2, 2), blurRadius: 22)
                ]),
            child: Text(
              "B",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Public Key : ",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Row(
                children: [
                  SelectableText(rsaKeys?.$2.toString() ?? " "),
                  const SizedBox(
                    width: 2,
                  ),
                  IconButton(
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: rsaKeys?.$1 ?? " "));
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                backgroundColor: Colors.black,
                                content: Text(
                                  "The text has been copied to the clipboard",
                                  style: TextStyle(color: Colors.white38),
                                )));
                      },
                      icon: const Icon(
                        Icons.copy,
                        color: Colors.white38,
                        size: 20,
                      ))
                ],
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Private Key : ",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Row(
                children: [
                  SelectableText(rsaKeys?.$1.toString() ?? ""),
                  const SizedBox(
                    width: 2,
                  ),
                  IconButton(
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: rsaKeys?.$2 ?? " "));
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                backgroundColor: Colors.black,
                                content: Text(
                                  "The text has been copied to the clipboard",
                                  style: TextStyle(color: Colors.white38),
                                )));
                      },
                      icon: const Icon(
                        Icons.copy,
                        color: Colors.white38,
                        size: 20,
                      ))
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                ref
                        .read(getRandomPrivteKeyAndPublicKeyValueProvider(To.B)
                            .notifier)
                        .state =
                    await ref.read(
                        getRandomPrivteKeyAndPublicKeyPRovider(To.B).future);
              },
              child: const Text("Generate Random Key")),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return GenerateRSAKEeysPage();
                  },
                ).then((value) {
                  if (value is (String, String)) {
                    ref
                        .read(getRandomPrivteKeyAndPublicKeyValueProvider(To.B)
                            .notifier)
                        .state = value;
                  }
                });
              },
              child: const Text("Generate Manual Key")),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => const SendMessagePage(
                          to: To.A,
                        ));
              },
              child: const Text("Send Message")),
          Row(
            children: [
              Text(
                "Messages  ",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 200,
            child: Consumer(builder: (context, ref, child) {
              List<Message> messages = ref.watch(messageNotifierProvider(To.B));
              if (messages.isEmpty) {
                return const Card(
                  child: Center(
                    child: Text("No Messages"),
                  ),
                );
              }
              messages.sort(
                (a, b) => a.date.compareTo(b.date),
              );
              return Card(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: messages.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.cyan,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          "B",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                        ),
                      ),
                      title: Text(messages[index].message),
                      trailing: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return DecodeMessagePage(
                                    message: messages[index]);
                              },
                            );
                          },
                          child: const Text("decode the message")),
                    );
                  },
                ),
              );
            }),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
