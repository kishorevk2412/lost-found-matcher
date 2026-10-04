import 'package:flutter/material.dart';

void main() {
runApp(const AnimatedAquariumApp());
}

// ROLL NO: 2403717624321025

class AnimatedAquariumApp extends StatelessWidget {
const AnimatedAquariumApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
title: 'Animated Aquarium',
theme: ThemeData(
useMaterial3: true,
colorSchemeSeed: Colors.blue,
),
home: const AnimatedFishPage(),
);
}
}

class AnimatedFishPage extends StatefulWidget {
const AnimatedFishPage({super.key});

@override
State<AnimatedFishPage> createState() => _AnimatedFishPageState();
}

class _AnimatedFishPageState extends State<AnimatedFishPage> {
bool showFeedingSchedule = false;

@override
void initState() {
super.initState();

// Show feeding schedule after a short delay
Future.delayed(const Duration(milliseconds: 500), () {
if (mounted) {
setState(() {
showFeedingSchedule = true;
});
}
});
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Animated Aquarium'),
backgroundColor: Colors.blue,
foregroundColor: Colors.white,
),
body: SingleChildScrollView(
padding: const EdgeInsets.all(16),
child: Column(
children: [
// Aquarium
Container(
height: 300,
width: double.infinity,
decoration: BoxDecoration(
color: Colors.lightBlue.shade300,
borderRadius: BorderRadius.circular(20),
border: Border.all(
color: Colors.blue,
width: 4,
),
),
child: Stack(
children: [
// Fish
const Positioned(
left: 80,
top: 110,
child: Icon(
Icons.set_meal,
size: 80,
color: Colors.orange,
),
),

// Bubbles
const Bubble(
left: 40,
top: 80,
size: 20,
),

const Bubble(
left: 150,
top: 40,
size: 15,
),

const Bubble(
left: 250,
top: 90,
size: 25,
),

const Bubble(
left: 300,
top: 30,
size: 18,
),

// Plants
Positioned(
bottom: 0,
left: 30,
child: Icon(
Icons.grass,
size: 80,
color: Colors.green.shade700,
),
),

Positioned(
bottom: 0,
right: 40,
child: Icon(
Icons.grass,
size: 90,
color: Colors.green.shade800,
),
),
],
),
),

const SizedBox(height: 20),

// Tank Temperature
const Card(
child: ListTile(
leading: Icon(
Icons.thermostat,
color: Colors.red,
size: 35,
),
title: Text(
'Tank Temperature',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
subtitle: Text(
'24°C - 27°C',
),
),
),

const SizedBox(height: 20),

// Feeding Schedule Animation
AnimatedOpacity(
opacity: showFeedingSchedule ? 1.0 : 0.0,
duration: const Duration(milliseconds: 1000),
curve: Curves.easeIn,
child: const Card(
child: ListTile(
leading: Icon(
Icons.restaurant,
color: Colors.orange,
size: 35,
),
title: Text(
'Feeding Schedule',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
subtitle: Text(
'Feed small portions two times a day',
),
),
),
),
],
),
),
);
}
}

// Bubble Widget
class Bubble extends StatefulWidget {
final double left;
final double top;
final double size;

const Bubble({
super.key,
required this.left,
required this.top,
required this.size,
});

@override
State<Bubble> createState() => _BubbleState();
}

class _BubbleState extends State<Bubble> {
bool enlarged = false;

@override
void initState() {
super.initState();

Future.delayed(const Duration(milliseconds: 500), () {
if (mounted) {
setState(() {
enlarged = true;
});
}
});
}

@override
Widget build(BuildContext context) {
return Positioned(
left: widget.left,
top: widget.top,
child: AnimatedContainer(
duration: const Duration(milliseconds: 1400),
curve: Curves.easeInOut,
width: enlarged ? widget.size + 8 : widget.size,
height: enlarged ? widget.size + 8 : widget.size,
decoration: BoxDecoration(
shape: BoxShape.circle,
border: Border.all(
color: Colors.white70,
width: 2,
),
),
),
);
}
}