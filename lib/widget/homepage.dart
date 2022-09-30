import 'package:bkn/db_helper.dart';
import 'package:bkn/model/tranksasi_model.dart';
import 'package:bkn/widget/add_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:bkn/constanta.dart';
import 'package:from_css_color/from_css_color.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'confirm_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box box;
  Map? data;

  int totalSaldo = 0;
  int totalPemasukan = 0;
  int totalPengeluaran = 0;
  DbHelper dbHelper = DbHelper();
  int index = 1;

  String? nama;

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

  DateTime today = DateTime.now();
  DateTime now = DateTime.now();

  late Future<dynamic> _futureGetdata;

  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();

    getPreference();

    box = Hive.box('db_bkn');

    _futureGetdata = fetch();
  }

  getPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nama = prefs.getString('name');
    });
    // box = Hive.box('money');
  }

  Future<List<TransactionModel>> fetch() async {
    if (box.values.isEmpty) {
      return Future.value([]);
    } else {
      // return Future.value(box.toMap());
      List<TransactionModel> items = [];
      box.toMap().values.forEach((element) {
        // print(element);
        items.add(
          TransactionModel(
            element['amount'] as int,
            element['note'],
            element['date'] as DateTime,
            element['type'],
          ),
        );
      });
      return items;
    }
  }

  gettotalSaldo(List<TransactionModel> entiredata) {
    totalPengeluaran = 0;
    totalPemasukan = 0;
    totalSaldo = 0;

    for (TransactionModel data in entiredata) {
      if (data.type == "Income") {
        totalSaldo += data.amount;
        totalPemasukan += data.amount;
      } else {
        totalSaldo -= data.amount;
        totalPengeluaran += data.amount;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        iconTheme: IconThemeData(
          color: fromCssColor('#5800FF'),
          // size: 35.0,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Image.asset(
                  "assets/icon.png",
                  width: 40.0,
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  "PT.BKN",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                    color: fromCssColor('#0078AA'),
                  ),
                ),
                SizedBox(
                  width: 70.0,
                ),
                Text(
                  "Welcome, ${nama ?? ""}",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: fromCssColor('#5800FF'),
                  ),
                ),
              ]),
              SizedBox(
                width: 20.0,
              ),
            ],
          )
        ],
      ),
      body: FutureBuilder<List<TransactionModel>>(
          future: fetch(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error!"),
              );
            }
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text("Mohon tambahkan catatan keuangan !"),
                );
              }
              gettotalSaldo(snapshot.data!);
              return ListView(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 180,
                    padding: EdgeInsets.only(left: 10.0, right: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade800,
                              offset: Offset(0, 4),
                              blurRadius: 8)
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "Total Saldo",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Text(
                          "$totalSaldo IDR ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 26.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              cardIncome(totalPemasukan.toString()),
                              cardExpense(totalPengeluaran.toString()),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 7.0,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 7.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(
                      12.0,
                    ),
                    child: Text(
                      "Catatan Keuangan",
                      style: TextStyle(
                        fontSize: 26.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:
                          snapshot.data == null ? 0 : snapshot.data!.length + 1,
                      itemBuilder: (context, index) {
                        TransactionModel dataAtIndex;
                        try {
                          // dataAtIndex = snapshot.data![index];
                          dataAtIndex = snapshot.data![index];
                        } catch (e) {
                          // deleteAt deletes that key and value,
                          // hence makign it null here., as we still build on the length.
                          return Container();
                        }

                        if (dataAtIndex.type == "Income") {
                          return IncomeTile(
                              dataAtIndex.amount,
                              dataAtIndex.note,
                              dataAtIndex.date,
                              dataAtIndex.type,
                              index);
                        } else {
                          return expenseTile(
                              dataAtIndex.amount,
                              dataAtIndex.note,
                              dataAtIndex.date,
                              dataAtIndex.type,
                              index);
                        }
                      }),
                  SizedBox(
                    height: 60.0,
                  ),
                ],
              );
            } else {
              return Center(
                child: Text("Error!"),
              );
            }
          }),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) => AddTransaction(),
                  ),
                )
                    .whenComplete(() {
                  setState(() {});
                });
              },
              child: const Icon(
                Icons.add,
                size: 40,
              ));
        },
      ),
    );
  }

  Widget expenseTile(
      int value, String note, DateTime date, String type, int index) {
    return InkWell(
      onLongPress: () async {
        bool? answer = await showConfirmDialog(
          context,
          "Warning",
          "Apakah anda ingin menghapus catatan keuangan ini ?",
        );
        if (answer != null && answer) {
          await dbHelper.deleteData(index);
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) =>
          //         AddTransaction(index: index, amount: value.toString()),
          //   ),
          // );
          setState(() {});
        }
        //  else {
        //   Navigator.of(context).push(
        //     MaterialPageRoute(
        //       builder: (context) =>
        //           AddTransaction(index: index, amount: value.toString()),
        //     ),
        //   );
        //   setState(() {});
        // }
      },
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddTransaction(
                  index: index,
                  amount: value.toString(),
                  notes: note,
                  date: date,
                  type: type),
            ),
          );
          setState(() {});
        },
        child: Container(
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.all(18.0),
          decoration: BoxDecoration(
              color: Color(0xfffac5c5),
              borderRadius: BorderRadius.circular(8.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_circle_down_outlined,
                        size: 28.0,
                        color: Colors.red[700],
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        "Pengeluaran",
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      "${date.day} ${months[date.month - 1]} ${date.year}",
                      style: TextStyle(
                        color: Colors.grey[800],
                        // fontSize: 24.0,
                        // fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    " - $value IDR",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    note,
                    style: TextStyle(color: Colors.grey[800]
                        // fontSize: 24.0,
                        // fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

////////////////

  Widget IncomeTile(
      int value, String note, DateTime date, String type, int index) {
    return InkWell(
      onLongPress: () async {
        bool? answer = await showConfirmDialog(
          context,
          "Warning",
          "Apakah anda ingin menghapus catatan keuangan ini ?",
        );
        if (answer != null && answer) {
          await dbHelper.deleteData(index);
          setState(() {});
        }
      },
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddTransaction(
                  index: index,
                  amount: value.toString(),
                  notes: note,
                  date: date,
                  type: type),
            ),
          );
          setState(() {});
        },
        child: Container(
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.all(18.0),
          decoration: BoxDecoration(
              color: Color(0xffd8fac5),
              // Color(0xffced4eb),
              borderRadius: BorderRadius.circular(8.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_circle_up_outlined,
                        size: 28.0,
                        color: Colors.green[700],
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        "Pemasukan",
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      "${date.day} ${months[date.month - 1]} ${date.year}",
                      style: TextStyle(
                        color: Colors.grey[800],
                        // fontSize: 24.0,
                        // fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    " + $value IDR",
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    note,
                    style: TextStyle(
                      color: Colors.grey[800],
                      // fontSize: 24.0,
                      // fontWeight: FontWeight.w700
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget cardIncome(String value) {
  return Row(
    children: [
      Container(
        decoration: BoxDecoration(
          color: fromCssColor('#A6D1E6'),
          borderRadius: BorderRadius.circular(
            20.0,
          ),
        ),
        padding: EdgeInsets.all(6.0),
        child: Icon(
          Icons.arrow_upward,
          size: 28.0,
          color: Colors.green[700],
        ),
        margin: EdgeInsets.only(right: 8.0),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pemasukan",
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
          Text(
            "$value IDR ",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget cardExpense(String value) {
  return Row(
    children: [
      Container(
        decoration: BoxDecoration(
          color: fromCssColor('#A6D1E6'),
          borderRadius: BorderRadius.circular(
            20.0,
          ),
        ),
        padding: EdgeInsets.all(6.0),
        child: Icon(
          Icons.arrow_downward,
          size: 28.0,
          color: Colors.red[700],
        ),
        margin: EdgeInsets.only(right: 8.0),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pengeluaran",
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
          Text(
            "$value IDR",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ],
  );
}

////////////
