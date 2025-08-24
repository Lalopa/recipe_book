import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class MainCubit extends Cubit<int> {
  MainCubit() : super(0);

  void setTab(int index) => emit(index);
}
