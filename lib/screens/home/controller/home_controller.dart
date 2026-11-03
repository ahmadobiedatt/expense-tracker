import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../repo/home_repo.dart';

class HomeController extends GetxController {

  final HomeRepo _repo = HomeRepo ();

  final RxDouble balance = 0.0.obs  ;
  final RxBool isLoading = true.obs;

  Future <void> loadBalance() async {
    
     isLoading.value = true; 
     

final user = FirebaseAuth.instance.currentUser ;
   
    if (user == null) {
  isLoading.value = false;
  return;
}

try {

balance.value = await _repo.getBalance(user.uid);

}
catch (e) {
  Get.snackbar(
    'Error',
    'Could not load balance. Please try again.',
  );
}
finally {
   if (!isClosed) {
    isLoading.value = false;
  }
}
  }
  @override
void onInit() {
  super.onInit();

 loadBalance();
}
} 