import 'package:fluent_ui/fluent_ui.dart';

class ErrorScreen extends StatelessWidget {
  final String message;
  final String? description;
  
  const ErrorScreen({
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
            FluentIcons.status_error_full, 
            color: Colors.red, 
            size: 90,
          ),
          const SizedBox(height: 30,),
          Text(
            message,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.grey[130],
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