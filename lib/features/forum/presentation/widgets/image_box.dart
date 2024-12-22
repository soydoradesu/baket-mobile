part of '_widgets.dart';

class ImageBox extends StatelessWidget {
  const ImageBox({
    required this.image,
    required this.onDelete,
    this.isEditPage = false,
    super.key,
  });

  final ImageProvider? image;
  final VoidCallback onDelete;
  final bool isEditPage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height / 2,
          ),
          decoration: BoxDecoration(
            color: BaseColors.gray5,
            borderRadius: BorderRadius.circular(8),
          ),
          child: image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Opacity(
                    opacity: isEditPage ? 0.4 : 1,
                    child: Image(image: image!),
                  ),
                )
              : const SizedBox.shrink(),
        ),
        Visibility(
          visible: image != null,
          child: Positioned(
            top: 12,
            right: 12,
            child: InkWell(
              onTap: onDelete,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: BaseColors.neutral100.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.x,
                  size: 18,
                  color: BaseColors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
