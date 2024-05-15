import 'package:hive/hive.dart';

import '../model/beneficiary_model.dart';

abstract interface class BeneficiaryLocalDataSource {
  void insert({required List<BeneficiaryModel> items});
  List<BeneficiaryModel> getAll();
}

class BeneficiaryLocalDataSourceImpl implements BeneficiaryLocalDataSource {
  final Box box;
  BeneficiaryLocalDataSourceImpl(this.box);
  @override
  List<BeneficiaryModel> getAll() {
    List<BeneficiaryModel> items = [];
    for (int i = 0; i < box.length; i++) {
      final jsonData = box.get(i.toString());
      items.add(BeneficiaryModel.fromJson(jsonData));
    }
    return items;
  }

  @override
  void insert({required List<BeneficiaryModel> items}) {
    box.clear(); // clearing old cached records
    box.write(() {
      for (int i = 0; i < items.length; i++) {
        box.put(i.toString(), items[i]);
      }
    });
  }
}
