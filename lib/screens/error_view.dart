import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final String? description;

  const ErrorView({
    super.key, 
    required this.message, 
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            MdiIcons.closeCircle, 
            color: Colors.red, 
            size: 90,
          ),
          const SizedBox(height: 30,),
          Text(
            message,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 30,),
          if (description != null) 
            Text(
              description!,
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[130]
              ),
            ),
        ],
      ),
    );
  }
}