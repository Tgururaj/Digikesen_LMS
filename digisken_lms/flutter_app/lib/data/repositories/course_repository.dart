import '../datasources/remote_data_source.dart';
import '../models/course.dart';

class CourseRepository {
  final RemoteDataSource remoteDataSource;

  CourseRepository({required this.remoteDataSource});

  Future<List<Course>> getCourses() async {
    return await remoteDataSource.getCourses();
  }

  Future<Course> getCourseDetail(int courseId) async {
    return await remoteDataSource.getCourseDetail(courseId);
  }
}
