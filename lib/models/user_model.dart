import 'package:flutter/foundation.dart'; // Add this import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String? email;
  final String? fullName;
  final String? phone;
  final DateTime? lastLogin;
  final DateTime? createdAt;
  final bool emailVerified;
  final List<String>? accounts;
  final Map<String, dynamic>? preferences;

  UserModel({
    required this.uid,
    this.email,
    this.fullName,
    this.phone,
    this.lastLogin,
    this.createdAt,
    this.emailVerified = false,
    this.accounts,
    this.preferences,
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      emailVerified: user.emailVerified,
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'],
      fullName: data['fullName'],
      phone: data['phone'],
      lastLogin: data['lastLogin']?.toDate(),
      createdAt: data['createdAt']?.toDate(),
      emailVerified: data['emailVerified'] ?? false,
      accounts: List<String>.from(data['accounts'] ?? []),
      preferences: Map<String, dynamic>.from(data['preferences'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'lastLogin': lastLogin,
      'createdAt': createdAt,
      'emailVerified': emailVerified,
      'accounts': accounts,
      'preferences': preferences,
    };
  }

  UserModel copyWith({
    String? email,
    String? fullName,
    String? phone,
    DateTime? lastLogin,
    bool? emailVerified,
    List<String>? accounts,
    Map<String, dynamic>? preferences,
  }) {
    return UserModel(
      uid: uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      lastLogin: lastLogin ?? this.lastLogin,
      createdAt: createdAt,
      emailVerified: emailVerified ?? this.emailVerified,
      accounts: accounts ?? this.accounts,
      preferences: preferences ?? this.preferences,
    );
  }

  static UserModel empty() => UserModel(uid: '');

  bool get isEmpty => uid.isEmpty;
  bool get isNotEmpty => !isEmpty;

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, fullName: $fullName, phone: $phone)';
  }
}

// Corrected UserProvider with proper ChangeNotifier mixin
class UserProvider with ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners(); // Notify all listening widgets
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  Future<void> refreshUser() async {
    if (_user == null || _user!.isEmpty) return;
    
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();
      
      if (userDoc.exists) {
        _user = UserModel.fromFirestore(userDoc);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error refreshing user: $e');
    }
  }
}