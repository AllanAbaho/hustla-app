import 'dart:io';

import 'package:hustla/custom/resources.dart';
import 'package:hustla/my_theme.dart';
import 'package:flutter/material.dart';

class ImageBox extends StatelessWidget {
  final File img;
  ImageBox({this.img});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.appBarColor,
          width: 1.8,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        // borderRadius: Corners.lgBorder,
        image: img == null
            ? null
            : DecorationImage(
                image: FileImage(img),
                fit: BoxFit.cover,
              ),
      ),
      padding: EdgeInsets.all(10),
      child: img == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 12,
                      width: 12,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: AppColors.appBarColor,
                            ),
                            left: BorderSide(
                              color: AppColors.appBarColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                      width: 12,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: AppColors.appBarColor,
                            ),
                            right: BorderSide(
                              color: AppColors.appBarColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 12,
                      width: 12,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.appBarColor,
                            ),
                            left: BorderSide(
                              color: AppColors.appBarColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                      width: 12,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.appBarColor,
                            ),
                            right: BorderSide(
                              color: AppColors.appBarColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
          : SizedBox(),
    );
  }

  Widget onTap(void Function() action, {bool opaque = true}) {
    return GestureDetector(
      behavior: opaque ? HitTestBehavior.opaque : HitTestBehavior.deferToChild,
      onTap: action,
      child: this,
    );
  }
}
