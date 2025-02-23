bool parseToBool(dynamic json) {
  if (json is bool) {
    return json;
  } else if (json is int) {
    return json == 1;
  } else if (json is String) {
    return int.tryParse(json) == 1;
  }
  return false;
}

int? parseToInt(dynamic value) {
  if (value == null) return null;
  if (value is String) {
    return int.tryParse(value);
  }
  if (value is num) {
    return value.toInt();
  }
  return null;
}

int? parseFromBoolToInt(dynamic value) {
  if (value == null) return null;
  if (value is bool) {
    return value ? 1 : 0;
  }
  if (value is int) {
    return value;
  }
  if (value is String) {
    return int.tryParse(value);
  }
  return null;
}

double? parseToDouble(dynamic value) {
  if (value == null) return null;
  if (value is String) {
    return double.tryParse(value);
  }
  if (value is num) {
    return value.toDouble();
  }
  return null;
}

String? parseToString(dynamic value) {
  if (value == null) return null;
  if (value is String) {
    return value;
  }

  return value.toString();
}
