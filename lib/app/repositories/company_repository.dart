import '../models/company.dart';
import '../models/company_payload.dart';
import '../services/api_service.dart';

class CompanyRepository {
  CompanyRepository(this._apiService);

  final ApiService _apiService;

  Future<List<Company>> fetchCompanies() async {
    final response = await _apiService.get('/companies');
    final companies = response['companies'] as List<dynamic>;
    return companies
        .map((company) => Company.fromJson(company as Map<String, dynamic>))
        .toList();
  }

  Future<Company> createCompany(CompanyPayload payload) async {
    final response = await _apiService.post('/companies', data: payload.toJson());
    return Company.fromJson(response['company'] as Map<String, dynamic>);
  }

  Future<Company> updateCompany(int id, CompanyPayload payload) async {
    final response =
        await _apiService.put('/companies/$id', data: payload.toJson());
    return Company.fromJson(response['company'] as Map<String, dynamic>);
  }

  Future<void> deleteCompany(int id) => _apiService.delete('/companies/$id');
}
