import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:math' as math;
import '../../res/asset_const.dart';

class EmptyPlaceholderWidget extends StatelessWidget {
  const EmptyPlaceholderWidget({super.key, this.subText = 'No result found'});

  final String subText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(AssetConstant.lBabyHeadDown,
              width: math.min(MediaQuery.sizeOf(context).height * 0.5,
                  MediaQuery.sizeOf(context).width * 0.5)),
          Text(subText)
        ],
      ),
    );
  }
}
