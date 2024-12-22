part of '_widgets.dart';

class CustomSnackbar {
  static SnackBar snackbar({
    final String message = 'This is a snackbar!',
    final IconData icon = Icons.info,
    final Color color = BaseColors.vividBlue,
  }) {
    return SnackBar(
      content: Container(
        color: BaseColors.white,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 20,
              ),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 14, 24, 14),
              child: Text(
                message,
                style: FontTheme.raleway14w500black(),
              ),
            ),
          ],
        ),
      ),
      elevation: 3,
      duration: const Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(48, 0, 48, 32),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
