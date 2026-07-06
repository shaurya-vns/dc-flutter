import 'package:firebase_database/firebase_database.dart';

import 'model/get/StationModel.dart';

class FirebaseServiceUtils {
  static final DatabaseReference ref = FirebaseDatabase.instance.ref("stations");

  static Future<void> deleteStation(String stationName) async {
    try {
      await ref.child(stationName).remove();
      print("Station deleted successfully");
    } catch (e) {
      print("Error: $e");
    }
  }

  static void getStations({
    required Function(List<StationModel>) onSuccess,
    required Function(String error) onError,
  }) {
    ref.onValue.listen(
      (event) {
        List<StationModel> list = [];

        if (event.snapshot.value != null) {
          final map = Map<dynamic, dynamic>.from(event.snapshot.value as Map);

          map.forEach((key, value) {
            list.add(StationModel.fromJson(Map<dynamic, dynamic>.from(value)));
          });
        }

        onSuccess(list);
      },
      onError: (e) {
        onError(e.toString());
      },
    );
  }
}
