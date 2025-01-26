enum FilterType { day, week, month, year, all }

// Extension to add helper methods for converting to/from string
extension FilterTypeExtension on FilterType {
  // Convert enum to string
  String toShortString() {
    return toString().split('.').last; // Extract the part after the dot
  }

// Static method to convert a string back to the enum
}

FilterType fromString(String value) {
  return FilterType.values.firstWhere(
    (type) => type.toShortString() == value,
    orElse: () => throw ArgumentError("Invalid FilterType string: $value"),
  );
}
