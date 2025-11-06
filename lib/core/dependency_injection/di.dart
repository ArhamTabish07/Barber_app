import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:barber_app/data/datasource/user_remote_data_source.dart';
import 'package:barber_app/data/datasource/booking_remote_data_soure.dart';
import 'package:barber_app/data/repo_impl/user_repo_impl.dart';
import 'package:barber_app/data/repo_impl/booking_repo_impl.dart';
import 'package:barber_app/data/services/database.dart';

import 'package:barber_app/provider/auth_provider.dart';
import 'package:barber_app/provider/user_provider.dart';
import 'package:barber_app/provider/booking_provider.dart';

final i = GetIt.instance;

Future<void> instance() async {
  i.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  i.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // ---- Data sources ----
  i.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSource(auth: i(), firestore: i()),
  );

  i.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSource(firestore: i()),
  );

  i.registerLazySingleton<Database>(() => Database());

  // ---- Repositories (impl types jo tum already use kar rahe ho) ----
  i.registerLazySingleton<UserRepositoryImpl>(
    () => UserRepositoryImpl(remote: i()),
  );

  i.registerLazySingleton<BookingRepositoryImpl>(
    () => BookingRepositoryImpl(remote: i()),
  );

  // ---- Providers (ChangeNotifiers) as factories ----
  i.registerFactory<AuthenticationProvider>(
    () => AuthenticationProvider(userRepo: i()),
  );

  i.registerFactory<UserProvider>(() => UserProvider(repo: i()));

  i.registerFactory<BookingProvider>(() => BookingProvider(repo: i()));
}
