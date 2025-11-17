import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/theme/app_theme.dart';
import '../../../../common/widgets/error_handler.dart';
import '../../../../common/widgets/premium_card.dart';
import '../../../models/company.dart';
import '../../../models/post.dart';
import '../../../models/post_payload.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/company_provider.dart';
import '../../../providers/post_provider.dart';

class PostsTab extends StatefulWidget {
  const PostsTab({super.key});

  @override
  State<PostsTab> createState() => _PostsTabState();
}

class _PostsTabState extends State<PostsTab> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postController = Get.find<PostController>();
    final companyController = Get.find<CompanyController>();
    final authController = Get.find<AuthController>();

    return Obx(() {
      final isLoading = postController.isLoading;
      final posts = postController.posts;
      final companies = companyController.companies;
      final showOnlyMine = postController.showOnlyMine;
      final currentUser = authController.user;

      return RefreshIndicator(
        onRefresh: () => postController.fetchPosts(),
        child: CustomScrollView(
          slivers: [
            // Header moderne avec gradient
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
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
                              'Publications',
                              style: GoogleFonts.inter(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${posts.length} publication${posts.length > 1 ? 's' : ''}',
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
                            Icons.article,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Barre de recherche
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Rechercher...',
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: Colors.white),
                                onPressed: () {
                                  _searchController.clear();
                                  postController.fetchPosts(query: '');
                                  setState(() {});
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) => setState(() {}),
                      onSubmitted: (value) =>
                          postController.fetchPosts(query: value.trim()),
                    ),
                  ],
                ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Filtres et bouton ajouter
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppTheme.primaryColor.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => postController.fetchPosts(onlyMine: false),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(14),
                                  bottomLeft: Radius.circular(14),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    gradient: !showOnlyMine
                                        ? AppTheme.primaryGradient
                                        : null,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(14),
                                      bottomLeft: Radius.circular(14),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.public,
                                        size: 18,
                                        color: !showOnlyMine
                                            ? Colors.white
                                            : AppTheme.textSecondaryColor,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Toutes',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: !showOnlyMine
                                              ? Colors.white
                                              : AppTheme.textSecondaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () => postController.fetchPosts(onlyMine: true),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(14),
                                  bottomRight: Radius.circular(14),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    gradient: showOnlyMine
                                        ? AppTheme.primaryGradient
                                        : null,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(14),
                                      bottomRight: Radius.circular(14),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.person,
                                        size: 18,
                                        color: showOnlyMine
                                            ? Colors.white
                                            : AppTheme.textSecondaryColor,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Mes posts',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: showOnlyMine
                                              ? Colors.white
                                              : AppTheme.textSecondaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Bouton ajouter
                    Container(
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _openPostDialog(context, companies: companies),
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Liste des publications
            if (isLoading)
              const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            else if (posts.isEmpty)
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
                          Icons.article_outlined,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _searchController.text.isEmpty
                            ? 'Aucune publication'
                            : 'Aucun résultat',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _searchController.text.isEmpty
                            ? 'Créez votre première publication'
                            : 'Essayez une autre recherche',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      if (_searchController.text.isEmpty) ...[
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => _openPostDialog(context, companies: companies),
                          icon: const Icon(Icons.add),
                          label: const Text('Créer une publication'),
                        ),
                      ],
                    ],
                  ).animate().fadeIn(delay: 600.ms).scale(delay: 600.ms),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final post = posts[index];
                    final isMyPost = currentUser?.name == post.authorName;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: PremiumCard(
                        onTap: () => _showPostDetails(context, post),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // En-tête avec auteur
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    gradient: isMyPost
                                        ? AppTheme.primaryGradient
                                        : LinearGradient(
                                            colors: [
                                              AppTheme.accentColor,
                                              AppTheme.accentLight,
                                            ],
                                          ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      post.authorName.isNotEmpty
                                          ? post.authorName[0].toUpperCase()
                                          : '?',
                                      style: GoogleFonts.inter(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        post.authorName,
                                        style: GoogleFonts.inter(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.textPrimaryColor,
                                        ),
                                      ),
                                      if (post.company != null)
                                        Text(
                                          post.company!.name,
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            color: AppTheme.textSecondaryColor,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                if (isMyPost)
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
                                        _openPostDialog(
                                          context,
                                          post: post,
                                          companies: companies,
                                        );
                                      } else {
                                        _deletePost(post.id, post.title);
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
                            const SizedBox(height: 16),
                            // Titre
                            Text(
                              post.title,
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Contenu
                            Text(
                              post.content,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                color: AppTheme.textSecondaryColor,
                                height: 1.5,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(delay: (500 + index * 100).ms)
                          .slideY(begin: 0.2),
                    );
                  },
                  childCount: posts.length,
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      );
    });
  }

  void _showPostDetails(BuildContext context, PostModel post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, controller) => SingleChildScrollView(
            controller: controller,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Barre de drag
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.textDisabledColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Auteur
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            post.authorName.isNotEmpty
                                ? post.authorName[0].toUpperCase()
                                : '?',
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.authorName,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (post.company != null)
                            Text(
                              post.company!.name,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Titre
                  Text(
                    post.title,
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Contenu
                  Text(
                    post.content,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppTheme.textSecondaryColor,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Bouton fermer
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Fermer'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _deletePost(int id, String title) async {
    final confirm = await ErrorHandler.showConfirmDialog(
      title: 'Supprimer la publication',
      message: 'Voulez-vous vraiment supprimer "$title" ?',
      confirmText: 'Supprimer',
      isDangerous: true,
    );

    if (confirm == true) {
      final controller = Get.find<PostController>();
      final success = await controller.deletePost(id);

      if (success) {
        await Get.find<AuthController>().fetchProfile();
        ErrorHandler.showSuccessSnackbar('Publication supprimée');
      } else {
        ErrorHandler.showErrorSnackbar('Erreur lors de la suppression');
      }
    }
  }

  Future<void> _openPostDialog(
    BuildContext context, {
    PostModel? post,
    required List<Company> companies,
  }) async {
    final titleController = TextEditingController(text: post?.title ?? '');
    final contentController = TextEditingController(text: post?.content ?? '');
    int? selectedCompanyId = post?.company?.id;
    final formKey = GlobalKey<FormState>();
    final postController = Get.find<PostController>();

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
                Icons.article_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              post == null ? 'Nouvelle publication' : 'Modifier',
            ),
          ],
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Titre',
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Champ requis' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: 'Contenu',
                    prefixIcon: Icon(Icons.description_outlined),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Champ requis' : null,
                ),
                const SizedBox(height: 16),
                if (companies.isNotEmpty)
                  DropdownButtonFormField<int>(
                    initialValue: selectedCompanyId,
                    items: companies
                        .map(
                          (company) => DropdownMenuItem<int>(
                            value: company.id,
                            child: Text(company.name),
                          ),
                        )
                        .toList(),
                    decoration: const InputDecoration(
                      labelText: 'Entreprise (optionnel)',
                      prefixIcon: Icon(Icons.business_outlined),
                    ),
                    onChanged: (value) => selectedCompanyId = value,
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

              final payload = PostPayload(
                title: titleController.text.trim(),
                content: contentController.text.trim(),
                companyId: selectedCompanyId,
              );

              bool success;
              if (post == null) {
                success = await postController.createPost(payload);
              } else {
                success = await postController.updatePost(post.id, payload);
              }

              if (context.mounted) {
                Navigator.of(context).pop();
                if (success) {
                  await postController.fetchPosts();
                  await Get.find<AuthController>().fetchProfile();

                  ErrorHandler.showSuccessSnackbar(
                    post == null
                        ? 'Publication créée'
                        : 'Publication modifiée',
                  );
                } else {
                  ErrorHandler.showErrorSnackbar(
                    'Erreur lors de l\'enregistrement',
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
}
