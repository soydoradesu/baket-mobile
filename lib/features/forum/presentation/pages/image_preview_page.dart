part of '_pages.dart';

/// nyomot hehe
class ImagePreviewPage extends StatefulWidget {
  const ImagePreviewPage({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  State<ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  bool focused = false;

  @override
  Widget build(BuildContext context) {
    final phoneWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => setState(() => focused = false),
                child: InteractiveViewer(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Hero(
                      tag: widget.imageUrl,
                      flightShuttleBuilder: (
                        flightContext,
                        animation,
                        direction,
                        fromContext,
                        toContext,
                      ) {
                        return AnimatedBuilder(
                          animation: animation,
                          builder: (context, child) {
                            return Container(
                              child: child,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  widget.imageUrl,
                                ),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              widget.imageUrl,
                            ),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !focused,
                child: Column(
                  children: [
                    SizedBox(
                      width: phoneWidth,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(
                                Icons.arrow_back,
                                size: 26,
                                color: BaseColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => focused = true),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
