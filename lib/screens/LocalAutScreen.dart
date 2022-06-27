import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:strapit/screens/AdminDashoardScreen.dart';
import 'package:strapit/screens/CustmerDashoardScreen.dart';
import 'package:strapit/utils/ShExtension.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class LocalAutScreen extends StatefulWidget {
  static String tag='/LocalAutScreen';

  const LocalAutScreen({Key? key}) : super(key: key);

  @override
  _LocalAutScreenState createState() => _LocalAutScreenState();
}

class _LocalAutScreenState extends State<LocalAutScreen> {
  final LocalAuthentication auth = LocalAuthentication();

  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _authenticate();
    // disableCapture();
    checkauth();
  }

  void checkauth() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();

    final List<BiometricType> availableBiometrics =
    await auth.getAvailableBiometrics();

    // if (availableBiometrics.isNotEmpty) {
    //   // Some biometrics are enrolled.
    //   toast("true");
    // }else{
    //   toast("false");
    // }

    try {
      final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to show account balance');
      toast(didAuthenticate.toString());
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        // Add handling of no hardware here.
        toast(e.code.toString());
      } else if (e.code == auth_error.notEnrolled) {
        // ...
        toast(e.code.toString());
      } else {
        toast(e.code.toString());
        // ...
      }
    }
    // toast(canAuthenticateWithBiometrics.toString());

  }


  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
          localizedReason: 'Let OS determine authentication method',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = "Error - ${e.message}";
      });
      return;
    }
    if (!mounted) return;


if(authenticated){
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(prefs.getInt('IsAdmin')==1){
    launchScreen(context, AdminDashoardScreen.tag);
  }else{
    launchScreen(context, CustmerDashoardScreen.tag);
  }

}else{
  setState(
          () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
}

  }

  void _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }
//flutterant - Biometric Authentication

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Container(
      height: height,
      width: width,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Current State: $_authorized\n'),
            (_isAuthenticating)
                ? ElevatedButton(
              onPressed: _cancelAuthentication,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Cancel Authentication"),
                  Icon(Icons.cancel),
                ],
              ),
            )
                : Column(
              children: [
                ElevatedButton(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Authenticate'),
                      Icon(Icons.fingerprint),
                    ],
                  ),
                  onPressed: _authenticate,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
