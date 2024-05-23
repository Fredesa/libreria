import 'package:flutter/widgets.dart';

class DetailLabel extends StatelessWidget {
  const DetailLabel({super.key, required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return value != ''
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              Expanded(
                child: 
                Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                  maxLines: 30,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
