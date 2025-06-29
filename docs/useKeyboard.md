# useKeyboard

A hook that tracks the on-screen keyboard state, providing visibility status and height information.

> **Note:** This hook is designed for mobile devices with software keyboards. On desktop browsers with physical keyboards, the keyboard state will always show as hidden (height: 0) since there's no on-screen keyboard to detect.

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://wasabeef.github.io/flutter_use/#/use-keyboard)

```dart
import 'package:flutter_use/flutter_use.dart';

class ChatScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final keyboard = useKeyboard();
    
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: MessageList(),
          ),
          AnimatedContainer(
            duration: keyboard.animationDuration,
            padding: EdgeInsets.only(bottom: keyboard.height),
            child: MessageInput(),
          ),
        ],
      ),
    );
  }
}
```

## Extended Version

For additional utilities:

```dart
class SmartForm extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final keyboard = useKeyboardExtended();
    
    return GestureDetector(
      onTap: keyboard.dismiss, // Dismiss keyboard on tap outside
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: keyboard.viewportHeight, // Height excluding keyboard
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Spacer(),
                Text('Keyboard uses ${(keyboard.heightPercentage * 100).toStringAsFixed(0)}% of screen'),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Tap here to show keyboard',
                  ),
                ),
                if (keyboard.isVisible)
                  ElevatedButton(
                    onPressed: keyboard.dismiss,
                    child: const Text('Dismiss Keyboard'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

## Keyboard-Aware Scrolling

Automatically scroll to keep focused fields visible:

```dart
class FormWithScroll extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final scrollController = useKeyboardAwareScroll(
      config: const KeyboardScrollConfig(
        extraScrollPadding: 20.0,
        animateScroll: true,
        scrollDuration: Duration(milliseconds: 200),
        scrollCurve: Curves.easeOut,
      ),
    );
    
    return Scaffold(
      body: ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        children: [
          for (int i = 0; i < 10; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Field ${i + 1}',
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
```

## API

### useKeyboard

```dart
KeyboardState useKeyboard({
  Duration animationDuration = const Duration(milliseconds: 250),
})
```

**Parameters:**
- `animationDuration`: Duration for keyboard animations

**Returns:** `KeyboardState` with:
- `isVisible`: Whether keyboard is shown
- `isHidden`: Whether keyboard is hidden
- `height`: Keyboard height in logical pixels
- `animationDuration`: Animation duration

### useKeyboardExtended

```dart
KeyboardStateExtended useKeyboardExtended({
  Duration animationDuration = const Duration(milliseconds: 250),
})
```

**Returns:** `KeyboardStateExtended` with:
- All properties from `KeyboardState`
- `dismiss()`: Function to dismiss keyboard
- `bottomInset`: Total bottom inset
- `viewportHeight`: Available height excluding keyboard
- `heightPercentage`: Keyboard height as percentage

### useIsKeyboardVisible

```dart
bool useIsKeyboardVisible()
```

**Returns:** Simple boolean for keyboard visibility

### useKeyboardAwareScroll

```dart
ScrollController useKeyboardAwareScroll({
  KeyboardScrollConfig config = const KeyboardScrollConfig(),
  ScrollController? controller,
})
```

**Parameters:**
- `config`: Scroll behavior configuration
- `controller`: Optional custom controller

**Returns:** ScrollController that auto-scrolls for keyboard

## Features

- Real-time keyboard state tracking
- Keyboard height measurement
- Animation duration support
- Viewport calculations
- Keyboard dismissal utility
- Automatic scroll adjustment
- Cross-platform support

## Common Use Cases

1. **Chat Applications**
   ```dart
   AnimatedPadding(
     duration: keyboard.animationDuration,
     padding: EdgeInsets.only(bottom: keyboard.height),
     child: MessageComposer(),
   )
   ```

2. **Form Layouts**
   ```dart
   if (keyboard.isVisible) {
     // Show compact view
   } else {
     // Show expanded view
   }
   ```

3. **Bottom Sheets**
   ```dart
   showModalBottomSheet(
     isScrollControlled: true,
     builder: (context) => Padding(
       padding: EdgeInsets.only(
         bottom: MediaQuery.of(context).viewInsets.bottom,
       ),
       child: Content(),
     ),
   )
   ```

4. **Floating Action Buttons**
   ```dart
   AnimatedPositioned(
     duration: keyboard.animationDuration,
     bottom: keyboard.height + 16,
     right: 16,
     child: FloatingActionButton(...),
   )
   ```

## Advanced Example

```dart
class AdvancedKeyboardExample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final keyboard = useKeyboardExtended();
    final scrollController = useKeyboardAwareScroll();
    final focusNodes = List.generate(5, (_) => useFocusNode());
    final currentFocus = useState<int?>(null);
    
    // Track which field is focused
    useEffect(() {
      for (int i = 0; i < focusNodes.length; i++) {
        void listener() {
          if (focusNodes[i].hasFocus) {
            currentFocus.value = i;
          }
        }
        focusNodes[i].addListener(listener);
      }
      return () {
        for (final node in focusNodes) {
          node.removeListener(() {});
        }
      };
    }, []);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Form'),
        actions: [
          if (keyboard.isVisible)
            IconButton(
              icon: const Icon(Icons.keyboard_hide),
              onPressed: keyboard.dismiss,
            ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            controller: scrollController,
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: keyboard.height + 100, // Extra space for last field
            ),
            children: [
              for (int i = 0; i < 5; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Field ${i + 1}',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        focusNode: focusNodes[i],
                        decoration: InputDecoration(
                          hintText: 'Enter value for field ${i + 1}',
                          border: const OutlineInputBorder(),
                          filled: currentFocus.value == i,
                          fillColor: currentFocus.value == i
                              ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                              : null,
                        ),
                        textInputAction: i < 4 
                            ? TextInputAction.next 
                            : TextInputAction.done,
                        onSubmitted: (_) {
                          if (i < 4) {
                            focusNodes[i + 1].requestFocus();
                          } else {
                            keyboard.dismiss();
                          }
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
          
          // Keyboard info overlay
          if (keyboard.isVisible)
            Positioned(
              bottom: keyboard.height,
              left: 0,
              right: 0,
              child: Container(
                color: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Text(
                      'Keyboard: ${keyboard.height.toStringAsFixed(0)}px '
                      '(${(keyboard.heightPercentage * 100).toStringAsFixed(0)}%)',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: keyboard.dismiss,
                      child: const Text(
                        'Done',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
```