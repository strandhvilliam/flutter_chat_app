import 'profile/profile.dart';
import 'form/form.dart';
import 'home/home.dart';

var appRoutes = {
  '/': (context) => const HomeScreen(),
  '/form': (context) => const FormScreen(),
  '/profile': (context) => const ProfileScreen(),
};
