import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/utils/globals.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_verify_otp_request_model.dart';

class MultifactorTestScreen extends StatefulWidget {
  const MultifactorTestScreen({super.key});

  @override
  State<MultifactorTestScreen> createState() => _MultifactorTestScreenState();
}

class _MultifactorTestScreenState extends State<MultifactorTestScreen> {
  // Multifacotr Verify Test Function
  final _mfaTokenController = TextEditingController();
  final _otpController = TextEditingController();
  final _challengeMfaTokenController = TextEditingController();

  final _clientIdController = TextEditingController();
  final _otpCodeController = TextEditingController();
  final _realmController = TextEditingController(text: 'email');
  final _usernameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  String? _challengeResult;
  bool _challengeLoading = false;

  String? _result;
  bool _isLoading = false;

  String multifactorVerifyResponse = '';
  String multifactorVerifyResponseError = '';

  void multifactorVerifyTest() async {
    setState(() {
      multifactorVerifyResponse = 'Loading...';
    });
    final client = AortemAuth0MultiFactorService(
      auth0DomainUri: Uri.parse(AUTH0_DOMAIN),
    );

    // Construct the MFA verification request with the MFA token and the OTP provided by the user.
    final request = AortemAuth0MultiFactorVerifyRequest(
      mfaToken: MFA_TOKEN,
      otp: '123456', // The one-time password entered by the user.
    );

    try {
      final response = await client.verify(request);
      if (kDebugMode) {
        print('MFA Verified Successfully!');
        print('Access Token: ${response.accessToken}');
        print('ID Token: ${response.idToken}');
        if (response.refreshToken != null) {
          print('Refresh Token: ${response.refreshToken}');
        }
        print('Token Type: ${response.tokenType}');
        if (response.expiresIn != null) {
          print('Expires In: ${response.expiresIn} seconds');
        }
      }
      multifactorVerifyResponse =
          'MFA Verified Successfully! \n Access Token: ${response.accessToken} \n ID Token: ${response.idToken} \n Refresh Token: ${response.refreshToken} \n Token Type: ${response.tokenType} \n Expires In: ${response.expiresIn} seconds';
    } catch (e) {
      if (kDebugMode) {
        print('Error verifying MFA: $e');
      }
      multifactorVerifyResponseError = '$e';
    }

    setState(() {});
  }

