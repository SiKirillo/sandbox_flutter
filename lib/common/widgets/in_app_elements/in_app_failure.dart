import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sandbox_flutter/common/models/in_app_failure_model.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../injection_container.dart';
import '../../bloc/core_bloc.dart';
import '../../usecases/core_update_in_app_failure.dart';
import '../app_bar.dart';
import '../buttons/text_button.dart';
import '../texts.dart';
import '../wrappers/opacity_wrapper.dart';

class InAppFailureBackground extends StatefulWidget {
  const InAppFailureBackground({Key? key}) : super(key: key);

  static const animationDuration = Duration(milliseconds: 400);

  @override
  State<InAppFailureBackground> createState() => _InAppFailureBackgroundState();
}

class _InAppFailureBackgroundState extends State<InAppFailureBackground> {
  bool _isRequestInProgress = false;

  void _onGoBackHandler() {
    locator<CoreUpdateInAppFailure>().call(null);
  }

  Future<void> _onTryAgainHandler(InAppFailureData? failure) async {
    if (_isRequestInProgress || failure?.onError == null) {
      return;
    }

    setState(() {
      _isRequestInProgress = true;
    });

    final response = await failure!.onError();
    response.fold(
      (failure) => null,
      (result) {
        locator<CoreUpdateInAppFailure>().call(null);
      },
    );

    setState(() {
      _isRequestInProgress = false;
    });
  }

  Widget _buildFailureWidget(InAppFailureData failure) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OpacityWrapper(
          isOpaque: _isRequestInProgress,
          child: Column(
            children: [
              const SizedBox(
                height: 112.0,
                child: Icon(Icons.add),
              ),
              const SizedBox(
                height: 12.0,
              ),
              SandboxText(
                text: 'Random',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: ColorConstants.light.white500,
                ),
              ),
              const SizedBox(
                height: 6.0,
              ),
              SandboxText(
                text: 'Random',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ColorConstants.light.black400.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 24.0,
        ),
        SandboxTextButton(
          content: 'Try again',
          onCallback: () => _onTryAgainHandler(failure),
          height: 40.0,
          padding: const EdgeInsets.symmetric(
            vertical: SizeConstants.defaultPadding * 0.5,
            horizontal: SizeConstants.defaultPadding * 2.0,
          ),
          isSlim: true,
          isProcessing: _isRequestInProgress,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoreBloc, CoreState>(
      buildWhen: (prev, current) {
        return prev.inAppFailureData != current.inAppFailureData;
      },
      builder: (_, state) {
        return AnimatedSwitcher(
            duration: InAppFailureBackground.animationDuration,
            child: state.inAppFailureData == null
                ? null
                : DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (state.inAppFailureData?.isImportant == false)
                        SafeArea(
                          child: SandboxAppBar(
                            onBackCallback: _onGoBackHandler,
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 60.0,
                          horizontal: SizeConstants.isSmallDevice() ? 60.0 : 80.0,
                        ),
                        child: _buildFailureWidget(state.inAppFailureData!),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
