import 'package:flutter/material.dart';

class BabyStatCard extends StatelessWidget {
  final String title;
  final dynamic value;
  final dynamic subValue;
  final IconData icon;
  final Color color;
  final VoidCallback callback;

  const BabyStatCard(
      {required this.title,
      required this.value,
      required this.icon,
      required this.color,
      this.subValue,
      required this.callback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              blurRadius: 6,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            RichText(
              maxLines: 3,
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                    text: value.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  TextSpan(
                    text: (title == "Weight" ? " kg" : " times"),
                    style: DefaultTextStyle.of(context).style,
                  ),
                ],
              ),
            ),
            if (subValue != null)
              RichText(
                maxLines: 3,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text: 'Consumed ',
                    ),
                    TextSpan(
                      text: '${subValue.toString()} mls',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
