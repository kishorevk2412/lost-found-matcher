import 'package:flutter/material.dart';

void main() => runApp(const HospitalApp());

class HospitalApp extends StatelessWidget {
const HospitalApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
home: const HospitalScreen(),
);
}
}

class HospitalScreen extends StatefulWidget {
const HospitalScreen({super.key});

@override
State<HospitalScreen> createState() => _HospitalScreenState();
}

class _HospitalScreenState extends State<HospitalScreen> {
bool expanded = false;

String doctor = "Dr. Anita Rao";
String slot = "9:00 AM";

final doctors = {
"Dr. Anita Rao": [
"9:00 AM",
"10:30 AM",
"4:00 PM",
],
"Dr. Kiran Mehta": [
"9:00 AM",
"1:00 PM",
"3:30 PM",
],
"Dr. Sameer Iyer": [
"11:00 AM",
"2:00 PM",
"5:30 PM",
],
};

void bookDoctor(String name) {
showModalBottomSheet(
context: context,
builder: (ctx) => Padding(
padding: const EdgeInsets.all(20),
child: Column(
mainAxisSize: MainAxisSize.min,
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
name,
style: const TextStyle(
fontSize: 22,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 15),

const Text(
"Available Slots",
style: TextStyle(
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 10),

Wrap(
spacing: 10,
children: doctors[name]!
    .map(
(s) => ActionChip(
label: Text(s),
onPressed: () {
setState(() {
doctor = name;
slot = s;
});

Navigator.pop(ctx);
},
),
)
    .toList(),
),
],
),
),
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("Hospital Appointment"),
backgroundColor: Colors.blue,
foregroundColor: Colors.white,
),

body: ListView(
padding: const EdgeInsets.all(16),
children: doctors.keys
    .map(
(name) => Card(
child: ListTile(
leading: const CircleAvatar(
child: Icon(Icons.person),
),
title: Text(name),
subtitle: const Text("Specialist Doctor"),
trailing: const Icon(
Icons.arrow_forward_ios,
),
onTap: () => bookDoctor(name),
),
),
)
    .toList(),
),

bottomSheet: GestureDetector(
onTap: () {
setState(() {
expanded = !expanded;
});
},

child: AnimatedContainer(
duration: const Duration(milliseconds: 250),
height: expanded ? 190 : 100,
padding: const EdgeInsets.all(18),

decoration: const BoxDecoration(
color: Colors.blue,
borderRadius: BorderRadius.vertical(
top: Radius.circular(20),
),
),

child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
"UPCOMING APPOINTMENT",
style: TextStyle(
color: Colors.white70,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 8),

Text(
doctor,
style: const TextStyle(
color: Colors.white,
fontWeight: FontWeight.bold,
fontSize: 17,
),
),

Text(
slot.isEmpty ? "No Appointment" : "Today, $slot",
style: const TextStyle(
color: Colors.white70,
),
),

if (expanded) ...[
const SizedBox(height: 15),

Row(
children: [
Expanded(
child: ElevatedButton(
onPressed: () => bookDoctor(doctor),
child: const Text("Reschedule"),
),
),

const SizedBox(width: 10),

Expanded(
child: OutlinedButton(
onPressed: () {
setState(() {
doctor = "No Appointment";
slot = "";
});
},

style: OutlinedButton.styleFrom(
foregroundColor: Colors.white,
side: const BorderSide(
color: Colors.white,
),
),

child: const Text("Cancel"),
),
),
],
),
],
],
),
),
),
);
}
}

