import 'package:flutter/material.dart';
import 'package:ynotes/core/utils/themeUtils.dart';

class CustomButtons {
  static Widget materialButton(BuildContext context, double? width, double? height, Function? onTap,
      {IconData? icon,
      String? label,
      Color? backgroundColor,
      Color? textColor,
      Color? iconColor,
      Function? onLongPress,
      BorderRadius? borderRadius,
      EdgeInsets? margin,
      EdgeInsets? padding,
      TextStyle? textStyle}) {
    var screenSize = MediaQuery.of(context);
    return Container(
      width: width,
      margin: margin ?? EdgeInsets.only(left: (screenSize.size.height / 10 * 8.8) / 10 * 0.1),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(screenSize.size.width / 5 * 0.11),
        ),
        color: backgroundColor ?? Theme.of(context).primaryColorDark,
        child: InkWell(
          borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
          onTap: onTap as void Function()?,
          onLongPress: onLongPress as void Function()? ?? null,
          child: Container(
              height: height,
              padding: padding ?? EdgeInsets.all(screenSize.size.width / 5 * 0.1),
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (icon != null)
                      Icon(
                        icon,
                        color: textColor ?? ThemeUtils.textColor(),
                      ),
                    if (label != null)
                      FittedBox(
                        child: Text(
                          label,
                          style: textStyle ??
                              TextStyle(
                                fontFamily: "Asap",
                                color: textColor ?? ThemeUtils.textColor(),
                              ),
                        ),
                      ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
