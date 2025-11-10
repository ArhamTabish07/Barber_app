import 'package:barber_app/core/services/navigation_service.dart';
import 'package:barber_app/features/booking/domain/booking_repo.dart';
import 'package:barber_app/features/home/user/domain/user_repo.dart';
import 'package:get_it/get_it.dart';

import 'package:barber_app/features/home/user/data/user_remote_data_source.dart';
import 'package:barber_app/features/booking/data/booking_remote_data_soure.dart';
import 'package:barber_app/features/home/user/data/user_repo_impl.dart';
import 'package:barber_app/features/booking/data/booking_repo_impl.dart';

import 'package:barber_app/features/auth/provider/auth_provider.dart';
import 'package:barber_app/features/home/user/provider/user_provider.dart';
import 'package:barber_app/features/booking/provider/booking_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class DI {
  static GetIt i = GetIt.instance;
  static void instance() {
    // ---- Data sources ----
    i.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSource());

    i.registerLazySingleton<BookingRemoteDataSource>(
      () => BookingRemoteDataSource(),
    );

    // i.registerLazySingleton<Database>(() => Database());

    // ---- Repositories and Services ----
    i.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(remote: i()),
    );

    i.registerLazySingleton<BookingRepository>(
      () => BookingRepositoryImpl(remote: i()),
    );
    i.registerLazySingleton<NavigationService>(() => NavigationService());
    // ---- Providers ----
    i.registerLazySingleton<AuthenticationProvider>(
      () => AuthenticationProvider(userRepo: i<UserRepository>()),
    );

    i.registerLazySingleton<UserProvider>(() => UserProvider(repo: i()));

    i.registerLazySingleton<BookingProvider>(() => BookingProvider(repo: i()));
  }
}

//============= APP PROVIDER =============//
class AppProviders {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => DI.i<AuthenticationProvider>()),
    ChangeNotifierProvider(create: (_) => DI.i<UserProvider>()),
    ChangeNotifierProvider(create: (_) => DI.i<BookingProvider>()),
  ];
}
