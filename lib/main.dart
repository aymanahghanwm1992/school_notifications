import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel _channel = AndroidNotificationChannel(
  'realtime_notifications', // id
  'Realtime Notifications', // title
  description: 'Channel for realtime notifications',
  importance: Importance.max,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://zzmqrqazvwcdanjxtlme.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp6bXFycWF6dndjZGFuanh0bG1lIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE0MzQ4MjMsImV4cCI6MjA5NzAxMDgyM30.l9xp0F6OsbQKETtdimklZF7EobDS69uQdv-WOs8YK78",
  );

  // Initialize local notifications
  const AndroidInitializationSettings androidInitSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final DarwinInitializationSettings iosInitSettings =
      DarwinInitializationSettings(requestAlertPermission: true, requestSoundPermission: true, requestBadgePermission: true);

  final InitializationSettings initSettings = InitializationSettings(
    android: androidInitSettings,
    iOS: iosInitSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  // Create Android channel
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(_channel);

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List notifications = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    listenRealtime();
  }

  /// 📌 جلب البيانات أول مرة
  Future<void> fetchData() async {
    final data = await supabase
        .from('notifications')
        .select()
        .order('id', ascending: false);

    setState(() {
      notifications = data;
    });
  }

  /// 🔥 تحديث مباشر (Realtime)
  void listenRealtime() {
    supabase.from('notifications').stream(primaryKey: ['id']).listen((data) {
      final newList = data.reversed.toList();

      // detect new incoming notification (compare newest id)
      if (newList.isNotEmpty) {
        final incomingNewest = newList.first;
        final currentNewestId = notifications.isNotEmpty ? notifications.first['id'] : null;

        if (currentNewestId == null || incomingNewest['id'] != currentNewestId) {
          // show local notification
          showLocalNotification(incomingNewest);

          // play default notification sound
          FlutterRingtonePlayer.play(
            android: AndroidSounds.notification,
            ios: IosSounds.glass,
            looping: false,
            volume: 1.0,
            asAlarm: false,
          );
        }
      }

      setState(() {
        notifications = newList;
      });
    });
  }

  Future<void> showLocalNotification(Map item) async {
    final androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.max,
      priority: Priority.high,
    );

    final iosDetails = DarwinNotificationDetails();

    final platformDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterLocalNotificationsPlugin.show(
      item['id'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
      item['title'] ?? 'إشعار جديد',
      item['body'] ?? '',
      platformDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("بوابة الإشعارات"),
        centerTitle: true,
      ),
      body: notifications.isEmpty
          ? const Center(child: Text("لا توجد إشعارات"))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(item['title'] ?? ""),
                    subtitle: Text(item['body'] ?? ""),
                  ),
                );
              },
            ),
    );
  }
}