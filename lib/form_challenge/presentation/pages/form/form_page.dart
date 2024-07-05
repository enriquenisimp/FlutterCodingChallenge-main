import 'package:benjamin/form_challenge/data/repositories/form_repository.dart';
import 'package:benjamin/form_challenge/data/utils/debouncer.dart';
import 'package:benjamin/form_challenge/domain/mapper/address/address_mapper.dart';
import 'package:benjamin/form_challenge/domain/use_cases/get_list_adress_by_input_use_case.dart';
import 'package:benjamin/form_challenge/domain/use_cases/submit_new_adress_to_cloud_use_case.dart';
import 'package:benjamin/form_challenge/presentation/pages/form/form_view.dart';
import 'package:benjamin/form_challenge/presentation/pages/form/viewmodels/address/address_cubit.dart';
import 'package:benjamin/form_challenge/presentation/pages/form/viewmodels/submit/submit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AddressCubit(
            getListAddressByInputUseCase: GetListAddressByInputUseCase(
              formRepository: FormRepository(),
              addressMapper: AddressMapper(),
            ),
            debounce: Debounce(),
          ),
        ),
        BlocProvider(
          create: (context) => SubmitCubit(
            submitNewAddressToCloudUseCase: SubmitNewAddressToCloudUseCase(
              formRepository: FormRepository(),
              addressMapper: AddressMapper(),
            ),
          ),
        ),
      ],
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: FormView(
          formKey: _formKey,
        ),
      ),
    );
  }
}
