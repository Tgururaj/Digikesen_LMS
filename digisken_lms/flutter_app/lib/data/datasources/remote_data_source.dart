import '../../core/services/http_client_service.dart';
import '../models/course.dart';
import '../models/lesson.dart';

class RemoteDataSource {
  final HttpClientService httpClient;

  RemoteDataSource({required this.httpClient});

  Future<List<Course>> getCourses() async {
    try {
      final response = await httpClient.get('/api/lms/courses');
      final List<dynamic> data = response.data;
      return data.map((json) => Course.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Course> getCourseDetail(int courseId) async {
    try {
      final response = await httpClient.get('/api/lms/courses/$courseId');
      return Course.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Lesson>> getCourseLessons(int courseId) async {
    try {
      final response =
          await httpClient.get('/api/lms/courses/$courseId/lessons');
      final List<dynamic> data = response.data;
      return data.map((json) => Lesson.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Lesson> getLesson(int lessonId) async {
    try {
      final response = await httpClient.get('/api/lms/lessons/$lessonId');
      return Lesson.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
