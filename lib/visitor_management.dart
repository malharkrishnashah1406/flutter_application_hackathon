import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VisitorManagementPage extends StatefulWidget {
  const VisitorManagementPage({Key? key}) : super(key: key);

  @override
  _VisitorManagementPageState createState() => _VisitorManagementPageState();
}

class _VisitorManagementPageState extends State<VisitorManagementPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _visitorNameController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _personToVisitController =
      TextEditingController();
  final TextEditingController _flatNumberController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _visitorCategory = "Frequent";

  void _submitVisitorDetails() async {
    try {
      await _firestore.collection('visitors').add({
        'visitorName': _visitorNameController.text,
        'contactNumber': _contactNumberController.text,
        'visitorCategory': _visitorCategory,
        'personToVisit': _personToVisitController.text,
        'flatNumber': _flatNumberController.text,
        'date': _selectedDate.toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Visitor details submitted successfully!")),
      );

      // Clear the form after submission
      _visitorNameController.clear();
      _contactNumberController.clear();
      _personToVisitController.clear();
      _flatNumberController.clear();
      setState(() {
        _visitorCategory = "Frequent";
        _selectedDate = DateTime.now();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error submitting details: $e")),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Visitor Management"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _visitorNameController,
              decoration: const InputDecoration(
                labelText: "Visitor's Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contactNumberController,
              decoration: const InputDecoration(
                labelText: "Contact Number",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _visitorCategory,
              onChanged: (String? newValue) {
                setState(() {
                  _visitorCategory = newValue!;
                });
              },
              items: const [
                DropdownMenuItem(value: "Frequent", child: Text("Frequent")),
                DropdownMenuItem(value: "One Time", child: Text("One Time")),
                DropdownMenuItem(value: "Relative", child: Text("Relative")),
                DropdownMenuItem(value: "Unknown", child: Text("Unknown")),
              ],
              decoration: const InputDecoration(
                labelText: "Visitor Category",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _personToVisitController,
              decoration: const InputDecoration(
                labelText: "Name of the Person to Visit",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _flatNumberController,
              decoration: const InputDecoration(
                labelText: "Flat Number",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Date: ${_selectedDate.toLocal().toString().split(' ')[0]}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text("Select Date"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitVisitorDetails,
                child: const Text("Submit Details"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
