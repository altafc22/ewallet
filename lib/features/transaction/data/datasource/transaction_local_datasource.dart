import 'package:ewallet/features/transaction/data/model/transaction_model.dart';
import 'package:hive/hive.dart';

abstract interface class TransactionLocalDataSource {
  void insert({required List<TransactionModel> items});
  List<TransactionModel> getAll();
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final Box box;
  TransactionLocalDataSourceImpl(this.box);
  @override
  List<TransactionModel> getAll() {
    List<TransactionModel> items = [];
    print("getAll local trxs");
    for (int i = 0; i < box.length; i++) {
      final jsonData = box.get(i.toString());
      print("Data ${jsonData}");
      items.add(TransactionModel.fromJson(jsonData));
    }

    return items;
  }

  @override
  void insert({required List<TransactionModel> items}) {
    box.clear(); // clearing old cached records
    box.write(() {
      for (int i = 0; i < items.length; i++) {
        box.put(i.toString(), items[i]);
      }
    });
  }
}
