import 'package:flutter/material.dart';
import '../../core/services/http_client_service.dart';
import '../../data/datasources/remote_data_source.dart';
import '../../data/datasources/mock_data_source.dart';
import '../../data/models/course.dart';
import '../../data/models/lesson.dart';
import '../../data/repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final HttpClientService _httpClient = HttpClientService();
  late CourseRepository _repository;
  final MockDataSource _mockDataSource = MockDataSource();

  List<Course> _courses = [];
  List<Lesson> _currentLessons = [];
  bool _isLoading = false;
  String? _error;

  CourseProvider() {
    final remoteDataSource = RemoteDataSource(httpClient: _httpClient);
    _repository = CourseRepository(remoteDataSource: remoteDataSource);
  }

  List<Course> get courses => _courses;
  List<Lesson> get currentLessons => _currentLessons;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Load from mock data instantly for offline-first app
      _courses = await _mockDataSource.getCourses();
      _error = null;
    } catch (e) {
      _error = 'Failed to load courses';
      _courses = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCourseLessons(int courseId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Load from mock data for instant loading
      _currentLessons = await _mockDataSource.getCourseLessons(courseId);
      _error = null;
    } catch (e) {
      _error = 'Failed to load lessons';
      _currentLessons = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
