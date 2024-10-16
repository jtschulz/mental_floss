import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ListWheelScrollViewApp(),
    );
  }
}

class ListWheelScrollViewApp extends StatefulWidget {
  const ListWheelScrollViewApp({super.key});

  @override
  State<ListWheelScrollViewApp> createState() {
    return _ListWheelScrollViewAppState();
  }
}

class EmotionCategory {
  EmotionCategory({
    required this.name,
    required this.color,
    required this.emoji,
    required this.emotions,
  });

  final String name;
  final Color color;
  final String emoji;
  final List<String> emotions;
}

class _ListWheelScrollViewAppState extends State<ListWheelScrollViewApp> {
  var _focusedIndex = 0;
  Set<String> selectedEmotions = {};

  @override
  Widget build(BuildContext context) {
    final List<EmotionCategory> emotionCategories = [
      EmotionCategory(
        name: 'bad',
        color: const Color.fromRGBO(39, 186, 158, 1),
        emoji: '(◕︵◕)',
        emotions: [
          'tired',
          'stressed',
          'busy',
          'bored',
        ],
      ),
      EmotionCategory(
          name: 'fearful',
          color: const Color.fromRGBO(22, 163, 186, 1),
          emoji: '(●﹏●)',
          emotions: [
            'scared',
            'anxious',
            'insecure',
            'weak',
            'rejected',
            'threatened',
          ]),
      EmotionCategory(
          name: 'angry',
          color: const Color.fromRGBO(117, 117, 180, 1),
          emoji: '(ಠ益ಠ)',
          emotions: [
            'let down',
            'humiliated',
            'insecure',
            'weak',
            'rejected',
            'threatened',
          ]),
      EmotionCategory(
          name: 'disgusted',
          color: const Color.fromRGBO(172, 124, 181, 1),
          emoji: '(๑-﹏-๑)',
          emotions: [
            'disapproving',
            'disappointed',
            'awful',
            'repelled',
          ]),
      EmotionCategory(
          name: 'sad',
          color: const Color.fromRGBO(207, 125, 137, 1),
          emoji: '(ಥ_ಥ)',
          emotions: [
            'hurt',
            'depressed',
            'guilty',
            'despair',
            'vulnerable',
            'lonely',
          ]),
      EmotionCategory(
          name: 'happy',
          color: const Color.fromRGBO(226, 135, 109, 1),
          emoji: '(◕‿◕✿)',
          emotions: [
            'optimistic',
            'trusting',
            'peaceful',
            'powerful',
            'accepted',
            'proud',
            'interested',
            'content',
            'playful',
          ]),
      EmotionCategory(
        name: 'surprised',
        color: const Color.fromRGBO(231, 165, 77, 1),
        emoji: '( ◐ o ◑ )',
        emotions: [
          'excited',
          'amazed',
          'confused',
          'startled',
        ],
      ),
    ];

    final items = Iterable<int>.generate(emotionCategories.length).map((idx) {
      final dataKey = GlobalKey();

      return ListTile(
        key: dataKey,
        titleAlignment: ListTileTitleAlignment.center,
        leading: Text(
          emotionCategories[idx].emoji,
          style: const TextStyle(fontSize: 24),
        ),
        title: Center(
          child: Text(
            emotionCategories[idx].name,
            style: const TextStyle(
              fontSize: 36.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        selected: _focusedIndex == idx,
        selectedColor: emotionCategories[idx].color,
        tileColor: emotionCategories[idx].color,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        onTap: () {
          Scrollable.ensureVisible(dataKey.currentContext!,
              curve: Curves.easeIn, duration: Durations.medium3);
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return StatefulBuilder(builder: (context, setState) {
                  void handleEmotionSelected(String emotion) {
                    if (selectedEmotions.contains(emotion)) {
                      selectedEmotions.remove(emotion);
                    } else {
                      selectedEmotions.add(emotion);
                    }
                    setState(() {
                      selectedEmotions = selectedEmotions;
                    });
                  }

                  return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            emotionCategories[idx].name.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 2.0,
                            alignment: WrapAlignment.spaceEvenly,
                            children:
                                emotionCategories[idx].emotions.map((emotion) {
                              if (selectedEmotions.contains(emotion)) {
                                return FilledButton(
                                  onPressed: () =>
                                      handleEmotionSelected(emotion),
                                  child: Text(emotion),
                                );
                              }
                              return OutlinedButton(
                                onPressed: () => handleEmotionSelected(emotion),
                                style: const ButtonStyle(),
                                child: Text(emotion),
                              );
                            }).toList(),
                          )
                        ],
                      ));
                });
              });
        },
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ListWheelScrollView Sample'),
      ),
      body: Center(
        child: ListWheelScrollView.useDelegate(
          itemExtent: 150,
          physics: const FixedExtentScrollPhysics(),
          overAndUnderCenterOpacity: 0.5,
          childDelegate: ListWheelChildLoopingListDelegate(
            children: items,
          ),
          onSelectedItemChanged: (index) {
            setState(() {
              _focusedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
