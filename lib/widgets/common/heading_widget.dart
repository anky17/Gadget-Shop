import 'package:flutter/material.dart';
import 'package:gadgetshop/core/utils/app_constant.dart';

class HeadingWidget extends StatelessWidget {
  final String headingTitle;
  final String headingSubtitle;
  final VoidCallback onTap;
  final String buttonText;

  const HeadingWidget(
      {super.key,
      required this.headingTitle,
      required this.headingSubtitle,
      required this.onTap,
      required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                headingTitle,
                style: TextStyle(
                    color: Colors.grey.shade800, fontWeight: FontWeight.bold),
              ),
              Text(
                headingSubtitle,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppConstant.appSecondaryColor, width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  buttonText,
                  style: TextStyle(
                      color: AppConstant.appSecondaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
