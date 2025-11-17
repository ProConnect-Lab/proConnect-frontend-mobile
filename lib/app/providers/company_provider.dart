import 'package:get/get.dart';

import '../exceptions/app_exception.dart';
import '../models/company.dart';
import '../models/company_payload.dart';
import '../repositories/company_repository.dart';

class CompanyController extends GetxController {
  CompanyController(this._repository);

  final CompanyRepository _repository;

  final RxList<Company> companies = <Company>[].obs;
  final RxBool _isLoading = false.obs;
  final RxnString _error = RxnString();

  bool get isLoading => _isLoading.value;
  String? get error => _error.value;

  Future<void> fetchCompanies() async {
    _setLoading(true);
    try {
      final items = await _repository.fetchCompanies();
      companies.assignAll(items);
      _error.value = null;
    } catch (error) {
      _error.value = _formatError(error);
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createCompany(CompanyPayload payload) async {
    try {
      final company = await _repository.createCompany(payload);
      companies.add(company);
      return true;
    } catch (error) {
      _error.value = _formatError(error);
      return false;
    }
  }

  Future<bool> updateCompany(int id, CompanyPayload payload) async {
    try {
      final company = await _repository.updateCompany(id, payload);
      final index = companies.indexWhere((item) => item.id == id);
      if (index != -1) {
        companies[index] = company;
      }
      return true;
    } catch (error) {
      _error.value = _formatError(error);
      return false;
    }
  }

  Future<bool> deleteCompany(int id) async {
    try {
      await _repository.deleteCompany(id);
      companies.removeWhere((company) => company.id == id);
      return true;
    } catch (error) {
      _error.value = _formatError(error);
      return false;
    }
  }

  void reset() {
    companies.clear();
    _error.value = null;
    _isLoading.value = false;
  }

  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  String _formatError(Object error) {
    if (error is AppException) {
      return error.message;
    }
    return 'Impossible de charger les entreprises.';
  }
}
