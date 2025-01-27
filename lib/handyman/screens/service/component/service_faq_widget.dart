import 'package:flutter_sixvalley_ecommerce/handyman/model/service_detail_response.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceFaqWidget extends StatelessWidget {
  const ServiceFaqWidget({Key? key, required this.serviceFaq}) : super(key: key);

  final ServiceFaq serviceFaq;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(serviceFaq.title.validate(), style: primaryTextStyle()),
      tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      children: [
        ListTile(
          title: Text(serviceFaq.description.validate(), style: secondaryTextStyle(), textAlign: TextAlign.justify),
          contentPadding: EdgeInsets.only(left: 32, right: 16),
        ),
      ],
    );
  }
}
