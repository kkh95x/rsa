import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rsa/input_filed.dart';
import 'package:rsa/providers.dart';

final formProvider = Provider((ref) => FormGroup({
      "q": FormControl<int>(validators: [
        Validators.required,
        // Validators.any((value) => ref.read(isValidePOrQNumbersProvider(value)))
      ]),
      "p": FormControl<int>(validators: [
        Validators.required,
        // Validators.any((value) => ref.read(isValidePOrQNumbersProvider(value)))
      ]),
      "n": FormControl<int>(validators: [Validators.required]),
      "phi": FormControl<int>(validators: [Validators.required]),
      "e": FormControl<int>(
          validators: [Validators.required, Validators.min(2)]),
      "d": FormControl<int>(validators: [Validators.required]),
    }));

class GenerateRSAKEeysPage extends ConsumerWidget {
  const GenerateRSAKEeysPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text("Generate Public and Private Keys"),
      content: ReactiveForm(
          formGroup: ref.read(formProvider),
          child: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildQandPSectionWidget(),
                  SizedBox(
                    height: 10,
                  ),
                  _buildNandphiSectionWidget(context, ref),
                  SizedBox(
                    height: 10,
                  ),
                  buildEandDSectionWidget(context),
                  ReactiveFormConsumer(builder: (context, formGroup, child) {
                    return ElevatedButton(
                        onPressed: () {
                          final q = formGroup.control("q").value as int?;
                          final p = formGroup.control("p").value as int?;
                          final e = formGroup.control("e").value as int?;
                          if (q == null && p == null) {
                            showMessage(context, "enter q and p first");
                            return;
                          }
                          if (e == null) {
                            showMessage(context, "enter e first");
                            return;
                          }
                          final n = q! * p!;
                          final phi = (q - 1) * (p - 1);
                          if (checkGcd(e, phi) > 1 && e.gcd(phi) != 1) {
                            showMessage(context, "gcd(e,φ(n)) != 1");
                            return;
                          }
                          final d = e.modInverse(phi);
                          final keys = ("${e}N$n", "${d}N$n");
                          Navigator.of(context).pop(keys);
                          formGroup.reset();
                        },
                        child: Text("Procced"));
                  })
                ],
              ),
            ),
          )),
    );
  }

  showMessage(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Container buildEandDSectionWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white70)),
      child: ReactiveFormConsumer(
        builder: (context, formGroup, child) {
          final phi = formGroup.control("phi").value as int?;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Calculate e and d"),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              DynamicInput(
                placeholder: "Enter e",
                control: "e",
                description:
                    "e : gcd(e,φ(n)${phi == null ? "" : " = $phi"}) , 2<= e <  φ(n)${phi == null ? "" : " = $phi"})",
              ),
              SizedBox(
                height: 10,
              ),
              ReactiveFormConsumer(builder: (context, formGroup, child) {
                final e = formGroup.control("e").value as int?;

                return Text.rich(TextSpan(
                  text:
                      "e : ${e != null ? (phi != null) ? e > phi ? " e < φ(n) " : e.gcd(phi) == 1 ? e : " gcd($e,$phi) != 1" : "?" : "?"} ",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                ));
              }),
              Text.rich(TextSpan(
                  text: "d = e * d = 1 mod n",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                  children: [
                    TextSpan(
                      text:
                          " ${formGroup.control("e").value != null && phi != null && (formGroup.control("e").value < phi) && (formGroup.control("e").value as int).gcd(phi) == 1 ? " ${formGroup.control("e").value} * d = 1 mode ${phi} => d=${(formGroup.control("e").value as int).modInverse(phi)}" : ""}",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic,
                            fontSize: 14,
                          ),
                    ),
                  ])),
              SizedBox(
                height: 10,
              ),
            ],
          );
        },
      ),
    );
  }

  int checkGcd(int a, int b) {
    if (b == 0) {
      return a;
    } else {
      return checkGcd(b, a % b);
    }
  }

  Container _buildNandphiSectionWidget(BuildContext context, WidgetRef ref) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white70)),
      child: ReactiveFormConsumer(builder: (context, formGroup, child) {
        int? q;
        int? p;
        if (formGroup.control("q").valid &&
            formGroup.control("p").valid &&
            ref.read(
                isValidePOrQNumbersProvider(formGroup.control("p").value)) &&
            ref.read(
                isValidePOrQNumbersProvider(formGroup.control("q").value)) &&
            formGroup.control("p").value != formGroup.control("q").value) {
          q = formGroup.control("q").value as int? ?? 0;
          p = formGroup.control("p").value as int? ?? 0;
          formGroup.control("n").value = q * p;
          formGroup.control("phi").value = (p - 1) * (q - 1);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text("Calculate n and φ(n)"),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text.rich(TextSpan(
                text: "n = p * q  ",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                children: [
                  TextSpan(
                    text: " ${p != null && q != null ? "=> $p * $q =  " : ""}",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                  ),
                  TextSpan(
                    text: " ${p != null && q != null ? (p * q) : ""}",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                        ),
                  )
                ])),
            SizedBox(
              height: 5,
            ),
            Text.rich(TextSpan(
                text: "φ(n) = (p - 1) * (q - 1) ",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                children: [
                  TextSpan(
                    text:
                        " ${p != null && q != null ? "=> ($p - 1) * ($q - 1) = ( ${p - 1} ) * ( ${q - 1} ) = " : ""}",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                  ),
                  TextSpan(
                    text: " ${p != null && q != null ? (q - 1) * (p - 1) : ""}",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                        ),
                  )
                ]))
          ],
        );
      }),
    );
  }

  Container _buildQandPSectionWidget() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white70)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("q and p Two different prime numbers"),
          Row(
            children: [
              Expanded(
                child: DynamicInput(
                    description: "q must to be prime number",
                    control: "q",
                    inputFormatters: [
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final number = int.tryParse(newValue.text.toString());
                        if (number == null) {
                          if (newValue.text.isEmpty) {
                            return newValue;
                          }
                          return TextEditingValue();
                        } else {
                          return newValue;
                        }
                      })
                    ],
                    placeholder: "Enter q"),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: DynamicInput(
                    description: "p must to be prime number",
                    control: "p",
                    inputFormatters: [
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final number = int.tryParse(newValue.text.toString());
                        if (number == null) {
                          if (newValue.text.isEmpty) {
                            return newValue;
                          }
                          return TextEditingValue();
                        } else {
                          return newValue;
                        }
                      })
                    ],
                    placeholder: "Enter p"),
              )
            ],
          ),
        ],
      ),
    );
  }
}
