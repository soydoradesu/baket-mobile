part of '_widgets.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    required this.searchController,
    required this.focusNode,
    required this.onQueryChanged,
    this.hintText = 'Search Tags',
    super.key,
  });

  final TextEditingController searchController;
  final FocusNode focusNode;
  final void Function(String) onQueryChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: searchController,
      decoration: TextInputDecorator.search(
        context: context,
        hint: hintText,
      ).copyWith(
        suffixIcon: focusNode.hasFocus || searchController.text.isNotEmpty
            ? InkWell(
                onTap: () {
                  focusNode.unfocus();
                  searchController.clear();
                  onQueryChanged('');
                },
                child: const Icon(
                  Icons.clear,
                  color: Colors.grey,
                ),
              )
            : null,
      ),
      style: FontTheme.raleway12w500black(),
      onChanged: onQueryChanged,
    );
  }
}
