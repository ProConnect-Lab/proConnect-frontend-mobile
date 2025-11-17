class PostPayload {
  PostPayload({
    required this.title,
    required this.content,
    this.companyId,
  });

  final String title;
  final String content;
  final int? companyId;

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        if (companyId != null) 'company_id': companyId,
      };
}
