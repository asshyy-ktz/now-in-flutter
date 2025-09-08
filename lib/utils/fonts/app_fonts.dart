class AppFonts {}

enum FontFamily { manrope, inter }

extension FontFamilyExtension on FontFamily {
  String get name {
    switch (this) {
      case FontFamily.manrope:
        return "Manrope";
      case FontFamily.inter:
        return "Inter";
    }
  }
}
