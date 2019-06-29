import 'package:flutter/material.dart';
import 'dart:async';

class PhoneCaptchaButton extends StatefulWidget {
  final onCallback;
  PhoneCaptchaButton(this.onCallback);
  @override
  _PhoneCaptchaButtonState createState() => _PhoneCaptchaButtonState();
}

class _PhoneCaptchaButtonState extends State<PhoneCaptchaButton> {
  Timer _countdownTimer;
  final int cd = 60;
  String title = '短信验证';
  var _onPressed;

  countdown() async {
    setState(() {
      _onPressed = null;
    });

    bool success = await widget.onCallback();
    if(!success){
      setState(() {
        _onPressed = countdown;
      });
      return;
    }

    _countdownTimer =  new Timer.periodic(new Duration(seconds: 1), (timer) {
      setState(() {
        if(_countdownTimer.tick < cd){
          title = '${cd - _countdownTimer.tick}s后重发';
          _onPressed = null;
        }else{
          _countdownTimer.cancel();
          _countdownTimer = null;
          title = '重新发送';
          _onPressed = countdown;
        }
      });
    });

    setState(() {
      title = '${cd}s后重发';
      _onPressed = null;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onPressed = countdown;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _countdownTimer?.cancel();
    _countdownTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      child: RaisedButton(
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        onPressed: _onPressed,
        color: Colors.black,
      ),
    );
  }
}
