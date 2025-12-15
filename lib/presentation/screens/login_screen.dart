import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/utils/validators.dart';
import 'device_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiKeyController = TextEditingController();
  final _refreshTokenController = TextEditingController();
  bool _obscureRefreshToken = true;

  @override
  void dispose() {
    _apiKeyController.dispose();
    _refreshTokenController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() != true) return;
    // Skip authentication; just navigate when user clicks Login
    if (_formKey.currentState?.validate() != true) return;
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const DeviceListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.08),
                  Theme.of(context).colorScheme.surface,
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 28.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 8),
                              CircleAvatar(
                                radius: 36,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.12),
                                child: Icon(
                                  Icons.air,
                                  size: 40,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Atomberg Fan Controller',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Enter your credentials to continue',
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),

                              // API Key Field
                              TextFormField(
                                controller: _apiKeyController,
                                autofocus: true,
                                decoration: InputDecoration(
                                  labelText: 'API Key',
                                  hintText: 'Enter your API key',
                                  prefixIcon: const Icon(Icons.key),
                                  suffixIcon: Tooltip(
                                    message: 'Paste from clipboard',
                                    child: IconButton(
                                      icon: const Icon(Icons.paste),
                                      onPressed: () async {
                                        final data = await Clipboard.getData(
                                            Clipboard.kTextPlain);
                                        final text = data?.text ?? '';
                                        if (text.isNotEmpty) {
                                          _apiKeyController.text = text.trim();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                validator: Validators.validateApiKey,
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 16),

                              // Refresh Token Field
                              TextFormField(
                                controller: _refreshTokenController,
                                decoration: InputDecoration(
                                  labelText: 'Refresh Token',
                                  hintText: 'Enter your refresh token',
                                  prefixIcon: const Icon(Icons.vpn_key),
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          _obscureRefreshToken
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                        tooltip: _obscureRefreshToken
                                            ? 'Show'
                                            : 'Hide',
                                        onPressed: () {
                                          setState(() {
                                            _obscureRefreshToken =
                                                !_obscureRefreshToken;
                                          });
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.paste),
                                        tooltip: 'Paste from clipboard',
                                        onPressed: () async {
                                          final data = await Clipboard.getData(
                                              Clipboard.kTextPlain);
                                          final text = data?.text ?? '';
                                          if (text.isNotEmpty) {
                                            _refreshTokenController.text =
                                                text.trim();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                obscureText: _obscureRefreshToken,
                                validator: Validators.validateRefreshToken,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _login(),
                              ),
                              const SizedBox(height: 20),

                              // Login Button (no auth, direct navigate)
                              SizedBox(
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: _login,
                                  child: const Text('Login'),
                                ),
                              ),

                              // No error block when bypassing auth
                              const SizedBox.shrink(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )));
  }
}
