import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAKauSenLX5G2eNAfha923S8F176tkBOf4",
            authDomain: "qrwalletnew1984.firebaseapp.com",
            projectId: "qrwalletnew1984",
            storageBucket: "qrwalletnew1984.firebasestorage.app",
            messagingSenderId: "974144029017",
            appId: "1:974144029017:web:54791e41f54eebad7d4c48"));
  } else {
    await Firebase.initializeApp();
  }
}
