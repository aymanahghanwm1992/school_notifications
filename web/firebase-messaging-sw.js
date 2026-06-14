importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js');

// تهيئة Firebase (تأكد من استبدال البيانات بمفاتيحك الفعلية)
firebase.initializeApp({
  apiKey: "YOUR_KEY",
  authDomain: "YOUR_DOMAIN",
  projectId: "YOUR_PROJECT",
  messagingSenderId: "YOUR_ID",
  appId: "YOUR_APP_ID"
});

const messaging = firebase.messaging();

// معالجة الرسائل في الخلفية
messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Received background message:', payload);
  
  const notificationTitle = payload.notification?.title || 'إشعار جديد';
  const notificationOptions = {
    body: payload.notification?.body || '',
    icon: '/icons/Icon-192.png',
    badge: '/icons/Icon-192.png',
    tag: 'notification',
    requireInteraction: false,
    silent: false,
    vibrate: [200, 100, 200],
    data: payload.data || {},
  };

  // تشغيل نغمة الإشعار
  const audioContext = new (window.AudioContext || window.webkitAudioContext)();
  playNotificationSound(audioContext);

  // عرض الإشعار
  self.registration.showNotification(notificationTitle, notificationOptions);
});

// معالجة النقر على الإشعار
self.addEventListener('notificationclick', (event) => {
  console.log('[firebase-messaging-sw.js] Notification clicked:', event.notification);
  
  event.notification.close();
  
  // فتح النافذة أو التركيز عليها
  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then((clientList) => {
      for (let i = 0; i < clientList.length; i++) {
        const client = clientList[i];
        if (client.url === '/' && 'focus' in client) {
          return client.focus();
        }
      }
      if (clients.openWindow) {
        return clients.openWindow('/');
      }
    })
  );
});

// تشغيل نغمة الإشعار
function playNotificationSound(audioContext) {
  try {
    const oscillator = audioContext.createOscillator();
    const gainNode = audioContext.createGain();
    
    oscillator.connect(gainNode);
    gainNode.connect(audioContext.destination);
    
    oscillator.frequency.value = 800; // تردد 800 هيرتز
    oscillator.type = 'sine'; // نوع الموجة
    
    gainNode.gain.setValueAtTime(0.3, audioContext.currentTime);
    gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 0.5);
    
    oscillator.start(audioContext.currentTime);
    oscillator.stop(audioContext.currentTime + 0.5);
  } catch (error) {
    console.log('Error playing notification sound:', error);
  }
}