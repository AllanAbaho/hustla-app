import 'dart:io';

import 'package:active_ecommerce_flutter/my_theme.dart';
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
          color: MyTheme.accent_color,
          width: 1.8,
        ),
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
                              color: MyTheme.accent_color,
                            ),
                            left: BorderSide(
                              color: MyTheme.accent_color,
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
                              color: MyTheme.accent_color,
                            ),
                            right: BorderSide(
                              color: MyTheme.accent_color,
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
                              color: MyTheme.accent_color,
                            ),
                            left: BorderSide(
                              color: MyTheme.accent_color,
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
                              color: MyTheme.accent_color,
                            ),
                            right: BorderSide(
                              color: MyTheme.accent_color,
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
