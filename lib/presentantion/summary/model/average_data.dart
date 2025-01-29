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

  static const Map<int, double> babyWeightLowerLimit = {
    0: 2.5,
    1: 2.9,
    2: 3.2,
    3: 3.5,
    4: 3.8,
    5: 4.0,
    6: 4.3,
    7: 4.5,
    8: 4.7,
    9: 5.0,
    10: 5.2,
    11: 5.5,
    12: 5.7,
    13: 5.9,
    14: 6.1,
    15: 6.3,
    16: 6.5,
    17: 6.7,
    18: 6.9,
    19: 7.1,
    20: 7.3,
    21: 7.5,
    22: 7.7,
    23: 7.9,
    24: 8.0,
    25: 8.2,
    26: 8.4,
    27: 8.6,
    28: 8.7,
    29: 8.9,
    30: 9.0,
    31: 9.2,
    32: 9.3,
    33: 9.5,
    34: 9.6,
    35: 9.8,
    36: 9.9,
    37: 10.0,
    38: 10.2,
    39: 10.3,
    40: 10.4,
    41: 10.6,
    42: 10.7,
    43: 10.8,
    44: 10.9,
    45: 11.0,
    46: 11.1,
    47: 11.2,
    48: 11.3,
    49: 11.4,
    50: 11.5,
    51: 11.6,
    52: 11.7
  };

  static const Map<int, double> babyWeightUpperLimit = {
    0: 4.3,
    1: 4.8,
    2: 5.4,
    3: 5.9,
    4: 6.4,
    5: 6.9,
    6: 7.3,
    7: 7.7,
    8: 8.0,
    9: 8.4,
    10: 8.7,
    11: 9.0,
    12: 9.3,
    13: 9.6,
    14: 9.9,
    15: 10.2,
    16: 10.5,
    17: 10.8,
    18: 11.0,
    19: 11.3,
    20: 11.5,
    21: 11.8,
    22: 12.0,
    23: 12.2,
    24: 12.4,
    25: 12.6,
    26: 12.8,
    27: 13.0,
    28: 13.2,
    29: 13.4,
    30: 13.6,
    31: 13.8,
    32: 14.0,
    33: 14.2,
    34: 14.4,
    35: 14.5,
    36: 14.7,
    37: 14.9,
    38: 15.0,
    39: 15.2,
    40: 15.4,
    41: 15.5,
    42: 15.7,
    43: 15.8,
    44: 16.0,
    45: 16.1,
    46: 16.2,
    47: 16.4,
    48: 16.5,
    49: 16.6,
    50: 16.7,
    51: 16.8,
    52: 17.0
  };
}
