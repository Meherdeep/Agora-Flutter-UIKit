import 'package:flutter/material.dart';

class DisabledVideoWidget extends StatelessWidget {
  const DisabledVideoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(8.0),
      child: Image.network(
        'https://i.ibb.co/q5RysSV/image.png',
      ),
    );
  }
}
