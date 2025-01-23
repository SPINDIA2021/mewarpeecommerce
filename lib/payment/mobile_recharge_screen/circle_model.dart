import 'dart:convert';

/// Status : "1"
/// SuccessMessage : "Success"
/// data : [{"circlecode":"36","circlename":"ANDAMAN AND NICOBAR ISLANDS"},{"circlecode":"1","circlename":"Andhra Pradesh"},{"circlecode":"26","circlename":"ARUNACHAL PRADESH"},{"circlecode":"2","circlename":"Assam"},{"circlecode":"3","circlename":"Bihar"},{"circlecode":"42","circlename":"Bihar and Jharkhand"},{"circlecode":"4","circlename":"Chennai"},{"circlecode":"27","circlename":"CHHATTISGARH"},{"circlecode":"41","circlename":"DADRA AND NAGAR"},{"circlecode":"40","circlename":"DAMAN AND DIU"},{"circlecode":"5","circlename":"Delhi"},{"circlecode":"28","circlename":"GOA"},{"circlecode":"6","circlename":"Gujarat"},{"circlecode":"7","circlename":"Haryana"},{"circlecode":"8","circlename":"Himachal Pradesh"},{"circlecode":"9","circlename":"Jammu & Kashmir"},{"circlecode":"24","circlename":"Jharkhand"},{"circlecode":"10","circlename":"Karnataka"},{"circlecode":"11","circlename":"Kerala"},{"circlecode":"12","circlename":"Kolkata"},{"circlecode":"39","circlename":"LAKSHADWEEP"},{"circlecode":"14","circlename":"MADHYA PRADESH CHHATTISGARH"},{"circlecode":"13","circlename":"Maharashtra"},{"circlecode":"29","circlename":"MANIPUR"},{"circlecode":"30","circlename":"MEGHALAYA"},{"circlecode":"31","circlename":"MIZORAM"},{"circlecode":"15","circlename":"Mumbai"},{"circlecode":"32","circlename":"NAGALAND"},{"circlecode":"16","circlename":"North East"},{"circlecode":"17","circlename":"Odisha"},{"circlecode":"38","circlename":"PUDUCHERRY"},{"circlecode":"18","circlename":"Punjab"},{"circlecode":"19","circlename":"Rajasthan"},{"circlecode":"33","circlename":"SIKKIM"},{"circlecode":"20","circlename":"Tamil Nadu"},{"circlecode":"37","circlename":"TELANGANA"},{"circlecode":"25","circlename":"TRIPURA"},{"circlecode":"34","circlename":"UTTAR PRADESH"},{"circlecode":"21","circlename":"Uttar Pradesh - East"},{"circlecode":"22","circlename":"Uttar Pradesh - West"},{"circlecode":"35","circlename":"UTTARAKHAND"},{"circlecode":"23","circlename":"West Bengal"}]

CircleModel circleModelFromJson(String str) => CircleModel.fromJson(json.decode(str));
String circleModelToJson(CircleModel data) => json.encode(data.toJson());

class CircleModel {
  CircleModel({
    String? status,
    String? successMessage,
    List<Data>? data,
  }) {
    _status = status;
    _successMessage = successMessage;
    _data = data;
  }

  CircleModel.fromJson(dynamic json) {
    _status = json['Status'];
    _successMessage = json['SuccessMessage'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  String? _status;
  String? _successMessage;
  List<Data>? _data;
  CircleModel copyWith({
    String? status,
    String? successMessage,
    List<Data>? data,
  }) =>
      CircleModel(
        status: status ?? _status,
        successMessage: successMessage ?? _successMessage,
        data: data ?? _data,
      );
  String? get status => _status;
  String? get successMessage => _successMessage;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Status'] = _status;
    map['SuccessMessage'] = _successMessage;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// circlecode : "36"
/// circlename : "ANDAMAN AND NICOBAR ISLANDS"

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    String? circlecode,
    String? circlename,
  }) {
    _circlecode = circlecode;
    _circlename = circlename;
  }

  Data.fromJson(dynamic json) {
    _circlecode = json['circlecode'];
    _circlename = json['circlename'];
  }
  String? _circlecode;
  String? _circlename;
  Data copyWith({
    String? circlecode,
    String? circlename,
  }) =>
      Data(
        circlecode: circlecode ?? _circlecode,
        circlename: circlename ?? _circlename,
      );
  String? get circlecode => _circlecode;
  String? get circlename => _circlename;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['circlecode'] = _circlecode;
    map['circlename'] = _circlename;
    return map;
  }
}
