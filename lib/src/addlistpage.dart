import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
import 'dart:async';
import 'itemflie.dart';

class AddListpage extends StatefulWidget {
  final Map subscriptionItem;
  AddListpage({this.subscriptionItem});
  @override
  _AddListpageState createState() => _AddListpageState();
}

class _AddListpageState extends State<AddListpage> {
  String _serviceName = '';
  String _serviceFee = '';
  DateTime  _nextPayDate = DateTime.now();
  String _payInterval = '';
  String _memo = '';
  Map<String, Object> _subscriptionItem = {
    'serviceName': ''
    , 'serviceFee': ''
    , 'nextPayDate': DateTime.now()
    , 'interval': 'month'
    , 'memo': ''
  };


  // todo このinitstateはいらんかも
  @override
  void initState() {
    if(widget.subscriptionItem.length > 0) setSubscriptionItem(widget.subscriptionItem);
      _serviceName = _subscriptionItem['serviceName'];
      _serviceFee = _subscriptionItem['serviceFee'];
      _nextPayDate = _subscriptionItem['nextPayDate'];
      _payInterval = _subscriptionItem['interval'];
      _memo = _subscriptionItem['memo'];
  }

  void setSubscriptionItem(item) {
    _subscriptionItem['serviceName'] = item['serviceName'];
    _subscriptionItem['serviceFee'] = item['serviceFee'];
    _subscriptionItem['nextPayDate'] = item['nextPayDate'];
    _subscriptionItem['interval'] = item['interval'];
    _subscriptionItem['memo'] = item['memo'];
  }

  // final formatter = NumberFormat("#,###");
  // var dateFormatter = new DateFormat('yyyy/MM/dd(E)', "ja_JP");

  // カレンダー実装
  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime selected = await showDatePicker(
  //     locale: const Locale("ja"),
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2015),
  //     lastDate: DateTime(2025),
  //   );
  //   if (selected != null) {
  //     setState(() {
  //       returnVal['nextPayDate'] = selected;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final defaultTextTheme = Theme.of(context).textTheme;
    final titleStyle = defaultTextTheme.subtitle1.copyWith(
      fontWeight: FontWeight.bold,
      color: Colors.grey,
    );
    return Scaffold(
        appBar: AppBar(
          title: Text(_subscriptionItem['serviceName'] == '' ? '新規作成':'編集'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Text('サービス名', style: titleStyle),
                            TextFormField(
                                initialValue: _serviceName,
                                cursorColor: Colors.black,
                                maxLength: 30,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                onChanged: (String value) {
                                  setState(() {
                                    _serviceName = value;
                                  });
                                }
                            ),
                            SizedBox(height: 20),
                            Text('利用料金(円)', style: titleStyle),
                            TextFormField(
                                initialValue: _serviceFee,
                                cursorColor: Colors.black,
                                maxLength: 30,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [FilteringTextInputFormatter.deny(new RegExp('[\\-|\\ ]'))],
                                //      controller: inputPrice,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                onChanged: (String value) {
                                  setState(() {
                                    //            inputPrice.text = formatter.format(int.parse(value));
                                    _serviceFee = value;
                                  });
                                }
                            ),
                            SizedBox(height: 20),
                            Text('次回支払日', style: titleStyle),
                            SizedBox(height: 20),
                            Container(
                              height: 50,
                              child: Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.date_range),
                                    // onPressed: () => _selectDate(context),
                                  ),
                                  // Text(
                                  //   //TextEditingController(text),
                                  //   //value: widget.nextPayDate,
                                  //   // dateFormatter.format(returnVal['nextPayDate']),
                                  //   // style: TextStyle(fontSize: 16),
                                  // ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Text('支払いスパン', style: titleStyle),
                            SizedBox(height: 10),
                            // DropdownButton<String>(
                            //   value: widget.interval,
                            //   icon: Icon(Icons.arrow_downward),
                            //   iconSize: 24,
                            //   elevation: 16,
                            //   underline: Container(
                            //     height: 1,
                            //     color: Colors.grey[600],
                            //   ),
                            //   onChanged: (String value) {
                            //     setState(() {
                            //       returnVal['interval'] = value;
                            //     });
                            //   },
                            //   items: payInterval.entries.map((entry) {
                            //     return DropdownMenuItem(
                            //       child: Text(entry.value),
                            //       value: entry.key,
                            //     );
                            //   }).toList(),
                            // ),
                            DropDownItem(),
                            SizedBox(height: 20),
                            Text('メモ', style: titleStyle),
                            TextFormField(
                                initialValue: _memo,
                                cursorColor: Colors.black,
                                maxLength: 300,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                onChanged: (String value) {
                                  setState(() {
                                    _memo = value;
                                  });
                                }
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  )
              ),
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    // todo validationcheck つける  validate();
                    _subscriptionItem['serviceName'] = _serviceName;
                    _subscriptionItem['serviceFee'] = _serviceFee;
                    _subscriptionItem['nextPayDate'] = _nextPayDate;
                    _subscriptionItem['interval'] = _payInterval;
                    _subscriptionItem['memo'] = _memo;
                    Navigator.of(context).pop(_subscriptionItem);
                  },
                  child: Text('登録', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        )
    );
  }
}

class DropDownItem extends StatefulWidget {
  const DropDownItem({Key key}) : super(key: key);

  @override
  _DropDownItemState createState() => _DropDownItemState();
}

class _DropDownItemState extends State<DropDownItem> {
  List<DropdownMenuItem<String>> _items = [];
  Map elMap = payInterval;
  String _selectItem = '0';

  @override
  void initState() {
    super.initState();
    setItems(elMap);
    _selectItem = _items[0].value;
  }

  void setItems(element) {
    element.forEach((var _elKey, var _elVal){
      _items.add(DropdownMenuItem(
        child: Text(_elVal.toString()),
        value: _elKey,
      ));
    });

  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      items: _items,
      value: _selectItem,
      onChanged: (newValue) => [
        setState(() {
          _selectItem = newValue;
        })
      ],
    );
  }
}

