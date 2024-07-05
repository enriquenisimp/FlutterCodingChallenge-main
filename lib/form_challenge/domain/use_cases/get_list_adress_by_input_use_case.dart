import 'package:benjamin/form_challenge/data/repositories/form_repository.dart';
import 'package:benjamin/form_challenge/domain/entities/address_entity.dart';
import 'package:benjamin/form_challenge/domain/mapper/address/address_mapper.dart';

class GetListAddressByInputUseCase {
  final FormRepository _formRepository;
  final AddressMapper _addressMapper;
  GetListAddressByInputUseCase({
    required FormRepository formRepository,
    required AddressMapper addressMapper,
  })  : _formRepository = formRepository,
        _addressMapper = addressMapper;

  Future<List<AddressEntity>> call(String streetAddress) async {
    final listAddressModel = await _formRepository.getListAddressByInput(
      streetAddress.toLowerCase(),
    );

    final listAddressEntity = _addressMapper.fromListModel(listAddressModel);

    return listAddressEntity;
  }
}
