// https://hardenberg-gymnasium.de/wp-json/wp/v2/posts/?_embed&per_page=25&page=
class Post{
  final String date;
  final String date_gmt;
  final String guid;
  final String id;
  final String link;
  final String modified;
  final String modified_gmt;
  final String slug;
  final String status;
  final String type;
  final String password;
  final String permalink_template;
  final String generated_slug;
  final String title;
  final String content;
  final String author;
  final String excerpt;
  final String featured_media;
  final String comment_status;
  final String ping_status;
  final String format;
  final String meta;
  final String sticky;
  final String template;
  final String categories;
  final String tags;

  Post(this.date, this.date_gmt, this.guid, this.id, this.link, this.modified, this.modified_gmt, this.slug, this.status, this.type, this.password, this.permalink_template, this.generated_slug, this.title, this.content, this.author, this.excerpt, this.featured_media, this.comment_status, this.ping_status, this.format, this.meta, this.sticky, this.template, this.categories, this.tags);

  Post.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        date_gmt = json['date_gmt'],
        guid = json['guid'],
        id = json['id'],
        link = json['link'],
        modified = json['modified'],
        modified_gmt = json['modified_gmt'],
        slug = json['slug'],
        status = json['status'],
        type = json['type'],
        password = json['password'],
        permalink_template = json['permalink_template'],
        generated_slug = json['generated_slug'],
        title = json['title'],
        content = json['content'],
        author = json['author'],
        excerpt = json['excerpt'],
        featured_media = json['featured_media'],
        comment_status = json['comment_status'],
        ping_status = json['ping_status'],
        format = json['format'],
        meta = json['meta'],
        sticky = json['sticky'],
        template = json['template'],
        categories = json['categories'],
        tags = json['tags'];

  Map<String, dynamic> toJson() =>
      {
        'date': date,
        'date_gmt': date_gmt,
        'guid': guid,
        'id': id,
        'link': link,
        'modified': modified,
        'modified_gmt': modified_gmt,
        'slug': slug,
        'status': status,
        'type': type,
        'password': password,
        'permalink_template': permalink_template,
        'generated_slug': generated_slug,
        'title': title,
        'content': content,
        'author': author,
        'excerpt': excerpt,
        'featured_media': featured_media,
        'comment_status': comment_status,
        'ping_status': ping_status,
        'format': format,
        'meta': meta,
        'sticky': sticky,
        'template': template,
        'categories': categories,
        'tags': tags,
      };
}