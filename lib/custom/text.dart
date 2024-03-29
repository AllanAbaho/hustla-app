import 'package:hustla/custom/styles.dart';
import 'package:hustla/my_theme.dart';
import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight fontWeight;
  final double size;
  final TextAlign align;

  SmallText(this.text, {this.size, this.color, this.align, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyles.h3.copyWith(
        color: color ?? MyTheme.light_grey,
        fontSize: size ?? 13,
        fontWeight: FontWeight.w300,
      ),
      textAlign: align,
    );
  }
}

class MediumText extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight fontWeight;
  final double size;
  final TextAlign align;

  MediumText(this.text,
      {this.size, this.color, this.align, this.fontWeight, TextStyle style});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyles.h3.copyWith(
        color: color ?? Colors.white,
        fontSize: size ?? 16,
        fontWeight: FontWeight.w400,
      ),
      textAlign: align,
    );
  }
}

class BigText extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight fontWeight;
  final double size;
  final TextAlign align;

  BigText(
    this.text, {
    this.size,
    this.color,
    this.align,
    this.fontWeight,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyles.h2.copyWith(
        color: color ?? Colors.black,
        fontSize: size,
        fontFamily: 'Lato',
        fontWeight: fontWeight,
      ),
      textAlign: align,
    );
  }
}

class LargeText extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight fontWeight;
  final double size;
  final TextAlign align;

  LargeText(this.text, {this.size, this.color, this.align, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyles.h1.copyWith(
        color: color,
        fontSize: size,
        fontFamily: 'Lato',
        fontWeight: fontWeight,
      ),
      textAlign: align,
    );
  }
}

class LabelText extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight fontWeight;
  final double size;
  final TextAlign align;
  final bool isRequired;

  LabelText(
    this.text, {
    this.isRequired = true,
    this.align = TextAlign.left,
    this.size,
    this.color,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: text),
          if (isRequired)
            TextSpan(
              text: " *",
              style: TextStyles.body1.copyWith(
                color: Colors.red,
                fontFamily: 'Lato',
              ),
            ),
        ],
      ),
      style: TextStyles.body1,
    );
  }
}
