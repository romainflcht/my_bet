import 'package:flutter/material.dart';
import 'package:esme2526/models/user_bet.dart';
import 'package:esme2526/constants/ui.dart';



class FinancialInfoWidget extends StatelessWidget
{
  final UserBet userBet;

  const FinancialInfoWidget({
      super.key, 
      required this.userBet,
    });

  @override
  Widget build(BuildContext context)
  {
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
              "Financial",
              style: const TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold, 
                color: AppColors.text
              ),
            ),
          ),
          GridView.count(
            crossAxisCount: 2, 
            physics: NeverScrollableScrollPhysics(), 
            shrinkWrap: true, 
            childAspectRatio: 5.0,
            crossAxisSpacing: 10.0,
            children: [
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  'Odds',
                  style: const TextStyle(
                    color: AppColors.text, 
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  userBet.odds.toStringAsFixed(2),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, 
                    color: AppColors.text,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  'Amount placed',
                  style: const TextStyle(
                    color: AppColors.text
                  ),
                ),
              ), 
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "-${userBet.amount.toStringAsFixed(2)}\$",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, 
                    color: AppColors.error
                  ),
                ),
              ), 
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  'Potential gain',
                  style: const TextStyle(
                    color: AppColors.text,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "+${userBet.payout.toStringAsFixed(2)}\$",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, 
                    color: AppColors.accent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}