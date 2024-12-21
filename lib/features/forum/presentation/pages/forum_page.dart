part of '_pages.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> with TickerProviderStateMixin {
  late TextEditingController _searchController;
  late TabController _tabController;
  late FocusNode _focusNode;

  final ScrollController discoverController = ScrollController();
  final ScrollController yourPostController = ScrollController();

  final PagingController<int, PostModel> discoverPaging =
      PagingController<int, PostModel>(
    firstPageKey: 1,
    invisibleItemsThreshold: 5,
  );

  final PagingController<int, PostModel> yourPostPaging =
      PagingController<int, PostModel>(
    firstPageKey: 1,
    invisibleItemsThreshold: 5,
  );

  int _selectedIndex = 0;

  @override
  void initState() {
    _searchController = TextEditingController();
    _tabController = TabController(length: 2, vsync: this);
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void onReceiveNewPost() {
    discoverPaging.refresh();
    yourPostPaging.refresh();

    if (_selectedIndex == 0) {
      discoverController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      yourPostController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        CustomSnackbar.snackbar(
          message: 'Post added successfully!',
          icon: LucideIcons.checkCircle,
          color: BaseColors.success,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double pinnedHeaderHeight = statusBarHeight + kToolbarHeight;

    return Scaffold(
      backgroundColor: BaseColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ExtendedNestedScrollView(
                headerSliverBuilder: (BuildContext c, bool f) {
                  return [
                    SliverAppBar(
                      backgroundColor: BaseColors.white,
                      surfaceTintColor: BaseColors.white,
                      automaticallyImplyLeading: false,
                      pinned: true,
                      expandedHeight: 105,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SearchField(
                            searchController: _searchController,
                            focusNode: _focusNode,
                            onQueryChanged: onQueryChanged,
                          ),
                        ),
                      ),
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(50),
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: BaseColors.gray3,
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: TabBar(
                            controller: _tabController,
                            onTap: (index) {
                              if (_focusNode.hasFocus) _focusNode.unfocus();
                              if (index == _selectedIndex) {
                                final controller = index == 0
                                    ? discoverController
                                    : yourPostController;
                                controller.animateTo(
                                  0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              } else if (index != _selectedIndex) {
                                setState(() {
                                  _selectedIndex = index;
                                });
                              }
                            },
                            labelPadding: EdgeInsets.zero,
                            tabs: [
                              Tab(
                                height: 45,
                                child: Text(
                                  'Discover',
                                  style: FontTheme.raleway14w700black(),
                                ),
                              ),
                              Tab(
                                height: 45,
                                child: Text(
                                  'Your Post',
                                  style: FontTheme.raleway14w700black(),
                                ),
                              ),
                            ],
                            indicator: _UnderlineTab(
                              width: 70,
                              height: 4,
                              color: BaseColors.vividBlue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                pinnedHeaderSliverHeightBuilder: () => pinnedHeaderHeight,
                body: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    PostView(
                      pagingController: discoverPaging,
                      scrollController: discoverController,
                      pageKey: const PageStorageKey<String>('discover'),
                      isYourPost: false,
                    ),
                    PostView(
                      pagingController: yourPostPaging,
                      scrollController: yourPostController,
                      pageKey: const PageStorageKey<String>('your_post'),
                      isYourPost: true,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              right: 24,
              child: FloatingActionButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddPostPage(
                      onReceiveNewPost: onReceiveNewPost,
                    ),
                  ),
                ),
                backgroundColor: BaseColors.vividBlue,
                child: const Icon(
                  LucideIcons.feather,
                  color: BaseColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onQueryChanged(String value) {
    setState(() {
      if (kDebugMode) {
        print(value);
      }
    });
  }
}

/// Custom underline tab indicator.
class _UnderlineTab extends Decoration {
  final double width;
  final double height;
  final Color color;
  final BorderRadius borderRadius;

  const _UnderlineTab({
    required this.width,
    required this.height,
    required this.color,
    required this.borderRadius,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _UnderlineTabPainter(width, height, color, borderRadius);
  }
}

class _UnderlineTabPainter extends BoxPainter {
  final double width;
  final double height;
  final Color color;
  final BorderRadius borderRadius;

  _UnderlineTabPainter(this.width, this.height, this.color, this.borderRadius);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final paint = Paint()..color = color;

    final xOffset = (configuration.size!.width - width) / 2;
    final yOffset = configuration.size!.height - height;

    final rect = Rect.fromLTWH(
      offset.dx + xOffset,
      offset.dy + yOffset,
      width,
      height,
    );

    final rRect = RRect.fromRectAndCorners(
      rect,
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );

    canvas.drawRRect(rRect, paint);
  }
}
