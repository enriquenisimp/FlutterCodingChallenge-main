import 'package:benjamin/form_challenge/data/utils/debouncer.dart';
import 'package:benjamin/form_challenge/domain/entities/address_entity.dart';
import 'package:benjamin/form_challenge/domain/use_cases/get_list_adress_by_input_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  AddressCubit({
    required GetListAddressByInputUseCase getListAddressByInputUseCase,
    required Debounce debounce,
  })  : _getListAddressByInputUseCase = getListAddressByInputUseCase,
        _debounce = debounce,
        super(AddressEmptyState());

  final GetListAddressByInputUseCase _getListAddressByInputUseCase;
  final Debounce _debounce;

  Future<void> getListStreetsByInput(String input) async {
    _debounce.run(
        milliseconds: 300,
        action: () async {
          emit(AddressLoadingState());
          final listAddressAvailable =
              await _getListAddressByInputUseCase(input);

          if (listAddressAvailable.isEmpty) {
            emit(AddressErrorState());
          } else {
            emit(
              AddressSuccessState(
                listAddress: listAddressAvailable,
              ),
            );
          }
        });
  }

  AddressEntity? getAddressByIndex(int index) {
    if (state is AddressSuccessState) {
      return (state as AddressSuccessState).listAddress[index];
    }
    return null;
  }

  void stopSearch() {
    emit(AddressEmptyState());
  }

  @override
  Future<void> close() {
    _debounce.close();
    return super.close();
  }
}
