import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_providers.dart';
import 'lesson_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  final int courseId;

  const CourseDetailScreen({Key? key, required this.courseId})
      : super(key: key);

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<CourseProvider>().fetchCourseLessons(widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Details'),
        elevation: 0,
      ),
      body: Consumer<CourseProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Text('Error: ${provider.error}'),
            );
          }

          // Get course info
          final courseList =
              provider.courses.where((c) => c.id == widget.courseId);
          final course = courseList.isNotEmpty
              ? courseList.first
              : (provider.courses.isNotEmpty ? provider.courses[0] : null);

          if (course == null) {
            return const Center(child: Text('Course not found'));
          }

          return ListView(
            children: [
              // Course header
              Container(
                color: Color(
                    (course.thumbnailEmoji.hashCode & 0xFFFFFF) | 0xE8E8E8),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.thumbnailEmoji,
                      style: const TextStyle(fontSize: 64),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'by ${course.instructor}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              // Course stats
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat(
                      Icons.star,
                      course.rating.toStringAsFixed(1),
                      'Rating',
                    ),
                    _buildStat(
                      Icons.people,
                      '${(course.students / 1000).toStringAsFixed(0)}K',
                      'Students',
                    ),
                    _buildStat(
                      Icons.schedule,
                      course.duration,
                      'Duration',
                    ),
                    _buildStat(
                      Icons.book,
                      '${course.lessons}',
                      'Lessons',
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Course description
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About this course',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      course.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Lessons section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Course Lessons',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (provider.currentLessons.isEmpty)
                      const Text('No lessons available')
                    else
                      ...provider.currentLessons.map((lesson) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            leading: Icon(
                              lesson.contentType == 'video'
                                  ? Icons.play_circle
                                  : Icons.description,
                              color: Colors.blue,
                            ),
                            title: Text(
                              lesson.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Text('${lesson.durationMinutes} min',
                                    style: const TextStyle(fontSize: 12)),
                                const SizedBox(width: 12),
                                if (lesson.isCompleted)
                                  const Icon(
                                    Icons.check_circle,
                                    size: 14,
                                    color: Colors.green,
                                  ),
                              ],
                            ),
                            trailing: lesson.isCompleted
                                ? null
                                : const Icon(Icons.arrow_forward, size: 18),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LessonScreen(
                                    lessonId: lesson.id,
                                    lessonTitle: lesson.title,
                                    lesson: lesson,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.blue),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
