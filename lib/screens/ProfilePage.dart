import 'package:flutter/material.dart';
import 'package:mouv_aps/screens/AuthPage.dart';
import 'SubscriptionPage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mouv_aps/services/secure_storage_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

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
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8)),
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
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
      ),
      trailing:
          Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Theme.of(context).colorScheme.primary),
      onTap: () {
        // TODO: Add Navigation Logic
      },
    );
  }

  // Calendar Section with dropdown for activity and clickable circles
DateTime _currentWeekStart = DateTime(2025, 1, 6); // Start week (6 Jan 2025)

 Widget _buildCalendarSection() {
    List<Map<String, dynamic>> weekDays = _generateWeekDays(_currentWeekStart);

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(color: Theme.of(context).colorScheme.primary),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
          ),

          child: Column(
            children: [
              // Header with Week Navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                        Icons.arrow_left,
                        color: Theme.of(context).colorScheme.onSurface),
                    onPressed: () {
                      setState(() {
                        _currentWeekStart = _currentWeekStart.subtract(
                            const Duration(days: 7));
                        weekDays = _generateWeekDays(_currentWeekStart);
                      });
                    },
                  ),
                  Text(
                    _getMonthName(_currentWeekStart.month),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  IconButton(
                    icon: Icon(
                        Icons.arrow_right,
                        color: Theme.of(context).colorScheme.onSurface),
                    onPressed: () {
                      setState(() {
                        _currentWeekStart = _currentWeekStart.add(
                            const Duration(days: 7));
                        weekDays = _generateWeekDays(_currentWeekStart);
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Week Day Rows
              ...weekDays.map((day) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      // Day Name
                      Expanded(
                        flex: 3,
                        child: Text(
                          day["day"] as String,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 14),
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
                            icon: Icon(
                                Icons.arrow_drop_down,
                                color: Theme.of(context).colorScheme.onSurface),
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
        title: Text("Profil"),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
        titleTextStyle: GoogleFonts.oswald(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 30,
            fontWeight: FontWeight.w500),
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
              Text(
                  "Rania Badi",
                  style:GoogleFonts.oswald(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
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
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child:  Text(
                    "Abonnement : Premium",
                    style: GoogleFonts.oswald(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Disconnect Button
              GestureDetector(
                onTap: () {
                  SecureStorageService().deleteAll();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthPage()
                    ),
                  );
                },
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.error.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child:  Text(
                    "Déconnexion",
                    style: GoogleFonts.oswald(
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
              Text(
                "Calendrier d'Activités",
                style: GoogleFonts.oswald(
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
