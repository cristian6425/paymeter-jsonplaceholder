import 'package:paymeterjsonplaceholder/core/domain/models/result.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/create_post_params.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/paginated_posts.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/update_post_params.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/pagination_params.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/post_model.dart';

abstract class IPostsRepository {
  AsyncResult<PaginatedPosts> getPosts(PaginationParams params);

  AsyncResult<PostModel> getPost(int id);

  AsyncResult<PostModel> createPost(CreatePostParams params);

  AsyncResult<PostModel> updatePost(UpdatePostParams params);

  AsyncResult<PostModel> patchPost(PatchPostParams params);
}
