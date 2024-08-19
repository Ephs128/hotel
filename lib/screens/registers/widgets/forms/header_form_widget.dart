import 'package:fluent_ui/fluent_ui.dart';

class HeaderFormWidget extends StatelessWidget {
  final Function() back;
  final String title;
  const HeaderFormWidget({
    super.key, 
    required this.back, 
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FluentTheme.of(context).activeColor,
      padding: const EdgeInsets.all(10),
      child: Row(
        children:[
          IconButton(
            icon: const Row(
              children: [
                Icon(FluentIcons.chrome_back),
                SizedBox(width: 5,),
                Text("Atrás"),
              ],
            ), 
            onPressed: back,
          ),
          const Spacer(),
          Text(title),
          const Spacer(),
        ],
      ),
    );
  }
}