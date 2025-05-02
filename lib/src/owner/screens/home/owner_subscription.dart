import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';
import 'package:maydon_go/src/common/tools/price_formatter_extension.dart';
import 'package:maydon_go/src/owner/bloc/home/owner_home_cubit.dart';
import 'package:maydon_go/src/owner/bloc/home/owner_home_state.dart';

import '../../../common/l10n/app_localizations.dart';

class OwnerSubscriptionPage extends StatefulWidget {
  @override
  State<OwnerSubscriptionPage> createState() => _OwnerSubscriptionPageState();
}

class _OwnerSubscriptionPageState extends State<OwnerSubscriptionPage> {
  @override
  void initState() {
    context.read<OwnerHomeCubit>().fetchSubscriptions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.subscriptionPackages)),
      backgroundColor: AppColors.white2,
      body: RefreshIndicator(
        onRefresh: () => context.read<OwnerHomeCubit>().fetchSubscriptions(),
        child: BlocBuilder<OwnerHomeCubit, OwnerHomeState>(
          builder: (context, state) {
            if (state is OwnerHomeLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is OwnerHomeError) {
              return Center(child: Text(l10n.errorLoading));
            } else if (state is OwnerHomeLoadedState) {
              final subscriptions = state.subscriptions;
              if (subscriptions.isEmpty) {
                return Center(child: Text("No data"));
              }
              return SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: subscriptions.map((subscription) {
                    return SubscriptionCard(
                      title: subscription.description ?? l10n.subscription,
                      price: "${subscription.price?.formatWithSpace()} so'm",
                      isBought: false,
                      onTap: () => _subscribe(
                        context,
                        "${subscription.price?.formatWithSpace()} so'm",
                        l10n,
                      ),
                    );
                  }).toList(),
                ),
              );
            } else {
              context.read<OwnerHomeCubit>().fetchSubscriptions();
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  void _subscribe(BuildContext context, String price, AppLocalizations l10n) {

  }
}

class SubscriptionCard extends StatelessWidget {
  final String title;
  final String price;
  final VoidCallback onTap;
  final bool isBought;

  const SubscriptionCard({
    required this.title,
    required this.price,
    required this.onTap,
    required this.isBought,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      price,
                      style: TextStyle(
                        color: AppColors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isBought ? AppColors.green.withOpacity(0.1) : AppColors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isBought ? l10n.active : l10n.inactive,
                  style: TextStyle(
                    color: isBought ? AppColors.green : AppColors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}