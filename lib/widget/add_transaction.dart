import 'package:bkn/db_helper.dart';
import 'package:bkn/widget/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:from_css_color/from_css_color.dart';

class AddTransaction extends StatefulWidget {
  final String? amount;
  final int? index;
  final String? notes;
  final String? type;
  final DateTime? date;
  const AddTransaction(
      {Key? key, this.amount, this.index, this.notes, this.type, this.date})
      : super(key: key);

  @override
  State<AddTransaction> createState() =>
      _AddTransactionState(amount, index, notes, type, date);
}

class _AddTransactionState extends State<AddTransaction> {
  //

  int? amonunt;
  String note = "Belanja";
  String types = "income";
  DateTime sdate = DateTime.now();
  // late  DateTime sdate;

  DateTime datenow = DateTime.now();

  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  String? amount;
  int? index;
  String? type;
  String? notes;
  DateTime? date;
  _AddTransactionState(
      this.amount, this.index, this.notes, this.type, this.date);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: sdate,
        firstDate: DateTime(1990, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != sdate) {
      setState(() {
        sdate = picked;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(type);
    setState(() {
      _amountController.text = amount ?? "";
      _noteController.text = notes ?? "";
      sdate = date ?? datenow;
      types = type ?? "income";

      // _dateController.text = date ?? DateTime.now();
      // _amountController.text = amount ?? "";
    });
  }

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.0,
        ),

        //backgroundColor: Color(0xffe2e7ef),

        body: ListView(
          padding: EdgeInsets.all(12.0),
          children: [
            SizedBox(
              height: 20.0,
            ),
            Text(
              index != null ? "Edit Catatan Keuangan" : "Add Catatan Keuangan",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w700,
                  color: fromCssColor('#5800FF')),
            ),
            //
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: fromCssColor('#0078AA'),
                      borderRadius: BorderRadius.circular(16.0)),
                  padding: EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.attach_money,
                    size: 24.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      hintText: "Masukan Nominal..",
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                    onChanged: (val) {
                      try {
                        amonunt = int.parse(val);
                      } catch (e) {}
                    },
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),

////////------------------------2nd
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: fromCssColor('#0078AA'),
                      borderRadius: BorderRadius.circular(16.0)),
                  padding: EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.description,
                    size: 24.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: TextField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      hintText: "Keterangan",
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                    onChanged: (val) {
                      note = val;
                    },
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 20.0,
            ),

            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: fromCssColor('#0078AA'),
                      borderRadius: BorderRadius.circular(16.0)),
                  padding: EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.moving_sharp,
                    size: 24.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 12.0,
                ),
                ChoiceChip(
                  label: Text(
                    "Pemasukan",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: types == "Income" ? Colors.white : Colors.black,
                    ),
                  ),
                  selectedColor: fromCssColor('#0078AA'),
                  selected: types == "Income" ? true : false,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        types = "Income";
                        if (note.isEmpty || note == "Expense") {
                          note = 'Income';
                        }
                      });
                    }
                  },
                ),
                SizedBox(
                  width: 12.0,
                ),
                ChoiceChip(
                  label: Text(
                    "Pengeluaran",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: types == "Income" ? Colors.white : Colors.black,
                    ),
                  ),
                  selectedColor: fromCssColor('#0078AA'),
                  selected: types == "Expense" ? true : false,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        types = "Expense";
                        if (note.isEmpty || note == "Expense") {
                          note = 'Expense';
                        }
                      });
                    }
                  },
                ),
              ],
            ),

            SizedBox(
              height: 20.0,
            ),
            SizedBox(
              height: 50.0,
              child: TextButton(
                onPressed: () {
                  _selectDate(context);
                },
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero)),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: fromCssColor('#0078AA'),
                        borderRadius: BorderRadius.circular(
                          16.0,
                        ),
                      ),
                      padding: EdgeInsets.all(
                        12.0,
                      ),
                      child: Icon(
                        Icons.date_range,
                        size: 24.0,
                        // color: Colors.grey[700],
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Text(
                      "${sdate.day} ${months[sdate.month - 1]}",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 20.0,
            ),

            SizedBox(
              height: 50.0,
              child: ElevatedButton(
                onPressed: () {
                  if (amonunt != null) {
                    DbHelper dbHelper = DbHelper();
                    if (index != null) {
                      print(index);
                      print(types);

                      print("edit");
                      Navigator.of(context).pop();

                      dbHelper.updateData(index!, amonunt!, sdate, types, note);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ));
                    } else {
                      dbHelper.addData(amonunt!, sdate, types, note);
                      Navigator.of(context).pop();
                    }
                  } else {
                    print("Not ");
                  }
                  // print(amonunt);
                  // print(note);
                  // print(types);
                  // print(sdate);
                },
                child: Text(
                  index != null ? "Edit" : "Add",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            )
          ],
        ));
  }
}
