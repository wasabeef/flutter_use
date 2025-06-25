import 'package:flutter/material.dart';
import 'hooks/use_throttle_demo.dart';
import 'hooks/use_copy_to_clipboard_demo.dart';
import 'hooks/use_throttle_fn_demo.dart';
import 'hooks/use_scroll_demo.dart';
import 'hooks/use_scrolling_demo.dart';
import 'hooks/use_click_away_demo.dart';
import 'hooks/use_counter_demo.dart';
import 'hooks/use_boolean_demo.dart';
import 'hooks/use_toggle_demo.dart';
import 'hooks/use_default_demo.dart';
import 'hooks/use_mount_demo.dart';
import 'hooks/use_unmount_demo.dart';
import 'hooks/use_effect_once_demo.dart';
import 'hooks/use_interval_demo.dart';
import 'hooks/use_debounce_demo.dart';
import 'hooks/use_list_demo.dart';
import 'hooks/use_map_demo.dart';
import 'hooks/use_update_effect_demo.dart';
import 'hooks/use_lifecycles_demo.dart';
import 'hooks/use_timeout_demo.dart';
import 'hooks/use_timeout_fn_demo.dart';
import 'hooks/use_set_demo.dart';
import 'hooks/use_state_list_demo.dart';
import 'hooks/use_logger_demo.dart';
import 'hooks/use_first_mount_state_demo.dart';
import 'hooks/use_previous_distinct_demo.dart';
import 'hooks/use_update_demo.dart';
import 'hooks/use_latest_demo.dart';
import 'hooks/use_future_retry_demo.dart';
import 'hooks/use_orientation_demo.dart';
import 'hooks/use_text_form_validator_demo.dart';
import 'hooks/use_error_demo.dart';
import 'hooks/use_builds_count_demo.dart';
import 'hooks/use_custom_compare_effect_demo.dart';
import 'hooks/use_orientation_fn_demo.dart';
import 'hooks/use_number_demo.dart';
import 'hooks/use_async_demo.dart';
import 'hooks/use_async_fn_demo.dart';
import 'hooks/use_debounce_fn_demo.dart';
import 'hooks/use_infinite_scroll_demo.dart';
import 'hooks/use_form_demo.dart';
import 'hooks/use_keyboard_demo.dart';

void main() {
  runApp(const FlutterUseDemo());
}

