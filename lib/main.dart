import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animation Tutorial',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AnimationPage(),
    );
  }
}

class AnimationPage extends StatefulWidget {
  const AnimationPage({super.key});

  @override
  State<AnimationPage> createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage> {
  // Variables to control animations
  bool isExpanded = false; // Controls AnimatedContainer size
  bool showText = true; // Controls FadeTransition opacity
  Color containerColor = Colors.blue; // Container color that will change

  // Function to toggle all animations
  void triggerAnimations() {
    setState(() {
      isExpanded = !isExpanded;
      showText = !showText;
      // Change color when expanded
      containerColor = isExpanded ? Colors.orange : Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Animations'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // Full screen background image using Container and BoxDecoration
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bgforeliflutter.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        // Center content on the background
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ===== ANIMATION 1: AnimatedContainer =====
              // This widget smoothly animates size and color changes
              GestureDetector(
                onTap: triggerAnimations,
                child: AnimatedContainer(
                  // Duration controls how long the animation takes
                  duration: const Duration(milliseconds: 500),
                  // Smooth curve for animation
                  curve: Curves.easeInOut,
                  // Box changes size based on isExpanded
                  width: isExpanded ? 200 : 100,
                  height: isExpanded ? 200 : 100,
                  // Box changes color based on containerColor
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  // Icon in the center of the box
                  child: const Icon(
                    Icons.favorite,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // ===== ANIMATION 2: FadeTransition (Opacity Animation) =====
              // This widget fades text in and out
              FadeTransition(
                // opacity changes from 0 to 1 smoothly
                opacity: AlwaysStoppedAnimation(showText ? 1.0 : 0.0),
                child: Text(
                  showText ? 'Tap the box to animate!' : 'Text faded out!',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // ===== ANIMATION 3: Button to trigger all animations =====
              ElevatedButton.icon(
                onPressed: triggerAnimations,
                icon: const Icon(Icons.animation),
                label: const Text('Start Animations'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Status text showing current animation state
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isExpanded ? 'Box is EXPANDED' : 'Box is SMALL',
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
