import 'package:flutter/material.dart';

class AbonnementsPage extends StatelessWidget {
  const AbonnementsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Abonnements",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                "Mouv'APeat",
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
  Widget _buildSection(String title, List<Widget> tiles) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const Divider(),
            ...tiles,
          ],
        ),
      ),
    );
  }

  // Build Compact Subscription Tile
  Widget _buildSubscriptionTile(String title, String price) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      leading: const Icon(Icons.subscriptions, color: Colors.blueAccent),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        price,
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
      trailing: ElevatedButton(
        onPressed: () {
          // TODO: Implement Subscription Logic
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text("S'abonner", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
