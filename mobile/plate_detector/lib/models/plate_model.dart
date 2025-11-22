// plate_data.dart
import 'auto_model.dart';
import 'user_model.dart';

class PlateData {
  final Auto autoData;
  final User userData;

  PlateData({
    required this.autoData,
    required this.userData,
  });

  factory PlateData.fromJson(Map<String, dynamic> json) {
    return PlateData(
      autoData: Auto.fromJson(json['auto'] as Map<String, dynamic>),
      userData: User.fromJson(json['persona'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'auto': autoData.toJson(),
      'persona': userData.toJson(),
    };
  }
}
