library units;

export 'units/blood_glucose.dart';
export 'units/energy.dart';
export 'units/length.dart';
export 'units/mass.dart';
export 'units/percentage.dart';
export 'units/power.dart';
export 'units/pressure.dart';
export 'units/temperature.dart';
export 'units/velocity.dart';
export 'units/volume.dart';

/// parses zoneOffset string (of format (-)HH:MM or "Z") into [Duration]
Duration parseTimeZoneOffset(String s) {
  if (s == 'Z') {
    return Duration.zero;
  }
  List<String> parts = s.split(':');
  if (parts.length == 2) {
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    return Duration(hours: hours, minutes: minutes);
  } else {
    throw ArgumentError.value(s, 's', 'Invalid zoneOffset string');
  }
}
