import 'package:esme2526/constants/ui.dart';
import 'package:esme2526/datas/user_bet_repository_hive.dart';
import 'package:esme2526/models/user_bet.dart';
import 'package:esme2526/models/bet.dart';
import 'package:flutter/material.dart';

import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:esme2526/utils/utils.dart';

class PlacedBetsPage extends StatelessWidget {
  const PlacedBetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userBetRepository = UserBetRepositoryHive();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bets'), 
        backgroundColor: AppColors.ui
      ),
      body: StreamBuilder<List<UserBet>>(
        stream: userBetRepository.getUserBetsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final userBets = snapshot.data ?? [];

          if (userBets.isEmpty) {
            return const Center(
              child: Text('No bets yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
            );
          }

          return ListView.builder(
            itemCount: userBets.length,
            itemBuilder: (context, index) 
            {
              final userBet = userBets[index];
              final betBox = Hive.box<Bet>('bets');
              final associatedBet = betBox.get(userBet.betId);

              final String betTitle = associatedBet?.title ?? 'Unknown Bet';
              final String betDesc = associatedBet?.description ?? 'Unknown Bet';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    betTitle, 
                    style: const TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 16
                    )
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          betDesc, 
                          style: TextStyle(
                            color: AppColors.descText
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 5.0),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF781F),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          'Odds: ${userBet.odds.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 5.0),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          'Amount placed: ${userBet.amount.toStringAsFixed(2)}\$',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold, 
                            color: AppColors.invertText),
                        ),
                      ), 
                      Container(
                        margin: const EdgeInsets.only(bottom: 5.0),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE606),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          'Potential gain: +${userBet.payout.toStringAsFixed(2)}\$',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold, 
                            color: AppColors.invertText,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 5.0),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Color(0xFF00B5FF), 
                          borderRadius: BorderRadius.circular(8.0)
                        ),
                        child: Text(
                          'Placed at ${formatDateTime(userBet.createdAt)}',
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.text),
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final year = dateTime.year.toString();
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$year/$month/$day at $hour:$minute';
  }
}
