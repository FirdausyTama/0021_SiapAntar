part of 'pemesanan_bloc.dart';

sealed class PemesananState {}

final class PemesananInitial extends PemesananState {}

final class PemesananLoadingState extends PemesananState {}

final class PemesananSuccessState extends PemesananState {
  final GetAllPemesananModel responseModel;

  PemesananSuccessState({required this.responseModel});
}

final class PemesananCreateSuccessState extends PemesananState {
  final GetPemesananById responseModel;

  PemesananCreateSuccessState({required this.responseModel});
}

final class PemesananDetailSuccessState extends PemesananState {
  final GetPemesananById responseModel;

  PemesananDetailSuccessState({required this.responseModel});
}

final class PemesananUpdateStatusSuccessState extends PemesananState {
  final String message;

  PemesananUpdateStatusSuccessState({required this.message});
}

// TAMBAH INI: State untuk sukses get sopir tersedia
final class PemesananSopirSuccessState extends PemesananState {
  final GetAllSopirModel responseModel;

  PemesananSopirSuccessState({required this.responseModel});
}

final class PemesananErrorState extends PemesananState {
  final String errorMessage;

  PemesananErrorState({required this.errorMessage});
}