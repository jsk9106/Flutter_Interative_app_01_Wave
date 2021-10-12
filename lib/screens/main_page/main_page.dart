import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'components/wave_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final Duration textDuration = const Duration(milliseconds: 300);

  final List<Color> colorList = [
    Colors.redAccent,
    Colors.yellowAccent,
    Colors.greenAccent,
    Colors.amber,
  ];

  List<String> innerFishList = [];
  double plusHeight = 0.0;
  bool isBlueTheme = true;

  String infoText = '';
  bool showInfo = false;

  void changeTheme(bool value) {
    setState(() {
      isBlueTheme = value;
      if (isBlueTheme) {
        infoText = '깨끗한 바다';
      } else {
        infoText = '오염된 바다';
      }

      textAnimation();
    });
  }

  void textAnimation() {
    showInfo = true;

    Timer(textDuration + const Duration(milliseconds: 1000), () {
      setState(() {
        showInfo = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          double yOffset = details.delta.dy * -1;

          setState(() {
            if (plusHeight < -100) {
              plusHeight = -100;
            } else {
              plusHeight += yOffset;
            }
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Spacer(),
            AnimatedOpacity(
              duration: textDuration,
              opacity: showInfo ? 1 : 0,
              child: Text(
                infoText,
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: 40),
            DragTarget(
              onAccept: (String data) {
                setState(() {
                  innerFishList.add(data);
                });
              },
              builder: (context, candidateData, rejectedData) => Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 6),
                        blurRadius: 6,
                        color: Color.fromRGBO(0, 0, 0, 0.05),
                      )
                    ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(300 / 2),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      buildWave(
                        waveColor: isBlueTheme
                            ? Colors.lightBlueAccent
                            : colorList[0].withOpacity(0.6),
                        waveStrength: 0.01,
                      ),
                      buildWave(
                        waveColor: isBlueTheme
                            ? Colors.lightBlue.withOpacity(0.4)
                            : colorList[1].withOpacity(0.6),
                        waveStrength: 0.006,
                      ),
                      buildWave(
                        waveColor: isBlueTheme
                            ? Colors.blue.withOpacity(0.4)
                            : colorList[2].withOpacity(0.6),
                        waveStrength: 0.002,
                      ),
                      // if (innerFishList.isNotEmpty) ...[
                      //   Positioned(
                      //     bottom: 10 + plusHeight,
                      //     left: 100,
                      //     child: SvgPicture.asset(innerFishList[0], width: 60),
                      //   ),
                      // ],
                      // if (innerFishList.length >= 2) ...[
                      //   Positioned(
                      //     bottom: 90 + plusHeight,
                      //     right: 60,
                      //     child: SvgPicture.asset(innerFishList[1], width: 60),
                      //   ),
                      // ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ThemeButton(
                  themeColor: const [Colors.blue, Colors.blueAccent],
                  onTap: () => changeTheme(true),
                ),
                const SizedBox(width: 20),
                ThemeButton(
                  themeColor: colorList,
                  onTap: () => changeTheme(false),
                ),
                const SizedBox(width: 20),
                SeaHeightButton(
                  iconData: Icons.arrow_circle_up,
                  onTap: () {
                    setState(() {
                      plusHeight += 100;
                      infoText = '해수면 상승';
                      textAnimation();
                    });
                  },
                ),
                const SizedBox(width: 20),
                SeaHeightButton(
                  iconData: Icons.arrow_circle_down,
                  onTap: () {
                    setState(() {
                      plusHeight += - 100;
                      infoText = '해수면 하강';
                      textAnimation();
                    });
                  },
                ),
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     draggableFish(svgPath + 'fish_02.svg'),
            //     const SizedBox(width: 20),
            //     draggableFish(svgPath + 'fish_03.svg'),
            //   ],
            // ),
            // const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // Draggable<Object> draggableFish(String iconPath) {
  //   return Draggable(
  //     data: iconPath,
  //     feedback: Opacity(
  //       opacity: 0.7,
  //       child: SvgPicture.asset(iconPath, width: 60),
  //     ),
  //     child: SvgPicture.asset(iconPath, width: 60),
  //   );
  // }

  Positioned buildWave(
      {required Color waveColor, required double waveStrength}) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedContainer(
        duration: textDuration,
        height: plusHeight + 150,
        child: WaveWidget(
          waveColor: waveColor,
          waveStrength: waveStrength,
        ),
      ),
    );
  }
}

class SeaHeightButton extends StatelessWidget {
  const SeaHeightButton({
    Key? key, required this.onTap, required this.iconData,
  }) : super(key: key);

  final GestureTapCallback onTap;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Icon(
          iconData,
          size: 35,
          color: CupertinoColors.white,
        ),
      ),
    );
  }
}

class ThemeButton extends StatelessWidget {
  const ThemeButton({
    Key? key,
    required this.themeColor,
    required this.onTap,
  }) : super(key: key);

  final List<Color> themeColor;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.white),
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: themeColor),
        ),
      ),
    );
  }
}
