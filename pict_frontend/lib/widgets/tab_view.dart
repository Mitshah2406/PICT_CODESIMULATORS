import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pict_frontend/utils/constants/app_colors.dart';

class TabView extends StatefulWidget {
  const TabView({super.key, required this.onTap, required this.selected});
  final void Function(int) onTap;
  final int selected;
  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Theme.of(context).brightness == Brightness.light
              ? TColors.grey
              : TColors.darkerGrey,
        ),
        clipBehavior: Clip.hardEdge,
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    widget.onTap(0);
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: widget.selected == 0
                          ? Theme.of(context).brightness == Brightness.light
                              ? TColors.white
                              : TColors.black
                          : Theme.of(context).brightness == Brightness.light
                              ? TColors.grey
                              : TColors.darkerGrey,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        "Ongoing ",
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: widget.selected == 0
                                  ? TColors.primaryGreen
                                  : Theme.of(context).brightness ==
                                          Brightness.light
                                      ? TColors.black
                                      : TColors.white,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    widget.onTap(1);
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: widget.selected == 1
                          ? Theme.of(context).brightness == Brightness.light
                              ? TColors.white
                              : TColors.black
                          : Theme.of(context).brightness == Brightness.light
                              ? TColors.grey
                              : TColors.darkerGrey,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        "PAST EVENTS",
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: widget.selected == 1
                                  ? TColors.primaryGreen
                                  : Theme.of(context).brightness ==
                                          Brightness.light
                                      ? TColors.black
                                      : TColors.white,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
