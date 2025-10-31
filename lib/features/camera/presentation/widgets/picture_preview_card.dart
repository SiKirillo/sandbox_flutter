part of '../../camera.dart';

class PicturePreviewCard extends StatefulWidget {
  final File? file;
  final String? bytes;
  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final double height, width;
  final bool isPreviewOnly;

  const PicturePreviewCard({
    super.key,
    this.file,
    this.bytes,
    this.onTap,
    this.onClear,
    this.height = 54.0,
    this.width = 54.0,
    this.isPreviewOnly = false,
  });

  const PicturePreviewCard.file({
    super.key,
    required this.file,
    this.bytes,
    this.onTap,
    this.onClear,
    this.height = 54.0,
    this.width = 54.0,
    this.isPreviewOnly = false,
  });

  const PicturePreviewCard.bytes({
    super.key,
    this.file,
    required this.bytes,
    this.onTap,
    this.onClear,
    this.height = 54.0,
    this.width = 54.0,
    this.isPreviewOnly = false,
  });

  @override
  State<PicturePreviewCard> createState() => _PicturePreviewCardState();
}

class _PicturePreviewCardState extends State<PicturePreviewCard> {
  File? _generatedFile;
  File? get image => _generatedFile ?? widget.file;

  @override
  void initState() {
    super.initState();
    if (widget.bytes != null) {
      locator<CameraRepository>().generateFileFromBytes(widget.bytes!).then((result) {
        setState(() {
          _generatedFile = result;
        });
      });
    }
  }

  Widget _buildImagePlaceholder() {
    if (image != null) {
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(11.0)),
        child: Image.file(
          image!,
          fit: BoxFit.fill,
        ),
      );
    }

    if (widget.isPreviewOnly) {
      return Container();
    }

    return Padding(
      padding: EdgeInsets.all(11.0),
      child: Container(),
      // child: SvgPicture.asset(
      //   ImageConstants.icAddItemButton,
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              color: ColorConstants.cameraPictureCardBG(),
              borderRadius: BorderRadius.circular(12.0),
              border: !widget.isPreviewOnly ? Border.all(
                color: ColorConstants.cameraPictureCardBorder(),
              ) : null,
            ),
            child: _buildImagePlaceholder(),
          ),
        ),
        if (image != null && widget.onClear != null)
          Positioned(
            top: -4.0,
            right: -4.0,
            child: InkWell(
              onTap: widget.onClear!,
              child: Container(),
              // child: SvgPicture.asset(
              //   ImageConstants.icClearPhoto,
              // ),
            ),
          ),
      ],
    );
  }
}
