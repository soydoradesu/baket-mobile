part of '_widgets.dart';

class PostView extends StatefulWidget {
  const PostView({
    required this.pageKey,
    required this.isYourPost,
    super.key,
  });

  final bool isYourPost;
  final PageStorageKey<String> pageKey;

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  late final PostUseCase postUseCase;
  late final String urls;
  late CookieRequest request;

  final PagingController<int, PostModel> _pagingController =
      PagingController<int, PostModel>(firstPageKey: 1);

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() {
    if (!mounted) return;

    postUseCase = PostUseCase(PostRepositoryImpl(PostRemoteDataSourceImpl()));
    urls = widget.isYourPost ? Endpoints.myPosts : Endpoints.allPosts;
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPosts(pageKey, request);
    });
  }

  void _fetchPosts(int pageKey, CookieRequest request) async {
    try {
      final response = await postUseCase.execute(PostParams(
        request: request,
        url: urls,
        query: '',
        limit: 15,
        page: pageKey,
      ));

      response.fold(
        (left) {
          if (left is GeneralFailure) {
            throw left.message!;
          } else {
            throw 'Terjadi kesalahan lain!';
          }
        },
        (right) {
          final data = right.data;
          final isLastPage = data['next_page'] == null;
          if (isLastPage) {
            _pagingController.appendLastPage(data['results']);
          } else {
            final nextPageKey = pageKey + 1;
            _pagingController.appendPage(data['results'], nextPageKey);
          }
        },
      );
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    request = context.watch<CookieRequest>();

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => Future.sync(() => _pagingController.refresh()),
            color: BaseColors.blue1,
            child: PagedListView<int, PostModel>.separated(
              key: widget.pageKey,
              pagingController: _pagingController,
              separatorBuilder: (context, index) => const Divider(
                color: BaseColors.gray5,
                height: 1,
              ),
              builderDelegate: PagedChildBuilderDelegate<PostModel>(
                newPageProgressIndicatorBuilder: (_) => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                firstPageProgressIndicatorBuilder: (_) => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                noItemsFoundIndicatorBuilder: (_) => Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        Assets.svg.noPost,
                        width: 180,
                        height: 180,
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'No post found.',
                        style: FontTheme.raleway20w700black(),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create a new post with\nthat blue floating button!',
                        style: FontTheme.raleway16w400black(),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                noMoreItemsIndicatorBuilder: (context) {
                  if (_pagingController.nextPageKey == null) {
                    return const SizedBox();
                  }

                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Text(
                        'You hit the rock bottom!',
                        style: FontTheme.raleway14w500black(),
                      ),
                    ),
                  );
                },
                firstPageErrorIndicatorBuilder: (context) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 64),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        Assets.svg.error,
                        width: 180,
                        height: 180,
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Error on retrieving data.',
                        style: FontTheme.raleway20w700black().copyWith(
                          color: BaseColors.vividBlue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please refresh the page.',
                        style: FontTheme.raleway16w400black(),
                      ),
                    ],
                  ),
                ),
                newPageErrorIndicatorBuilder: (context) => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text('Error on retrieving data, please refresh.'),
                  ),
                ),
                itemBuilder: (context, item, index) {
                  return PostCard(post: item);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
