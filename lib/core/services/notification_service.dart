import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
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
      // Handle notification tap
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

        // Skip sunrise notification (not a prayer)
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

        // Schedule reminder 10 minutes before
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
    // Cancel prayer notifications (IDs 100-199)
    for (int i = 100; i < 200; i++) {
      await cancelNotification(i);
    }
    // Cancel reminder notifications (IDs 200-299)
    for (int i = 200; i < 300; i++) {
      await cancelNotification(i);
    }
  }

  static Future<void> cancelPrayerNotification(String prayerName) async {
    final prayerNames = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];
    final index = prayerNames.indexOf(prayerName.toLowerCase());

    if (index != -1) {
      await cancelNotification(100 + index); // Prayer notification
      await cancelNotification(200 + index); // Reminder notification
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
    // This should be called before any scheduled notifications
    // Implement timezone initialization based on user location
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
}

enum NotificationPriority {
  low,
  normal,
  high,
  max,
}