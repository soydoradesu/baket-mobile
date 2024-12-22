part of '_pages.dart';

class DetailPostPage extends StatefulWidget {
  const DetailPostPage({
    required this.updatePost,
    required this.post,
    super.key,
  });

  final PostModel post;
  final void Function(bool) updatePost;

  @override
  State<DetailPostPage> createState() => _DetailPostPageState();
}

class _DetailPostPageState extends State<DetailPostPage> {
  final PagingController<int, ReplyModel> _pagingController = PagingController(
    firstPageKey: 1,
    invisibleItemsThreshold: 5,
  );

  final ReplyUseCase replyUseCase = ReplyUseCase(
    ReplyRepositoryImpl(ReplyRemoteDataSourceImpl()),
  );

  final LikeUseCase likeUseCase = LikeUseCase(
    PostRepositoryImpl(PostRemoteDataSourceImpl()),
    ReplyRepositoryImpl(ReplyRemoteDataSourceImpl()),
  );

  final DeletePostUseCase deletePostUseCase = DeletePostUseCase(
    PostRepositoryImpl(PostRemoteDataSourceImpl()),
  );

  late CookieRequest request;
  late final List<String> menus;

  bool isLoadingLike = false;
  int currentPage = 1;

  @override
  void initState() {
    menus = [
      'Report',
      if (PrefService.getString('username') == widget.post.user.username) ...[
        'Edit',
        'Delete',
      ],
    ];

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final response = await replyUseCase.execute(
        ReplyParams(
          request: request,
          url: Endpoints.replies,
          postId: widget.post.id,
          limit: 15,
          page: pageKey,
        ),
      );

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
            currentPage = nextPageKey;
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

    String nama = '${widget.post.user.firstName} ${widget.post.user.lastName}';
    if (nama == ' ') nama = widget.post.user.username;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Post',
          style: FontTheme.raleway22w700black(),
        ),
        shape: const Border(
          bottom: BorderSide(
            color: BaseColors.gray4,
            width: 1,
          ),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back,
            color: BaseColors.neutral100,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(() => _pagingController.refresh()),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 21,
                                backgroundColor: Colors.grey[200],
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: '${Endpoints.baseUrl}'
                                        '${widget.post.user.profilePicture}',
                                    errorWidget: (context, url, error) {
                                      return Image.network(
                                        '${Endpoints.baseUrl}'
                                        '/static/images/default_pp.png',
                                        fit: BoxFit.cover,
                                      );
                                    },
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    nama,
                                    style: FontTheme.raleway16w700black(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '@${widget.post.user.username}',
                                    style:
                                        FontTheme.raleway14w500black().copyWith(
                                      color: BaseColors.gray2,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: MenuButton(
                              menus: menus,
                              onChanged: (String? val) {
                                if (val == 'Edit') {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => EditPostPage(
                                        postId: widget.post.id,
                                        prevContent: widget.post.content,
                                        prevImage: widget.post.image != null
                                            ? '${Endpoints.baseUrl}'
                                                '${widget.post.image}'
                                            : null,
                                        onReceiveNewState: (val) async {
                                          widget.post.content = val;
                                          await _updateImage();
                                          setState(() {
                                            widget.updatePost(false);
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                } else if (val == 'Delete') {
                                  _deletePost();
                                } else {
                                  print('Report');
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.post.content,
                      style: FontTheme.raleway18w400black().copyWith(
                        fontFamily: 'sans-serif',
                      ),
                    ),
                    SizedBox(height: widget.post.image != null ? 10 : 0),
                    if (widget.post.image != null)
                      Hero(
                        tag: '${Endpoints.baseUrl}'
                            '${widget.post.image}-detail',
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ImagePreviewPage(
                                tag: '${Endpoints.baseUrl}'
                                    '${widget.post.image}-detail',
                                image: CachedNetworkImageProvider(
                                  '${Endpoints.baseUrl}'
                                  '${widget.post.image}',
                                ),
                              ),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: BaseColors.gray5,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: '${Endpoints.baseUrl}'
                                    '${widget.post.image}',
                                errorWidget: (context, url, error) {
                                  return Image.network(
                                    'https://placehold.co/400',
                                    fit: BoxFit.cover,
                                  );
                                },
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: widget.post.image != null ? 14 : 12),
                    Text(
                      DateConverter.getFullDate(widget.post.createdAt),
                      style: FontTheme.raleway12w500black().copyWith(
                        color: BaseColors.gray2,
                        fontFamily: 'sans-serif',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: _onTapLike,
                              borderRadius: BorderRadius.circular(10),
                              highlightColor:
                                  BaseColors.vividBlue.withOpacity(0.2),
                              splashColor:
                                  BaseColors.vividBlue.withOpacity(0.1),
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: Icon(
                                  widget.post.isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border_outlined,
                                  size: 21,
                                  color: widget.post.isLiked
                                      ? BaseColors.vividBlue
                                      : BaseColors.gray2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              ConvertLikes.convert(widget.post.likeCount),
                              style: FontTheme.raleway16w500black().copyWith(
                                color: BaseColors.gray2,
                                fontFamily: 'sans-serif',
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 24),
                            const Padding(
                              padding: EdgeInsets.all(2),
                              child: Icon(
                                LucideIcons.messageCircle,
                                size: 20,
                                color: BaseColors.gray2,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              ConvertLikes.convert(
                                widget.post.replyCount,
                              ),
                              style: FontTheme.raleway18w500black().copyWith(
                                color: BaseColors.gray2,
                                fontFamily: 'sans-serif',
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(
                                text: '${Endpoints.baseUrl}/'
                                    'feeds/post/${widget.post.id}',
                              ),
                            );

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                CustomSnackbar.snackbar(
                                  message: 'Link copied to clipboard!',
                                  icon: Icons.check,
                                  color: BaseColors.success,
                                ),
                              );
                          },
                          borderRadius: BorderRadius.circular(10),
                          highlightColor: BaseColors.gray3.withOpacity(0.2),
                          splashColor: BaseColors.gray3.withOpacity(0.1),
                          child: const Padding(
                            padding: EdgeInsets.all(2),
                            child: Icon(
                              LucideIcons.upload,
                              size: 20,
                              color: BaseColors.gray2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    color: BaseColors.gray5,
                    thickness: 1,
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 6,
                    ),
                    child: Text(
                      'Replies',
                      style: FontTheme.raleway18w700black(),
                    ),
                  ),
                ],
              ),
            ),
            ReplyView(
              pagingController: _pagingController,
              onDeleteReply: () => setState(() {
                widget.post.replyCount--;
                widget.updatePost(false);
              }),
              page: currentPage,
            ),
          ],
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddReplyPage(
              postId: widget.post.id,
              onReceiveNewReply: () {
                _pagingController.refresh();
                setState(() {
                  widget.post.replyCount++;
                  widget.updatePost(false);
                });
              },
            ),
          ),
        ),
        child: Container(
            decoration: const BoxDecoration(
              color: BaseColors.white,
              border: Border(
                top: BorderSide(
                  color: BaseColors.gray4,
                  width: 1,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: BaseColors.gray4.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: '${Endpoints.baseUrl}'
                              '${PrefService.getString('profile_picture')}',
                          errorWidget: (context, url, error) {
                            return Image.network(
                              '${Endpoints.baseUrl}/static/images/default_pp.png',
                              fit: BoxFit.cover,
                            );
                          },
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Write a reply ...',
                      style: FontTheme.raleway16w500black().copyWith(
                        color: BaseColors.gray2,
                        fontFamily: 'sans-serif',
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  void _onTapLike() async {
    if (isLoadingLike) return;

    setState(() {
      isLoadingLike = true;
    });

    // Hit API
    final response = await likeUseCase.execute(
      LikeParams(
        request: request,
        url: widget.post.isLiked ? Endpoints.unlikePost : Endpoints.likePost,
        uuid: widget.post.id,
      ),
    );

    response.fold(
      (left) {
        if (left is GeneralFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackbar.snackbar(
              message: '${left.message!.split(':')[0]} ...',
              icon: Icons.error,
              color: BaseColors.error,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackbar.snackbar(
              message: 'Terjadi kesalahan lain!',
              icon: Icons.error,
              color: BaseColors.error,
            ),
          );
        }
      },
      (right) {
        // Update UI
        setState(() {
          widget.post.isLiked = !widget.post.isLiked;
          widget.post.isLiked
              ? widget.post.likeCount++
              : widget.post.likeCount--;
          widget.updatePost(false);
        });

        setState(() {
          isLoadingLike = false;
        });
      },
    );
  }

  Future<void> _updateImage() async {
    dynamic newImage = await request
        .get(
          '${Endpoints.feeds}/json/post/id/${widget.post.id}',
        )
        .then((res) => res[0]['image']);

    setState(() {
      widget.post.image = newImage;
    });
  }

  void _deletePost() async {
    // Hit API
    final response = await deletePostUseCase.execute(widget.post.id);

    response.fold(
      (left) {
        if (left is GeneralFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackbar.snackbar(
              message: '${left.message!.split(':')[0]} ...',
              icon: Icons.error,
              color: BaseColors.error,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackbar.snackbar(
              message: 'Terjadi kesalahan lain!',
              icon: Icons.error,
              color: BaseColors.error,
            ),
          );
        }
      },
      (right) {
        Navigator.pop(context);
        widget.updatePost(true);
      },
    );
  }
}
