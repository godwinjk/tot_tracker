import 'package:flutter/material.dart';

class BabyStatCard extends StatelessWidget {
  final String title;
  final dynamic value;
  final dynamic subValue;
  final IconData icon;
  final Color color;

  const BabyStatCard(
      {required this.title,
      required this.value,
      required this.icon,
      required this.color,
      this.subValue});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
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
                      color: Colors.black),
                ),
                TextSpan(
                  text: (title == "Weight" ? " kg" : " times"),
                  style: DefaultTextStyle.of(context)
                      .style
                      .copyWith(color: Colors.black),
                ),
              ],
            ),
          ),
          if (subValue != null)
            RichText(
              maxLines: 3,
              text: TextSpan(
                style: DefaultTextStyle.of(context)
                    .style
                    .copyWith(color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Consumed ',
                  ),
                  TextSpan(
                    text: '${value.toString()} mls',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
