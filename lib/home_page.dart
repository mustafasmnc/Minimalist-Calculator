import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:math_expressions/math_expressions.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _light = true;
  String equation = "0";
  String result = "0";
  String expression = "";
  double equationFontSize = 38.0;
  double resultFontSize = 48.0;
  Color bgLightColor = Hexcolor("#EDEDED");
  Color bgDarkColor = Hexcolor("#212121");
  Color bgBlueColor = Hexcolor("#0EB2C8");
  Color bgGreenColor = Hexcolor("#23eb8a");
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Material(
      child: Container(
        color: _light == true ? bgLightColor : bgDarkColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Transform.scale(
                    scale: 1.5,
                    child: Switch(
                        activeThumbImage: AssetImage("assets/images/sun.png"),
                        inactiveThumbImage:
                            AssetImage("assets/images/moon.png"),
                        activeTrackColor: Hexcolor("#f77e00"),
                        inactiveTrackColor: Hexcolor("#27536b"),
                        activeColor: bgLightColor,
                        value: _light,
                        onChanged: (toggle) {
                          setState(() {
                            _light = toggle;
                          });
                        }),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.72,
              height:
                  Theme.of(context).textTheme.display1.fontSize * 1.1 + 120.0,
              decoration: BoxDecoration(
                color: _light == true ? bgLightColor : bgDarkColor,
              ),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    equation.toString(),
                    style: GoogleFonts.montserrat(
                      fontSize: equationFontSize,
                      color: _light == true ? Colors.black54 : bgLightColor,
                      backgroundColor:
                          _light == true ? bgLightColor : bgDarkColor,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    result.toString(),
                    style: GoogleFonts.montserrat(
                        fontSize: resultFontSize,
                        color: _light == true ? Colors.black87 : bgLightColor,
                        backgroundColor:
                            _light == true ? bgLightColor : bgDarkColor),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _button("C"),
                          _button("7"),
                          _button("4"),
                          _button("1"),
                          _button(".")
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _button("⌫"),
                          _button("8"),
                          _button("5"),
                          _button("2"),
                          _button("0"),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _button("÷"),
                          _button("9"),
                          _button("6"),
                          _button("3"),
                          _button("00"),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _button("×"),
                          _button("-"),
                          _button("+"),
                          _button("="),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _button(String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      height: text == "=" ? 140 : 65,
      width: 65.0,
      child: ButtonTheme(
        child: RaisedButton(
          child: Text(text,
              style: GoogleFonts.montserrat(
                  fontWeight: text == "C" ? FontWeight.bold : FontWeight.w300,
                  fontSize: (text == "+" ||
                          text == "-" ||
                          text == "." ||
                          text == "÷" ||
                          text == "=" ||
                          text == "×")
                      ? 38.0
                      : 20.0)),
          textColor: text == "="
              ? Colors.white
              : text == "÷"
                  ? bgBlueColor
                  : text == "⌫"
                      ? bgBlueColor
                          : text == "C"
                              ? bgBlueColor
                                  : text == "×"
                                      ? bgBlueColor
                                      : text == "-"
                                          ? bgBlueColor
                                          : text == "+"
                                              ? bgBlueColor
                                              : _light == true
                                                  ? Colors.black54
                                                  : Colors.white,
          color: text == "="
              ? bgBlueColor
              : _light == true ? bgLightColor : bgDarkColor,
          onPressed: () => buttonPressed(text),
          shape: text == "="
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0))
              : CircleBorder(
                  side: BorderSide(
                      color: _light == true
                          ? bgLightColor
                          : (text == "C" || text == "⌫" || text == "÷" || text == "×" || text == "-" || text == "+")
                              ? Hexcolor("#363636")
                              : Hexcolor("#363636"))),
          elevation: 8,
        ),
      ),
    );
  }

  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        equation = "0";
        result = "0";
        equationFontSize = 38.0;
        resultFontSize = 48.0;
      } else if (buttonText == "⌫") {
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        equation = equation.substring(0, equation.length - 1);
        if (equation == "") {
          equation = "0";
        }
      } else if (buttonText == "=") {
        equationFontSize = 38.0;
        resultFontSize = 48.0;

        expression = equation;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');

        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
        } catch (e) {
          result = "Error";
        }
      } else {
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        if (equation == "0") {
          equation = buttonText;
        } else {
          equation = equation + buttonText;
        }
      }
    });
  }
}
