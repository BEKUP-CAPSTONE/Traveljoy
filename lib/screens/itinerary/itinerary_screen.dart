import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/itinerary_provider.dart';

class ItineraryScreen extends StatelessWidget {
  const ItineraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final itineraryProvider = Provider.of<ItineraryProvider>(context);

    final inputController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Itinerary")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: inputController,
              decoration: const InputDecoration(
                labelText: "Masukkan kebutuhan perjalanan",
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                if (inputController.text.isNotEmpty) {
                  itineraryProvider.generateItinerary(inputController.text);
                  inputController.clear();
                }
              },
              child: const Text("Generate Itinerary"),
            ),
            const Divider(),
            const Text("History"),
            Expanded(
              child: ListView.builder(
                itemCount: itineraryProvider.history.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(itineraryProvider.history[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
