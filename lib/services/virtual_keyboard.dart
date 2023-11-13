import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xterm/xterm.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VirtualKeyboardView extends StatelessWidget {
  const VirtualKeyboardView(this.keyboard, {Key? key}) : super(key: key);

  final VirtualKeyboard keyboard;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: keyboard,
      builder: (context, child) => Container(
        padding: const EdgeInsets.all(8.0),
        child: ToggleButtons(
          borderColor: Colors.grey,
          selectedBorderColor: Colors.blue,
          selectedColor: Colors.white,
          fillColor: const Color.fromARGB(255, 10, 125, 243),
          borderWidth: 2,
          borderRadius:
              BorderRadius.circular(8),
          children: <Widget>[
            Text('Ctrl',), 
            Text('Alt'), 
            Text('Shift')],
          isSelected: [keyboard.ctrl, keyboard.alt, keyboard.shift],
          onPressed: (index) {
            HapticFeedback
                .lightImpact(); // Retroalimentación táctil al presionar
            switch (index) {
              case 0:
                keyboard.ctrl = !keyboard.ctrl;
                break;
              case 1:
                keyboard.alt = !keyboard.alt;
                break;
              case 2:
                keyboard.shift = !keyboard.shift;
                break;
            }
          },
        ),
      ),
    );
  }
}

class VirtualKeyboard extends TerminalInputHandler with ChangeNotifier {
  final TerminalInputHandler _inputHandler;

  VirtualKeyboard(this._inputHandler);

  bool _ctrl = false;

  bool get ctrl => _ctrl;

  set ctrl(bool value) {
    if (_ctrl != value) {
      _ctrl = value;
      notifyListeners();
    }
  }

  bool _shift = false;

  bool get shift => _shift;

  set shift(bool value) {
    if (_shift != value) {
      _shift = value;
      notifyListeners();
    }
  }

  bool _alt = false;

  bool get alt => _alt;

  set alt(bool value) {
    if (_alt != value) {
      _alt = value;
      notifyListeners();
    }
  }

  @override
  String? call(TerminalKeyboardEvent event) {
    return _inputHandler.call(event.copyWith(
      ctrl: event.ctrl || _ctrl,
      shift: event.shift || _shift,
      alt: event.alt || _alt,
    ));
  }
}
