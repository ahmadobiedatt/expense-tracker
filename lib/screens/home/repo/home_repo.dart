import 'package:cloud_firestore/cloud_firestore.dart';


 class HomeRepo {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<double> getBalance(String userid) async {

  final userData = await _firestore.collection('users').doc(userid).get();

  final data = userData.data();

  return (data?['balance'] as num?)?.toDouble() ?? 0.0;

    }
 }
