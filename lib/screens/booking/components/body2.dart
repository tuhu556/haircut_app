import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:haircut_app/controllers/serviceController.dart';
import 'package:haircut_app/models/service.dart';
import 'package:haircut_app/repository/service/service_repository.dart';

class Body2 extends StatelessWidget {
  var serviceController = ServiceController(ServiceRepository());
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Service>>(
      future: serviceController.fechServiceList(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error'),
          );
        } else
          return Swiper(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return cardService(
                    snapshot.data[index].serviceName,
                    snapshot.data[index].price,
                    snapshot.data[index].durationTime,
                    false);
              });
      },
    );
  }
}

// ListView.builder(
//               itemCount: snapshot.data?.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return cardService(
//                     snapshot.data[index].serviceName,
//                     snapshot.data[index].price,
//                     snapshot.data[index].durationTime,
//                     false);
//               });
Widget cardService(
  String serviceName,
  double price,
  int durationTime,
  bool isSelected,
) {
  return GestureDetector(
    child: ListTile(
      title: Text(
        serviceName,
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text('Price: ' +
          price.toString() +
          ' - ' +
          'Duration Time: ' +
          durationTime.toString() +
          ' min'),
      isThreeLine: true,
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: Colors.green[700],
            )
          : Icon(
              Icons.check_circle_outline,
              color: Colors.grey,
            ),
    ),
    onTap: () {},
  );
}
