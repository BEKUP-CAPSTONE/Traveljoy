importScripts("https://www.gstatic.com/firebasejs/9.23.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.23.0/firebase-messaging-compat.js");

const firebaseConfig = {
  apiKey: 'AIzaSyAjKr9JtjjJhldmP3NzUQq23Z7w7Yz3QMo',
  appId: '1:734061247705:web:d098d767648e98a13bd2c8',
  messagingSenderId: '734061247705',
  projectId: 'traveljoy-81ef6',
  authDomain: 'traveljoy-81ef6.firebaseapp.com',
  storageBucket: 'traveljoy-81ef6.firebasestorage.app',
  measurementId: 'G-769WWSG1P4',
};

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log('Received background message ', payload);
  // notifikasi kustom
});