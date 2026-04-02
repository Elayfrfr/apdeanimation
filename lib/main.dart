import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;

  bool isExpanded = false;
  bool showText = true;

  // 🔥 EXPLICIT ANIMATION
  late AnimationController _controller;
  late Animation<double> rotation;

  final List<String> titles = ["Home", "Profile", "Messages", "Settings"];

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    rotation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.repeat(); // keeps rotating
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentIndex]),
        centerTitle: true,
      ),

      // ===== DRAWER =====
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Center(
                child: Text("Menu",
                    style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
            ),
            drawerItem(Icons.home, "Home", 0),
            drawerItem(Icons.person, "Profile", 1),
            drawerItem(Icons.message, "Messages", 2),
            drawerItem(Icons.settings, "Settings", 3),
          ],
        ),
      ),

      // ===== BODY =====
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/mabgpinkeu.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: const Color.fromRGBO(0, 0, 0, 0.6),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: getPage(),
          ),
        ),
      ),

      // ===== BOTTOM NAV =====
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Messages"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }

  // ===== DRAWER ITEM =====
  Widget drawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        setState(() => currentIndex = index);
      },
    );
  }

  // ===== PAGE SWITCH =====
  Widget getPage() {
    switch (currentIndex) {
      case 0:
        return homePage();
      case 1:
        return profilePage();
      case 2:
        return const MessagesPage(key: ValueKey("messages"));
      case 3:
        return settingsPage();
      default:
        return homePage();
    }
  }

  //////////////////////////////////////////////////
  // HOME (Implicit + Explicit + Hero + Fade)
  //////////////////////////////////////////////////

  Widget homePage() {
    return Center(
      key: const ValueKey("home"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.home, size: 80),
          const SizedBox(height: 10),
          const Text("Welcome Back 👋", style: TextStyle(fontSize: 22)),
          const SizedBox(height: 30),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 600),
                  pageBuilder: (_, __, ___) => const ProfileDetailPage(),
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              );
            },
            child: Hero(
              tag: "profileHero",
              child: RotationTransition(
                turns: rotation, // 🔥 explicit animation
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: isExpanded ? 200 : 120,
                  height: isExpanded ? 200 : 120,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person, size: 40),
                        Text("Tap Me"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: showText ? 1 : 0,
            child: const Text("Tap button to animate"),
          ),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {
              setState(() {
                isExpanded = !isExpanded;
                showText = !showText;
              });
            },
            child: const Text("Animate"),
          ),
        ],
      ),
    );
  }

  //////////////////////////////////////////////////
  // PROFILE
  //////////////////////////////////////////////////

  Widget profilePage() {
    return Center(
      key: const ValueKey("profile"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.deepPurple,
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 10),
          const Text("Joise Velascos",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Text("Flutter Developer"),
          const SizedBox(height: 20),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: showText ? 1 : 0,
            child: const Text("Hello! This is your profile ✨"),
          ),
          ElevatedButton(
            onPressed: () => setState(() => showText = !showText),
            child: const Text("Toggle Info"),
          ),
        ],
      ),
    );
  }

  //////////////////////////////////////////////////
  // SETTINGS (Implicit)
  //////////////////////////////////////////////////

  Widget settingsPage() {
    return Center(
      key: const ValueKey("settings"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.settings, size: 80),
          const SizedBox(height: 10),
          const Text("App Settings"),
          const SizedBox(height: 30),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: isExpanded ? 200 : 100,
            height: 20,
            color: Colors.deepPurple,
          ),
          ElevatedButton(
            onPressed: () => setState(() => isExpanded = !isExpanded),
            child: const Text("Animate"),
          ),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////
// MESSAGES (REAL STAGGERED + EXPLICIT)
//////////////////////////////////////////////////

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final int count = 5;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: count,
      itemBuilder: (context, index) {
        final animation = CurvedAnimation(
          parent: _controller,
          curve: Interval(index / count, 1.0, curve: Curves.easeOut),
        );

        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Opacity(
              opacity: animation.value,
              child: Transform.translate(
                offset: Offset(0, 50 * (1 - animation.value)),
                child: child,
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade200,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text("Message ${index + 1}"),
          ),
        );
      },
    );
  }
}

//////////////////////////////////////////////////
// HERO DESTINATION
//////////////////////////////////////////////////

class ProfileDetailPage extends StatelessWidget {
  const ProfileDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/mabgpinkeu.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: const Color.fromRGBO(0, 0, 0, 0.6),
          child: Center(
            child: Hero(
              tag: "profileHero",
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(Icons.person, size: 90),
              ),
            ),
          ),
        ),
      ),
    );
  }
}