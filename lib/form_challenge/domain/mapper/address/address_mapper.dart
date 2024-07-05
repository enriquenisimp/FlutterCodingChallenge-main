import 'dart:developer';

import 'package:benjamin/form_challenge/data/models/address/address_model.dart';
import 'package:benjamin/form_challenge/domain/entities/address_entity.dart';

class AddressMapper {
  AddressEntity fromAddressModel(AddressModel model) {
    return AddressEntity(
      street: model.street,
      city: model.city,
      zip: model.zip,
      state: model.state,
    );
  }

  AddressModel toAddressModel(AddressEntity entity) {
    return AddressModel(
      street: entity.street,
      city: entity.city,
      street2: entity.street2,
      zip: entity.zip,
      state: entity.state,
    );
  }

  List<AddressEntity> fromListModel(List<AddressModel> listAddressModel) {
    final listAddressEntity = <AddressEntity>[];
    for (final addressModel in listAddressModel) {
      try {
        final addressEntity = fromAddressModel(addressModel);

        listAddressEntity.add(addressEntity);
      } catch (e, s) {
        log("error mapping address model: $e", stackTrace: s);
      }
    }

    return listAddressEntity;
  }
}
