part of 'pemesanan_bloc.dart';

sealed class PemesananEvent {}

class PemesananGetAllEvent extends PemesananEvent {}

class PemesananCreateEvent extends PemesananEvent {
  final PemesananRequestModel requestModel;

  PemesananCreateEvent({required this.requestModel});
}

class PemesananUpdateStatusEvent extends PemesananEvent {
  final int id;
  final String status;

  PemesananUpdateStatusEvent({required this.id, required this.status});
}

class PemesananGetByIdEvent extends PemesananEvent {
  final int id;

  PemesananGetByIdEvent({required this.id});
}

// TAMBAH INI: Event untuk get sopir tersedia
class PemesananGetSopirTersediaEvent extends PemesananEvent {
  final String? tanggalMulai;
  final String? tanggalSelesai;

  PemesananGetSopirTersediaEvent({
    this.tanggalMulai,
    this.tanggalSelesai,
  });
}