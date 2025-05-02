import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';

import '../../../bloc/donation_cubit/donation_cubit.dart';
import '../../../bloc/donation_cubit/donation_state.dart';

class DonationPage extends StatelessWidget {
  const DonationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DonationCubit()..fetchDonations(),
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(color: Colors.white),
          title: const Text("Donation", style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.green,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.green, Colors.black87],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: BlocBuilder<DonationCubit, DonationState>(
                builder: (context, state) {
                  if (state is DonationLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DonationLoaded) {
                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          "Support Us!",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Your donation helps us keep going.\nThank you!",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                        const SizedBox(height: 30),
                        Expanded(
                          child: ListView.separated(
                            itemCount: state.cards.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 20),
                            itemBuilder: (context, index) {
                              final card = state.cards[index];
                              return _buildDonationCard(context, card.cardNumber, card.cardType);
                            },
                          ),
                        ),
                      ],
                    );
                  } else if (state is DonationError) {
                    return Center(
                      child: Text(state.message, style: const TextStyle(color: Colors.red)),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: const Text(
          "Every little bit helps. Thank you!",
          style: TextStyle(fontSize: 14, color: Colors.white54),
        ),
      ),
    );
  }

  Widget _buildDonationCard(BuildContext context, String cardNumber, String cardHolder) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cardNumber,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, color: AppColors.green),
                  onPressed: () => Clipboard.setData(ClipboardData(text: cardNumber)),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              "Card type: $cardHolder",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
