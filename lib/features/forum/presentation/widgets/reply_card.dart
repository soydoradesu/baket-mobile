part of '_widgets.dart';

class ReplyCard extends StatelessWidget {
  const ReplyCard({
    required this.reply,
    required this.onTapLike,
    super.key,
  });

  final ReplyModel reply;
  final VoidCallback onTapLike;

  @override
  Widget build(BuildContext context) {
    String nama = '${reply.user.firstName} ${reply.user.lastName}';
    if (nama == ' ') nama = reply.user.username;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 21,
            backgroundColor: Colors.grey[200],
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: '${Endpoints.baseUrl}${reply.user.profilePicture}',
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
          const SizedBox(width: 14),
          Expanded(
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
                        '@${reply.user.username}',
                        style: FontTheme.raleway14w500black().copyWith(
                          color: BaseColors.gray2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '  •  ${DateConverter.getTime(reply.createdAt)}',
                      style: FontTheme.raleway12w500black().copyWith(
                        color: BaseColors.gray2,
                        fontFamily: 'sans-serif',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                Text(
                  reply.content,
                  style: FontTheme.raleway16w400black().copyWith(
                    fontFamily: 'sans-serif',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: onTapLike,
                borderRadius: BorderRadius.circular(10),
                highlightColor: BaseColors.vividBlue.withOpacity(0.2),
                splashColor: BaseColors.vividBlue.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    reply.isLiked
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                    size: 18,
                    color:
                        reply.isLiked ? BaseColors.vividBlue : BaseColors.gray2,
                  ),
                ),
              ),
              Text(
                ConvertLikes.convert(reply.likeCount),
                style: FontTheme.raleway12w500black().copyWith(
                  color: BaseColors.gray2,
                  fontFamily: 'sans-serif',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
