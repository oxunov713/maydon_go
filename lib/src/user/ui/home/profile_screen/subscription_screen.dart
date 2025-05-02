import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';
import '../../../bloc/subscription_cubit/subscription_cubit.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<SubscriptionCubit>().fetchSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Subscription")),
      backgroundColor: AppColors.white2,
      body: BlocBuilder<SubscriptionCubit, SubscriptionState>(
        builder: (context, state) {
          if (state is SubscriptionLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: state.subscriptions.length,
              itemBuilder: (context, index) {
                final sub = state.subscriptions[index];
                final isSelected = state.selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    context.read<SubscriptionCubit>().selectSubscription(index);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isSelected ? AppColors.green3 : AppColors.grey4,
                        width: 3,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: isSelected
                                  ? AppColors.green
                                  : AppColors.grey4,
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: AppColors.white,
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: isSelected
                                      ? AppColors.green
                                      : AppColors.grey4,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(sub.name ?? "Not found",
                                style: const TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Divider(thickness: 2),
                        ...sub.description!
                            .split('\n')
                            .where((e) => e.trim().isNotEmpty)
                            .map(
                              (benefit) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check,
                                        color: Colors.black),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(benefit.trim())),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        const Divider(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            sub.price == 0.0
                                ? "Bepul"
                                : "${sub.price!.toStringAsFixed(0)} so'm/oyiga",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.green3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is SubscriptionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SubscriptionError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            // action for subscribe
          },
          child: const Text("Sotib olish",
              style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
    );
  }
}
