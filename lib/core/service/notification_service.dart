import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:event_bus/event_bus.dart';

// Evento de notificação para ser usado no EventBus
class NotificationReceivedEvent {
  final String title;
  final String body;
  final Map<String, dynamic>? data;

  NotificationReceivedEvent({
    required this.title,
    required this.body,
    this.data,
  });
}

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  final EventBus _eventBus = EventBus();
  int _notificationId = 0;

  Future<void> initialize() async {
  if (kIsWeb) {
    return;
  }

  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings iosSettings =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await _plugin.initialize(
    settings: initSettings,
  );

  if (Platform.isAndroid) {
    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();
  }
}

  Future<void> showNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'pedidos_channel_id',
      'Pedidos Notificações',
      channelDescription: 'Notificações de pedidos e atualizações',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      id: _notificationId++,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: data != null ? data.toString() : null,
    );

    // Emitir evento para que qualquer tela possa escutar
    _eventBus.fire(NotificationReceivedEvent(
      title: title,
      body: body,
      data: data,
    ));
  }

  // Método para escutar notificações em outras telas
  Stream<NotificationReceivedEvent> get notifications => _eventBus.on<NotificationReceivedEvent>();
}
