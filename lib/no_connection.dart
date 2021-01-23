import 'package:flutter/material.dart';
import 'main.dart';

class NoConnectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/1_NoConnection.png",
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 100,
            left: 30,
            child: FlatButton(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {

                        return HomeScreen();
                      },
                    ),
                  );
                },
              child: Text("Ok".toUpperCase(),
              style: TextStyle(
                color: Colors.black
              )),
            ),
          )
        ],
      ),
    );
  }
}