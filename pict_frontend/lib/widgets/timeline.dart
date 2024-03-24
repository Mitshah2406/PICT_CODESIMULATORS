import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pict_frontend/utils/constants/app_colors.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MyTimeLineTile extends StatelessWidget {
  const MyTimeLineTile(
      {super.key,
      required this.isFirst,
      required this.isLast,
      required this.isPast,
      required this.status});
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final String status;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        axis: TimelineAxis.horizontal,
        beforeLineStyle: LineStyle(
            color: isPast ? TColors.black : TColors.darkGrey, thickness: 2),
        indicatorStyle: IndicatorStyle(
          width: 40,
          color: isPast ? TColors.primaryGreen : TColors.darkGrey,
          iconStyle: IconStyle(
            iconData: Icons.done,
            color: TColors.white,
          ),
        ),
        endChild: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            status,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: isPast ? TColors.primaryGreen : TColors.black,
                ),
          ),
        ),
      ),
    );
  }
}
