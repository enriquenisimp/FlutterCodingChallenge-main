import 'package:benjamin/form_challenge/domain/entities/address_entity.dart';
import 'package:benjamin/form_challenge/domain/use_cases/submit_new_adress_to_cloud_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'submit_state.dart';

class SubmitCubit extends Cubit<SubmitState> {
  SubmitCubit({
    required SubmitNewAddressToCloudUseCase submitNewAddressToCloudUseCase,
  })  : _submitNewAddressToCloudUseCase = submitNewAddressToCloudUseCase,
        super(SubmitInitialState());

  final SubmitNewAddressToCloudUseCase _submitNewAddressToCloudUseCase;

  void submitForm(AddressEntity addressEntity) async {
    emit(SubmitLoadingState());
    final hasSucceed = await _submitNewAddressToCloudUseCase(addressEntity);

    if (hasSucceed) {
      emit(SubmitSuccessState());
    } else {
      emit(
        const SubmitErrorState(
          message: "Something went wrong, please try again",
        ),
      );
    }
  }
}
