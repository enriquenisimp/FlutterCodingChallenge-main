import 'package:benjamin/form_challenge/presentation/pages/form/viewmodels/address/address_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AutoCompleteAddressOverlay extends StatefulWidget {
  const AutoCompleteAddressOverlay({
    super.key,
    required this.onAddressSelected,
    required this.focusNode,
    required this.child,
  });
  final Function(int index) onAddressSelected;
  final FocusNode focusNode;
  final Widget child;
  @override
  State<AutoCompleteAddressOverlay> createState() =>
      _AutoCompleteAddressOverlayState();
}

class _AutoCompleteAddressOverlayState
    extends State<AutoCompleteAddressOverlay> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  @override
  void initState() {
    super.initState();

    widget.focusNode.addListener(() {
      if (!widget.focusNode.hasFocus) {
        context.read<AddressCubit>().stopSearch();
      }
    });
  }

  void showOverlay({
    List<String>? listItems,
    bool isError = false,
  }) {
    hideOverlay();
    _overlayEntry = _createOverlayEntry(listItems, isError);
    Overlay.of(context).deactivate();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressCubit, AddressState>(
      listener: (context, state) {
        switch (state) {
          case AddressSuccessState():
            showOverlay(
                listItems: state.listAddress.map((e) => "${e.street}, ${e.city}, ${e.state}").toList());
            break;
          case AddressEmptyState():
            hideOverlay();
            break;
          case AddressLoadingState():
            showOverlay();
            break;
          case AddressErrorState():
            showOverlay(isError: true);
            break;
        }
      },
      child: CompositedTransformTarget(
        link: _layerLink,
        child: widget.child,
      ),
    );
  }

  OverlayEntry _createOverlayEntry(List<String>? listItems, bool isError) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height),
          child: Material(
            borderRadius: BorderRadius.circular(8),
            borderOnForeground: true,
            elevation: 2,
            child: SizedBox(
              height: 200,
              child: listItems != null
                  ? Scrollbar(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: List.generate(
                          listItems.length,
                          (index) => ListTile(
                            title: Text(listItems[index]),
                            onTap: () => widget.onAddressSelected(index),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: isError
                          ? errorTextWidget()
                          : const CircularProgressIndicator(),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget errorTextWidget(){
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.warning_rounded, color: Colors.grey,),
         Text("No address was found for that name")
      ],
    );
  }
}
