import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('关于我们'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: a.px30, bottom: a.px20),
              color: Color.fromARGB(255, 97, 97, 111),
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  Image.asset(CustomIcons.logo, width: a.px(60), fit: BoxFit.fill),
                  SizedBox(height: a.px20,),
                  Text('股票配资神奇', style: TextStyle(fontSize: a.px18, color: Colors.white, fontWeight: FontWeight.w500),)
                ],
              )
            )
          ],
        ),
      )
    );
  }
}