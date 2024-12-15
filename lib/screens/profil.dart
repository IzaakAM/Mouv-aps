import 'package:flutter/material.dart';
import 'abonnements_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Days with activities and states
  final List<Map<String, dynamic>> _days = [
    {"day": "Lundi 15 Janvier", "activity": "Repos", "color": Colors.grey},
    {"day": "Mardi 16 Janvier", "activity": "Musculation", "color": Colors.green},
    {"day": "Mercredi 17 Janvier", "activity": "Cours en ligne", "color": Colors.yellow},
    {"day": "Jeudi 18 Janvier", "activity": "Course", "color": Colors.red},
    {"day": "Vendredi 19 Janvier", "activity": "Musculation", "color": Colors.green},
    {"day": "Samedi 20 Janvier", "activity": "Repos", "color": Colors.grey},
    {"day": "Dimanche 21 Janvier", "activity": "Cours en ligne", "color": Colors.yellow},
  ];

  // Dropdown options for activity types
  final List<String> _activities = [
    "Repos",
    "Musculation",
    "Course",
    "Cours en ligne"
  ];

  final Map<String, Color> _activityColors = {
  "Repos": Colors.grey,
  "Musculation": Colors.green,
  "Course": Colors.red,
  "Cours en ligne": Colors.yellow,
};

final Map<String, Color> _etatColors = {
  "Normal": Colors.green,
  "Attention": Colors.yellow,
  "Critique": Colors.red,
};


  // Helper function to get day name from weekday number
  String _getDayName(int weekday) {
    const days = ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche"];
    return days[weekday - 1];
  }

  // Helper function to get month name from month number
  String _getMonthName(int month) {
    const months = [
      "Janvier", "Février", "Mars", "Avril", "Mai", "Juin",
      "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"
    ];
    return months[month - 1];
  }

  // Generate week days dynamically
  List<Map<String, dynamic>> _generateWeekDays(DateTime weekStart) {
    return List.generate(7, (index) {
      DateTime date = weekStart.add(Duration(days: index));
      return {
        "day": "${_getDayName(date.weekday)} ${date.day} ${_getMonthName(date.month)}",
        "activity": "Repos",
        "color": Colors.grey
      };
    });
  }

  // Function to handle circle tap
  void _onCircleTap(Map<String, dynamic> day) {
    int currentIndex = _activities.indexOf(day["activity"]);
    int nextIndex = (currentIndex + 1) % _activities.length;
    setState(() {
      day["activity"] = _activities[nextIndex];
      day["color"] = _activityColors[day["activity"]]!;
    });
  }

  // Metric Card for Points and Sessions
  Widget _buildMetricCard(String title, String value, Color color) {
    return Container(
      height: 100,
      width: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  // List Tile for Navigation
  Widget _buildListTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.grey),
      ),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        // TODO: Add Navigation Logic
      },
    );
  }

  // Calendar Section with dropdown for activity and clickable circles
DateTime _currentWeekStart = DateTime(2025, 1, 6); // Start week (6 Jan 2025)

 Widget _buildCalendarSection() {
    List<Map<String, dynamic>> _weekDays = _generateWeekDays(_currentWeekStart);

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: [
              // Header with Week Navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_left, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _currentWeekStart = _currentWeekStart.subtract(const Duration(days: 7));
                        _weekDays = _generateWeekDays(_currentWeekStart);
                      });
                    },
                  ),
                  Text(
                    "${_getMonthName(_currentWeekStart.month)}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_right, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _currentWeekStart = _currentWeekStart.add(const Duration(days: 7));
                        _weekDays = _generateWeekDays(_currentWeekStart);
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Week Day Rows
              ..._weekDays.map((day) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      // Day Name
                      Expanded(
                        flex: 3,
                        child: Text(
                          day["day"] as String,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                      // Dropdown for Activity
                      Expanded(
                        flex: 3,
                        child: Center(
                          child: DropdownButton<String>(
                            value: day["activity"] as String? ?? "Repos",
                            dropdownColor: Colors.black,
                            underline: const SizedBox(),
                            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                            items: _activities.map((String activity) {
                              return DropdownMenuItem<String>(
                                value: activity,
                                child: Text(activity, style: const TextStyle(color: Colors.white)),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  day["activity"] = newValue;
                                  day["color"] = _activityColors[newValue];
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      // Circles for Task Status
                      Expanded(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _etatColors.entries.map((entry) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  day["color"] = entry.value;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: entry.value,
                                  child: day["color"] == entry.value
                                      ? const Icon(Icons.check, size: 12, color: Colors.black)
                                      : null,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Picture and Name
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/avatar.png'),
              ),
              const SizedBox(height: 10),
              const Text(
                "Rania Badi",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              // Abonnement Button
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AbonnementsPage(),
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    "Abonnement : Premium",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Metrics
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMetricCard("Points", "1250", Colors.blueAccent),
                  _buildMetricCard("Séances / Semaine", "3", Colors.green),
                  _buildMetricCard("Séances Totales", "45", Colors.orange),
                ],
              ),
              const SizedBox(height: 20),
              // List Tiles
              _buildListTile(Icons.history, "Historique des séances",
                  "Voir toutes les séances"),
              _buildListTile(Icons.bar_chart, "Statistiques",
                  "Progrès cette année"),
              _buildListTile(Icons.medical_services, "Pathologie",
                  "Détails des problèmes de santé"),
              const SizedBox(height: 20),
              // Calendar Section
              const Text(
                "Calendrier d'Activités",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 10),
              _buildCalendarSection(),
            ],
          ),
        ),
      ),
    );
  }
}
