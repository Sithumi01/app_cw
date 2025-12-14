import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const WaterTankApp());
}

class WaterTankApp extends StatelessWidget {
  const WaterTankApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Tank Monitor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BottomNavController(),
    );
  }
}

class BottomNavController extends StatefulWidget {
  const BottomNavController({Key? key}) : super(key: key);

  @override
  State<BottomNavController> createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    WaterLevelScreen(),
    UsageAnalyticsScreen(),
    NotificationsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.water_drop), label: "Water Level"),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "Analytics"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notifications"),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////
/// DASHBOARD SCREEN
////////////////////////////////////////////////////////
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double tankLevel = 0.6;
  bool motorOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
            // Circular tank level using CustomPaint
            CustomPaint(
              size: const Size(150, 150),
              painter: TankPainter(tankLevel),
            ),
            const SizedBox(height: 20),
            Text(
              "${(tankLevel * 100).toInt()}%",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            const Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text("Usage Stats",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("Today's Usage:"), Text("120 L")],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("Monthly Usage:"), Text("2500 L")],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Motor Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Motor Status",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Switch(
                  value: motorOn,
                  activeThumbColor: Colors.green,
                  onChanged: (v) => setState(() => motorOn = v),
                )
              ],
            ),
            Text(
              motorOn ? "Motor is ON 🟢" : "Motor is OFF 🔴",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: motorOn ? Colors.green : Colors.red),
            ),
          ],
        ),
      ),
    ),
  );
  }
}

class TankPainter extends CustomPainter {
  final double level;
  TankPainter(this.level);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint bgPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;

    final Paint fgPaint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2 - 10;

    canvas.drawCircle(center, radius, bgPaint);
    double sweepAngle = 2 * pi * level;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, sweepAngle, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

////////////////////////////////////////////////////////
/// WATER LEVEL SCREEN
////////////////////////////////////////////////////////
class WaterLevelScreen extends StatelessWidget {
  const WaterLevelScreen({Key? key}) : super(key: key);

  final double level = 0.7;

  @override
  Widget build(BuildContext context) {
    double capacity = 1000 * level;
    return Scaffold(
      appBar: AppBar(title: const Text("Water Level")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 250,
                  width: 120,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  height: 250 * level,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text("Remaining Capacity: ${capacity.toStringAsFixed(0)} L",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////
/// USAGE ANALYTICS SCREEN
////////////////////////////////////////////////////////
class UsageAnalyticsScreen extends StatelessWidget {
  const UsageAnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<double> monthlyUsage = [300, 500, 700, 400, 650, 900];
    List<double> dailyUsage = [2, 4, 3, 5, 2, 6, 4];

    return Scaffold(
      appBar: AppBar(title: const Text("Usage Analytics")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Monthly Usage", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 160,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(monthlyUsage.length, (i) {
                  final value = monthlyUsage[i];
                  final maxValue = monthlyUsage.reduce((a, b) => a > b ? a : b);
                  final barHeight = (value / maxValue) * 140; // normalize
                  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: barHeight,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(months[i], style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),
            const Text("Daily Usage", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: CustomPaint(
                size: const Size(double.infinity, 180),
                painter: LineGraphPainter(dailyUsage),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LineGraphPainter extends CustomPainter {
  final List<double> values;
  LineGraphPainter(this.values);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final double stepX = size.width / (values.length - 1);
    final double maxY = values.reduce(max);
    final double scaleY = size.height / maxY;

    final Path path = Path();
    path.moveTo(0, size.height - values[0] * scaleY);
    for (int i = 1; i < values.length; i++) {
      path.lineTo(i * stepX, size.height - values[i] * scaleY);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

////////////////////////////////////////////////////////
/// NOTIFICATIONS SCREEN
////////////////////////////////////////////////////////
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<String> notifications = [
    "Motor turned ON automatically",
    "Tank 80% full",
    "Daily usage limit reached"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(notifications[index]),
            onDismissed: (_) {
              setState(() => notifications.removeAt(index));
            },
            child: Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                leading: const Icon(Icons.notifications_active, color: Colors.orange),
                title: Text(notifications[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}
