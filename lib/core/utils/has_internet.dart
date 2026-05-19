import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:range_wave/core/utils/custom_toast.dart';

Future<bool> hasInternet({bool showError = false}) async {
  final List<ConnectivityResult> connectivityResult = await Connectivity()
      .checkConnectivity();

  if (connectivityResult.contains(ConnectivityResult.none)) {
    if (showError) _showError();
    return false;
  }

  try {
    final result = await InternetAddress.lookup(
      'google.com',
    ).timeout(const Duration(seconds: 5));

    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    if (showError) _showError();
    return false;
  } on TimeoutException catch (_) {
    if (showError) _showError();
    return false;
  }

  if (showError) _showError();
  return false;
}

void _showError() {
  showCustomToast(
    text:
        'Failed to establish connection, please check your internet connection',
  );
}

// import 'package:connectivity_plus/connectivity_plus.dart';
// import '../core/common_widgets/custom_toast.dart';

// Future<bool> hasInternet({bool showError = false}) async {
//   final List<ConnectivityResult> connectivityResult =
//   await (Connectivity().checkConnectivity());
//   if (connectivityResult.contains(ConnectivityResult.none)) {
//     if (showError) {
//       showCustomToast(
//         text:
//         'Failed to establish connection, please check your internet connection',
//       );
//     }

//     return false;
//   } else {
//     return true;
//   }
// }
