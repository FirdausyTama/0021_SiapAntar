import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siapantar/data/repository/auth_repository.dart';
import 'package:siapantar/data/repository/pemesanan_repository.dart';
import 'package:siapantar/data/repository/profile_admin_repository.dart';
import 'package:siapantar/data/repository/profile_buyer_repository.dart';
import 'package:siapantar/data/repository/sopir_repository.dart';
import 'package:siapantar/presentation/admin/profile/bloc/add_profile/add_profile_bloc.dart';
import 'package:siapantar/presentation/admin/profile/bloc/get_profile/get_profile_bloc.dart';
import 'package:siapantar/presentation/admin/sopir/bloc/sopir_bloc.dart';
import 'package:siapantar/presentation/auth/bloc/login/login_bloc.dart';
import 'package:siapantar/presentation/auth/bloc/register/register_bloc.dart';
import 'package:siapantar/presentation/auth/login_screen.dart';
import 'package:siapantar/presentation/buyer/pemesanan/bloc/pemesanan_bloc.dart';
import 'package:siapantar/presentation/buyer/profile/bloc/profile_buyer_bloc.dart';
import 'package:siapantar/presentation/welcome_screen.dart';
import 'package:siapantar/services/service_http_client.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              LoginBloc(authRepository: AuthRepository(ServiceHttpClient())),
        ),
        BlocProvider(
          create: (context) =>
              RegisterBloc(authRepository: AuthRepository(ServiceHttpClient())),
        ),
        BlocProvider(
          create: (context) => ProfileBuyerBloc(
            profileBuyerRepository: ProfileBuyerRepository(ServiceHttpClient()),
          ),
        ),
        BlocProvider(
          create: (context) =>
              AddProfileBloc(PrifileAdminRepository(ServiceHttpClient())),
        ),
        BlocProvider(
          create: (context) =>
              GetProfileBloc(PrifileAdminRepository(ServiceHttpClient())),
        ),
        BlocProvider(
          create: (context) =>
              GetProfileBloc(PrifileAdminRepository(ServiceHttpClient())),
        ),
        BlocProvider(
          create: (context) => SopirBloc(SopirRepository(ServiceHttpClient())),
        ),
        BlocProvider(
          create: (context) => PemesananBloc(PemesananRepository(ServiceHttpClient())),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: WelcomeScreen(),
      ),
    );
  }
}