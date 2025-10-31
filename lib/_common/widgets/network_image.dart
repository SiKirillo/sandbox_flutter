part of '../common.dart';

typedef CustomNetworkImageCallback = Future<dartz.Either<Failure, File>> Function();

class CustomNetworkImage extends StatefulWidget {
  final CustomNetworkImageCallback onRequest;
  final Function(File?, Size)? onFinish;
  final double? height, width;
  final BoxConstraints? constraints;
  final double placeholderHeight, placeholderWidth;
  final BorderRadiusGeometry borderRadius;
  final BoxFit? fit;

  const CustomNetworkImage({
    super.key,
    required this.onRequest,
    this.onFinish,
    this.height,
    this.width,
    this.constraints,
    this.placeholderHeight = 54.0,
    this.placeholderWidth = 54.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(10.0)),
    this.fit = BoxFit.contain,
  });

  @override
  State<CustomNetworkImage> createState() => _CustomNetworkImageState();
}

class _CustomNetworkImageState extends State<CustomNetworkImage> {
  File? _image;
  Failure? _failure;

  @override
  void initState() {
    super.initState();
    widget.onRequest().then((response) {
      return response.fold(
        (failure) {
          if (mounted) {
            setState(() {
              _failure = failure;
            });
          }

          if (widget.onFinish != null) {
            widget.onFinish!(null, Size(widget.placeholderWidth, widget.placeholderHeight));
          }
        },
        (result) {
          if (mounted) {
            setState(() {
              _image = result;
            });
          }

          if (widget.onFinish != null) {
            decodeImageFromList(result.readAsBytesSync()).then((result) {
              widget.onFinish!(_image, Size(result.width.toDouble(), result.height.toDouble()));
            });
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_image != null) {
      return ClipRRect(
        borderRadius: widget.borderRadius,
        child: Container(
          constraints: widget.constraints,
          child: Image.file(
            _image!,
            errorBuilder: (_, error, stacktrace) {
              return Container(
                height: widget.placeholderHeight,
                width: widget.placeholderWidth,
                decoration: BoxDecoration(
                  borderRadius: widget.borderRadius,
                ),
              );
            },
            height: widget.height,
            width: widget.width,
            fit: widget.fit,
          ),
        ),
      );
    }

    return SizedBox(
      height: widget.placeholderHeight,
      width: widget.placeholderWidth,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: widget.placeholderHeight,
            width: widget.placeholderWidth,
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
            ),
          ),
          if (_image == null && _failure == null)
            Center(
              child: CustomProgressIndicator.simple(
                size: math.max(widget.placeholderWidth * 0.3, 20.0),
              ),
            ),
        ],
      ),
    );
  }
}
