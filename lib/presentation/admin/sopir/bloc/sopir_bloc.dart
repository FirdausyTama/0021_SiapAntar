import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:siapantar/data/model/request/admin/admin_sopir_request.dart';
import 'package:siapantar/data/model/response/get_all_sopir_response_model.dart';
import 'package:siapantar/data/repository/sopir_repository.dart';

part 'sopir_event.dart';
part 'sopir_state.dart';

class SopirBloc extends Bloc<SopirEvent, SopirState> {
  final SopirRepository repository;
  SopirBloc(this.repository) : super(SopirInitial()) {
    
    // Get All Sopir
    on<SopirGetAllEvent>((event, emit) async {
      emit(SopirLoadingState());
      final result = await repository.getAllSopir();
      result.fold(
        (l) => emit(SopirErrorState(errorMessage: l)),
        (r) => emit(SopirSuccessState(responseModel: r)),
      );
    });

    // Add Sopir
    on<SopirRequestEvent>((event, emit) async {
      emit(SopirLoadingState());
      final result = await repository.addSopir(event.requestModel);
      result.fold(
        (l) => emit(SopirErrorState(errorMessage: l)),
        (r) => emit(SopirAddSuccessState(responseModel: r)),
      );
    });

    // Get Sopir by ID
    on<SopirGetByIdEvent>((event, emit) async {
      emit(SopirLoadingState());
      final result = await repository.getSopirById(event.id);
      result.fold(
        (l) => emit(SopirErrorState(errorMessage: l)),
        (r) => emit(SopirDetailSuccessState(responseModel: r)),
      );
    });

    // Update Sopir
    on<SopirUpdateEvent>((event, emit) async {
      emit(SopirLoadingState());
      final result = await repository.updateSopir(event.id, event.requestModel);
      result.fold(
        (l) => emit(SopirErrorState(errorMessage: l)),
        (r) => emit(SopirUpdateSuccessState(responseModel: r)),
      );
    });

    // Delete Sopir
    on<SopirDeleteEvent>((event, emit) async {
      emit(SopirLoadingState());
      final result = await repository.deleteSopir(event.id);
      result.fold(
        (l) => emit(SopirErrorState(errorMessage: l)),
        (r) => emit(SopirDeleteSuccessState(message: r)),
      );
    });
  }
}