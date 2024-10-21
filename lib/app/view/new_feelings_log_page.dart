import 'package:flutter/material.dart';
import 'package:mental_floss/feelings_log_model.dart';
import 'package:mental_floss/main.dart';
import 'package:mental_floss/models.dart';
import 'package:provider/provider.dart';

class NewFeelingsLogPage extends StatefulWidget {
  const NewFeelingsLogPage({super.key});

  @override
  State<NewFeelingsLogPage> createState() {
    return _NewFeelingsLogPageState();
  }
}

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

class _NewFeelingsLogPageState extends State<NewFeelingsLogPage> {
  var _focusedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<ListTile> items = buildItems(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MNTL FLOSS'),
        actions: const [
          // TODO: Add ability to record an emotions log
        ],
      ),
      body: body(items),
      floatingActionButton: Consumer<FeelingsLogModel>(
        builder: (context, feelingsLog, child) => Visibility(
          visible: feelingsLog.selectedEmotions.isNotEmpty,
          child: FloatingActionButton.extended(
            elevation: 2,
            label: const Text("Add"),
            onPressed: () {
              objectbox.feelingsLogsBox
                  .put(FeelingsLog(feelingsLog.selectedEmotions));
              feelingsLog.removeAll();
            },
            icon: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Stack body(
    List<ListTile> items,
  ) {
    return Stack(
      children: [
        ListWheelScrollView.useDelegate(
          itemExtent: 150,
          physics: const FixedExtentScrollPhysics(),
          overAndUnderCenterOpacity: 0.5,
          childDelegate: ListWheelChildLoopingListDelegate(
            children: items,
          ),
          onSelectedItemChanged: (index) {
            setFocusedIndex(index);
          },
        ),
        Consumer<FeelingsLogModel>(
            builder: (context, feelingsLog, child) => Wrap(
                  direction: Axis.horizontal,
                  children: feelingsLog.selectedEmotions
                      .map(
                        (emotion) => InputChip(
                          label: Text(emotion),
                          onDeleted: () {
                            feelingsLog.remove(emotion);
                          },
                        ),
                      )
                      .toList(),
                )),
      ],
    );
  }

  void setFocusedIndex(int index) {
    setState(() {
      _focusedIndex = index;
    });
  }

  List<ListTile> buildItems(BuildContext context) {
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
            useRootNavigator: true,
            elevation: 0,
            context: context,
            builder: (context) {
              return Consumer<FeelingsLogModel>(
                  builder: (context, feelingsLog, child) {
                void handleEmotionSelected(String emotion) {
                  if (feelingsLog.selectedEmotions.contains(emotion)) {
                    feelingsLog.remove(emotion);
                  } else {
                    feelingsLog.add(emotion);
                  }
                }

                return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          emotionCategories[idx].name.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: Wrap(
                            spacing: 2.0,
                            alignment: WrapAlignment.spaceEvenly,
                            children:
                                emotionCategories[idx].emotions.map((emotion) {
                              if (feelingsLog.selectedEmotions
                                  .contains(emotion)) {
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
                          ),
                        ),
                        Consumer<FeelingsLogModel>(
                          builder: (context, feelingsLog, child) => Visibility(
                            visible: feelingsLog.selectedEmotions.isNotEmpty,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                margin: const EdgeInsets.only(
                                  right: 10,
                                  bottom: 50,
                                ),
                                child: FloatingActionButton.extended(
                                  elevation: 2,
                                  label: const Text("Add"),
                                  onPressed: () {
                                    objectbox.feelingsLogsBox.put(FeelingsLog(
                                        feelingsLog.selectedEmotions));
                                    feelingsLog.removeAll();
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ));
              });
            },
          );
        },
      );
    }).toList();
    return items;
  }
}
