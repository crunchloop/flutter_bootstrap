import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/src/common/app_styles.dart';

import '../../gen/colors.gen.dart';
import '../common/sizes.dart';

class CustomButton extends StatefulWidget {
  final double _height;
  final String _label;
  final VoidCallback? _pressHandler;
  final VoidCallback? _longPressHandler;
  bool get _enabled => _pressHandler != null || _longPressHandler != null;
  const CustomButton(
      {super.key,
      double height = Sizes.buttonSize,
      required String label,
      required VoidCallback? pressHandler,
      VoidCallback? longPressHandler})
      : _height = height,
        _label = label,
        _pressHandler = pressHandler,
        _longPressHandler = longPressHandler;

  @override
  State<CustomButton> createState() => _CustomButton();
}

class _CustomButton extends State<CustomButton> {
  static final BorderRadius borderRadius =
      BorderRadius.circular(Sizes.borderRadius);
  MaterialStatesController buttonStatesController = MaterialStatesController();
  Set<MaterialState> currentStates = {};

  void handleStatesControllerChange() {
    setState(() {});
  }

  void initStatesController() {
    buttonStatesController.update(MaterialState.disabled, !widget._enabled);
    buttonStatesController.addListener(handleStatesControllerChange);
  }

  @override
  void initState() {
    super.initState();
    initStatesController();
  }

  @override
  Widget build(BuildContext context) {
    return WithStyle.build(
        AppStyle.primary(context),
        ((style) => ElevatedButton(
              statesController: buttonStatesController,
              style: style.buttonStyle,
              onPressed: widget._pressHandler,
              child: Text(
                widget._label,
                style: style.textStyle,
              ),
            ).withDecorator(
                decoration: buttonStatesController.value
                        .contains(MaterialState.disabled)
                    ? BoxDecoration(
                        borderRadius: borderRadius,
                        gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              ColorName.primaryGreenBtnBottom.withOpacity(0.6),
                              ColorName.primaryGreenBtnTop.withOpacity(0.6)
                            ]),
                      )
                    : style.decorator,
                someHeight: widget._height)));
  }
}
