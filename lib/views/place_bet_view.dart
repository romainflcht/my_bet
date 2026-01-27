import 'package:esme2526/constants/ui.dart';
import 'package:esme2526/domain/user_bet_case.dart';
import 'package:esme2526/models/bet.dart';
import 'package:esme2526/models/user_bet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:esme2526/utils/utils.dart';


class BetPage extends StatefulWidget 
{
  final Bet bet;
  final TextEditingController textEditingController;

  BetPage({super.key, required this.bet, required this.textEditingController}) 
  {
    textEditingController.text = "";
  }

  @override
  State<BetPage> createState() => _BetPageState();
}

class _BetPageState extends State<BetPage> 
{
  double potentialGain = 0; 

  // _ METHODS _________________________________________________________________
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(title: Text(widget.bet.title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: 
        [
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Text(widget.bet.description)
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              margin: EdgeInsets.only(bottom: 15.0),
              child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF781F),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          widget.bet.odds.toStringAsFixed(2),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold, 
                            color: AppColors.text
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Color(0xFF00B5FF), 
                          borderRadius: BorderRadius.circular(8.0)
                        ),
                        child: Text(
                          formatDateTime(widget.bet.startTime), 
                          style: const TextStyle(
                            fontWeight: FontWeight.bold, 
                            color: AppColors.text
                          ),
                        ),
                      ),
                    ],
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              controller: widget.textEditingController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),  
              ],
              decoration: InputDecoration(border: OutlineInputBorder(), labelText: "Enter your bet"),
              onChanged: (text) 
              {
                setState(() 
                {
                  potentialGain = (double.tryParse(text) ?? 0) * widget.bet.odds;
                });
              },
            ),
          ),

          // Potential gain text section. 
          Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE606),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
            child: Text(
              'Potential gain: +${potentialGain.toStringAsFixed(2)}\$',
              style: const TextStyle(
                
                fontWeight: FontWeight.bold, 
                color: AppColors.invertText,
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            child: FilledButton(
              onPressed: () async 
              {
                final amount = int.tryParse(widget.textEditingController.text) ?? 0;

                if (amount <= 0)
                {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Enter a valid bet.'), 
                      backgroundColor: AppColors.error,
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    )
                  );
                  return; 
                }

                try
                {
                  await UserBetCase().createUserBet(
                    UserBet(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      userId: "1",
                      betId: widget.bet.id,
                      amount: int.parse(widget.textEditingController.text),
                      odds: widget.bet.odds,
                      payout: widget.bet.odds * int.parse(widget.textEditingController.text),
                      createdAt: DateTime.now(),
                    ),
                  );

                if (mounted) 
                {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Bet placed successfully!'),
                          backgroundColor: AppColors.accent,
                          duration: Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating, 
                        ),
                      );
                  }
                  Navigator.of(context).pop(true);
                }

                catch (err)
                {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error while placing the bet: $err'), 
                      backgroundColor: AppColors.error,
                        duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),  
                  );
                }
                

              },
              child: Text("Place Bet"),
            ),
          ),
        ],
      ),
    );
  }
}
