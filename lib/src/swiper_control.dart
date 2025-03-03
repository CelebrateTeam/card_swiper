import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class SwiperControl extends SwiperPlugin {
  ///IconData for previous
  final IconData iconPrevious;

  ///iconData fopr next
  final IconData iconNext;

  ///icon size
  final double size;

  ///Icon normal color, The theme's [ThemeData.primaryColor] by default.
  final Color? color;

  ///if set loop=false on Swiper, this color will be used when swiper goto the last slide.
  ///The theme's [ThemeData.disabledColor] by default.
  final Color? disableColor;

  final EdgeInsetsGeometry padding;

  final Key? key;

  final bool disableSwiperControl;

  const SwiperControl({
    this.iconPrevious = Icons.arrow_back_ios,
    this.iconNext = Icons.arrow_forward_ios,
    this.color,
    this.disableColor,
    this.key,
    this.size = 30.0,
    this.padding = const EdgeInsets.all(5.0),

    this.disableSwiperControl = false
  });

  Widget buildButton(SwiperPluginConfig? config, Color color, IconData iconDaga,
      int quarterTurns, bool previous, EdgeInsetsGeometry internalPadding) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (previous) {
          config!.controller.previous(animation: true);
        } else {
          config!.controller.next(animation: true);
        }
      },
      child: Padding(
        padding: padding,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          child: Container(
            color: Colors.black38,
            child: Padding(
              padding: internalPadding,
              child: RotatedBox(
                  quarterTurns: quarterTurns,
                  child: Icon(
                    iconDaga,
                    semanticLabel: previous ? 'Previous' : 'Next',
                    size: size,
                    color: color,
                  )),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, SwiperPluginConfig? config) {
    final themeData = Theme.of(context);

    final color = this.color ?? themeData.primaryColor;
    final disableColor = this.disableColor ?? themeData.disabledColor;
    var prevColor;
    var nextColor;

    if (config!.loop!) {
      prevColor = nextColor = color;
    } else {
      final next = config.activeIndex! < config.itemCount! - 1;
      final prev = config.activeIndex! > 0;
      prevColor = prev ? color : disableColor;
      nextColor = next ? color : disableColor;
    }

    Widget child;
    if (config.scrollDirection == Axis.horizontal) {
      child = Row(
        key: key,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if(!disableSwiperControl)
          buildButton(
            config, prevColor, iconPrevious, 0, true,
            const EdgeInsets.only(top: 10 , bottom: 10, left: 14, right: 6)
          ),
          if(!disableSwiperControl)
          buildButton(
            config, nextColor, iconNext, 0, false,
            const EdgeInsets.all(10)
          )
        ],
      );
    } else {
      child = Column(
        key: key,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if(!disableSwiperControl)
          buildButton(
            config, prevColor, iconPrevious, -3, true,
            const EdgeInsets.only(top: 14 , bottom: 6, left: 10, right: 10),
          ),
          if(!disableSwiperControl)
          Padding(
            padding: padding,
            child: buildButton(
              config, nextColor, iconNext, -3, false,
              const EdgeInsets.all(10)
            ),
          )
        ],
      );
    }

    return Container(
      height: double.infinity,
      width: double.infinity,
      child: child,
    );
  }
}
