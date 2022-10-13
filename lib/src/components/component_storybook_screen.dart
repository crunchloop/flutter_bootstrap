import 'package:flutter/material.dart';

import '../common/sizes.dart';
import 'custom_button.dart';

class ComponentStorybookScreen extends StatefulWidget {
  const ComponentStorybookScreen({super.key});

  @override
  State<ComponentStorybookScreen> createState() =>
      _ComponentStorybookScreenState();
}

class _ComponentStorybookScreenState extends State<ComponentStorybookScreen> {
  final String buttonText = 'BUTTON';
  late VoidCallback? pressAction1 = () => setState(() {
        pressAction1 = null;
      });
  late VoidCallback? pressAction2 = () => setState(() {
        pressAction2 = null;
      });
  late VoidCallback? pressAction3 = () => setState(() {
        pressAction3 = null;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Component storybook for testing'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              children: [
                const Text('Buttons'),
                Padding(
                    padding: const EdgeInsets.all(Sizes.small),
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      runSpacing: Sizes.small,
                      spacing: Sizes.small,
                      children: [
                        const CustomButton(
                          label: 'CUSTOM BUTTON DISABLED',
                          pressHandler: null,
                        ),
                        CustomButton(
                          label: 'CUSTOM BUTTON ENABLED',
                          pressHandler: () {},
                        ),
                      ],
                    )),
                const Text('Text fields'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
