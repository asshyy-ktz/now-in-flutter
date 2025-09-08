enum DurationType {
  all,
  daily,
  weekly,
}

extension DurationTypeExtension on DurationType {
  String get displayName {
    switch (this) {
      case DurationType.all:
        return 'ALL';
      case DurationType.daily:
        return 'Daily';
      case DurationType.weekly:
        return 'Weekly';
    }
  }
}
