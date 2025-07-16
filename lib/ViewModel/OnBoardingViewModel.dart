import 'package:flutter_riverpod/flutter_riverpod.dart';

class onboardingViewModel extends StateNotifier<int>{

onboardingViewModel():super(0);

void setPage(int index){
  state=index;
}

}

final onboardingViewModelProvider=
StateNotifierProvider<onboardingViewModel,int>((ref){

return onboardingViewModel();

});