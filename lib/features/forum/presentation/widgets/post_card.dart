part of '_widgets.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    required this.post,
    required this.onTap,
    required this.onTapLike,
    super.key,
  });

  final PostModel post;
  final VoidCallback onTap;
  final VoidCallback onTapLike;

  @override
  Widget build(BuildContext context) {
    String nama = '${post.user.firstName} ${post.user.lastName}';
    if (nama == ' ') nama = post.user.username;

    return InkWell(
      onTap: onTap,
      highlightColor: BaseColors.gray5,
      splashColor: BaseColors.transparent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 21,
              backgroundColor: Colors.grey[200],
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: '${Endpoints.baseUrl}${post.user.profilePicture}',
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
            const SizedBox(width: 18),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          flex: 3,
                          child: Text(
                            nama,
                            style: FontTheme.raleway16w700black().copyWith(
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          flex: 2,
                          child: Text(
                            '@${post.user.username}',
                            style: FontTheme.raleway14w500black().copyWith(
                              color: BaseColors.gray2,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '  •  ${DateConverter.getTime(post.createdAt)}',
                          style: FontTheme.raleway12w500black().copyWith(
                            color: BaseColors.gray2,
                            fontFamily: 'sans-serif',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      post.content,
                      style: FontTheme.raleway16w400black().copyWith(
                        fontFamily: 'sans-serif',
                      ),
                    ),
                    SizedBox(height: post.image != null ? 10 : 0),
                    if (post.image != null)
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ImagePreviewPage(
                              imageUrl: '${Endpoints.baseUrl}${post.image}',
                            ),
                          ),
                        ),
                        child: Hero(
                          tag: '${Endpoints.baseUrl}${post.image}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: double.infinity,
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height / 2,
                              ),
                              decoration: BoxDecoration(
                                color: BaseColors.gray5,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: '${Endpoints.baseUrl}${post.image}',
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
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: onTapLike,
                              borderRadius: BorderRadius.circular(10),
                              highlightColor:
                                  BaseColors.vividBlue.withOpacity(0.2),
                              splashColor:
                                  BaseColors.vividBlue.withOpacity(0.1),
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: Icon(
                                  post.isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border_outlined,
                                  size: 21,
                                  color: post.isLiked
                                      ? BaseColors.vividBlue
                                      : BaseColors.gray2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              ConvertLikes.convert(post.likeCount),
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
                              ConvertLikes.convert(post.replyCount),
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
                                    'feeds/post/${post.id}',
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
          ],
        ),
      ),
    );
  }
}
