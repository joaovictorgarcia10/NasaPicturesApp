import 'package:flutter/material.dart';

typedef WidgetBuilderArgs = Widget Function(BuildContext context, Object? args);

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
