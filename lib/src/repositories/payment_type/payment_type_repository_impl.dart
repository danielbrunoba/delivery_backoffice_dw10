import 'dart:developer';

import 'package:dio/dio.dart';

import '../../core/exceptions/repository_exception.dart';
import '../../core/rest_client/custom_dio.dart';
import '../../models/payment_type_model.dart';
import './payment_type_repository.dart';

class PaymentTypeRepositoryImpl implements PaymentTypeRepository {
  final CustomDio dio;

  PaymentTypeRepositoryImpl({required this. dio});
  @override
  Future<List<PaymentTypeModel>> findAll(bool? enabled) async {
    try {
      final paymentResult = await dio.auth().get(
        '/payment-types',
        queryParameters: {
          if (enabled != null) 'enable': enabled,
        },
      );
      return paymentResult.data
          .map<PaymentTypeModel>((p) => PaymentTypeModel.fromMap(p))
          .toList();
    } on DioError catch (e, s) {
      log('Erro ao buscar formas de pagamento', error: e, stackTrace: s);
      throw RepositoryException(message: 'Erro ao buscar formas de pagamento');
    }
  }

  @override
  Future<PaymentTypeModel> getById(int id) async {
    try {
      final paymentResult = await dio.auth().get(
            '/payment-types/$id',
          );
      return PaymentTypeModel.fromMap(paymentResult.data);
    } on DioError catch (e, s) {
      log('Erro ao buscar formas de pagamento $id', error: e, stackTrace: s);
      throw RepositoryException(
          message: 'Erro ao buscar formas de pagamento $id',);
    }
  }

  @override
  Future<void> save(PaymentTypeModel model) async {
    try {
      final client = dio.auth();

      if (model.id != null) {
        await client.put(
          '/payment-types/${model.id}',
          data: model.toMap(),
        );
      } else {
        await client.post(
          '/payment-types/',
          data: model.toMap(),
        );
      }
    } on DioError catch (e, s) {
      log('Erro ao salvar forma de pagamento', error: e, stackTrace: s);
      throw RepositoryException(message: 'Erro ao salvar forma de pagamento');
    }
  }
}