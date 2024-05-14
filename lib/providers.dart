import 'dart:convert';
import 'dart:math';
import 'package:fast_rsa/fast_rsa.dart';
import 'package:pointycastle/export.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsa/message_domain.dart';

final getRandomPrivteKeyAndPublicKeyPRovider =
    FutureProvider.autoDispose.family<(String, String), To>((ref, type) async {
  final random = Random.secure();
  final p = generateRandomPrime(50, 90);
  final q = generateRandomPrime(50, 90, otherThis: p);

  final n = p * q;
  final phi = (p - 1) * (q - 1);

  int e;
  do {
    e = random.nextInt(phi);
  } while (phi.gcd(e) != 1);

  final d = e.modInverse(phi);
  return ("${e}N$n", "${d}N$n");
});
final getRandomPrivteKeyAndPublicKeyValueProvider=StateProvider.family<(String, String)?,To>((ref,to) {
return null;
});
final messageNotifierProvider =
    StateNotifierProvider.family<MessageNotifier, List<Message>, To>(
        (ref, t) => MessageNotifier());

class MessageNotifier extends StateNotifier<List<Message>> {
  MessageNotifier() : super([]);
  addMessage(Message message) {
    state = [...state, message];
  }
}

final encriptionStringByPublicKey =
    StateProvider.family<List<int>, (String, List<int>)>((ref, params) {
  final plainTextList = params.$2;
  final publicKey = params.$1;
  if (!publicKey.contains("N")) {
    return [];
  }
  final pk = int.tryParse(publicKey.split("N").firstOrNull ?? "");
  final n = int.tryParse(publicKey.split("N").lastOrNull ?? "");
  if (pk == null || n == null) {
    return [];
  }
  List<int> encTextList = [];
  for (var element in plainTextList) {
    final m = BigInt.from(element);

    final nBig = BigInt.from(n);
    final result = (pow(m, pk));
    final c = result % nBig;
    encTextList.add(c.toInt());
  }

  return encTextList;
});
BigInt pow(BigInt base, int exponent) {
  BigInt result = BigInt.one;
  BigInt absExponent = BigInt.from(exponent.abs());
  while (absExponent > BigInt.zero) {
    if (absExponent.isOdd) {
      result *= base;
    }
    base *= base;
    absExponent >>= 1;
  }
  return exponent >= 0 ? result : BigInt.one ~/ result;
}

final decriptionStringByPrivateKey =
    FutureProvider.family<String, (To, String)>((ref, params) async {
  final message = params.$2;
  final privateKey =
      (await ref.read(getRandomPrivteKeyAndPublicKeyPRovider(params.$1).future))
          .$1;
  var result = await RSA.decryptPKCS1v15(message, privateKey);
  return result;
  // final decryptedCipher = RSAEngine()
  //   ..init(false, PrivateKeyParameter<RSAPrivateKey>(privateKey));
  // final decryptedBytes = decryptedCipher.process(utf8.encode(message));
  // final decryptedText = utf8.decode(decryptedBytes);
  // return decryptedText;
});

// Function to generate a random prime number greater than 100
// int generateRandomPrime() {
//   final random = Random.secure();
//   while (true) {
//     final number =
//         random.nextInt(10); // Generate a random number greater than 100
//     if (isPrime2(number) && number > 1) {
//       return number;
//     }
//   }
// }

// bool isPrime2(N) {
//   for (var i = 2; i <= N / i; ++i) {
//     if (N % i == 0) {
//       return false;
//     }
//   }
//   return true;
// }

// Function to check if a number is prime using the Miller-Rabin primality test
// bool isPrime(int n, {int k = 5}) {
//   if (n <= 1) return false;
//   if (n <= 3) return true;
//   if (n % 2 == 0) return false;

//   int r = 0, d = n - 1;
//   while (d % 2 == 0) {
//     d ~/= 2;
//     r++;
//   }

//   for (int i = 0; i < k; i++) {
//     int a = Random.secure().nextInt(n - 3) + 2;
//     int x = powMod(a, d, n);
//     if (x != 1 && x != n - 1) {
//       for (int j = 0; j < r - 1; j++) {
//         x = powMod(x, 2, n);
//         if (x == 1) return false;
//         if (x == n - 1) break;
//       }
//       if (x != n - 1) return false;
//     }
//   }
//   return true;
// }

// Function to calculate (a^b) % c
int powMod(int a, int b, int c) {
  int result = 1;
  a %= c;
  while (b > 0) {
    if (b % 2 == 1) {
      result = (result * a) % c;
    }
    b ~/= 2;
    a = (a * a) % c;
  }
  return result;
}

String encryptString(String plaintext, RSAPublicKey publicKey) {
  final encryptor = OAEPEncoding(RSAEngine())
    ..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));
  return base64.encode(encryptor.process(utf8.encode(plaintext)));
}

bool isPrime(int n) {
  if (n <= 1) return false;
  if (n <= 3) return true;

  if (n % 2 == 0 || n % 3 == 0) return false;

  for (int i = 5; i * i <= n; i += 6) {
    if (n % i == 0 || n % (i + 2) == 0) return false;
  }

  return true;
}

int generateRandomPrime(int min, int max, {int? otherThis}) {
  Random random = Random();
  int randomNumber = random.nextInt(max - min) + min;
  if (otherThis == null) {
    while (!isPrime(randomNumber)) {
      randomNumber = random.nextInt(max - min) + min;
    }
  } else {
    while (!isPrime(randomNumber) && randomNumber != otherThis) {
      randomNumber = random.nextInt(max - min) + min;
    }
  }

  return randomNumber;
}

final isValidePOrQNumbersProvider =
    Provider.autoDispose.family<bool, Object?>((ref, value) {
  print("----------->$value");
  final number = int.tryParse(value.toString()) ?? 0;
  if (number == 0 || number == 1) {
    return false;
  }
  if (!isPrime(number)) {
    return false;
  }
  return true;
});
