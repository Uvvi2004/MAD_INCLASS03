import 'package:flutter/material.dart';

void main() => runApp(const ValentineApp());

class ValentineApp extends StatelessWidget {
  const ValentineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ValentineHome(),
    );
  }
}

class ValentineHome extends StatefulWidget {
  const ValentineHome({super.key});

  @override
  State<ValentineHome> createState() => _ValentineHomeState();
}

class _ValentineHomeState extends State<ValentineHome>
    with SingleTickerProviderStateMixin {
  final List<String> emojiOptions = ['Sweet Heart', 'Party Heart'];
  String selectedEmoji = 'Sweet Heart';

  bool showBalloons = false;
  double balloonOffset = -400;

  // Heartbeat control
  bool heartbeatOn = false;
  late final AnimationController _beatController;
  late final Animation<double> _beatAnim;

  @override
  void initState() {
    super.initState();

    // Heartbeat: scale up/down repeatedly
    _beatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _beatAnim = Tween<double>(begin: 1.0, end: 1.18).animate(
      CurvedAnimation(parent: _beatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _beatController.dispose();
    super.dispose();
  }

  void _toggleHeartbeat() {
    setState(() {
      heartbeatOn = !heartbeatOn;
    });

    if (heartbeatOn) {
      _beatController.repeat(reverse: true);
    } else {
      _beatController.stop();
      _beatController.reset(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isParty = selectedEmoji == 'Party Heart';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cupid's Canvas"),
        backgroundColor: isParty ? Colors.red : Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              isParty
                  ? 'assets/images/Red_Background.webp'
                  : 'assets/images/download.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),

            DropdownButton<String>(
              value: selectedEmoji,
              items: emojiOptions
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) =>
                  setState(() => selectedEmoji = value ?? selectedEmoji),
            ),

            const SizedBox(height: 12),

            
            ElevatedButton(
              onPressed: _toggleHeartbeat,
              child: Text(heartbeatOn ? "Pulse: ON ❤️" : "Pulse: OFF"),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  showBalloons = true;
                  balloonOffset = -400;
                });

                Future.delayed(const Duration(milliseconds: 50), () {
                  setState(() {
                    balloonOffset = 1300; 
                  });
                });

                Future.delayed(const Duration(seconds: 5), () {
                  setState(() {
                    showBalloons = false;
                  });
                });
              },
              child: const Text("Balloon Celebration 🎈"),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: ScaleTransition(
                      scale: heartbeatOn
                          ? _beatAnim
                          : const AlwaysStoppedAnimation(1.0),
                      child: Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              isParty
                                  ? 'assets/images/Party_Heart_Picture.png'
                                  : 'assets/images/Love_Heart_Image.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),

                  if (showBalloons)
                    ...List.generate(20, (index) {
                      final randomLeft = (index * 97) % 360 + 10;
                      final randomSpacing = (index * 113) % 250;

                      final pinkRedShades = [
                        Colors.pink.shade200,
                        Colors.pink.shade300,
                        Colors.pink.shade400,
                        Colors.pink.shade600,
                        Colors.red.shade300,
                        Colors.red.shade400,
                        Colors.red.shade600,
                        Colors.red.shade800,
                      ];

                      final dropDuration =
                          Duration(milliseconds: 3500 + (index * 120));

                      return AnimatedPositioned(
                        duration: dropDuration,
                        curve: Curves.easeIn,
                        top: balloonOffset + randomSpacing,
                        left: randomLeft.toDouble(),
                        child: Column(
                          children: [
                            Container(
                              width: 28,
                              height: 42,
                              decoration: BoxDecoration(
                                color: pinkRedShades[index % pinkRedShades.length],
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            Container(
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 35,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
