import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vehicle_base/src/make/make_list_view.dart';
import 'package:vehicle_base/src/models/model_list_view.dart';
import 'package:vehicle_base/src/vehicles/vehicle_list_view.dart';

import 'sample_feature/sample_item_details_view.dart';
import 'sample_feature/sample_item_list_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // TODO(omkartapale): [ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: This widget has been unmounted, so the State no longer has a context (and should be considered defunct).
          // Consider canceling any active work during "dispose" or using the "mounted" getter to determine if the State is still active.
          // initialRoute: '/home',
          initialRoute: '/login',

          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(
              useMaterial3: true, textTheme: GoogleFonts.poppinsTextTheme()),
          darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
              textTheme: GoogleFonts.poppinsTextTheme(
                  ThemeData(brightness: Brightness.dark).textTheme)),
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case MakeListView.routeName:
                    return const MakeListView();
                  case ModelListView.routeName:
                    return const ModelListView();
                  case SampleItemDetailsView.routeName:
                    return const SampleItemDetailsView();
                  case SampleItemListView.routeName:
                    return const SampleItemListView();
                  case VehicleListView.routeName:
                    return const VehicleListView();
                  case '/forgot-password':
                    {
                      final arguments = ModalRoute.of(context)
                          ?.settings
                          .arguments as Map<String, dynamic>?;

                      return ForgotPasswordScreen(
                        email: arguments?['email'] as String,
                        headerMaxExtent: 200,
                      );
                    }
                  case '/profile':
                    return ProfileScreen(
                      providers: const [],
                      appBar: AppBar(
                        title: const Text('User Profile'),
                      ),
                      actions: [
                        SignedOutAction(
                          ((context) {
                            Navigator.of(context)
                                .popUntil(ModalRoute.withName('/login'));
                          }),
                        ),
                        // SignedOutAction((context) {
                        //   Navigator.of(context).pushReplacementNamed('/login');
                        // }),
                      ],
                    );
                  case '/verify-email':
                    {
                      return EmailVerificationScreen(
                        headerBuilder: (context, constraints, shrinkOffset) {
                          return Padding(
                            padding: const EdgeInsets.all(20).copyWith(top: 40),
                            child: Icon(
                              Icons.verified,
                              color: Theme.of(context).colorScheme.primary,
                              size:
                                  constraints.maxWidth / 4 * (1 - shrinkOffset),
                            ),
                          );
                        },
                        sideBuilder: (context, constraints) {
                          return Padding(
                            padding: const EdgeInsets.all(20),
                            child: Icon(
                              Icons.verified,
                              color: Theme.of(context).colorScheme.primary,
                              size: constraints.maxWidth / 3,
                            ),
                          );
                        },
                        // actionCodeSettings: actionCodeSettings,
                        actions: [
                          EmailVerifiedAction(() {
                            Navigator.pushReplacementNamed(context, '/profile');
                          }),
                          AuthCancelledAction((context) {
                            FirebaseUIAuth.signOut(context: context);
                            Navigator.pushReplacementNamed(context, '/');
                          }),
                        ],
                      );
                    }
                  case '/login':
                  default:
                    {
                      return SignInScreen(
                        showPasswordVisibilityToggle: true,
                        showAuthActionSwitch: false,
                        // styles: const {
                        //   EmailFormStyle(
                        //       signInButtonVariant: ButtonVariant.filled),
                        // },
                        actions: [
                          ForgotPasswordAction(
                            ((context, email) {
                              Navigator.of(context).pushNamed(
                                  '/forgot-password',
                                  arguments: {'email': email});
                            }),
                          ),
                          AuthStateChangeAction(
                            ((context, state) {
                              // final user = switch (state) {
                              //   SignedIn(user: final user) => user,
                              //   CredentialLinked(user: final user) => user,
                              //   UserCreated(credential: final cred) => cred.user,
                              //   _ => null,
                              // };

                              // switch (user) {
                              //   case User(emailVerified: true):
                              //     Navigator.pushReplacementNamed(context, '/profile');
                              //   case User(emailVerified: false, email: final String _):
                              //     Navigator.pushNamed(context, '/verify-email');
                              // }

                              if (state is UserCreated || state is SignedIn) {
                                var user = (state is SignedIn)
                                    ? state.user
                                    : (state as UserCreated).credential.user;
                                if (user == null) {
                                  return;
                                }

                                if (state is UserCreated) {
                                  if (user.displayName == null &&
                                      user.email != null) {
                                    var defaultDisplayName =
                                        user.email!.split('@')[0];
                                    user.updateDisplayName(defaultDisplayName);
                                  }
                                }

                                if (!user.emailVerified) {
                                  user.sendEmailVerification();
                                  debugPrint('Account Verification email sent');
                                  Navigator.pushNamed(context, '/verify-email');
                                } else {
                                  Navigator.pushReplacementNamed(
                                      context, '/home');
                                }
                                // if (!user.emailVerified &&
                                //     (state is UserCreated)) {
                                //   user.sendEmailVerification();
                                //   debugPrint('Account Verification email sent');
                                // }

                                // Navigator.of(context).pushNamedAndRemoveUntil(
                                //     '/home', ((route) => false));
                              }
                            }),
                          ),
                        ],
                        headerBuilder: (context, constraints, shrinkOffset) {
                          return Padding(
                            padding: const EdgeInsets.all(20).copyWith(top: 40),
                            child: Icon(
                              Icons.data_exploration_outlined,
                              color: Theme.of(context).colorScheme.primary,
                              size:
                                  constraints.maxWidth / 4 * (1 - shrinkOffset),
                            ),
                          );
                        },
                        sideBuilder: (context, constraints) {
                          return Padding(
                            padding: const EdgeInsets.all(20),
                            child: Icon(
                              Icons.data_exploration_outlined,
                              color: Theme.of(context).colorScheme.primary,
                              size: constraints.maxWidth / 3,
                            ),
                          );
                        },
                        subtitleBuilder: (context, action) {
                          final actionText = switch (action) {
                            AuthAction.signIn => 'Please sign in to continue.',
                            AuthAction.signUp =>
                              'Please create an account to continue',
                            _ => throw Exception('Invalid action: $action'),
                          };

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                                'Welcome to Indian Vehicles Base Dataset!\n$actionText.'),
                          );
                        },
                        footerBuilder: (context, action) {
                          final actionText = switch (action) {
                            AuthAction.signIn => 'signing in',
                            AuthAction.signUp => 'registering',
                            _ => throw Exception('Invalid action: $action'),
                          };

                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Text(
                                'By $actionText, you agree to our terms and conditions.',
                                style: TextStyle(
                                    color: Theme.of(context).hintColor),
                              ),
                            ),
                          );
                        },
                      );
                    }
                }
              },
            );
          },
        );
      },
    );
  }
}
