enum Topic { Crypto, Technology, Science, Sports, Entertainment, Politics }

class HeaderTopic {
  String topic = 'crypto';
  bool select = false;
  List<HeaderTopic> resultData = [];
  HeaderTopic(this.topic, this.select);

  List<HeaderTopic> topicListProperty() {
    List<String> list =
        Topic.values.map((e) => e.toString().substring(6)).toList();
    for (var element in list) {
      if (element == 'Crypto') {
        resultData.add(HeaderTopic(element, true));
      } else {
        resultData.add(HeaderTopic(element, false));
      }
    }
    return resultData;
  }

  void changeResultData(int select) {
    List<HeaderTopic> selectData = [];
    resultData.asMap().forEach((key, value) {
      if (key == select) {
        selectData.add(HeaderTopic(value.topic, true));
      } else {
        selectData.add(HeaderTopic(value.topic, false));
      }
    });
    resultData.clear();
    resultData = selectData;
  }
}
