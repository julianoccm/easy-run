import 'package:flutter/material.dart';
import 'package:frontend/resources/colors.dart';

class RaceCard extends StatelessWidget {
  final String date;
  final String kilometragem;
  final String horaInicial;
  final String horaFinal;
  final VoidCallback onPressed;

  const RaceCard(
      {super.key,
      required this.horaFinal,
      required this.horaInicial,
      required this.kilometragem,
      required this.date,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            color: appColors['secondaryDark'],
            borderRadius: BorderRadius.circular(8)),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(date,
                        style: TextStyle(
                          color: appColors['white'],
                          fontSize: 16,
                        )),
                    const Padding(padding: EdgeInsets.only(bottom: 5)),
                    Text("$kilometragem Km",
                        style: TextStyle(
                          color: appColors['white'],
                          fontSize: 16,
                        ))
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.only(right: 40)),
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 20),
                child: Text("$horaInicial - $horaFinal",
                    style: TextStyle(
                      color: appColors['white'],
                      fontSize: 16,
                    )),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(Icons.chevron_right,
                        color: appColors['primary'], size: 40),
                  ),
                ),
              )
            ]),
      ),
    );
  }
}
