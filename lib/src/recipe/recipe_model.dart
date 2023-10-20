import 'package:flutter/material.dart';

class ProcedureList extends StatelessWidget {
  //作り方手順を表示させるクラス
  final List<String>? procedures;

  ProcedureList({required this.procedures});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: procedures != null
          ? List.generate(procedures!.length, (index) {
              String procedureText = procedures![index];
              String inde = "${index}";
              String numberedText = "$inde$procedureText";
              return Padding(
                padding: const EdgeInsets.all(2),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      numberedText,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              );
            })
          : [],
    );
  }
}
