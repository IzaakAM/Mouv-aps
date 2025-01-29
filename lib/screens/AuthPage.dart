import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mouv_aps/services/api_service.dart';
import 'package:mouv_aps/services/secure_storage_service.dart';
import 'package:mouv_aps/widgets/PagesView.dart';
import 'package:mouv_aps/widgets/custom_input_field.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool isLogin = true;

  @override
  void initState() {
    super.initState();
    _checkIfUserIsLoggedIn();
  }

  Future<void> _checkIfUserIsLoggedIn() async {
    bool authed = await SecureStorageService().checkAuth();
    if (authed) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PagesView()),
      );
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;
      String username = _usernameController.text;

      try {
        Map<String, dynamic> response;

        if (isLogin) {
          response = await ApiService.requestToken(username, password);
        } else {
          response = await ApiService.register(username, email, password);
        }

        // Assuming the response contains a JWT token
        try {
          String access_token = response['access'];
          String refresh_token = response['refresh'];
          await SecureStorageService().save('jwt_access', access_token);
          await SecureStorageService().save('jwt_refresh', refresh_token);

          // Handle successful response
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Authentifié!')),
          );

          // Navigate to the home page or dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PagesView()),
          );
        } catch (e) {
          // Handle error response
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } catch (e) {
        // Handle exceptions
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _continueAsGuest() async {
    try {
      Map<String, dynamic> response;
      response = await ApiService.requestGuestToken();
      String access_token = response['access'];
      String refresh_token = response['refresh'];
      await SecureStorageService().save('jwt_access', access_token);
      await SecureStorageService().save('jwt_refresh', refresh_token);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PagesView()),
      );
    }
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isLogin ? 'Connexion' : 'S\'enregistrer',
          style: GoogleFonts.oswald(
            fontSize: 30,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomInputField(
                      labelText: 'Nom d\'utilisateur',
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre nom d\'utilisateur';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _usernameController.text = value!;
                      },
                    ),
                    if (!isLogin)
                      CustomInputField(
                        labelText: 'Email',
                        keyboardType: TextInputType.text,
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre adresse mail';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _emailController.text = value!;
                        },
                      ),
                    CustomInputField(
                      labelText: 'Mot de passe',
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre mot de passe';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _passwordController.text = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: Text(isLogin ? 'Connexion' : 'Créer un compte'),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(isLogin
                          ? 'Pas encore de compte? Créer un compte'
                          : 'Déjà un compte? Se connecter'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _continueAsGuest,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black12,
              ),
              child: const Text('Continuer en tant qu\'invité'),
            ),
          ],
        ),
      ),
    );
  }
}