class FlutterUseDemo extends StatelessWidget {
  const FlutterUseDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Use - Interactive Demos',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/use-throttle': (context) => const UseThrottleDemo(),
        '/use-copy-to-clipboard': (context) => const UseCopyToClipboardDemo(),
        '/use-throttle-fn': (context) => const UseThrottleFnDemo(),
        '/use-scroll': (context) => const UseScrollDemo(),
        '/use-scrolling': (context) => const UseScrollingDemo(),
        '/use-click-away': (context) => const UseClickAwayDemo(),
        '/use-counter': (context) => const UseCounterDemo(),
        '/use-boolean': (context) => const UseBooleanDemo(),
        '/use-toggle': (context) => const UseToggleDemo(),
        '/use-default': (context) => const UseDefaultDemo(),
        '/use-mount': (context) => const UseMountDemo(),
        '/use-unmount': (context) => const UseUnmountDemo(),
        '/use-effect-once': (context) => const UseEffectOnceDemo(),
        '/use-update-effect': (context) => const UseUpdateEffectDemo(),
        '/use-lifecycles': (context) => const UseLifecyclesDemo(),
        '/use-interval': (context) => const UseIntervalDemo(),
        '/use-debounce': (context) => const UseDebounceDemo(),
        '/use-list': (context) => const UseListDemo(),
        '/use-map': (context) => const UseMapDemo(),
        '/use-timeout': (context) => const UseTimeoutDemo(),
        '/use-timeout-fn': (context) => const UseTimeoutFnDemo(),
        '/use-set': (context) => const UseSetDemo(),
        '/use-state-list': (context) => const UseStateListDemo(),
        '/use-logger': (context) => const UseLoggerDemo(),
        '/use-first-mount-state': (context) => const UseFirstMountStateDemo(),
        '/use-previous-distinct': (context) => const UsePreviousDistinctDemo(),
        '/use-update': (context) => const UseUpdateDemo(),
        '/use-latest': (context) => const UseLatestDemo(),
        '/use-future-retry': (context) => const UseFutureRetryDemo(),
        '/use-orientation': (context) => const UseOrientationDemo(),
        '/use-text-form-validator': (context) =>
            const UseTextFormValidatorDemo(),
        '/use-error': (context) => const UseErrorDemo(),
        '/use-builds-count': (context) => const UseBuildsCountDemo(),
        '/use-custom-compare-effect': (context) =>
            const UseCustomCompareEffectDemo(),
        '/use-orientation-fn': (context) => const UseOrientationFnDemo(),
        '/use-number': (context) => const UseNumberDemo(),
        '/use-async': (context) => const UseAsyncDemo(),
        '/use-async-fn': (context) => const UseAsyncFnDemo(),
        '/use-debounce-fn': (context) => const UseDebounceFnDemo(),
        '/use-infinite-scroll': (context) => const UseInfiniteScrollDemo(),
        '/use-form': (context) => const UseFormDemo(),
        '/use-keyboard': (context) => const UseKeyboardDemo(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // Sophisticated Hero App Bar
          SliverAppBar.large(
            title: const Text(
              'Flutter Use',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                letterSpacing: -0.5,
              ),
            ),
            expandedHeight: 280,
            pinned: true,
            stretch: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.tertiary,
                        ],
                        stops: const [0.0, 0.7, 1.0],
                      ),
                    ),
                  ),
                  // Floating shapes decoration
                  Positioned(
                    top: 40,
                    right: 30,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 120,
                    left: 20,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  // Main content
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 60),
                        // Icon with glow effect
                        Stack(
                          children: [
                            Text(
                              '⚡',
                              style: TextStyle(
                                fontSize: 64,
                                shadows: [
                                  Shadow(blurRadius: 20, color: Colors.white30),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Interactive Hook Demos',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                            letterSpacing: -0.5,
                            shadows: [
                              Shadow(blurRadius: 10, color: Colors.black26),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Test Flutter hooks live in your browser',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content with refined spacing
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 40.0,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // State Management Section
                _buildRefinedSection(
                  context,
                  '🎯 State Management',
                  'Core hooks for managing component state',
                  [
                    _buildEnhancedDemoCard(
                      context,
                      'useCounter',
                      'Enhanced counter with increment, decrement, set',
                      '',
                      Icons.add_circle,
                      Colors.green,
                      '/use-counter',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useBoolean',
                      'Boolean state with toggle, setTrue, setFalse',
                      '',
                      Icons.toggle_on,
                      Colors.indigo,
                      '/use-boolean',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useToggle',
                      'Simple toggle state management',
                      '',
                      Icons.swap_horiz,
                      Colors.amber,
                      '/use-toggle',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useDefault',
                      'Provide default values for nullable states',
                      '',
                      Icons.settings_backup_restore,
                      Colors.brown,
                      '/use-default',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useList',
                      'List state management with push, pop, insert',
                      '',
                      Icons.list_alt,
                      Colors.deepPurple,
                      '/use-list',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useMap',
                      'Key-value state management with Map utilities',
                      '',
                      Icons.data_object,
                      Colors.cyan,
                      '/use-map',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useSet',
                      'Unique value collection with Set operations',
                      '',
                      Icons.category,
                      Colors.pink,
                      '/use-set',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useStateList',
                      'State history with undo/redo functionality',
                      '',
                      Icons.history,
                      Colors.lime,
                      '/use-state-list',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'usePreviousDistinct',
                      'Track previous distinct values with custom comparison',
                      '',
                      Icons.compare_arrows,
                      Colors.blueGrey,
                      '/use-previous-distinct',
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // Effects & Lifecycle Section
                _buildRefinedSection(
                  context,
                  '🎭 Effects & Lifecycle',
                  'Manage side effects and component lifecycle',
                  [
                    _buildEnhancedDemoCard(
                      context,
                      'useMount',
                      'Run effects only on component mount',
                      '',
                      Icons.play_circle_filled,
                      Colors.green,
                      '/use-mount',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useUnmount',
                      'Cleanup on component unmount',
                      '',
                      Icons.stop_circle,
                      Colors.red,
                      '/use-unmount',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useEffectOnce',
                      'Run effect only once on mount',
                      '',
                      Icons.looks_one,
                      Colors.blue,
                      '/use-effect-once',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useUpdateEffect',
                      'Skip effect on mount, run only on updates',
                      '',
                      Icons.update,
                      Colors.orange,
                      '/use-update-effect',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useLifecycles',
                      'Combined mount and unmount management',
                      '',
                      Icons.sync_alt,
                      Colors.purple,
                      '/use-lifecycles',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useFirstMountState',
                      'Detect if component is in first render',
                      '',
                      Icons.fiber_new,
                      Colors.teal,
                      '/use-first-mount-state',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useLogger',
                      'Debug component lifecycle and state changes',
                      '',
                      Icons.bug_report,
                      Colors.deepOrange,
                      '/use-logger',
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // Enhanced Performance Hooks Section
                _buildRefinedSection(
                  context,
                  '⚡ Performance & Optimization',
                  'Control update frequency and optimize app performance',
                  [
                    _buildEnhancedDemoCard(
                      context,
                      'useThrottle',
                      'Throttle value updates to improve performance',
                      '',
                      Icons.speed,
                      Colors.blue,
                      '/use-throttle',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useThrottleFn',
                      'Throttle function calls to prevent excessive execution',
                      '',
                      Icons.flash_on,
                      Colors.purple,
                      '/use-throttle-fn',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useDebounce',
                      'Delay value updates until user stops changing',
                      '',
                      Icons.timer,
                      Colors.teal,
                      '/use-debounce',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useInterval',
                      'Execute functions at regular intervals',
                      '',
                      Icons.repeat,
                      Colors.indigo,
                      '/use-interval',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useTimeout',
                      'Execute code after a specified delay',
                      '',
                      Icons.timer_outlined,
                      Colors.amber,
                      '/use-timeout',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useTimeoutFn',
                      'Controllable timeout with start/stop/reset',
                      '',
                      Icons.av_timer,
                      Colors.deepOrange,
                      '/use-timeout-fn',
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // Scroll Hooks Section
                _buildRefinedSection(
                  context,
                  '📜 Scroll & Navigation',
                  'Track and respond to scroll events and position',
                  [
                    _buildEnhancedDemoCard(
                      context,
                      'useScroll',
                      'Track scroll position in real-time',
                      '',
                      Icons.height,
                      Colors.teal,
                      '/use-scroll',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useScrolling',
                      'Detect when user is actively scrolling',
                      '',
                      Icons.directions_run,
                      Colors.orange,
                      '/use-scrolling',
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // Enhanced Utility Hooks Section
                _buildRefinedSection(
                  context,
                  '🛠️ Utility & Integration',
                  'Common utility functions for everyday development',
                  [
                    _buildEnhancedDemoCard(
                      context,
                      'useCopyToClipboard',
                      'Copy text to clipboard with status feedback',
                      '',
                      Icons.content_copy,
                      Colors.green,
                      '/use-copy-to-clipboard',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useClickAway',
                      'Detect clicks outside of specific elements',
                      '',
                      Icons.touch_app,
                      Colors.red,
                      '/use-click-away',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useUpdate',
                      'Force component re-render on demand',
                      '',
                      Icons.refresh,
                      Colors.blue,
                      '/use-update',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useLatest',
                      'Access latest value in stale closures',
                      '',
                      Icons.push_pin,
                      Colors.purple,
                      '/use-latest',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useFutureRetry',
                      'Async operations with retry capability',
                      '',
                      Icons.replay,
                      Colors.indigo,
                      '/use-future-retry',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useOrientation',
                      'Track device orientation changes',
                      '',
                      Icons.screen_rotation,
                      Colors.cyan,
                      '/use-orientation',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useTextFormValidator',
                      'Reactive form field validation',
                      '',
                      Icons.check_box,
                      Colors.lime,
                      '/use-text-form-validator',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useError',
                      'Error and exception state management',
                      '',
                      Icons.error_outline,
                      Colors.red,
                      '/use-error',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useBuildsCount',
                      'Track widget rebuild count',
                      '',
                      Icons.numbers,
                      Colors.brown,
                      '/use-builds-count',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useCustomCompareEffect',
                      'Custom dependency comparison for effects',
                      '',
                      Icons.compare,
                      Colors.deepPurple,
                      '/use-custom-compare-effect',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useOrientationFn',
                      'Callback-based orientation change detection',
                      '',
                      Icons.screen_lock_rotation,
                      Colors.teal,
                      '/use-orientation-fn',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useNumber',
                      'Numeric value management (alias for useCounter)',
                      '',
                      Icons.calculate,
                      Colors.green,
                      '/use-number',
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // Mobile-first Hooks Section
                _buildRefinedSection(
                  context,
                  '📱 Mobile-first Hooks',
                  'Essential hooks for modern mobile app development',
                  [
                    _buildEnhancedDemoCard(
                      context,
                      'useAsync',
                      'Manage async operations with loading and error states',
                      '',
                      Icons.sync,
                      Colors.blue,
                      '/use-async',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useAsyncFn',
                      'Manual async operations for forms and user actions',
                      '',
                      Icons.touch_app,
                      Colors.blueAccent,
                      '/use-async-fn',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useDebounceFn',
                      'Debounce function calls for better performance',
                      '',
                      Icons.timer_off,
                      Colors.orange,
                      '/use-debounce-fn',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useInfiniteScroll',
                      'Implement infinite scrolling with automatic loading',
                      '',
                      Icons.all_inclusive,
                      Colors.purple,
                      '/use-infinite-scroll',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useForm',
                      'Comprehensive form state management with validation',
                      '',
                      Icons.assignment,
                      Colors.green,
                      '/use-form',
                    ),
                    _buildEnhancedDemoCard(
                      context,
                      'useKeyboard',
                      'Track keyboard visibility and manage layouts',
                      '',
                      Icons.keyboard,
                      Colors.teal,
                      '/use-keyboard',
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // Elegant divider
                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Theme.of(
                          context,
                        ).colorScheme.outline.withValues(alpha: 0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Enhanced Footer
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.outline.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.rocket_launch_outlined,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Powered by Flutter Web',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.menu_book_outlined,
                                  size: 16,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'github.com/wasabeef/flutter_use',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefinedSection(
    BuildContext context,
    String title,
    String subtitle,
    List<Widget> cards,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 24),
        Wrap(spacing: 20, runSpacing: 20, children: cards),
      ],
    );
  }

  Widget _buildEnhancedDemoCard(
    BuildContext context,
    String title,
    String description,
    String subDescription,
    IconData icon,
    Color accentColor,
    String route,
  ) {
    return SizedBox(
      width: 320,
      child: Card(
        elevation: 4,
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, route),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      size: 24,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
                const SizedBox(height: 12),
                Text(description, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
