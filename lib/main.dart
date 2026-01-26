import 'package:esme2526/hive/hive_registrar.g.dart';
import 'package:esme2526/tree_page.dart';
import 'package:flutter/material.dart';
//import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'package:esme2526/constants/ui.dart';


void main() async 
{
  // Wait for the batabase to be initialized before starting the app. 
  await Hive.initFlutter();
  Hive.registerAdapters();

  runApp(const MyBet());
}

class MyBet extends StatelessWidget 
{
  const MyBet({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyBets',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
          seedColor:   AppColors.ui,
          surface:     AppColors.background,
          brightness:  Brightness.dark,
          primary: AppColors.accent, 
        ),
      ),
      home: TreePage(),
    );
  }
}
