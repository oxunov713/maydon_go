import 'package:flutter_bloc/flutter_bloc.dart';

class FabVisibilityCubit extends Cubit<bool> {
  FabVisibilityCubit() : super(true);

  void show() => emit(true);
  void hide() => emit(false);
}
