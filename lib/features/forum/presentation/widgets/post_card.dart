part of '_widgets.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    required this.post,
    super.key,
  });

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    String nama = '${post.user.firstName} ${post.user.lastName}';
    if (nama == ' ') nama = post.user.username;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
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
              padding: const EdgeInsets.only(right: 18),
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
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateConverter.getTime(post.createdAt),
                    style: FontTheme.raleway12w500black().copyWith(
                      color: BaseColors.gray2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.content,
                    style: FontTheme.raleway16w400black().copyWith(
                      fontFamily: 'sans-serif',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
