import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:num_game/bloc/activity_bloc.dart';
import 'package:num_game/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ActivityBloc activityBloc;
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
    activityBloc = BlocProvider.of(context);
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString("data");
    if (encodedData != null) {
      SharedObject _data = SharedObject.fromJson(encodedData);
      data = _data.data;
      activityBloc.add(SearchAgain(excelData: data));
    }
  }

  List<List>? data = [];
  List<List> filteredata = [];
  String fileName = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Number Game"),
        centerTitle: true,
      ),
      body: Center(
        child: BlocConsumer<ActivityBloc, ActivityState>(
          listener: (context, state) {
            if (state is SelectedExcelFile) {
              data = List.from(state.data!);

              if (fileName == "") {
                fileName = data![0][0];
              }
            } else if (state is RecordsFoundState) {
              print(data!.length);
              filteredata = List.from(state.excelData);
            }
          },
          builder: (context, state) {
            if (state is SelectedExcelFile) {
              return Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildRichText("", fileName),
                            IconButton(
                              icon: const Icon(Icons.change_circle_rounded),
                              onPressed: () {
                                fileName = "";
                                activityBloc.add(SelectExcelFile());
                              },
                            )
                          ],
                        )),
                  ),
                  const Divider(color: Colors.grey),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Please enter the amount below to search:",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const Divider(
                          height: 30,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 170,
                          child: TextFormField(
                              controller: amountController,
                              textAlign: TextAlign.center,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              )),
                        ),
                        const Divider(
                          height: 30,
                          color: Colors.white,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            activityBloc.add(SearchExcelFile(
                                excelData:List.from( data!),
                                amountToBeSearched:
                                    num.parse(amountController.text)));
                          },
                          child: const Text("Search"),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(120, 50),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is NoRecordsFoundState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "No Records Found",
                    style: TextStyle(fontSize: 18),
                  ),
                  const Divider(
                    color: Colors.white,
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      amountController.clear();
                      activityBloc.add(SearchAgain(excelData: data));
                    },
                    child: const Text("Clear Filters"),
                    style: ElevatedButton.styleFrom(),
                  ),
                ],
              );
            } else if (state is RecordsFoundState) {
              filteredata = state.excelData;
              return Column(
                children: [
                  GridView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: filteredata.length,
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 5,
                        mainAxisSpacing: 20,
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 5.0,
                                  spreadRadius: 3.0,
                                )
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildRichText(
                                    "Name: ", "${filteredata[index][0]}"),
                                buildRichText(
                                    "Amount: ", "${filteredata[index][1]}"),
                              ],
                            ),
                          ),
                        );
                      }),
                  const Divider(
                    color: Colors.white,
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      filteredata = List.from(data!);
                      amountController.clear();
                      activityBloc.add(SearchAgain(excelData: data));
                    },
                    child: const Text("Search Again"),
                    style: ElevatedButton.styleFrom(),
                  ),
                ],
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Please select the excel file',
                  // : "newFile.xls",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const Divider(
                  height: 20,
                  color: Colors.white,
                ),
                ElevatedButton(
                    onPressed: () {
                      activityBloc.add(SelectExcelFile());
                    },
                    child: const Text("Select File"))
              ],
            );
          },
        ),
      ),
    );
  }
}

RichText buildRichText(String? key, String? value) {
  return RichText(
    textAlign: TextAlign.left,
    text: TextSpan(
      text: "$key",
      style: const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      children: [
        TextSpan(
          text: "$value",
          style: const TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.normal),
        )
      ],
    ),
  );
}
/* Container(
                          // height: 60,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black45)),
                          child: const Text(
                            'Rs',
                            style: TextStyle(fontSize: 20),
                          )),
                      const Divider(
                        color: Colors.white,
                        indent: 1,
                      ), */