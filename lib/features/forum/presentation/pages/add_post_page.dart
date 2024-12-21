part of '_pages.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({
    required this.onReceiveNewPost,
    super.key,
  });

  final VoidCallback onReceiveNewPost;

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  late CookieRequest request;
  late final AddPostUseCase addPostUseCase;
  late final FocusNode _focusNode;
  late final TextEditingController _textController;

  int _wordCount = 0;
  File? _image;

  @override
  void initState() {
    super.initState();
    addPostUseCase = AddPostUseCase(
      PostRepositoryImpl(PostRemoteDataSourceImpl()),
    );
    _focusNode = FocusNode();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: BaseColors.white,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: BaseColors.white,
            boxShadow: [
              BoxShadow(
                color: BaseColors.gray5,
                blurRadius: 4,
                offset: Offset(0, -2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => _pickImage(context),
                child: Icon(
                  LucideIcons.imagePlus,
                  color:
                      _image == null ? BaseColors.vividBlue : BaseColors.gray3,
                  size: 24,
                ),
              ),
              SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  value: _wordCount / 250,
                  backgroundColor: BaseColors.gray4,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _wordCount > 225
                        ? BaseColors.danger
                        : _wordCount > 200
                            ? BaseColors.warning
                            : BaseColors.vividBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            LucideIcons.x,
            size: 28,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: ElevatedButton(
              onPressed: _onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: BaseColors.vividBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
              ),
              child: Text(
                'Post',
                style: FontTheme.raleway16w700white(),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: CircleAvatar(
                    radius: 21,
                    backgroundColor: Colors.grey[200],
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl:
                            '${Endpoints.baseUrl}${PrefService.getString('profile_picture')}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _textController,
                        focusNode: _focusNode,
                        autofocus: true,
                        maxLines: null,
                        decoration: TextInputDecorator.form(
                          'content',
                          'Post something!',
                          isRequired: true,
                        ).copyWith(
                          hintStyle: TextStyle(
                            color: BaseColors.gray3.withOpacity(0.8),
                            fontSize: 22,
                            fontFamily: 'Helvetica',
                            fontWeight: FontWeight.w400,
                          ),
                          counter: const SizedBox.shrink(),
                        ),
                        style: const TextStyle(
                          color: BaseColors.mineShaft,
                          fontSize: 22,
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.w400,
                        ),
                        maxLength: 250,
                        onChanged: (value) => setState(() {
                          _wordCount = value.length;
                        }),
                      ),
                      if (_image != null) ...[
                        const SizedBox(height: 16),
                        ImageBox(
                          image: _image,
                          onDelete: () => setState(() {
                            _image = null;
                          }),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    if (_image != null) {
      return;
    }

    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedImage != null) {
      final fileSizeInBytes = await pickedImage.length();
      final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

      if (fileSizeInMB > 5) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            CustomSnackbar.snackbar(
              message: 'File needs to be less than 5MB',
              icon: LucideIcons.xCircle,
              color: BaseColors.danger,
            ),
          );
      }

      if (!(pickedImage.path.endsWith('.png') ||
          pickedImage.path.endsWith('.jpg') ||
          pickedImage.path.endsWith('.jpeg'))) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            CustomSnackbar.snackbar(
              message: 'Unsupported file type',
              icon: LucideIcons.xCircle,
              color: BaseColors.danger,
            ),
          );
        return;
      }

      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  void _onSubmit() async {
    if (_textController.text.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          CustomSnackbar.snackbar(
            message: 'Content cannot be empty',
            icon: LucideIcons.xCircle,
            color: BaseColors.danger,
          ),
        );
      return;
    }

    final content = _textController.text;
    final image = _image;

    // Hit API
    final res = await addPostUseCase.execute(
      AddPostParams(
        request: request,
        url: Endpoints.addPost,
        content: content,
        image: image,
      ),
    );

    res.fold(
      (left) {
        if (left is GeneralFailure) {
          final msg = left.message!.split(':')[0];
          final error =
              msg.contains('status') ? "Terjadi kesalahan lain!" : msg;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              CustomSnackbar.snackbar(
                message: error,
                icon: LucideIcons.xCircle,
                color: BaseColors.danger,
              ),
            );
        } else {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              CustomSnackbar.snackbar(
                message: 'Terjadi kesalahan lain!',
                icon: LucideIcons.xCircle,
                color: BaseColors.danger,
              ),
            );
        }
      },
      (right) {
        // Update UI
        widget.onReceiveNewPost();

        Navigator.pop(context);
      },
    );
  }
}
