import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../features/auth/controllers/auth_controller.dart';
import '../../main.dart';
import 'circle_model.dart';

class MobileRechargeScreen extends StatefulWidget {
  const MobileRechargeScreen({super.key});

  @override
  State<MobileRechargeScreen> createState() => _MobileRechargeScreenState();
}

class _MobileRechargeScreenState extends State<MobileRechargeScreen> {
  CircleModel? orderInfoList;
  final List<String> dropdownItems = [];
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Heelo${dropdownItems.length}");
    getOperators();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Recharge'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mobile Number Input
            TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Enter Mobile Number',
                prefixIcon: const Icon(Icons.phone_android),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Operator and Circle Selection
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Operator',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'AT', child: Text('Airtel Prepaid')),
                      DropdownMenuItem(value: 'JIO', child: Text('Jio Prepaid')),
                      DropdownMenuItem(value: 'VF', child: Text('Vi Prepaid')),
                      DropdownMenuItem(value: 'BSNL', child: Text('BSNL Prepaid')),
                    ],
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Circle',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),

            // Fetch Plans Button
            ElevatedButton(
              onPressed: () {
                // Simulate fetching plans
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                  ),
                  builder: (context) => _buildPlansSheet(),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Fetch Plans'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlansSheet() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Plans',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView.separated(
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Plan ₹${index * 100 + 199}'),
                  subtitle: const Text('28 Days | 1.5GB/Day | Unlimited Calls'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Simulate recharge
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Recharge of ₹${index * 100 + 199} successful!'),
                        ),
                      );
                    },
                    child: const Text('Recharge'),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
          ),
        ],
      ),
    );
  }

  getOperators() async {
    try {
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Provider.of<AuthController>(Get.context!, listen: false).getUserToken()}',
      };

      Uri uri = Uri.parse("https://mewarpe.com/ecommerce/api/v1/customer/recharge/getcircle");
      var response = await http.post(
        uri,
        headers: headers,
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        orderInfoList = CircleModel.fromJson(result);
        for (int i = 0; i < orderInfoList!.data!.length; i++) {
          dropdownItems.add(orderInfoList!.data![i].circlename.toString());
        }
        print("Heelo${dropdownItems.length}");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
