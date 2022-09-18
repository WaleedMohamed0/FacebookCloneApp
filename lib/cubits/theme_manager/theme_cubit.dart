import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubits/theme_manager/theme_states.dart';

import '../../network/cache_helper.dart';

class ThemeManagerCubit extends Cubit<ThemeManagerStates> {
  ThemeManagerCubit() :super(ThemeManagerInitialState());

  static ThemeManagerCubit get(context)=>BlocProvider.of(context);

  bool isDark = true;
  void changeTheme({bool isDarkInCache=false})
  {
    if(isDarkInCache)
      {
        isDark = isDarkInCache;
        emit(ThemeManagerSuccessState());
      }
    else
      {
        isDark = !isDark;
        emit(ThemeManagerSuccessState());
        CacheHelper.saveData(
            key: 'theme',
            value: isDark);
      }

  }

}