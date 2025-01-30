import 'package:flutter/material.dart';
import 'package:mouv_aps/screens/AuthPage.dart';
import '../models/session.dart';
import 'SubscriptionPage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mouv_aps/services/secure_storage_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Session> sessions = [
  /*Session(
  title: "Session 1",
  duration: 30,
  videoUrl: "https://192.168.72.204:8443/media/videos/Ahsoka.S01E02.Part.Two.1080p.DSNP.WEB-DL.DDP5.1.H.264-NTb.mkv",
  thumbnailUrl:
  "https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png",
  date: DateTime.now(),
  steps: [
  "Step 1",
  "Step 2",
  "Step 3",
  ]),*/
];
  DateTime _currentMonthStart = DateTime(
      DateTime.now().year, DateTime.now().month, 1);

  // Helper function to get day name from weekday number
  String _getDayName(int weekday) {
    const days = [
      "Lundi",
      "Mardi",
      "Mercredi",
      "Jeudi",
      "Vendredi",
      "Samedi",
      "Dimanche"
    ];
    return days[weekday - 1];
  }

  // Helper function to get month name from month number
  String _getMonthName(int month) {
    const months = [
      "Janvier",
      "Février",
      "Mars",
      "Avril",
      "Mai",
      "Juin",
      "Juillet",
      "Août",
      "Septembre",
      "Octobre",
      "Novembre",
      "Décembre"
    ];
    return months[month - 1];
  }

  void _goToPreviousMonth() {
    setState(() {
      int prevMonth = _currentMonthStart.month - 1;
      int prevYear = _currentMonthStart.year;
      if (prevMonth < 1) {
        prevMonth = 12;
        prevYear--;
      }
      _currentMonthStart = DateTime(prevYear, prevMonth, 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      int nextMonth = _currentMonthStart.month + 1;
      int nextYear = _currentMonthStart.year;
      if (nextMonth > 12) {
        nextMonth = 1;
        nextYear++;
      }
      _currentMonthStart = DateTime(nextYear, nextMonth, 1);
    });
  }

  Color _evaluateSessionColor(Session session) {
    print(DateTime.now().difference(session.date).inDays);
    if (session.completed) {
      return Colors.green.withOpacity(0.5);
    }
    else if (DateTime.now().difference(session.date).inDays >= 1) {
      return Colors.red.withOpacity(0.5);
    } else {
      return Colors.orange.withOpacity(0.5);
    }
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
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.8)),
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
      trailing: Icon(Icons.arrow_forward_ios,
          size: 16, color: Theme.of(context).colorScheme.primary),
      onTap: () {
        // TODO: Add Navigation Logic
      },
    );
  }

  Widget _buildCalendarSection() {
    List<Session> filteredSessions = sessions
        .where((session) =>
            session.date.month == _currentMonthStart.month &&
            session.date.year == _currentMonthStart.year)
        .toList();
    filteredSessions.sort((a, b) => a.date.day.compareTo(b.date.day));
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
              // Header with Month Navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_left,
                        color: Theme.of(context).colorScheme.onSurface),
                    onPressed: () {
                      _goToPreviousMonth();
                    },
                  ),
                  Text(
                    "${_getMonthName(_currentMonthStart.month)} ${_currentMonthStart.year}",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_right,
                        color: Theme.of(context).colorScheme.onSurface),
                    onPressed: () {
                      _goToNextMonth();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Display activities this month here
              if (filteredSessions.isEmpty)
                Text(
                  'Aucune séance pour ce mois.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredSessions.length,
                  itemBuilder: (context, index) {
                    final session = filteredSessions[index];
                    final dayName = _getDayName(session.date.weekday);
                    final dayNumber = session.date.day;
                    final monthName = _getMonthName(session.date.month);

                    return ListTile(
                      title: Text(session.title,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        '$dayName $dayNumber $monthName',
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.7),
                        ),
                      ),
                      trailing: Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _evaluateSessionColor(session),
                          shape: BoxShape.circle,
                        ),
                      ),
                      onTap: () {
                        // Could navigate to a SessionDetailPage
                        // or show a dialog with more info.
                      },
                    );
                  },
                ),
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
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.onSurface),
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
                style: GoogleFonts.oswald(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),

              // Subscription Button
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
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
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
                    MaterialPageRoute(builder: (context) => const AuthPage()),
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
                        color: Theme.of(context)
                            .colorScheme
                            .error
                            .withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
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
              _buildListTile(
                  Icons.bar_chart, "Statistiques", "Progrès cette année"),
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
