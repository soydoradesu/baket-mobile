// Convert integer likes to a string with K or M suffixes

class ConvertLikes {
  static String convert(int likes) {
    if (likes < 1000) {
      return likes.toString();
    } else if (likes < 1000000) {
      double shortened = likes / 1000;
      return '${shortened.toStringAsFixed(shortened.truncateToDouble() == shortened ? 0 : 1)}K';
    } else if (likes < 1000000000) {
      double shortened = likes / 1000000;
      return '${shortened.toStringAsFixed(shortened.truncateToDouble() == shortened ? 0 : 1)}M';
    } else {
      return '999M';
    }
  }
}
