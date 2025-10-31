part of 'logger_service.dart';

class LoggerScreen extends StatefulWidget {
  static const routePath = '/logger';

  const LoggerScreen({super.key});

  static Widget button(VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConstants.loggerButton(),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.loggerButtonShadow(),
            blurRadius: 6.0,
          ),
        ],
        shape: BoxShape.circle,
      ),
      child: CustomIconButton(
        content: Icon(
          Icons.settings,
          color: ColorConstants.loggerButtonContent(),
        ),
        onTap: onTap,
        options: CustomButtonOptions(
          size: 40.0,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }

  @override
  State<LoggerScreen> createState() => _LoggerScreenState();
}

class _LoggerScreenState extends State<LoggerScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      locator<LoggerProvider>()._open();
    });
  }

  @override
  void dispose() {
    Future.delayed(Duration.zero).then((_) {
      locator<LoggerProvider>()._close();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Color(0xFF212121),
        ),
      ),
      child: TalkerScreen(
        talker: LoggerService.talker,
        theme: TalkerScreenTheme(
          logColors: {
            /// Common
            _ErrorLog.logKey: _ErrorLog.logColor,
            _WarningLog.logKey: _WarningLog.logColor,
            _SuccessLog.logKey: _SuccessLog.logColor,
            _InfoLog.logKey: _InfoLog.logColor,
            _TraceLog.logKey: _TraceLog.logColor,
            /// Navigation
            _TalkerRouteLog.logKey: _TalkerRouteLog.logColor,
            /// Dio
            _DioRequestLog.logKey: _DioRequestLog.logColor,
            _DioResponseLog.logKey: _DioResponseLog.logColor,
            _DioErrorLog.logKey: _DioErrorLog.logColor,
            /// Bloc
            _BlocEventLog.logKey: _BlocEventLog.logColor,
            _BlocStateLog.logKey: _BlocStateLog.logColor,
            _BlocChangeLog.logKey: _BlocChangeLog.logColor,
            _BlocErrorLog.logKey: _BlocErrorLog.logColor,
            _BlocCreateLog.logKey: _BlocCreateLog.logColor,
            _BlocCloseLog.logKey: _BlocCloseLog.logColor,
          },
        ),
      ),
    );
  }
}
