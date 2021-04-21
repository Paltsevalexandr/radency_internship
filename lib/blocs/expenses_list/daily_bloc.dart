import 'dart:async';

class ItemsBloc {

  Map _items = {};

  final _itemsStream = StreamController();

  Stream get itemsStream => _itemsStream.stream;
  Sink get itemsSink => _itemsStream.sink;

  void dispose() {
    _itemsStream.close();
  }

  void loadItems(data) {
    _items = data;
    itemsSink.add(_items);
  }
}