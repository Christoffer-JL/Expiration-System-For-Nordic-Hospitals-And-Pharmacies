import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: ListView(children: const [
          StartskRm(),
        ]),
      ),
    );
  }
}

class StartskRm extends StatelessWidget {
  const StartskRm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(



      children: [
        Container(
          width: 390,
          height: 844,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            
            children: [
               GestureDetector(
                    onTap: () {
            // Navigate to the DummyScreen when the button is pressed.
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MenyskRm(),
            ));
          },
                     ),
              Positioned(
                left: 40,
                top: 168,
                child: Container(
                  width: 287,
                  height: 74,
                  decoration: ShapeDecoration(
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 54,
                top: 182,
                child: Text(
                  'Registrera vara',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontFamily: 'Inika',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MenyskRm extends StatelessWidget {
  const MenyskRm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 390,
          height: 844,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                left: 47,
                top: 260,
                child: Container(
                  width: 218,
                  height: 56,
                  decoration: BoxDecoration(color: Color(0xFFD9D9D9)),
                ),
              ),
              Positioned(
                left: 90,
                top: 275,
                child: Text(
                  'Produktnam / kod',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Inika',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 47,
                top: 351,
                child: Container(
                  width: 218,
                  height: 56,
                  decoration: BoxDecoration(color: Color(0xFFD9D9D9)),
                ),
              ),
              Positioned(
                left: 47,
                top: 457,
                child: Container(
                  width: 218,
                  height: 56,
                  decoration: BoxDecoration(color: Color(0xFFD9D9D9)),
                ),
              ),
              Positioned(
                left: 60,
                top: 472,
                child: Text(
                  'Utgångsdatum',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Inika',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 47,
                top: 563,
                child: Container(
                  width: 218,
                  height: 56,
                  decoration: BoxDecoration(color: Color(0xFFD9D9D9)),
                ),
              ),
              Positioned(
                left: 60,
                top: 578,
                child: Text(
                  'EAN',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Inika',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 56,
                top: 366,
                child: Text(
                  'Batch NR',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Inika',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 216,
                top: 64,
                child: Container(
                  width: 98,
                  height: 98,
                  decoration: ShapeDecoration(
                    color: Color(0xFFD9D9D9),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 235,
                top: 83,
                child: Container(
                  width: 61,
                  height: 61,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://via.placeholder.com/61x61"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 56,
                top: 275,
                child: Container(
                  width: 29,
                  height: 26,
                  decoration: BoxDecoration(color: Colors.white),
                ),
              ),
              Positioned(
                left: 83,
                top: 298,
                child: Transform(
                  transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(-3.14),
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: ShapeDecoration(
                      color: Color(0x00D9D9D9),
                      shape: StarBorder.polygon(side: BorderSide(width: 1), sides: 3),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 59,
                top: 278,
                child: Container(
                  width: 24,
                  height: 3,
                  decoration: BoxDecoration(color: Colors.white),
                ),
              ),
              Positioned(
                left: 277,
                top: 578,
                child: Container(
                  width: 84,
                  height: 31,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://via.placeholder.com/84x31"),
                      fit: BoxFit.fill,
                    ),
                    shape: RoundedRectangleBorder(side: BorderSide(width: 2)),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 26,
                child: Container(
                  width: 54,
                  height: 48,
                  decoration: ShapeDecoration(
                    color: Colors.black,
                    shape: OvalBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class QrSkRm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 390,
          height: 844,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                left: 17,
                top: 80,
                child: Container(
                  width: 356,
                  height: 476,
                  decoration: ShapeDecoration(
                    color: Color(0x00D9D9D9),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 7),
                      borderRadius: BorderRadius.circular(84),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 120,
                top: 28,
                child: Container(
                  width: 150,
                  height: 610,
                  decoration: BoxDecoration(color: Colors.white),
                ),
              ),
              Positioned(
                left: 470.47,
                top: 192.31,
                child: Transform(
                  transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(1.58),
                  child: Container(
                    width: 286.42,
                    height: 610,
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                ),
              ),
              Positioned(
                left: 19,
                top: 14,
                child: Container(
                  width: 54,
                  height: 48,
                  decoration: ShapeDecoration(
                    color: Colors.black,
                    shape: OvalBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class EanSkRm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 390,
          height: 844,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                left: 17,
                top: 238,
                child: Container(
                  width: 356,
                  height: 187,
                  decoration: ShapeDecoration(
                    color: Color(0x00D9D9D9),
                    shape: RoundedRectangleBorder(side: BorderSide(width: 7)),
                  ),
                ),
              ),
              Positioned(
                left: 244,
                top: 648,
                child: Transform(
                  transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(-3.14),
                  child: Container(
                    width: 98,
                    height: 610,
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                ),
              ),
              Positioned(
                left: -128,
                top: 379,
                child: Transform(
                  transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(-1.57),
                  child: Container(
                    width: 98,
                    height: 610,
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                ),
              ),
              Positioned(
                left: 19,
                top: 14,
                child: Container(
                  width: 54,
                  height: 48,
                  decoration: ShapeDecoration(
                    color: Colors.black,
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 266,
                child: Transform(
                  transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(-3.09),
                  child: Container(
                    width: 148.17,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}