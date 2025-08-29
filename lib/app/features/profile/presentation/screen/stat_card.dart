import 'package:feed_app/app/export.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;

  const StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(
          value,
          style: const TextStyle(fontSize: AppSizes.s24, fontWeight: FontWeight.bold),
        ),
        CustomText(title, style: TextStyle(fontSize: AppSizes.s14, color: Colors.grey[600])),
      ],
    );
  }
}
