import 'package:vpn_connection_detector/vpn_connection_detector.dart';

Future<bool> vpnDetector() async {
  bool isConnected = await VpnConnectionDetector.isVpnActive();
  return isConnected;
}