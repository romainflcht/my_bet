import 'package:esme2526/domain/user_use_case.dart';
import 'package:esme2526/models/user.dart';
import 'package:esme2526/views/feed_view.dart';
import 'package:esme2526/views/profile_view.dart';
import 'package:esme2526/views/placed_bets_view.dart';
import 'package:flutter/material.dart';

import 'package:esme2526/widgets/navbar_widget.dart';
import 'package:esme2526/datas/notifiers.dart';

class TreePage extends StatefulWidget 
{
  const TreePage({super.key});

  @override
  State<TreePage> createState() => _TreePageState();
}


class _TreePageState extends State<TreePage> 
{
  late Future<User> _userFuture;

  // _ METHODS _________________________________________________________________
  @override
  void initState() 
  {
    super.initState();
    UserUseCase userUseCase = UserUseCase();
    _userFuture = userUseCase.getUser();
  }

  @override
  Widget build(BuildContext context) 
  {
    return FutureBuilder<User>(
      future: _userFuture,
      builder: (context, snapshot) 
      {
        final user = snapshot.data!;

        // Waiting for the database response.  
        if (snapshot.connectionState == ConnectionState.waiting) 
        {
          return Scaffold(
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        // Database request failed. 
        if (snapshot.hasError) 
        {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        // Database request succeded. 
        return Scaffold(
          body: _getBody(user),
          bottomNavigationBar: NavbarWidget(), 
        );
      },
    );
  }


  Widget _getBody(User user) 
  {
    return ValueListenableBuilder(
          valueListenable: navbarSelectedViewNotifier,
          builder: (context, pageIndex, child) 
          {
            switch (pageIndex) 
            {
              case 0:
                return HomePage();
              case 1:
                return PlacedBetsPage();
              case 2:
                return ProfilePage(user: user);
              default:
                return const Center(child: Text('Home'));
            }
          }
        );
  }
}