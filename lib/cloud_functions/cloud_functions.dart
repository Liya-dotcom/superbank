import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_functions/cloud_functions.dart';



Future<String?> createPaystackCheckoutUrl({
  required String userEmail,
  required int paymentAmount,
}) async {
  final createCheckout = FirebaseFunctions.instanceFor(
    app: Firebase.app(),
  ).httpsCallable('createPaystackCheckout');

  try {
    final result = await createCheckout.call({
      'email': userEmail,
      'amount': paymentAmount,
    });

    final checkoutUrl = result.data?['checkoutUrl'] as String?;

    if (checkoutUrl == null || checkoutUrl.isEmpty) {
      throw Exception('createPaystackCheckout returned invalid checkoutUrl');
    }

    return checkoutUrl;
  } on FirebaseFunctionsException {
    rethrow;
  }
}
