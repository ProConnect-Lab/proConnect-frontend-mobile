import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/theme/app_theme.dart';
import '../../../../common/widgets/error_handler.dart';
import '../../../../common/widgets/premium_card.dart';
import '../../../models/company.dart';
import '../../../models/company_payload.dart';
import '../../../providers/company_provider.dart';

class CompaniesTab extends StatefulWidget {
  const CompaniesTab({super.key});

  @override
  State<CompaniesTab> createState() => _CompaniesTabState();
}

class _CompaniesTabState extends State<CompaniesTab> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cfeController = TextEditingController();
  final _addressController = TextEditingController();
  bool _showForm = false;

  @override
  void dispose() {
    _nameController.dispose();
    _cfeController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CompanyController>();

    return Obx(() {
      final isLoading = controller.isLoading;
      final companies = controller.companies;

      return RefreshIndicator(
        onRefresh: () => controller.fetchCompanies(),
        child: CustomScrollView(
          slivers: [
            // Header moderne
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
                decoration: const BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mes Entreprises',
                              style: GoogleFonts.inter(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${companies.length} entreprise${companies.length > 1 ? 's' : ''}',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.business,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ],
                ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Bouton ajouter avec animation
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _showForm = !_showForm;
                        });
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: _showForm
                              ? null
                              : AppTheme.primaryGradient,
                          color: _showForm ? Colors.white : null,
                          borderRadius: BorderRadius.circular(16),
                          border: _showForm
                              ? Border.all(
                                  color: AppTheme.primaryColor,
                                  width: 2,
                                )
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor
                                  .withValues(alpha: 0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _showForm ? Icons.close : Icons.add_circle,
                              color: _showForm
                                  ? AppTheme.primaryColor
                                  : Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _showForm
                                  ? 'Annuler'
                                  : 'Ajouter une entreprise',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _showForm
                                    ? AppTheme.primaryColor
                                    : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
              ),
            ),

            // Formulaire d'ajout avec animation
            if (_showForm)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: PremiumCard(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nouvelle entreprise',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Nom de l\'entreprise',
                              prefixIcon: Icon(Icons.business_outlined),
                            ),
                            validator: _required,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _cfeController,
                            decoration: const InputDecoration(
                              labelText: 'Numéro CFE',
                              prefixIcon: Icon(Icons.numbers),
                            ),
                            validator: _required,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _addressController,
                            decoration: const InputDecoration(
                              labelText: 'Adresse',
                              prefixIcon: Icon(Icons.location_on_outlined),
                            ),
                            maxLines: 2,
                            validator: _required,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.save, size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Enregistrer',
                                          style: GoogleFonts.inter(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 300.ms)
                      .slideY(begin: -0.2, end: 0),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 10)),

            // Liste des entreprises
            if (companies.isEmpty && !_showForm)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.business_outlined,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Aucune entreprise',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ajoutez votre première entreprise\npour commencer',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: AppTheme.textSecondaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ).animate().fadeIn(delay: 600.ms).scale(delay: 600.ms),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final company = companies[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: PremiumCard(
                        onTap: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    gradient: AppTheme.primaryGradient,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(
                                    Icons.business,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        company.name,
                                        style: GoogleFonts.inter(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.textPrimaryColor,
                                        ),
                                      ),
                                      if (company.cfeNumber != null) ...[
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.numbers,
                                              size: 14,
                                              color: AppTheme.textSecondaryColor,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'CFE: ${company.cfeNumber}',
                                              style: GoogleFonts.inter(
                                                fontSize: 13,
                                                color:
                                                    AppTheme.textSecondaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                // Actions
                                PopupMenuButton<String>(
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: AppTheme.textSecondaryColor,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      _editCompany(company);
                                    } else {
                                      _deleteCompany(
                                        company.id,
                                        company.name,
                                      );
                                    }
                                  },
                                  itemBuilder: (_) => [
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.edit_outlined,
                                            size: 20,
                                            color: AppTheme.primaryColor,
                                          ),
                                          SizedBox(width: 12),
                                          Text('Modifier'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.delete_outline,
                                            size: 20,
                                            color: AppTheme.errorColor,
                                          ),
                                          SizedBox(width: 12),
                                          Text('Supprimer'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (company.address != null) ...[
                              const SizedBox(height: 16),
                              Divider(
                                color: AppTheme.textDisabledColor
                                    .withValues(alpha: 0.3),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 18,
                                    color: AppTheme.accentColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      company.address!,
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: AppTheme.textSecondaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(delay: (500 + index * 100).ms)
                          .slideX(begin: -0.2),
                    );
                  },
                  childCount: companies.length,
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      );
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      ErrorHandler.showWarningSnackbar('Veuillez remplir tous les champs');
      return;
    }

    final payload = CompanyPayload(
      name: _nameController.text.trim(),
      cfeNumber: _cfeController.text.trim(),
      address: _addressController.text.trim(),
    );

    final controller = Get.find<CompanyController>();
    final success = await controller.createCompany(payload);

    if (success) {
      _nameController.clear();
      _cfeController.clear();
      _addressController.clear();
      setState(() {
        _showForm = false;
      });
      ErrorHandler.showSuccessSnackbar('Entreprise ajoutée avec succès');
    } else {
      ErrorHandler.showErrorSnackbar(
        'Erreur lors de l\'ajout de l\'entreprise',
      );
    }
  }

  Future<void> _editCompany(Company company) async {
    final nameController = TextEditingController(text: company.name);
    final cfeController = TextEditingController(text: company.cfeNumber);
    final addressController = TextEditingController(text: company.address);
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.edit_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Modifier l\'entreprise'),
          ],
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom de l\'entreprise',
                    prefixIcon: Icon(Icons.business_outlined),
                  ),
                  validator: _required,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: cfeController,
                  decoration: const InputDecoration(
                    labelText: 'Numéro CFE',
                    prefixIcon: Icon(Icons.numbers),
                  ),
                  validator: _required,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Adresse',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  validator: _required,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!(formKey.currentState?.validate() ?? false)) {
                ErrorHandler.showWarningSnackbar(
                  'Veuillez remplir tous les champs',
                );
                return;
              }

              final payload = CompanyPayload(
                name: nameController.text.trim(),
                cfeNumber: cfeController.text.trim(),
                address: addressController.text.trim(),
              );

              final controller = Get.find<CompanyController>();
              final success = await controller.updateCompany(company.id, payload);

              if (context.mounted) {
                Navigator.of(context).pop();
                if (success) {
                  ErrorHandler.showSuccessSnackbar(
                    'Entreprise modifiée avec succès',
                  );
                } else {
                  ErrorHandler.showErrorSnackbar(
                    'Erreur lors de la modification',
                  );
                }
              }
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCompany(int id, String name) async {
    final confirm = await ErrorHandler.showConfirmDialog(
      title: 'Supprimer l\'entreprise',
      message: 'Voulez-vous vraiment supprimer "$name" ?',
      confirmText: 'Supprimer',
      isDangerous: true,
    );

    if (confirm == true) {
      final controller = Get.find<CompanyController>();
      final success = await controller.deleteCompany(id);

      if (success) {
        ErrorHandler.showSuccessSnackbar('Entreprise supprimée');
      } else {
        ErrorHandler.showErrorSnackbar('Erreur lors de la suppression');
      }
    }
  }

  String? _required(String? value) {
    if (value == null || value.isEmpty) {
      return 'Champ obligatoire';
    }
    return null;
  }
}
