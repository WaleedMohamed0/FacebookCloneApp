import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubits/theme_manager/theme_states.dart';

class ThemeManagerCubit extends Cubit<ThemeManagerStates> {
  ThemeManagerCubit() :super(ThemeManagerInitialState());

  static ThemeManagerCubit get(context)=>BlocProvider.of(context);

  bool isDark = false;
  void changeTheme()
  {
    isDark = !isDark;
    emit(ThemeManagerSuccessState());
  }

}