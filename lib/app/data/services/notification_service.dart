import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    if (kIsWeb) return; // tidak support web

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    if (kIsWeb) return; // tidak support web

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'spaceflight_channel',
      'Spaceflight Notifications',
      channelDescription: 'Notifikasi dari Spaceflight App',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.show(id, title, body, details);
  }

  static Future<void> showLocationNotification(String locationInfo) async {
    if (kIsWeb) return;
    await showNotification(
      id: 1,
      title: '📍 Lokasi Terdeteksi',
      body: locationInfo,
    );
  }

  static Future<void> showArticleNotification(String articleTitle) async {
    if (kIsWeb) return;
    await showNotification(
      id: 2,
      title: '🚀 Artikel Dibuka',
      body: articleTitle,
    );
  }

  static Future<void> showLoginNotification(String username) async {
    if (kIsWeb) return;
    await showNotification(
      id: 3,
      title: '👋 Selamat Datang!',
      body: 'Halo, $username! Selamat datang di Spaceflight App.',
    );
  }
}