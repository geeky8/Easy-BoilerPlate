import 'package:fit_page/controller/main_controller.dart';
import 'package:fit_page/models/criteria_model.dart';
import 'package:fit_page/models/main_model.dart';
import 'package:fit_page/models/variable_model.dart';
import 'package:fit_page/utils/enums.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    _getData();
    super.initState();
  }

  /// Function to fetch list of [MainModel]
  _getData() async {
    final controller = Get.put(MainController());
    await controller.getData();
  }

  @override
  Widget build(BuildContext context) {
    /// Definining the [MainController]
    final controller = Get.find<MainController>();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.black,
        elevation: 2,
        shadowColor: Colors.white,
        centerTitle: true,
      ),
      body: Obx(() {
        final state = controller.state.value;
        switch (state) {
          case StoreState.LOADING:
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          case StoreState.SUCCESS:
            return ListView.builder(
                itemCount: controller.mainList.length,
                itemBuilder: (_, mainListIndex) {
                  final model = controller.mainList[mainListIndex];
                  return Obx(
                    () => ExpansionTile(
                      title: Text(
                        model.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        model.tag,
                        style: TextStyle(
                          color: model.color,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      trailing: Icon(
                        (model.isTapped)
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_right_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      onExpansionChanged: (value) {
                        final ind = controller.mainList
                            .indexWhere((element) => model.id == element.id);
                        final updateModel =
                            model.copyWith(isTapped: !model.isTapped);
                        controller.mainList
                          ..removeAt(ind)
                          ..insert(ind, updateModel);
                      },
                      children: model.criterias.map<ListTile>(
                        (element) {
                          int criteriaListIndex = -1;
                          if (controller.state.value == StoreState.SUCCESS) {
                            criteriaListIndex = model.criterias.indexWhere(
                                (criteria) =>
                                    element.text[0] == criteria.text[0]);
                          }
                          return ListTile(
                            title: RichText(
                              text: TextSpan(
                                text: '.',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                                children: element.text.map<TextSpan>((e) {
                                  int variableListIndex = -1;
                                  if (element.variableModel != null) {
                                    variableListIndex = element.variableModel!
                                        .indexWhere(
                                            (element) => element.value == e);
                                  }
                                  return TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        if (variableListIndex != -1) {
                                          final varModel =
                                              element.variableModel![
                                                  variableListIndex];
                                          showDialog(
                                            context: context,
                                            builder: (_) => ValueDialog(
                                              model: varModel,
                                              mainModel: model,
                                              mainListIndex: mainListIndex,
                                              variableListIndex:
                                                  variableListIndex,
                                              criteriasListIndex:
                                                  criteriaListIndex,
                                              criteriaModel: model
                                                  .criterias[criteriaListIndex],
                                            ),
                                          );
                                        }
                                      },
                                    text: ' $e',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: (variableListIndex != -1)
                                            ? Colors.blue
                                            : Colors.white),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  );
                });
          case StoreState.EMPTY:
            return Center(child: Image.asset('assets/error.png'));
        }
      }),
    );
  }
}

/// To show values that a user can choose from to update [VariableModel] and the text based on [CriteriaModel]
class ValueDialog extends StatefulWidget {
  const ValueDialog({
    Key? key,
    required this.model,
    required this.mainListIndex,
    required this.criteriasListIndex,
    required this.variableListIndex,
    required this.mainModel,
    required this.criteriaModel,
  }) : super(key: key);

  final VariableModel model;
  final int mainListIndex;
  final int criteriasListIndex;
  final int variableListIndex;
  final CriteriaModel criteriaModel;
  final MainModel mainModel;

  @override
  State<ValueDialog> createState() => _ValueDialogState();
}

class _ValueDialogState extends State<ValueDialog> {
  @override
  Widget build(BuildContext context) {
    double sliderValue =
        double.parse((widget.model.defaultValue ?? 0).toString());
    final controller = Get.find<MainController>();

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height / 5,
        width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.center,
        child: (widget.model.variableType == VariableType.INDICATOR)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Slider(
                    label: 'Position',
                    value: sliderValue,
                    min:
                        double.parse((widget.model.minValue ?? 0.0).toString()),
                    max:
                        double.parse((widget.model.maxValue ?? 0.0).toString()),
                    onChanged: (value) {
                      /// Update the state of slider
                      setState(() {
                        sliderValue = value;
                      });

                      /// Updating the string of [CriteriaModel] based on [sliderValue]
                      final textIndex = widget.criteriaModel.text.indexWhere(
                          (element) => element == widget.model.value);
                      widget.criteriaModel.text
                        ..removeAt(textIndex)
                        ..insert(textIndex, sliderValue.toStringAsFixed(0));

                      /// Update [VariableModel]
                      final updatedVariableModel = widget.model.copyWith(
                          value: '\$${sliderValue.toStringAsFixed(0)}');

                      /// Updating main model
                      widget.criteriaModel.variableModel!
                        ..removeAt(widget.variableListIndex)
                        ..insert(
                            widget.variableListIndex, updatedVariableModel);

                      final updatedMainModel = widget.mainModel.copyWith(
                          criterias: widget.mainModel.criterias
                            ..removeAt(widget.criteriasListIndex)
                            ..insert(widget.criteriasListIndex,
                                widget.criteriaModel));

                      /// Update the list based on [MainModel]
                      controller.mainList
                        ..removeAt(widget.mainListIndex)
                        ..insert(widget.mainListIndex, updatedMainModel);
                    },
                  ),
                  Text(
                    sliderValue.toStringAsFixed(0),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: widget.model.values!.length,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        // scrollDirection: Axis.vertical,
                        itemBuilder: (_, valueIndex) {
                          return ListTile(
                            title: Text(
                              widget.model.values![valueIndex],
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            onTap: () {
                              /// Updating the values of [VariableModel]
                              final updateValues =
                                  widget.model.values![valueIndex];

                              /// Updating the string of [CriteriaModel] based on [String]
                              final textIndex = widget.criteriaModel.text
                                  .indexWhere((element) =>
                                      element == widget.model.value);
                              widget.criteriaModel.text
                                ..removeAt(textIndex)
                                ..insert(textIndex, updateValues);

                              /// Update [VaribaleModel]
                              widget.model.values!
                                ..removeAt(valueIndex)
                                ..insert(
                                  valueIndex,
                                  (widget.model.value[0] == '\$')
                                      ? widget.model.value.substring(1)
                                      : widget.model.value,
                                );
                              final updatedVariableModel = widget.model
                                  .copyWith(value: "\$$updateValues");

                              /// Updating main model
                              widget.criteriaModel.variableModel!
                                ..removeAt(widget.variableListIndex)
                                ..insert(widget.variableListIndex,
                                    updatedVariableModel);

                              final updatedMainModel =
                                  widget.mainModel.copyWith(
                                criterias: widget.mainModel.criterias
                                  ..removeAt(widget.criteriasListIndex)
                                  ..insert(widget.criteriasListIndex,
                                      widget.criteriaModel),
                              );

                              /// Update list of based on [MainModel]
                              controller.mainList
                                ..removeAt(widget.mainListIndex)
                                ..insert(
                                    widget.mainListIndex, updatedMainModel);

                              /// Popping the dialog box
                              Navigator.of(context).pop();
                            },
                          );
                        }),
                  ),
                ],
              ),
      ),
    );
  }
}
