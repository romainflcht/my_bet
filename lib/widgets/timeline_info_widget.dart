import 'package:flutter/material.dart';
import 'package:esme2526/models/user_bet.dart';
import 'package:esme2526/models/bet.dart';
import 'package:esme2526/constants/ui.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:esme2526/utils/utils.dart';



class TimelineInfoWidget extends StatelessWidget 
{
  final UserBet userBet; 

  const TimelineInfoWidget({
    super.key, 
    required this.userBet, 
  });

  @override
  Widget build(BuildContext context) 
  {

    final now             = DateTime.now();
    final betBox          = Hive.box<Bet>('bets');
    final associatedBet   = betBox.get(userBet.betId);
    final betEndTime      = associatedBet?.endTime ?? DateTime.now();
    final totalDuration   = betEndTime.difference(userBet.createdAt).inSeconds;
    final elapsedDuration = now.difference(userBet.createdAt).inSeconds;
    double progress       = 0.0;

    if (totalDuration > 0) 
    {
      progress = elapsedDuration / totalDuration;
    }

    progress = progress.clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(5.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: AppColors.ui,
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent, 
            spreadRadius: -1, 
            blurRadius: 4, 
            offset: const Offset(0, 0)
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 5.0, left: 15.0),
            child: Text(
              "Timeline",
              style: const TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold, 
                color: AppColors.text
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 10,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300, 
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Stack(
                    children: [
                      FractionallySizedBox(
                        widthFactor: progress, 
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Placed: ${formatDateTime(userBet.createdAt)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, 
                    color: AppColors.text
                  ),
                ), 
                Text(
                  'Expiration: ${formatDateTime(betEndTime)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, 
                    color: AppColors.text
                  ),
                ), 
              ],
            ),
          )
        ]
      )
    );
  }
}