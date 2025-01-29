import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mouv_aps/screens/FormPage.dart';

class AbonnementsPage extends StatelessWidget {
  const AbonnementsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          "Abonnements",
          style: GoogleFonts.oswald(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 30,
            fontWeight: FontWeight.w500),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                "Mouv'APeat",
                "Programme sportif & alimentaire",
                [
                  _buildSubscriptionTile("Abonnement Mensuel", "14€ / mois"),
                  _buildSubscriptionTile("Abonnement Trimestriel", "36€ (12€/mois)"),
                  _buildSubscriptionTile("Abonnement Semestriel", "60€ (10€/mois)"),
                  _buildSubscriptionTile("Abonnement Annuel", "96€ (8€/mois)"),
                ],
              ),
              const SizedBox(height: 15),
              _buildSection(
                "Mouv'APA",
                "Programme sportif",
                [
                  _buildSubscriptionTile("Abonnement Mensuel", "8€ / mois"),
                  _buildSubscriptionTile("Abonnement Trimestriel", "21€ (7€/mois)"),
                  _buildSubscriptionTile("Abonnement Semestriel", "36€ (6€/mois)"),
                  _buildSubscriptionTile("Abonnement Annuel", "60€ (5€/mois)"),
                ],
              ),
              const SizedBox(height: 15),
              _buildSection(
                "Mouv'EAT",
                "Programme alimentaire",
                [
                  _buildSubscriptionTile("Abonnement Mensuel", "8€ / mois"),
                  _buildSubscriptionTile("Abonnement Trimestriel", "21€ (7€/mois)"),
                  _buildSubscriptionTile("Abonnement Semestriel", "36€ (6€/mois)"),
                  _buildSubscriptionTile("Abonnement Annuel", "60€ (5€/mois)"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build Section with Title and Tiles
  Widget _buildSection(String title, String subtitle, List<Widget> tiles) {
    return StatefulBuilder(builder: (context, setState) {
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.oswald(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              Divider(color: Theme.of(context).colorScheme.primary),
              ...tiles,
            ],
          ),
        ),
      );
    });
  }

  // Build Compact Subscription Tile
  Widget _buildSubscriptionTile(String title, String price) {
    return StatefulBuilder(builder: (context, setState) {
      return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      leading: Icon(
          Icons.subscriptions,
          color: Theme.of(context).colorScheme.primary,
        ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        price,
        style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
      ),
      trailing: ElevatedButton(
        onPressed: () {
          // Push form page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FormPage(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text("S'abonner", style: TextStyle(color: Colors.white)),
      ),
    );
    });
  }
}