import 'package:bada/screens/my_family/fam_member.dart';
import 'package:bada/widgets/buttons.dart';
import 'package:flutter/material.dart';

class MyFamily extends StatelessWidget {
  const MyFamily({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('우리 가족'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Row(
                children: [
                  Button281_77(
                    label: const Text('아이들'),
                    onPressed: () {},
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const Button281_77(
                    label: Text('부모'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const FamilyMember(name: '김나희')
            ],
          ),
        ),
      ),
      // appBar: commonAppbar(title: '우리 가족',),
    );
  }
}
