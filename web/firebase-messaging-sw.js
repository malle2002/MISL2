

// Give the service worker access to Firebase Messaging.
// Note that you can only use Firebase Messaging here. Other Firebase libraries
// are not available in the service worker.
// Replace 10.13.2 with latest version of the Firebase JS SDK.
importScripts('https://www.gstatic.com/firebasejs/10.13.2/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.13.2/firebase-messaging-compat.js');

// Initialize the Firebase app in the service worker by passing in
// your app's Firebase config object.
// https://firebase.google.com/docs/web/setup#config-object
firebase.initializeApp({
  apiKey: "AIzaSyCgPNJv9mdTuvQ6XVbvCNCaRQb-coh80tw",
    authDomain: "lab3-4b4d9.firebaseapp.com",
    projectId: "lab3-4b4d9",
    storageBucket: "lab3-4b4d9.firebasestorage.app",
    messagingSenderId: "678018125735",
    appId: "1:678018125735:web:d5eb00d74f72a35e297082",
    measurementId: "G-YF6M0FSEC1"
});

// Retrieve an instance of Firebase Messaging so that it can handle background
// messages.
const messaging = firebase.messaging();