import 'package:flutter_sixvalley_ecommerce/features/splash/domain/repositories/splash_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/services/splash_service_interface.dart';

import '../../../../data/datasource/remote/dio/dio_client.dart';
import '../../../../di_container.dart';
import '../../../../utill/app_constants.dart';

class SplashService implements SplashServiceInterface{
  SplashRepositoryInterface splashRepositoryInterface;

  SplashService({required this.splashRepositoryInterface});

  @override
  void disableIntro() {
    return splashRepositoryInterface.disableIntro();
  }

  @override
  Future getConfig() async{
    // DioClient(AppConstants.baseUrl+AppConstants.categoriesUri, sl(), loggingInterceptor: sl(), sharedPreferences: sl());

    return splashRepositoryInterface.getConfig();
  }

  @override
  String getCurrency() {
    return splashRepositoryInterface.getCurrency();
  }

  @override
  void initSharedData() {
    return splashRepositoryInterface.initSharedData();
  }

  @override
  void setCurrency(String currencyCode) {
    return splashRepositoryInterface.setCurrency(currencyCode);
  }

  @override
  bool? showIntro() {
    return splashRepositoryInterface.showIntro();
  }

}