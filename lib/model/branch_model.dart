import 'package:cloud_firestore/cloud_firestore.dart';

class BranchModel {
  String id;
  String name;

  BranchModel({
    required this.id,
    required this.name,
  });

  factory BranchModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data()!;
    return BranchModel(
      id: snapshot.id,
      name: data['name'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
    };
  }
}