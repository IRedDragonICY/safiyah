import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../data/models/notification_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final StreamController<List<NotificationModel>> _notificationsController =
      StreamController<List<NotificationModel>>.broadcast();

  final List<NotificationModel> _notifications = [];
  
  Stream<List<NotificationModel>> get notificationsStream =>
      _notificationsController.stream;

  List<NotificationModel> get notifications => List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> initializeData() async {
    // Initialize with some demo notifications
    await _loadDemoNotifications();
  }

  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    if (kIsWeb) return;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    await _requestNotificationPermission();
  }

  static void _onNotificationTapped(NotificationResponse notificationResponse) {
    final String? payload = notificationResponse.payload;
    if (payload != null && payload.isNotEmpty) {
    }
  }

  static Future<bool> _requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? icon,
    NotificationPriority priority = NotificationPriority.high,
  }) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'safiyah_channel',
      'Safiyah Notifications',
      channelDescription: 'General notifications for Safiyah app',
      importance: Importance.high,
      priority: Priority.high,
      icon: icon ?? '@mipmap/ic_launcher',
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  static Future<void> schedulePrayerNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    bool useAdhanSound = true,
  }) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'prayer_channel',
      'Prayer Notifications',
      channelDescription: 'Prayer time notifications',
      importance: Importance.max,
      priority: Priority.max,
      sound: useAdhanSound
          ? const RawResourceAndroidNotificationSound('adhan')
          : null,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      ledColor: const Color(0xFF4CAF50),
      ledOnMs: 1000,
      ledOffMs: 500,
      icon: '@drawable/prayer_icon',
    );

    final DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: useAdhanSound ? 'adhan.aiff' : null,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  static Future<void> scheduleRecurringPrayerNotifications({
    required List<DateTime> prayerTimes,
    required List<String> prayerNames,
    bool enableAllPrayers = true,
    List<String> disabledPrayers = const [],
  }) async {
    await cancelAllPrayerNotifications();

    for (int i = 0; i < prayerTimes.length; i++) {
      if (i < prayerNames.length) {
        final prayerName = prayerNames[i];
        final prayerTime = prayerTimes[i];

        if (!enableAllPrayers && disabledPrayers.contains(prayerName)) {
          continue;
        }

        if (prayerName.toLowerCase() == 'sunrise') {
          continue;
        }

        await schedulePrayerNotification(
          id: 100 + i,
          title: 'Prayer Time: $prayerName',
          body: 'It\'s time for $prayerName prayer',
          scheduledDate: prayerTime,
          payload: 'prayer_$prayerName',
        );

        final reminderTime = prayerTime.subtract(const Duration(minutes: 10));
        if (reminderTime.isAfter(DateTime.now())) {
          await scheduleReminderNotification(
            id: 200 + i,
            title: '$prayerName in 10 minutes',
            body: 'Prepare for $prayerName prayer',
            scheduledDate: reminderTime,
            payload: 'reminder_$prayerName',
          );
        }
      }
    }
  }

  static Future<void> scheduleReminderNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'reminder_channel',
      'Prayer Reminders',
      channelDescription: 'Prayer reminder notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@drawable/reminder_icon',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  static Future<void> scheduleQiblaReminder({
    required int id,
    String title = 'Qibla Direction',
    String body = 'Find the Qibla direction for prayer',
    required DateTime scheduledDate,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'qibla_channel',
      'Qibla Reminders',
      channelDescription: 'Qibla direction reminders',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@drawable/qibla_icon',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'qibla_reminder',
    );
  }

  static Future<void> scheduleItineraryReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? itineraryId,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'itinerary_channel',
      'Itinerary Reminders',
      channelDescription: 'Travel itinerary reminders',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@drawable/itinerary_icon',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'itinerary_${itineraryId ?? ''}',
    );
  }

  static Future<void> scheduleHalaalPlaceAlert({
    required int id,
    required String placeName,
    required double latitude,
    required double longitude,
    String? placeType,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'halaal_places_channel',
      'Halaal Places',
      channelDescription: 'Nearby halaal places notifications',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@drawable/halaal_icon',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      'Halaal ${placeType ?? 'Place'} Nearby',
      'Found $placeName near your location',
      platformChannelSpecifics,
      payload: 'halaal_place_$latitude,$longitude',
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<void> cancelAllPrayerNotifications() async {
    for (int i = 100; i < 200; i++) {
      await cancelNotification(i);
    }
    for (int i = 200; i < 300; i++) {
      await cancelNotification(i);
    }
  }

  static Future<void> cancelPrayerNotification(String prayerName) async {
    final prayerNames = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];
    final index = prayerNames.indexOf(prayerName.toLowerCase());

    if (index != -1) {
      await cancelNotification(100 + index);
      await cancelNotification(200 + index);
    }
  }

  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  static Future<List<ActiveNotification>?> getActiveNotifications() async {
    return await _flutterLocalNotificationsPlugin.getActiveNotifications();
  }

  static Future<bool> hasPermission() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  static Future<void> requestExactAlarmPermission() async {
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
  }

  static Future<void> showProgressNotification({
    required int id,
    required String title,
    required String body,
    required int progress,
    required int maxProgress,
  }) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'progress_channel',
      'Progress Notifications',
      channelDescription: 'Progress notifications',
      importance: Importance.low,
      priority: Priority.low,
      onlyAlertOnce: true,
      showProgress: true,
      maxProgress: maxProgress,
      progress: progress,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: false,
      presentBadge: false,
      presentSound: false,
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  static Future<void> showBigTextNotification({
    required int id,
    required String title,
    required String body,
    required String bigText,
    String? payload,
  }) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'big_text_channel',
      'Extended Notifications',
      channelDescription: 'Notifications with extended text',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(
        bigText,
        htmlFormatBigText: true,
        contentTitle: title,
        htmlFormatContentTitle: true,
        summaryText: 'Safiyah App',
        htmlFormatSummaryText: true,
      ),
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  static Future<void> showInboxNotification({
    required int id,
    required String title,
    required String body,
    required List<String> lines,
    String? payload,
  }) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'inbox_channel',
      'Multiple Updates',
      channelDescription: 'Notifications with multiple lines',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: InboxStyleInformation(
        lines,
        htmlFormatLines: true,
        contentTitle: title,
        htmlFormatContentTitle: true,
        summaryText: '${lines.length} updates',
        htmlFormatSummaryText: true,
      ),
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  static Future<void> createNotificationChannelGroup({
    required String groupId,
    required String groupName,
    String? groupDescription,
  }) async {
    const AndroidNotificationChannelGroup androidNotificationChannelGroup =
        AndroidNotificationChannelGroup(
      'prayer_group',
      'Prayer Notifications',
      description: 'All prayer related notifications',
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannelGroup(androidNotificationChannelGroup);
  }

  static Future<void> initializeTimeZone() async {
  }

  static Future<Map<String, dynamic>> getNotificationStats() async {
    final pending = await getPendingNotifications();
    final active = await getActiveNotifications();

    return {
      'pending_count': pending.length,
      'active_count': active?.length ?? 0,
      'prayer_notifications': pending.where((n) => n.id >= 100 && n.id < 200).length,
      'reminder_notifications': pending.where((n) => n.id >= 200 && n.id < 300).length,
      'has_permission': await hasPermission(),
    };
  }

  Future<void> _loadDemoNotifications() async {
    final demoNotifications = [
      NotificationModel(
        id: '1',
        title: 'Special Voucher for Tokyo',
        message: 'Get 20% off on Tokyo Halal restaurants! Valid until tomorrow. Enjoy authentic halal cuisine.',
        type: NotificationType.voucher,
        priority: NotificationPriority.high,
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        imageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?ixlib=rb-4.0.3',
        deepLink: '/voucher',
        actionData: {
          'voucherId': 'TOKYO20',
          'discount': 20,
          'validUntil': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
        },
      ),
      NotificationModel(
        id: '2',
        title: 'Flight Reminder',
        message: 'Your flight to Tokyo departs tomorrow at 14:30. Please ensure your passport, tickets, and health documents are ready.',
        type: NotificationType.transportation,
        priority: NotificationPriority.urgent,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        scheduledTime: DateTime.now().add(const Duration(days: 1, hours: -3)),
        imageUrl: 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?ixlib=rb-4.0.3',
        actionData: {
          'flightNumber': 'JL123',
          'departure': '14:30',
          'gate': 'A12',
          'terminal': '2',
        },
      ),
      NotificationModel(
        id: '3',
        title: 'Hotel Check-in Reminder',
        message: 'Your reservation at Grand Halal Hotel Tokyo is in 1 hour. Check-in starts at 15:00.',
        type: NotificationType.accommodation,
        priority: NotificationPriority.high,
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
        scheduledTime: DateTime.now().add(const Duration(hours: 1)),
        imageUrl: 'https://images.unsplash.com/photo-1445019980597-93fa8acb246c?ixlib=rb-4.0.3',
        actionData: {
          'hotelName': 'Grand Halal Hotel Tokyo',
          'checkInTime': '15:00',
          'roomNumber': '1205',
          'confirmationCode': 'GHH123456',
        },
      ),
      NotificationModel(
        id: '4',
        title: 'Prayer Time Alert',
        message: 'Maghrib prayer time is in 15 minutes. Direction to nearest mosque: Tokyo Camii (1.2 km away).',
        type: NotificationType.prayer,
        priority: NotificationPriority.normal,
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        scheduledTime: DateTime.now().add(const Duration(minutes: 15)),
        deepLink: '/prayer',
        actionData: {
          'prayerName': 'Maghrib',
          'time': '18:45',
          'nearestMosque': 'Tokyo Camii',
          'distance': '1.2 km',
        },
      ),
      NotificationModel(
        id: '5',
        title: 'New Itinerary Shared',
        message: 'Ahmad shared "Kyoto Temple Tour" itinerary with you. Check out the amazing places to visit!',
        type: NotificationType.itinerary,
        priority: NotificationPriority.normal,
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        imageUrl: 'https://images.unsplash.com/photo-1545569341-9eb8b30979d9?ixlib=rb-4.0.3',
        deepLink: '/itinerary/detail/kyoto-tour',
        actionData: {
          'itineraryId': 'kyoto-tour',
          'sharedBy': 'Ahmad',
          'placesCount': 8,
        },
      ),
      NotificationModel(
        id: '6',
        title: 'Transportation Update',
        message: 'JR Yamanote Line experiencing 10-minute delays. Consider alternative routes for your evening plans.',
        type: NotificationType.transportation,
        priority: NotificationPriority.normal,
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        actionData: {
          'line': 'JR Yamanote Line',
          'delay': '10 minutes',
          'affectedStations': ['Shibuya', 'Shinjuku', 'Tokyo'],
        },
      ),
      NotificationModel(
        id: '7',
        title: 'Exclusive Hotel Deal',
        message: 'Last-minute deal: 40% off luxury hotels in Osaka for next weekend. Book now before it\'s gone!',
        type: NotificationType.voucher,
        priority: NotificationPriority.high,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        imageUrl: 'https://images.unsplash.com/photo-1564501049412-61c2a3083791?ixlib=rb-4.0.3',
        deepLink: '/voucher',
        actionData: {
          'discount': 40,
          'location': 'Osaka',
          'validUntil': DateTime.now().add(const Duration(days: 2)).toIso8601String(),
        },
      ),
      NotificationModel(
        id: '8',
        title: 'Document Check Reminder',
        message: 'Don\'t forget to check your visa validity. Your Japan visa expires in 30 days.',
        type: NotificationType.general,
        priority: NotificationPriority.normal,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
        actionData: {
          'documentType': 'Visa',
          'expiryDate': DateTime.now().add(const Duration(days: 30)).toIso8601String(),
          'country': 'Japan',
        },
      ),
    ];

    _notifications.addAll(demoNotifications);
    _notificationsController.add(_notifications);
  }

  Future<void> addNotification(NotificationModel notification) async {
    _notifications.insert(0, notification);
    _notificationsController.add(_notifications);
  }

  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      _notificationsController.add(_notifications);
    }
  }

  Future<void> markAllAsRead() async {
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    }
    _notificationsController.add(_notifications);
  }

  Future<void> deleteNotification(String notificationId) async {
    _notifications.removeWhere((n) => n.id == notificationId);
    _notificationsController.add(_notifications);
  }

  Future<void> scheduleNotification({
    required String title,
    required String message,
    required NotificationType type,
    required DateTime scheduledTime,
    NotificationPriority priority = NotificationPriority.normal,
    Map<String, dynamic>? actionData,
    String? imageUrl,
    String? deepLink,
  }) async {
    final notification = NotificationModel(
      id: _generateId(),
      title: title,
      message: message,
      type: type,
      priority: priority,
      createdAt: DateTime.now(),
      scheduledTime: scheduledTime,
      actionData: actionData,
      imageUrl: imageUrl,
      deepLink: deepLink,
    );

    // For demo purposes, we'll add it immediately
    // In a real app, you'd schedule this with a background service
    await addNotification(notification);
  }

  List<NotificationModel> getNotificationsByType(NotificationType type) {
    return _notifications.where((n) => n.type == type).toList();
  }

  List<NotificationModel> getUnreadNotifications() {
    return _notifications.where((n) => !n.isRead).toList();
  }

  String _generateId() {
    return 'notif_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';
  }

  void dispose() {
    _notificationsController.close();
  }
}


