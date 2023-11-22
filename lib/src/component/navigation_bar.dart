import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyBottomNavigationBar extends StatelessWidget {
  
  BuildContext context;
  bool isHome;
  MyBottomNavigationBar({required this.context, required this.isHome});
  
  @override
  Widget build(BuildContext context) {
    //int _selectedIndex = 0;
    return  BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          /*BottomNavigationBarItem(
            icon: Icon(Icons.remove_road_outlined),
            label: 'Viagem',
          ),*/
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'Sair',
          ),
        ],
        //currentIndex: _selectedIndex,
        onTap: (int index) {
          if (index == 0 && !this.isHome) {
            Navigator.pushNamed(this.context, '/');
          } else if (index == 1) {
            //Navigator.pushNamed(this.context, '/trip');  
          } else if (index == 2) {  
            SystemNavigator.pop();
          } else if (!this.isHome){
            Navigator.pushNamed(this.context, '/');
          }
        }
      );

  }
}
