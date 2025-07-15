import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference accountsCollection = FirebaseFirestore.instance.collection('accounts');
  final CollectionReference transactionsCollection = FirebaseFirestore.instance.collection('transactions');

  Future<void> updateUserData({
    required String fullName,
    required String email,
    required String phone,
  }) async {
    return await usersCollection.doc(uid).set({
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'lastLogin': DateTime.now(),
    });
  }

  Future<DocumentReference<Object?>> addAccount({
  required String accountType,
  required String accountNumber,
  required double balance,
}) async {
  return await accountsCollection.add({
    'userId': uid,
    'accountType': accountType,
    'accountNumber': accountNumber,
    'balance': balance,
    'createdAt': DateTime.now(),
  });
}

  Stream<QuerySnapshot> getUserAccounts() {
    return accountsCollection.where('userId', isEqualTo: uid).snapshots();
  }

  Stream<QuerySnapshot> getUserTransactions() {
    return transactionsCollection
        .where('userId', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}