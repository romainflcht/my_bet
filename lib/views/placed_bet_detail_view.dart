import 'package:esme2526/constants/ui.dart';
import 'package:flutter/material.dart';
import 'package:esme2526/models/user_bet.dart';
import 'package:esme2526/models/bet.dart';

import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:esme2526/domain/user_bet_case.dart';

import 'package:esme2526/widgets/financial_info_widget.dart';
import 'package:esme2526/widgets/timeline_info_widget.dart';



class PlacedBetDetailPage extends StatelessWidget
{
  final UserBet userBet;

  const PlacedBetDetailPage({
      super.key, 
      required this.userBet,
    });

  @override
  Widget build(BuildContext context)
  {
    final betBox = Hive.box<Bet>('bets');
    final associatedBet = betBox.get(userBet.betId);

    final String betTitle = associatedBet?.title ?? 'Unknown Bet';


    return Scaffold(
      appBar: AppBar(title: Text(betTitle),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FinancialInfoWidget(userBet: userBet,), 
          TimelineInfoWidget(userBet: userBet,), 

          // Delete bet button. 
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
            child: FilledButton(onPressed: () async =>
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Delete Bet'),
                    content: const Text('Are you sure you want to cancel this bet? Your balance will not be refunded.'),
                    actions: [
                      FilledButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(onPressed: () async {
                          await UserBetCase().deleteUserBet(userBet.id);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                        }, 
                        style: FilledButton.styleFrom(
                        foregroundColor: AppColors.error, 
                      ),
                        child: const Text('Delete'), 
                      ),
                    ],
                  ),
                ),

              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error, 
                foregroundColor: AppColors.text, 
              ),
              child: Text('Delete bet'), 
            ),
          ), 
        ]
      )
    ); 
  }
}