import 'package:flutter_sixvalley_ecommerce/eclassify/data/model/data_output.dart';

import '../../utils/api.dart';
import '../model/ReportProperty/reason_model.dart';

class ReportItemRepository {
  Future<DataOutput<ReportReason>> fetchReportReasonsList() async {
    try {
      Map<String, dynamic> response = await Api.get(
        url: Api.getReportReasonsApi,
        queryParameters: {},
      );

      List<ReportReason> list = (response['data']['data'] as List).map((e) {
        return ReportReason(id: e["id"], reason: e['reason']);
      }).toList();

      return DataOutput(total: response['total'], modelList: list);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map> reportItem(
      {required int reasonId, required int itemId, String? message}) async {
    try {
      Map response = await Api.post(
        url: Api.addReportsApi,
        parameter: {
          "report_reason_id": (reasonId == -10) ? "" : reasonId,
          "item_id": itemId,
          if (message != null) "other_message": message
        },
      );


      return response;
    } catch (e) {
      rethrow;
    }
  }
}