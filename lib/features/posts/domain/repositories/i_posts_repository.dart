import 'package:paymeterjsonplaceholder/core/domain/models/result.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/paginated_posts.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/pagination_params.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/post_model.dart';

abstract class IPostsRepository {
  AsyncResult<PaginatedPosts> getPosts(PaginationParams params);

  AsyncResult<PostModel> getPost(int id);
}
