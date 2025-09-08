import 'package:flutter/material.dart';

extension BoldSubString on Text {
  Text boldSubString(String target) {
    // Get the original TextStyle of the Text widget
    final originalStyle = this.style;

    // Escape special characters from the target string
    final escapedTarget = RegExp.escape(target);
    final pattern = RegExp(escapedTarget, caseSensitive: false);
    final matches = pattern.allMatches(this.data!);

    final textSpans = <TextSpan>[];
    int currentIndex = 0;

    // Iterate through matches and build TextSpan accordingly
    for (final match in matches) {
      final beforeMatch = this.data!.substring(currentIndex, match.start);
      if (beforeMatch.isNotEmpty) {
        textSpans.add(TextSpan(text: beforeMatch, style: originalStyle));
      }

      final matchedText = this.data!.substring(match.start, match.end);
      textSpans.add(
        TextSpan(
          text: matchedText,
          style: originalStyle?.copyWith(fontWeight: FontWeight.bold),
        ),
      );

      currentIndex = match.end;
    }

    // Add any remaining text after the last match
    if (currentIndex < this.data!.length) {
      final remainingText = this.data!.substring(currentIndex);
      textSpans.add(TextSpan(text: remainingText, style: originalStyle));
    }

    return Text.rich(
      TextSpan(children: textSpans),
      style: originalStyle,
      textAlign: this.textAlign,
    );
  }
}
