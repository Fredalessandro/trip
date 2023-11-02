import 'package:flutter/material.dart';
import 'package:trip/src/component/navigation_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage>  {
  
  @override
  Widget build(BuildContext context) {
 
    return MaterialApp( 
      
      home: Scaffold(
      appBar: AppBar(
        actions: <Widget> [
          IconButton(
              icon: Icon(Icons.manage_accounts_outlined),
              onPressed: () {
                
              },
            ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
        title:
            Text('Diário de Viagem',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                )),
      ),
                
      body: Text(''),
      bottomNavigationBar: MyBottomNavigationBar(context: context,isHome: true)
      )
    );
    
  }
}