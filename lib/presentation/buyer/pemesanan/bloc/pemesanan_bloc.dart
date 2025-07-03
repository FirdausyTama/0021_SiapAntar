import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:siapantar/data/model/request/penyewa/pemesanan_request_model.dart';
import 'package:siapantar/data/model/response/penyewa/get_all_pemesanan_response.dart';
import 'package:siapantar/data/model/response/get_all_sopir_response_model.dart';  // TAMBAH INI
import 'package:siapantar/data/repository/pemesanan_repository.dart';

part 'pemesanan_event.dart';
part 'pemesanan_state.dart';

class PemesananBloc extends Bloc<PemesananEvent, PemesananState> {
  final PemesananRepository repository;
  PemesananBloc(this.repository) : super(PemesananInitial()) {
    
    // Get All Pemesanan (untuk admin)
    on<PemesananGetAllEvent>((event, emit) async {
      emit(PemesananLoadingState());
      final result = await repository.getAllPemesanan();
      result.fold(
        (l) => emit(PemesananErrorState(errorMessage: l)),
        (r) => emit(PemesananSuccessState(responseModel: r)),
      );
    });

    // Create Pemesanan (untuk buyer)
    on<PemesananCreateEvent>((event, emit) async {
      emit(PemesananLoadingState());
      final result = await repository.createPemesanan(event.requestModel);
      result.fold(
        (l) => emit(PemesananErrorState(errorMessage: l)),
        (r) => emit(PemesananCreateSuccessState(responseModel: r)),
      );
    });

    // Get Pemesanan by ID
    on<PemesananGetByIdEvent>((event, emit) async {
      emit(PemesananLoadingState());
      final result = await repository.getPemesananById(event.id);
      result.fold(
        (l) => emit(PemesananErrorState(errorMessage: l)),
        (r) => emit(PemesananDetailSuccessState(responseModel: r)),
      );
    });

    // Update Status Pemesanan (untuk admin)
    on<PemesananUpdateStatusEvent>((event, emit) async {
      emit(PemesananLoadingState());
      final result = await repository.updateStatusPemesanan(event.id, event.status);
      result.fold(
        (l) => emit(PemesananErrorState(errorMessage: l)),
        (r) => emit(PemesananUpdateStatusSuccessState(message: r)),
      );
    });

    // TAMBAH INI: Get Sopir Tersedia (untuk form pemesanan)
    on<PemesananGetSopirTersediaEvent>((event, emit) async {
      emit(PemesananLoadingState());
      final result = await repository.getSopirTersedia(
        tanggalMulai: event.tanggalMulai,
        tanggalSelesai: event.tanggalSelesai,
      );
      result.fold(
        (l) => emit(PemesananErrorState(errorMessage: l)),
        (r) => emit(PemesananSopirSuccessState(responseModel: r)),
      );
    });
  }
}