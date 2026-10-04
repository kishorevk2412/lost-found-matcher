import 'package:flutter/material.dart';

void main() {
runApp(const AquariumApp());
}

class AquariumApp extends StatelessWidget {
const AquariumApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
title: 'Aquarium Viewer',
theme: ThemeData(
useMaterial3: true,
colorSchemeSeed: Colors.blue,
),
home: const AquariumHomePage(),
);
}
}

class AquariumHomePage extends StatelessWidget {
const AquariumHomePage({super.key});

// ROLL NO: 2403717624321025

static const List<Map<String, String>> fish = [
{
'name': 'Clownfish',
'species': 'Amphiprioninae',
'diet': 'Algae, small worms and crustaceans',
'care':
'Keep the saltwater tank clean and maintain stable water conditions.',
'image': 'assets/images/clownfish.png',
},
{
'name': 'Blue Tang',
'species': 'Paracanthurus hepatus',
'diet': 'Mainly algae and plant-based food',
'care':
'Provide a spacious aquarium with clean saltwater.',
'image': 'assets/images/bluetang.png',
},
{
'name': 'Goldfish',
'species': 'Carassius auratus',
'diet': 'Fish flakes, pellets and vegetables',
'care':
'Provide clean freshwater and regular tank maintenance.',
'image': 'assets/images/goldfish.png',
},
];

void openFishDetails(
BuildContext context,
Map<String, String> selectedFish,
) {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => FishDetailsPage(
fish: selectedFish,
),
),
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Aquarium Viewer'),
backgroundColor: Colors.blue,
foregroundColor: Colors.white,
),
body: ListView.builder(
padding: const EdgeInsets.all(16),
itemCount: fish.length,
itemBuilder: (context, index) {
final selectedFish = fish[index];

return Card(
margin: const EdgeInsets.only(bottom: 15),
child: ListTile(
leading: CircleAvatar(
backgroundColor: Colors.blue.shade100,
child: const Icon(
Icons.water,
color: Colors.blue,
),
),
title: Text(
selectedFish['name']!,
style: const TextStyle(
fontWeight: FontWeight.bold,
),
),
subtitle: Text(
selectedFish['species']!,
),
trailing: const Icon(
Icons.arrow_forward_ios,
),
onTap: () {
openFishDetails(
context,
selectedFish,
);
},
),
);
},
),
);
}
}

class FishDetailsPage extends StatelessWidget {
final Map<String, String> fish;

const FishDetailsPage({
super.key,
required this.fish,
});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text(fish['name']!),
backgroundColor: Colors.blue,
foregroundColor: Colors.white,
),
body: SingleChildScrollView(
padding: const EdgeInsets.all(20),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
// Fish Image
Center(
child: Image.asset(
fish['image']!,
height: 200,
width: 300,
fit: BoxFit.contain,
errorBuilder: (context, error, stackTrace) {
return const Icon(
Icons.set_meal,
size: 120,
color: Colors.blue,
);
},
),
),

const SizedBox(height: 25),

// Fish Name
Text(
fish['name']!,
style: const TextStyle(
fontSize: 28,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 20),

// Species
const Text(
'Species',
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
color: Colors.blue,
),
),

const SizedBox(height: 5),

Text(
fish['species']!,
style: const TextStyle(
fontSize: 16,
),
),

const SizedBox(height: 20),

// Diet
const Text(
'Diet',
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
color: Colors.blue,
),
),

const SizedBox(height: 5),

Text(
fish['diet']!,
style: const TextStyle(
fontSize: 16,
),
),

const SizedBox(height: 20),

// Care
const Text(
'Care Instructions',
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
color: Colors.blue,
),
),

const SizedBox(height: 5),

Text(
fish['care']!,
style: const TextStyle(
fontSize: 16,
),
),

const SizedBox(height: 30),

// Back Button
SizedBox(
width: double.infinity,
child: ElevatedButton.icon(
onPressed: () {
Navigator.pop(context);
},
icon: const Icon(Icons.arrow_back),
label: const Text('Back to Aquarium'),
),
),
],
),
),
);
}
}
