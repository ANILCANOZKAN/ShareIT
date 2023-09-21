import 'package:firebase_database/firebase_database.dart';

class getData {
  getData() {
    FirebaseDatabase database = FirebaseDatabase.instance;

    DatabaseReference starCountRef = FirebaseDatabase.instance.ref('/Users');

    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      print(data);
    });
  }
}
