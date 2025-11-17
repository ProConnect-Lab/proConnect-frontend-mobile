import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/custom_text_field.dart';
import '../../../common/widgets/error_handler.dart';
import '../../models/auth_payloads.dart';
import '../../providers/auth_provider.dart';

class RegisterModule extends StatefulWidget {
  const RegisterModule({super.key});

  @override
  State<RegisterModule> createState() => _RegisterModuleState();
}

class _RegisterModuleState extends State<RegisterModule> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _companyAddressController = TextEditingController();
  final _cfeController = TextEditingController();
  String _accountType = 'private';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _companyNameController.dispose();
    _companyAddressController.dispose();
    _cfeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un compte'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Obx(() {
          final isLoading = authController.isLoading;
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // En-tête
                const Text(
                  'Rejoignez ProConnect',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Créez votre compte en quelques étapes',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 32),

                // Section Informations personnelles
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person_outline, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 8),
                            const Text(
                              'Informations personnelles',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        CustomTextField(
                          controller: _nameController,
                          label: 'Nom complet',
                          prefixIcon: Icons.badge_outlined,
                          validator: _requiredValidator,
                        ),
                        const SizedBox(height: 16),

                        CustomTextField(
                          controller: _emailController,
                          label: 'Email',
                          hint: 'exemple@email.com',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email obligatoire';
                            }
                            if (!value.contains('@')) {
                              return 'Email invalide';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        CustomTextField(
                          controller: _addressController,
                          label: 'Adresse',
                          prefixIcon: Icons.home_outlined,
                          validator: _requiredValidator,
                        ),
                        const SizedBox(height: 16),

                        PasswordTextField(
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.length < 8) {
                              return 'Minimum 8 caractères';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Section Type de compte
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.work_outline, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 8),
                            const Text(
                              'Type de compte',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        DropdownButtonFormField<String>(
                          initialValue: _accountType,
                          decoration: const InputDecoration(
                            labelText: 'Sélectionnez votre type de compte',
                            prefixIcon: Icon(Icons.account_circle_outlined),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'private',
                              child: Text('Particulier'),
                            ),
                            DropdownMenuItem(
                              value: 'pro',
                              child: Text('Professionnel'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _accountType = value);
                            }
                          },
                        ),

                        if (_accountType == 'pro') ...[
                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 16),
                          const Text(
                            'Informations entreprise',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),

                          CustomTextField(
                            controller: _companyNameController,
                            label: 'Nom de l\'entreprise',
                            prefixIcon: Icons.business_outlined,
                            validator: _requiredValidator,
                          ),
                          const SizedBox(height: 16),

                          CustomTextField(
                            controller: _companyAddressController,
                            label: 'Adresse de l\'entreprise',
                            prefixIcon: Icons.location_on_outlined,
                            validator: _requiredValidator,
                          ),
                          const SizedBox(height: 16),

                          CustomTextField(
                            controller: _cfeController,
                            label: 'Numéro CFE',
                            prefixIcon: Icons.numbers,
                            validator: _requiredValidator,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Bouton de soumission
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Créer mon compte'),
                  ),
                ),
                const SizedBox(height: 16),

                // Lien retour
                Center(
                  child: TextButton(
                    onPressed: isLoading ? null : () => Get.back(),
                    child: const Text('Retour à la connexion'),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      ErrorHandler.showWarningSnackbar('Veuillez remplir tous les champs requis');
      return;
    }

    final payload = RegisterPayload(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      accountType: _accountType,
      address: _addressController.text.trim(),
      companyName:
          _accountType == 'pro' ? _companyNameController.text.trim() : null,
      companyAddress:
          _accountType == 'pro' ? _companyAddressController.text.trim() : null,
      cfeNumber: _accountType == 'pro' ? _cfeController.text.trim() : null,
    );

    final authController = Get.find<AuthController>();
    final success = await authController.register(payload);

    if (!mounted) return;

    if (success) {
      ErrorHandler.showSuccessSnackbar('Compte créé avec succès !');
      Get.back();
    } else {
      ErrorHandler.showErrorSnackbar(
        authController.error ?? 'Impossible de créer le compte',
      );
    }
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Champ obligatoire';
    }
    return null;
  }
}
