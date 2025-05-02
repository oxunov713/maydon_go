import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';
import '../../../../common/model/tournament_model.dart';
import '../../../bloc/tournament_cubit/tournament_cubit.dart';
import '../../../bloc/tournament_cubit/tournament_state.dart';

class TournamentPage extends StatefulWidget {
  const TournamentPage({super.key});

  @override
  State<TournamentPage> createState() => _TournamentPageState();
}

class _TournamentPageState extends State<TournamentPage> {
  @override
  void initState() {
    super.initState();
    context.read<TournamentCubit>().loadTournaments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Turnirlar'),
        centerTitle: true,
      ),
      backgroundColor: AppColors.white2,
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<TournamentCubit, TournamentState>(
              listener: (context, state) {
                if (state is TournamentError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is TournamentLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.green),
                  );
                }
                if (state is TournamentLoaded) {
                  return _TournamentList(tournaments: state.tournaments);
                }
                return const Center(child: Text('Turnirlar ro‘yxati bo‘sh'));
              },
            ),
          ),
          _buildInfoSection(), // Ma'lumot qismini alohida metodga ajratdim
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb_outline,
              color: AppColors.green,
              size: 24,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                "Turnir maksimum ovozga yetganda boshlanadi",
                style: TextStyle(
                  color: AppColors.grey4.withOpacity(0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TournamentList extends StatelessWidget {
  final List<Tournament> tournaments;

  const _TournamentList({required this.tournaments});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<TournamentCubit>().loadTournaments(),
      color: AppColors.green,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tournaments.length,
        itemBuilder: (context, index) =>
            _TournamentCard(tournament: tournaments[index]),
      ),
    );
  }
}

class _TournamentCard extends StatelessWidget {
  final Tournament tournament;

  const _TournamentCard({required this.tournament});

  @override
  Widget build(BuildContext context) {
    final double progress =
        tournament.maxCount > 0 ? tournament.count / tournament.maxCount : 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      // Xato: "bottom" bo‘lishi kerak
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    tournament.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Chip(
                  label: Text(
                    '${tournament.count}/${tournament.maxCount}',
                    style: TextStyle(
                        color: AppColors.green, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.grey[200],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              tournament.description,
              style: TextStyle(color: AppColors.grey4, fontSize: 14),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
              backgroundColor: Colors.blue.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(
                  progress >= 1 ? Colors.green : Colors.blue),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: BlocBuilder<TournamentCubit, TournamentState>(
                builder: (context, state) {
                  final isMaxReached = tournament.count >= tournament.maxCount;
                  final isVoted = state is TournamentLoaded &&
                      state.votedList.contains(tournament.id);

                  return ElevatedButton.icon(
                    onPressed: (isVoted || isMaxReached)
                        ? null
                        : () => context
                            .read<TournamentCubit>()
                            .voteForTournament(tournament.id),
                    icon:
                        const Icon(Icons.add, size: 18, color: AppColors.white),
                    label: Text(
                      isVoted ? "Ovoz berilgan" : "Ovoz berish",
                      style: const TextStyle(color: AppColors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      backgroundColor: isVoted || isMaxReached
                          ? Colors.grey
                          : AppColors.green2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
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
