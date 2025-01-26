  class AverageDataConst {
  static const Map<int, int> poopLower = {
    0: 3, // Lower bound for 0-1 months
    1: 3,
    2: 2, // Lower bound for 1-2 months
    3: 2,
    4: 1, // Lower bound for 2-4 months
    5: 1,
    6: 1, // Lower bound for 4-12 months
    7: 1,
    8: 1,
    9: 1,
    10: 1,
    11: 1,
    12: 1
  };

  static const Map<int, int> poopUpper = {
    0: 5, // Upper bound for 0-1 months
    1: 5,
    2: 4, // Upper bound for 1-2 months
    3: 4,
    4: 3, // Upper bound for 2-4 months
    5: 3,
    6: 2, // Upper bound for 4-12 months
    7: 2,
    8: 2,
    9: 2,
    10: 2,
    11: 2,
    12: 2
  };

  static const Map<int, int> weeLower = {
    0: 6, // Lower bound for 0-12 months
    1: 6,
    2: 6,
    3: 6,
    4: 6,
    5: 6,
    6: 5,
    7: 5,
    8: 5,
    9: 5,
    10: 5,
    11: 5,
    12: 5
  };

  static const Map<int, int> weeUpper = {
    0: 8, // Upper bound for 0-12 months
    1: 8,
    2: 8,
    3: 8,
    4: 8,
    5: 8,
    6: 7,
    7: 7,
    8: 7,
    9: 6,
    10: 6,
    11: 6,
    12: 6
  };

  static const Map<int, int> nappyChangesLower = {
    0: 8, // Lower bound for 0-1 months
    1: 8,
    2: 6, // Lower bound for 1-2 months
    3: 6,
    4: 5, // Lower bound for 2-4 months
    5: 5,
    6: 4, // Lower bound for 4-12 months
    7: 4,
    8: 4,
    9: 4,
    10: 4,
    11: 4,
    12: 4
  };

  static const Map<int, int> nappyChangesUpper = {
    0: 12, // Upper bound for 0-1 months
    1: 12,
    2: 10, // Upper bound for 1-2 months
    3: 10,
    4: 7, // Upper bound for 2-4 months
    5: 7,
    6: 6, // Upper bound for 4-12 months
    7: 6,
    8: 6,
    9: 6,
    10: 6,
    11: 6,
    12: 6
  };

  static const Map<int, int> feedsLower = {
    0: 8, // Lower bound for 0-1 months
    1: 8,
    2: 6, // Lower bound for 1-2 months
    3: 6,
    4: 5, // Lower bound for 2-4 months
    5: 5,
    6: 4, // Lower bound for 4-12 months
    7: 4,
    8: 4,
    9: 3, // Lower bound for 9-12 months
    10: 3,
    11: 3,
    12: 3
  };

  static const Map<int, int> feedsUpper = {
    0: 12, // Upper bound for 0-1 months
    1: 12,
    2: 8, // Upper bound for 1-2 months
    3: 8,
    4: 6, // Upper bound for 2-4 months
    5: 6,
    6: 6, // Upper bound for 4-12 months
    7: 6,
    8: 6,
    9: 5, // Upper bound for 9-12 months
    10: 5,
    11: 5,
    12: 5
  };
}