  Future<void> _verifyMfa() async {
    setState(() {
      _result = null;
      _isLoading = true;
    });

    final client = AortemAuth0MultiFactorService(
      auth0DomainUri: Uri.parse(AUTH0_DOMAIN),
    );

    final mfaToken = _mfaTokenController.text.trim();
    final otp = _otpController.text.trim();

    try {
      final request = AortemAuth0MultiFactorVerifyRequest(
        mfaToken: mfaToken,
        otp: otp,
      );
      final response = await client.verify(request);

      _result = '''
            ✅ MFA Verified Successfully!

            🔐 Access Token: ${response.accessToken}
            🆔 ID Token: ${response.idToken}
            🔄 Refresh Token: ${response.refreshToken ?? 'N/A'}
            📛 Token Type: ${response.tokenType}
            ⏱️ Expires In: ${response.expiresIn ?? 'N/A'} seconds
            ''';
    } catch (e) {
      _result = '❌ Error verifying MFA:\n$e';
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _requestNewChallenge() async {
    setState(() {
      _challengeResult = null;
      _challengeLoading = true;
    });

    final mfaToken = _challengeMfaTokenController.text.trim();
    if (mfaToken.isEmpty) {
      setState(() {
        _challengeResult =
            '❌ MFA Token is required to request a new challenge.';
        _challengeLoading = false;
      });
      return;
    }
    final client = AortemAuthOMultifactorChallengeRequest(
      auth0Domain: AUTH0_DOMAIN,
    );
    try {
      final request = AortemAuth0ChallengeRequest(
        mfaToken: mfaToken,
        challengeType: 'otp', // optional
      );

      final response = await client.requestChallenge(request);

      _challengeResult = '''
          📨 New MFA Challenge Requested

          🆔 Challenge ID: ${response.challengeId}
          ⏱️ Expires In: ${response.expiresIn ?? 'N/A'} seconds
          💬 Message: ${response.message ?? 'No message returned'}
          ''';
    } catch (e) {
      _challengeResult = '❌ Failed to request new challenge:\n$e';
    }

    setState(() {
      _challengeLoading = false;
    });
  }

  Future<void> _verifyPasswordlessOTP() async {
    setState(() => _isLoading = true);

    try {
      final otpService = AortemAuth0MfaVerifyOpt(auth0Domain: AUTH0_DOMAIN);
      if (_clientIdController.text.trim().isEmpty ||
          _otpCodeController.text.trim().isEmpty ||
          (_realmController.text == 'email' &&
              _usernameController.text.trim().isEmpty) ||
          (_realmController.text == 'sms' &&
              _phoneNumberController.text.trim().isEmpty)) {
        setState(() {
          _result = '❌ Please fill in all required fields.';
          _isLoading = false;
        });
        return;
      }

      final request = AortemAuth0VerifyOTPRequest(
        clientId: _clientIdController.text.trim(),
        otp: _otpCodeController.text.trim(),
        realm: _realmController.text.trim(),
        username: _realmController.text == 'email'
            ? _usernameController.text.trim()
            : null,
        phoneNumber: _realmController.text == 'sms'
            ? _phoneNumberController.text.trim()
            : null,
      );
      final response = await otpService.verifyOTP(request);

      setState(() {
        _result = '''
        ✅ OTP Verified Successfully!

        🔐 Access Token: ${response.accessToken}
        🆔 ID Token: ${response.idToken}
        🔄 Refresh Token: ${response.refreshToken ?? 'N/A'}
        📛 Token Type: ${response.tokenType}
        ⏱️ Expires In: ${response.expiresIn ?? 'N/A'} seconds
        ''';
      });
    } catch (e) {
      setState(() {
        _result = '❌ OTP verification failed:\n$e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Multifactor Verification Test')),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Multifactor Verify widgets
              TextButton(
                onPressed: () {
                  multifactorVerifyTest();
                },
                child: const Text('Multifactor Verify Test'),
              ),
              Text(multifactorVerifyResponse),
              Text(multifactorVerifyResponseError),
              SizedBox(height: 20),
              const Text(
                'Enter MFA Token and OTP to verify MFA',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _mfaTokenController,
                decoration: const InputDecoration(labelText: 'MFA Token'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _otpController,
                decoration: const InputDecoration(
                  labelText: 'One-Time Password (OTP)',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _verifyMfa,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Verify MFA'),
              ),
              const SizedBox(height: 20),
              if (_result != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _result!.startsWith('✅')
                        ? Colors.green[50]
                        : Colors.red[50],
                    border: Border.all(
                      color:
                          _result!.startsWith('✅') ? Colors.green : Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_result!),
                ),

              const SizedBox(height: 40),
              const Text(
                'Request New MFA Challenge',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _challengeMfaTokenController,
                decoration: const InputDecoration(labelText: 'MFA Token'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _challengeLoading ? null : _requestNewChallenge,
                child: _challengeLoading
                    ? const CircularProgressIndicator()
                    : const Text('Request New Challenge'),
              ),
              const SizedBox(height: 20),
              if (_challengeResult != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _challengeResult!.startsWith('📨')
                        ? Colors.blue[50]
                        : Colors.red[50],
                    border: Border.all(
                      color: _challengeResult!.startsWith('📨')
                          ? Colors.blue
                          : Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_challengeResult!),
                ),
              const SizedBox(height: 40),
              const Text('Verify Passwordless OTP',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                  controller: _clientIdController,
                  decoration: InputDecoration(labelText: 'Client ID')),
              TextField(
                  controller: _otpCodeController,
                  decoration: InputDecoration(labelText: 'OTP Code')),
              DropdownButtonFormField<String>(
                value: _realmController.text,
                decoration: InputDecoration(labelText: 'Realm'),
                items: const ['email', 'sms']
                    .map((type) =>
                        DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (val) {
                  _realmController.text = val!;
                  setState(() {});
                },
              ),
              if (_realmController.text == 'email')
                TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: 'Email')),
              if (_realmController.text == 'sms')
                TextField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(labelText: 'Phone Number')),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _isLoading ? null : _verifyPasswordlessOTP,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Verify OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
