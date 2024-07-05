import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String street;
  final String city;
  final String zip;
  final String state;
  final String? street2;
  const AddressEntity({
    required this.street,
    required this.city,
    required this.zip,
    required this.state,
    this.street2,
  });

  @override
  List<Object?> get props => [
    street,
    city,
    zip,
    state,
    street2,
  ];
}
