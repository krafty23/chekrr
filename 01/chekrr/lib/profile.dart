import 'package:flutter/material.dart';

class Profilescreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Jaroslav Krafty',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Nothing',
                    fontSize: 45.0,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(6.0, 6.0),
                        blurRadius: 7.0,
                        color: Color.fromRGBO(15, 1, 24, 1),
                      ),
                    ],
                    color: Color.fromRGBO(203, 135, 235, 1)),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            fit: FlexFit.tight,
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'Jaroslav Krafty',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Nothing',
                        fontSize: 45.0,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(6.0, 6.0),
                            blurRadius: 7.0,
                            color: Color.fromRGBO(15, 1, 24, 1),
                          ),
                        ],
                        color: Color.fromRGBO(203, 135, 235, 1)),
                  ),
                  Text(
                    'Level 6',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 45.0, color: Color.fromRGBO(143, 85, 168, 1)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
