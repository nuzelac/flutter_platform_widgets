/*
 * flutter_platform_widgets
 * Copyright (c) 2018 Lance Johnstone. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:flutter/cupertino.dart'
    show CupertinoButton, CupertinoColors, CupertinoNavigationBar;
import 'package:flutter/material.dart'
    show IconButton, VisualDensity, ButtonStyle;
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/src/parent_widget_finder.dart';

import 'platform.dart';
import 'widget_base.dart';
import 'platform_provider.dart';

const double _kMinInteractiveDimensionCupertino = 44.0;

abstract class _BaseData {
  _BaseData({
    this.widgetKey,
    this.icon,
    this.onPressed,
    this.padding,
    this.color,
    this.disabledColor,
  });

  final Key? widgetKey;
  final Widget? icon;
  final void Function()? onPressed;
  final EdgeInsets? padding;
  final Color? color;
  final Color? disabledColor;
}

class CupertinoIconButtonData extends _BaseData {
  CupertinoIconButtonData({
    super.widgetKey,
    super.icon,
    super.onPressed,
    super.padding,
    super.color,
    super.disabledColor,
    this.borderRadius,
    this.minSize,
    this.pressedOpacity,
    this.alignment,
  });

  final BorderRadius? borderRadius;
  final double? minSize;
  final double? pressedOpacity;
  final AlignmentGeometry? alignment;
}

class MaterialIconButtonData extends _BaseData {
  MaterialIconButtonData({
    super.widgetKey,
    super.icon,
    super.onPressed,
    super.padding,
    super.color,
    super.disabledColor,
    this.alignment,
    this.highlightColor,
    this.iconSize = 24.0,
    this.splashColor,
    this.tooltip,
    this.focusColor,
    this.hoverColor,
    this.focusNode,
    this.autofocus,
    this.enableFeedback,
    this.visualDensity,
    this.constraints,
    this.splashRadius,
    this.mouseCursor,
    this.isSelected,
    this.selectedIcon,
    this.style,
  });

  final AlignmentGeometry? alignment;
  final Color? highlightColor;
  final double? iconSize;
  final Color? splashColor;
  final String? tooltip;
  final Color? focusColor;
  final Color? hoverColor;
  final FocusNode? focusNode;
  final bool? autofocus;
  final bool? enableFeedback;
  final VisualDensity? visualDensity;
  final BoxConstraints? constraints;
  final double? splashRadius;
  final MouseCursor? mouseCursor;
  final bool? isSelected;
  final Widget? selectedIcon;
  final ButtonStyle? style;
}

class PlatformIconButton extends PlatformWidgetBase<CupertinoButton, Widget> {
  final Key? widgetKey;

  final Widget? icon;
  final Widget? cupertinoIcon;
  final Widget? materialIcon;
  final void Function()? onPressed;
  final Color? color;
  final EdgeInsets? padding;
  final Color? disabledColor;

  final PlatformBuilder<MaterialIconButtonData>? material;
  final PlatformBuilder<CupertinoIconButtonData>? cupertino;

  PlatformIconButton({
    super.key,
    this.widgetKey,
    this.icon,
    this.cupertinoIcon,
    this.materialIcon,
    this.onPressed,
    this.color,
    this.disabledColor,
    this.padding,
    this.material,
    this.cupertino,
  });

  @override
  Widget createMaterialWidget(BuildContext context) {
    final data = material?.call(context, platform(context));

    // icon is required non nullable
    assert(data?.icon != null || materialIcon != null || icon != null);

    return IconButton(
      key: data?.widgetKey ?? widgetKey,
      icon: data?.icon ?? materialIcon ?? icon!,
      onPressed: data?.onPressed ?? onPressed ?? null,
      padding: data?.padding ?? padding ?? const EdgeInsets.all(8.0),
      color: data?.color ?? color,
      alignment: data?.alignment ?? Alignment.center,
      disabledColor: data?.disabledColor ?? disabledColor,
      highlightColor: data?.highlightColor,
      iconSize: data?.iconSize ?? 24.0,
      splashColor: data?.splashColor,
      tooltip: data?.tooltip,
      focusColor: data?.focusColor,
      focusNode: data?.focusNode,
      hoverColor: data?.hoverColor,
      autofocus: data?.autofocus ?? false,
      enableFeedback: data?.enableFeedback ?? true,
      visualDensity: data?.visualDensity,
      constraints: data?.constraints,
      splashRadius: data?.splashRadius,
      mouseCursor: data?.mouseCursor ?? SystemMouseCursors.click,
      isSelected: data?.isSelected,
      selectedIcon: data?.selectedIcon,
      style: data?.style,
    );
  }

  @override
  CupertinoButton createCupertinoWidget(BuildContext context) {
    final data = cupertino?.call(context, platform(context));

    // child is required non nullable
    assert(data?.icon != null || cupertinoIcon != null || icon != null);

    // If the IconButton is placed inside the AppBar, we need to have zero padding.
    final haveZeroPadding = PlatformProvider.of(context)
            ?.settings
            .iosUseZeroPaddingForAppbarPlatformIcon ??
        false;
    final isPlacedOnPlatformAppBar =
        ParentWidgetFinder.of<CupertinoNavigationBar>(context) != null;
    final overriddenPadding =
        haveZeroPadding && isPlacedOnPlatformAppBar ? EdgeInsets.zero : null;

    final givenPadding = data?.padding ?? padding ?? overriddenPadding;

    return CupertinoButton(
      key: data?.widgetKey ?? widgetKey,
      child: data?.icon ?? cupertinoIcon ?? icon!,
      onPressed: data?.onPressed ?? onPressed ?? null,
      padding: givenPadding,
      color: data?.color ?? color,
      borderRadius: data?.borderRadius ??
          const BorderRadius.all(const Radius.circular(8.0)),
      minSize: data?.minSize ?? _kMinInteractiveDimensionCupertino,
      pressedOpacity: data?.pressedOpacity ?? 0.4,
      disabledColor: data?.disabledColor ??
          disabledColor ??
          CupertinoColors.quaternarySystemFill,
      alignment: data?.alignment ?? Alignment.center,
    );
  }
}
