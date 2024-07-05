import 'package:benjamin/form_challenge/data/repositories/form_repository.dart';
import 'package:benjamin/form_challenge/domain/entities/address_entity.dart';
import 'package:benjamin/form_challenge/domain/mapper/address/address_mapper.dart';

class SubmitNewAddressToCloudUseCase {
  final FormRepository _formRepository;
  final AddressMapper _addressMapper;
  SubmitNewAddressToCloudUseCase({
    required FormRepository formRepository,
    required AddressMapper addressMapper,
  })  : _formRepository = formRepository,
        _addressMapper = addressMapper;

  Future<bool> call(AddressEntity address) async {
    final addressModel = _addressMapper.toAddressModel(address);
    final hasSucceed = await _formRepository.submitFormToCloud(
      addressModel,
    );
    return hasSucceed;
  }
}
