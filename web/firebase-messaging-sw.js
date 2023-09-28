importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
    apiKey: 'AIzaSyCL9YKxDrz2bfgVgn2vuDVwIjkSnljOFBs',
    appId: '1:647725682472:web:1777b070fa6f2d7ccc8a1d',
    messagingSenderId: '647725682472',
    projectId: 'reminder-app-803e2',
    authDomain: 'reminder-app-803e2.firebaseapp.com',
    storageBucket: 'reminder-app-803e2.appspot.com',
    measurementId: 'G-L2P2GE75CR',
});

const messaging = firebase.messaging();

// Next, the worker must be registered. Within the entry file, after the main.dart.js file has loaded, register your worker inside index.html

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});