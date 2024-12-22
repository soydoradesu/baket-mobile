part of '_widgets.dart';

class ReplyView extends StatefulWidget {
  const ReplyView({
    required this.pagingController,
    required this.onDeleteReply,
    required this.page,
    super.key,
  });

  final PagingController<int, ReplyModel> pagingController;
  final void Function() onDeleteReply;
  final int page;

  @override
  State<ReplyView> createState() => _ReplyViewState();
}

class _ReplyViewState extends State<ReplyView>
    with AutomaticKeepAliveClientMixin {
  late final LikeUseCase likeUseCase;
  late final DeleteReplyUseCase deleteReplyUseCase;
  late CookieRequest request;

  bool isLoadingLike = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  bool get wantKeepAlive => true;

  void _init() {
    if (!mounted) return;
    likeUseCase = LikeUseCase(
      PostRepositoryImpl(PostRemoteDataSourceImpl()),
      ReplyRepositoryImpl(ReplyRemoteDataSourceImpl()),
    );
    deleteReplyUseCase = DeleteReplyUseCase(
      ReplyRepositoryImpl(ReplyRemoteDataSourceImpl()),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    request = context.watch<CookieRequest>();

    return PagedSliverList<int, ReplyModel>.separated(
      pagingController: widget.pagingController,
      separatorBuilder: (context, index) => const Divider(
        color: BaseColors.gray5,
        height: 1,
      ),
      builderDelegate: PagedChildBuilderDelegate<ReplyModel>(
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
                'No replies found.',
                style: FontTheme.raleway20w700black(),
              ),
              const SizedBox(height: 8),
              Text(
                'Be the first to reply!',
                style: FontTheme.raleway16w400black(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        noMoreItemsIndicatorBuilder: (context) {
          if (widget.page == 1) {
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
          return InkWell(
            onLongPress: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          splashColor: BaseColors.transparent,
                          hoverColor: BaseColors.transparent,
                          focusColor: BaseColors.transparent,
                          title: Text(
                            'Report',
                            style: FontTheme.raleway18w700black(),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            // Handle report action
                          },
                        ),
                        if (PrefService.getString('username') ==
                            item.user.username)
                          ListTile(
                            splashColor: BaseColors.transparent,
                            hoverColor: BaseColors.transparent,
                            focusColor: BaseColors.transparent,
                            title: Text(
                              'Delete',
                              style: FontTheme.raleway18w700black().copyWith(
                                color: BaseColors.error,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Confirm Delete',
                                      style: FontTheme.raleway18w700black(),
                                    ),
                                    content: Text(
                                      'Are you sure you want to '
                                      'delete this reply?',
                                      style: FontTheme.raleway16w400black(),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Cancel',
                                          style: FontTheme.raleway14w700black()
                                              .copyWith(
                                            color: BaseColors.gray2,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _deleteReply(item);
                                        },
                                        child: Text(
                                          'Delete',
                                          style: FontTheme.raleway14w700black()
                                              .copyWith(
                                            color: BaseColors.error,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                      ],
                    ),
                  );
                },
              );
            },
            child: ReplyCard(
              onTapLike: () => _onTapLike(item),
              reply: item,
            ),
          );
        },
      ),
    );
  }

  void _onTapLike(ReplyModel item) async {
    if (isLoadingLike) return;

    setState(() {
      isLoadingLike = true;
    });

    // Hit API
    final response = await likeUseCase.execute(
      LikeParams(
        request: request,
        url: item.isLiked ? Endpoints.unlikeReply : Endpoints.likeReply,
        uuid: item.id,
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
        item.isLiked = !item.isLiked;

        // Update UI
        updateLike(item);

        setState(() {
          isLoadingLike = false;
        });
      },
    );
  }

  void updateLike(ReplyModel reply) {
    setState(() {
      if (reply.isLiked) {
        reply.likeCount++;
      } else {
        reply.likeCount--;
      }
    });
  }

  void _deleteReply(ReplyModel item) async {
    // Hit API
    final response = await deleteReplyUseCase.execute(item.id);

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
        widget.pagingController.refresh();
        widget.onDeleteReply();
      },
    );
  }
}
