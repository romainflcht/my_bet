import 'package:esme2526/datas/bet_repository_hive.dart';
import 'package:esme2526/models/bet.dart';
import 'package:esme2526/widgets/bet_widget.dart';
import 'package:flutter/material.dart';

import 'package:esme2526/domain/bet_use_case.dart';
import 'package:esme2526/domain/user_use_case.dart';
import 'package:esme2526/models/user.dart';
import 'dart:math';


import 'package:flutter/cupertino.dart';
import 'package:esme2526/constants/ui.dart';
import 'package:esme2526/views/nfc_view.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> 
{

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'), 
        backgroundColor: AppColors.ui, 
        actions: [
          IconButton(
            onPressed: () async {
              List<Bet> bets = await BetUseCase().getBets();
              Bet randomBet = bets[Random().nextInt(bets.length)];

              BetRepositoryHive().saveBets([randomBet]);
            },
            icon: Icon(CupertinoIcons.add)
          ),
          IconButton(
            onPressed: () 
            {
              // NFC. 
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NFCReaderScreen()),
              );
            }, 
            icon: Icon(CupertinoIcons.badge_plus_radiowaves_right)
          )
        ],
      ),
      body: StreamBuilder<List<Bet>>(
        stream: BetRepositoryHive().getBetsStream(),
        builder: (context, snapshot) 
        {
          if (snapshot.connectionState == ConnectionState.waiting)
          {
            return Center(child: CircularProgressIndicator());
          } 
          
          else if (snapshot.hasError) 
          {
            return Center(child: Text('Error: ${snapshot.error}'));
          } 
          
          else if (snapshot.hasData && snapshot.data != null) 
          {
            List<Bet> bets = snapshot.data ?? [];
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:   1,
                    childAspectRatio: 0.9, // Adjust to your layout
                    crossAxisSpacing: 8,
                    mainAxisSpacing:  8,
                  ),
              itemCount: bets.length,
              itemBuilder:
                  (context, index) 
                  {
                    return BetWidget(bet: bets[index]);
                  },
            );
          }
      
          return Center(child: Text('No Data'));
        },
      ),
    );
  }
}
