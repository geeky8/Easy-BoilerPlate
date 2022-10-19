import 'package:fit_page/models/main_model.dart';
import 'package:fit_page/services/repository.dart';
import 'package:fit_page/utils/enums.dart';
import 'package:get/get.dart';

/// Controller for statemanagement
class MainController extends GetxController {
  final mainList = (<MainModel>[]).obs;
  final state = (StoreState.SUCCESS).obs;

  final _repository = Repository();

  Future<void> getData() async {
    state.value = StoreState.LOADING;
    final data = await _repository.getData();
    if (data != null && data.isNotEmpty) {
      mainList
        ..clear()
        ..addAll(data);
      state.value = StoreState.SUCCESS;
    } else {
      state.value = StoreState.EMPTY;
    }
  }
}
