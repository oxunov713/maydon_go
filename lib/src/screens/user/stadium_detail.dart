import 'package:flutter/material.dart';

import '../../model/stadium_model.dart';

class StadiumDetailScreen extends StatelessWidget {
  final Stadium stadium;

  const StadiumDetailScreen({Key? key, required this.stadium}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(stadium.description),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stadium.description,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Address: ${stadium.location.address}'),
            Text('Price: \$${stadium.price.toStringAsFixed(2)}'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: stadium.images.map((image) {
                return Image.asset(
                  image,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}