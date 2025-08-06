import 'package:cloud_functions/cloud_functions.dart';

class FirebaseFunctionsService {
  final FirebaseFunctions _functions;

  FirebaseFunctionsService() : _functions = FirebaseFunctions.instance;

  // Set the emulator location if developing locally
  void useLocalEmulator() {
    _functions.useFunctionsEmulator('localhost', 5001);
  }

  // Function to process money transfer
  Future<Map<String, dynamic>> processTransfer({
    required String senderId,
    required String recipientId,
    required double amount,
    required String description,
    bool isInstant = true,
  }) async {
    try {
      final HttpsCallable callable = _functions.httpsCallable(
        'processTransfer',
      );

      final result = await callable.call(<String, dynamic>{
        'senderId': senderId,
        'recipientId': recipientId,
        'amount': amount,
        'description': description,
        'isInstant': isInstant,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return result.data;
    } on FirebaseFunctionsException catch (e) {
      throw _handleFirebaseError(e);
    } catch (e) {
      throw Exception('Transfer failed: ${e.toString()}');
    }
  }

  // Function to get transfer history
  Future<List<Map<String, dynamic>>> getTransferHistory(String userId) async {
    try {
      final HttpsCallable callable = _functions.httpsCallable(
        'getTransferHistory',
      );

      final result = await callable.call(<String, dynamic>{
        'userId': userId,
      });

      return List<Map<String, dynamic>>.from(result.data);
    } on FirebaseFunctionsException catch (e) {
      throw _handleFirebaseError(e);
    }
  }

  String _handleFirebaseError(FirebaseFunctionsException e) {
    switch (e.code) {
      case 'invalid-argument':
        return 'Invalid transfer details provided';
      case 'permission-denied':
        return 'You don\'t have permission to perform this transfer';
      case 'failed-precondition':
        return 'Account balance is insufficient';
      default:
        return 'Transfer failed: ${e.message}';
    }
  }
}