import 'dart:convert';

class timeFormat {
  List timeFormatter(int pubDate) {
    final time = DateTime.fromMillisecondsSinceEpoch(pubDate);
    int created = 0;
    String d = "s";
    if (DateTime.timestamp().difference(time).inDays >= 365) {
      created = (DateTime.timestamp().difference(time).inDays / 365).toInt();
      d = "y";
    } else if (DateTime.timestamp().difference(time).inDays >= 30) {
      created = (DateTime.timestamp().difference(time).inDays / 30).toInt();
      d = "ay";
    } else if (DateTime.timestamp().difference(time).inHours >= 24) {
      created = DateTime.timestamp().difference(time).inDays;
      d = "g";
    } else if (DateTime.timestamp().difference(time).inHours >= 1) {
      created = DateTime.timestamp().difference(time).inHours;
    } else {
      d = "d";
      created = DateTime.timestamp().difference(time).inMinutes;
    }
    List response = List.empty(growable: true);
    response.add(d);
    response.add(created.toString());
    return response;
  }
}
