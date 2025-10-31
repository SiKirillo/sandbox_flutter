part of '../../camera.dart';

class CameraPicturePreviewScreen extends StatefulWidget {
  static const routePath = '/camera/preview';

  final CameraPreviewEntity data;

  const CameraPicturePreviewScreen({
    super.key,
    required this.data,
  });

  @override
  State<CameraPicturePreviewScreen> createState() => _CameraPicturePreviewScreenState();
}

class _CameraPicturePreviewScreenState extends State<CameraPicturePreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      appBar: CustomAppBar(
        content: widget.data.title,
        options: CustomAppBarOptions(
          contentPadding: EdgeInsets.fromLTRB(12.0, 0.0, 36.0, 0.0),
          contentStyle: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
            color: ColorConstants.textWhite(),
          ),
          backgroundColor: ColorConstants.cameraPreviewBG(),
          iconColor: ColorConstants.textWhite(),
        ),
      ),
      options: ScaffoldWrapperOptions(
        backgroundColor: ColorConstants.cameraBG(),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              maxScale: 5.0,
              minScale: 1.0,
              child: widget.data.image,
            ),
          ),
        ],
      ),
    );
  }
}
