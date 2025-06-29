import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/config/router/app_router_notifiaer.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/auth/presentation/providers/providers.dart';
import 'package:teslo_shop/features/products/products.dart';

final goRouterProvider = Provider((ref) {
  final goRounterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRounterNotifier,
    routes: [
      ///* Auth Routes
      ///
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatus(),
      ),

      ///
      ///
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ///* Product Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductsScreen(),
      ),
    ],

    redirect:(context, state) {
      final isGoingTo = state.subloc;
      final autStatus = goRounterNotifier.authStatus;

      if(isGoingTo == '/splash' && autStatus == AuthStatus.checking) return null;
      
      if( autStatus == AuthStatus.notAuthenticated){
        if(isGoingTo == '/' || isGoingTo == '/register') return null;
        return '/login';
      }
      if( autStatus == AuthStatus.authenticated){
        if(isGoingTo == '/login' || isGoingTo == '/register' || isGoingTo == '/splash') return '/';
        
      }
      return null;

    },
  );
});
