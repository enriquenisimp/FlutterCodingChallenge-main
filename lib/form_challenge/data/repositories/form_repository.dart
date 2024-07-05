import 'dart:convert';
import 'dart:developer';

import 'package:benjamin/form_challenge/data/models/address/address_model.dart';
import 'package:flutter/services.dart';

class FormRepository {
  Future<List<AddressModel>> getListAddressByInput(String input) async {
    final listAddressModel = <AddressModel>[];

    final stringJson =
        await rootBundle.loadString("assets/list_address_mocked.json");

    final jsonList = jsonDecode(stringJson);

    for (final jsonAddress in jsonList) {
      try {
        final addressModel = AddressModel.fromJson(jsonAddress);

        listAddressModel.add(addressModel);
      } catch (e) {
        log("mapping json error: $e");
      }
    }
    await Future.delayed(
      const Duration(seconds: 1),
    );
    return listAddressModel
        .where((address) => address.street.toLowerCase().contains(input))
        .toList();
  }

  Future<bool> submitFormToCloud(AddressModel address) async {
    await Future.delayed(
      const Duration(seconds: 1),
    );

    return true;
  }
}
