import 'package:dartz/dartz.dart';

import 'service/failure_model.dart';

class InAppFailureData {
  final Future<Either<Failure, dynamic>> Function() onError;
  final bool isImportant;

  const InAppFailureData({
    required this.onError,
    this.isImportant = false,
  });
}
