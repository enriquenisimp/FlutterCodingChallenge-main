import 'package:benjamin/form_challenge/domain/entities/address_entity.dart';
import 'package:benjamin/form_challenge/presentation/pages/form/viewmodels/address/address_cubit.dart';
import 'package:benjamin/form_challenge/presentation/pages/form/viewmodels/submit/submit_cubit.dart';
import 'package:benjamin/form_challenge/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormView extends StatefulWidget {
  const FormView({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  State<FormView> createState() => _FormViewState();
}

class _FormViewState extends State<FormView> {
  final _addressTextController = TextEditingController();
  final _address2TextController = TextEditingController();
  final _cityTextController = TextEditingController();
  final _zipTextController = TextEditingController();
  final _stateTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff002433),
        title: const Text("Benjamin", style: TextStyle(color: Colors.white)),
      ),
      body: BlocBuilder<SubmitCubit, SubmitState>(
        builder: (context, submitState) {
          return switch (submitState) {
            SubmitLoadingState() => const Center(
                child: CircularProgressIndicator(),
              ),
            SubmitErrorState() => Center(
                child: Text(submitState.message),
              ),
            SubmitSuccessState() => const Center(
                child: Text("Your address was successfully updated"),
              ),
            SubmitInitialState() => Form(
                key: widget.formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextFormField(
                        labelText: "Street address",
                        controller: _addressTextController,
                        autoCompleteInfo: AutoCompleteInfo(
                            showAutoComplete: true,
                            onSelectedItem: (indexSelected) {
                              final address = context
                                  .read<AddressCubit>()
                                  .getAddressByIndex(indexSelected);

                              if (address != null) {
                                _addressTextController.text = address.street;
                                _cityTextController.text = address.city;
                                _zipTextController.text = address.zip;
                                _stateTextController.text = address.state;
                              }
                              context.read<AddressCubit>().stopSearch();
                            }),
                        validator: (value) =>
                            defaultValidator("Address", value),
                        onChanged: (String? value) {
                          if (value != null && value.length > 2) {
                            context
                                .read<AddressCubit>()
                                .getListStreetsByInput(value);
                          } else {
                            context.read<AddressCubit>().stopSearch();
                          }
                        },
                        maxLength: 100,
                        keyboardType: TextInputType.streetAddress,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        labelText: "Street address line 2",
                        validator: (value) =>
                            defaultValidator("Second Address", value),
                        controller: _address2TextController,
                        maxLength: 100,
                      ),
                      const SizedBox(height: 20),
                      Row(children: [
                        Expanded(
                          child: CustomTextFormField(
                            labelText: "City",
                            controller: _cityTextController,
                            validator: (value) =>
                                defaultValidator("City", value),
                            maxLength: 50,
                            keyboardType: TextInputType.name,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z]'))
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: CustomTextFormField(
                            labelText: "Zip",
                            controller: _zipTextController,
                            validator: (value) =>
                                defaultValidator("Zip", value),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]'))
                            ],
                            maxLength: 5,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        labelText: "State",
                        controller: _stateTextController,
                        validator: (value) => defaultValidator("State", value),
                      ),
                    ],
                  ),
                ),
              ),
          };
        },
      ),
      floatingActionButton: BlocBuilder<SubmitCubit, SubmitState>(
        builder: (context, submitState) {
          if (submitState is SubmitInitialState) {
            return ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff002433), elevation: 2),
              child:
                  const Text("Submit", style: TextStyle(color: Colors.white)),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  void _submitForm() {
    if (widget.formKey.currentState!.validate()) {
      context.read<SubmitCubit>().submitForm(
            AddressEntity(
              street: _addressTextController.text,
              city: _cityTextController.text,
              zip: _zipTextController.text,
              state: _stateTextController.text,
              street2: _address2TextController.text,
            ),
          );
    }
  }

  String? defaultValidator(String text, String? value) {
    if (value?.isEmpty == true) {
      return "$text cannot be empty";
    }
    return null;
  }

  @override
  void dispose() {
    _addressTextController.dispose();
    _address2TextController.dispose();
    _cityTextController.dispose();
    _zipTextController.dispose();
    _stateTextController.dispose();
    super.dispose();
  }
}
