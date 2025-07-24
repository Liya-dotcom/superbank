import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";

firebase.initializeApp({
  apiKey: "AIzaSyDSza0qZdaih7k8DQbJQnP-_Oi79nXKL2Y",
  authDomain: "superbank-app.firebaseapp.com",
  projectId: "superbank-20",
  storageBucket: "superbank-20.firebasestorage.app",
  messagingSenderId: "698853456796",
  appId: "1:698853456796:android:620a3aecefd08578762659",
  appId: "1:698853456796:ios:b99dcd18f6cba1b4762659",
});

c// Make auth available globally (for Flutter web plugin)
firebase.auth().setPersistence(firebase.auth.Auth.Persistence.LOCAL);

console.log("Firebase initialized!");  // Debug log