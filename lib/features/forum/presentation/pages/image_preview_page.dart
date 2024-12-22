part of '_pages.dart';

class ImagePreviewPage extends StatelessWidget {
  const ImagePreviewPage({
    required this.image,
    this.haveAnimation = true,
    this.tag,
    super.key,
  });

  final String? tag;
  final ImageProvider image;
  final bool haveAnimation;

  @override
  Widget build(BuildContext context) {
    final imagePreview = Image(image: image);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Stack(
            children: [
              InteractiveViewer(
                minScale: 1,
                maxScale: 3,
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: haveAnimation
                        ? Hero(
                            tag: tag ?? 'preview-image',
                            child: Material(
                              type: MaterialType.transparency,
                              child: imagePreview,
                            ),
                          )
                        : imagePreview,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 26,
                    color: BaseColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
