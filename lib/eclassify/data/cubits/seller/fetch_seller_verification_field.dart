﻿import '../../../exports/main_export.dart';
import '../../Repositories/seller/seller_verification_field_repository.dart';
import '../../model/CustomField/custom_field_model.dart';

abstract class FetchSellerVerificationFieldState {}

class FetchSellerVerificationFieldInitial
    extends FetchSellerVerificationFieldState {}

class FetchSellerVerificationFieldInProgress
    extends FetchSellerVerificationFieldState {}

class FetchSellerVerificationFieldSuccess
    extends FetchSellerVerificationFieldState {
  final List<VerificationFieldModel> fields;

  FetchSellerVerificationFieldSuccess(this.fields);
}

class FetchSellerVerificationFieldFail
    extends FetchSellerVerificationFieldState {
  final dynamic error;

  FetchSellerVerificationFieldFail(this.error);
}

class FetchSellerVerificationFieldsCubit
    extends Cubit<FetchSellerVerificationFieldState> {
  FetchSellerVerificationFieldsCubit()
      : super(FetchSellerVerificationFieldInitial());
  final SellerVerificationFieldRepository sellerVerificationFieldRepository =
      SellerVerificationFieldRepository();

  void fetchSellerVerificationFields() async {
    try {
      emit(FetchSellerVerificationFieldInProgress());
      List<VerificationFieldModel> result =
          await sellerVerificationFieldRepository.getSellerVerificationFields();

      emit(FetchSellerVerificationFieldSuccess(result));
    } catch (e) {
      emit(FetchSellerVerificationFieldFail(e.toString()));
    }
  }

//while edit
  void fillCustomFields(List<VerificationFieldModel> fields) {
    emit(FetchSellerVerificationFieldSuccess(fields));
  }

  List<VerificationFieldModel> getFields() {
    if (state is FetchSellerVerificationFieldSuccess) {
      return (state as FetchSellerVerificationFieldSuccess).fields;
    }
    return [];
  }

  bool? isEmpty() {
    if (state is FetchSellerVerificationFieldSuccess) {
      return (state as FetchSellerVerificationFieldSuccess).fields.isEmpty;
    }
    return null;
  }
}