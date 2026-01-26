import 'package:esme2526/constants/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:esme2526/datas/notifiers.dart';

class NavbarWidget extends StatelessWidget 
{
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return ValueListenableBuilder(
      valueListenable: navbarSelectedViewNotifier,
      builder: (context, pageIndex, child) 
      {
        return NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          shadowColor: AppColors.background,
          destinations: [
            NavigationDestination(
              icon: Icon(CupertinoIcons.game_controller),
              label: "feed",
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.list_bullet),
              label: "bets",
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.person),
              label: "account",
            ),
          ],
          selectedIndex: pageIndex,

          onDestinationSelected: (itemIndex) {
            navbarSelectedViewNotifier.value = itemIndex;
          },
        );
      },
    );
  }
}
