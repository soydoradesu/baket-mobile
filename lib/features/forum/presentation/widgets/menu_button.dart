part of '_widgets.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    required this.menus,
    required this.onChanged,
    super.key,
  });

  final List<String> menus;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        value: menus.first,
        onChanged: onChanged,
        items: menus
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e,
                  style: FontTheme.raleway14w600black().copyWith(
                    fontSize: 16,
                    color: e == 'Delete'
                        ? BaseColors.danger
                        : BaseColors.neutral100,
                  ),
                ),
              ),
            )
            .toList(),
        customButton: const Icon(
          Icons.more_vert,
          color: BaseColors.gray2,
        ),
        dropdownStyleData: DropdownStyleData(
          direction: DropdownDirection.left,
          maxHeight: 150,
          width: 150,
          elevation: 2,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: BaseColors.neutral10,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 45,
        ),
      ),
    );
  }
}
