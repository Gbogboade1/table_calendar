// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../customization/header_style.dart';
import '../shared/utils.dart' show CalendarFormat, DayBuilder;
import 'custom_icon_button.dart';
import 'format_button.dart';

const blue = Color(0xFF455AFE);

Widget assetsImage({
  required String imgUrl,
  BoxFit? fit,
  BoxShape shape = BoxShape.rectangle,
  double? height: 24,
  double? width: 24,
}) =>
    Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        shape: shape,
        image: DecorationImage(
          image: AssetImage(imgUrl),
          fit: fit,
        ),
      ),
    );

Widget asssetButton(
  String assetPath, {
  double? iconHeight,
  double? iconWidth,
  Function()? onPressed,
  EdgeInsetsGeometry? padding,
  Color? bgColor,
}) {
  return InkWell(
    onTap: onPressed,
    child: Container(
      padding: padding ?? EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: bgColor,
      ),
      child: assetsImage(
        imgUrl: assetPath,
        height: iconHeight ?? 24,
        width: iconWidth ?? 24,
      ),
    ),
  );
}

class CalendarCustomFooter extends StatelessWidget {
  final dynamic locale;
  final DateTime focusedMonth;
  final CalendarFormat calendarFormat;
  final HeaderStyle headerStyle;
  final VoidCallback onLeftChevronTap;
  final VoidCallback onRightChevronTap;
  final VoidCallback onHeaderTap;
  final VoidCallback onHeaderLongPress;
  final ValueChanged<CalendarFormat> onFormatButtonTap;
  final Map<CalendarFormat, String> availableCalendarFormats;
  final DayBuilder? headerTitleBuilder;

  const CalendarCustomFooter({
    Key? key,
    this.locale,
    required this.focusedMonth,
    required this.calendarFormat,
    required this.headerStyle,
    required this.onLeftChevronTap,
    required this.onRightChevronTap,
    required this.onHeaderTap,
    required this.onHeaderLongPress,
    required this.onFormatButtonTap,
    required this.availableCalendarFormats,
    this.headerTitleBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = headerStyle.titleTextFormatter?.call(focusedMonth, locale) ??
        DateFormat.yMMMM(locale).format(focusedMonth);
    final monthText = DateFormat.MMMM(locale).format(focusedMonth);
    final yearText = DateFormat.y(locale).format(focusedMonth);
    return Container(
      decoration: headerStyle.decoration,
      margin: headerStyle.headerMargin,
      padding: headerStyle.headerPadding,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: onHeaderTap,
            onLongPress: onHeaderLongPress,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: blue.withOpacity(.1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: blue,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: '$monthText, ',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(text: '$yearText'),
                  ],
                ),
              ),
            ),
          ),
          Spacer(),
          if (headerStyle.leftChevronVisible)
            asssetButton(
              'assets/left.png',
              bgColor: blue,
              onPressed: onLeftChevronTap,
            ),
          SizedBox(
            width: 10,
          ),
          if (headerStyle.rightChevronVisible)
            asssetButton(
              'assets/right.png',
              bgColor: blue,
              onPressed: onRightChevronTap,
            ),
        ],
      ),
    );
  }
}

class CalendarHeader extends StatelessWidget {
  final dynamic locale;
  final DateTime focusedMonth;
  final CalendarFormat calendarFormat;
  final HeaderStyle headerStyle;
  final VoidCallback onLeftChevronTap;
  final VoidCallback onRightChevronTap;
  final VoidCallback onHeaderTap;
  final VoidCallback onHeaderLongPress;
  final ValueChanged<CalendarFormat> onFormatButtonTap;
  final Map<CalendarFormat, String> availableCalendarFormats;
  final DayBuilder? headerTitleBuilder;

  const CalendarHeader({
    Key? key,
    this.locale,
    required this.focusedMonth,
    required this.calendarFormat,
    required this.headerStyle,
    required this.onLeftChevronTap,
    required this.onRightChevronTap,
    required this.onHeaderTap,
    required this.onHeaderLongPress,
    required this.onFormatButtonTap,
    required this.availableCalendarFormats,
    this.headerTitleBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = headerStyle.titleTextFormatter?.call(focusedMonth, locale) ??
        DateFormat.yMMMM(locale).format(focusedMonth);

    return Container(
      decoration: headerStyle.decoration,
      margin: headerStyle.headerMargin,
      padding: headerStyle.headerPadding,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (headerStyle.leftChevronVisible)
            CustomIconButton(
              icon: headerStyle.leftChevronIcon,
              onTap: onLeftChevronTap,
              margin: headerStyle.leftChevronMargin,
              padding: headerStyle.leftChevronPadding,
            ),
          Expanded(
            child: headerTitleBuilder?.call(context, focusedMonth) ??
                GestureDetector(
                  onTap: onHeaderTap,
                  onLongPress: onHeaderLongPress,
                  child: Text(
                    text,
                    style: headerStyle.titleTextStyle,
                    textAlign: headerStyle.titleCentered
                        ? TextAlign.center
                        : TextAlign.start,
                  ),
                ),
          ),
          if (headerStyle.formatButtonVisible &&
              availableCalendarFormats.length > 1)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: FormatButton(
                onTap: onFormatButtonTap,
                availableCalendarFormats: availableCalendarFormats,
                calendarFormat: calendarFormat,
                decoration: headerStyle.formatButtonDecoration,
                padding: headerStyle.formatButtonPadding,
                textStyle: headerStyle.formatButtonTextStyle,
                showsNextFormat: headerStyle.formatButtonShowsNext,
              ),
            ),
          if (headerStyle.rightChevronVisible)
            CustomIconButton(
              icon: headerStyle.rightChevronIcon,
              onTap: onRightChevronTap,
              margin: headerStyle.rightChevronMargin,
              padding: headerStyle.rightChevronPadding,
            ),
        ],
      ),
    );
  }
}
