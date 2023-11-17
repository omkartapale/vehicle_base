import 'package:cloud_firestore/cloud_firestore.dart'; //https://pub.dev/packages/cloud_firestore

import '../model/make.dart';

class MakeService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  late CollectionReference ref;

  MakeService() {
    ref = _fireStore.collection("makes");
  }

  Future<List<Make>> getMakeList() async {
    QuerySnapshot querySnapshot = await ref.get();
    // Get data from docs and convert map to List
    final allData = querySnapshot.docs
        .map((doc) => Make.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return allData;
  }

  Stream<List<Make>> getMakes() {
    return ref.orderBy('name').snapshots().map((event) => event.docs
        .map((e) => Make.fromJson(e.data() as Map<String, dynamic>))
        .toList());
  }

  Future<QuerySnapshot<Object?>> checkDuplicate(Make make) async {
    QuerySnapshot res = await ref
        .where('name', isEqualTo: make.name)
        .where('id', isNotEqualTo: make.id)
        .limit(1)
        .get();
    return res;
  }

  Future<bool> checkMakeAlreadyExist(Make make) async {
    final QuerySnapshot result = await ref
        .where('name', isEqualTo: make.name)
        .where('id', isNotEqualTo: make.id)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  Future<DocumentReference> addMake(Make make) async {
    var res = await ref.add(make.toJson());
    res.update({"id": res.id});
    return res;
  }

  Future<void> updateMake(Make make) => ref.doc(make.id).update(make.toJson());

  Future<void> removeMake(String? id) => ref.doc(id).delete();
}
