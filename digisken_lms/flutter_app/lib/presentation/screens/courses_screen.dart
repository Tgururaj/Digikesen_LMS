import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_providers.dart';
import 'course_detail_screen.dart';
import '../widgets/common_widgets.dart';

class CoursesScreen extends StatelessWidget {
  final String searchQuery;

  const CoursesScreen({Key? key, this.searchQuery = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return CommonWidgets.buildLoadingWidget();
        }

        if (provider.error != null) {
          return CommonWidgets.buildErrorWidget(provider.error!);
        }

        // Filter courses based on search query
        final filteredCourses = searchQuery.isEmpty
            ? provider.courses
            : provider.courses
                .where((course) =>
                    course.title.toLowerCase().contains(searchQuery) ||
                    course.description.toLowerCase().contains(searchQuery) ||
                    course.instructor.toLowerCase().contains(searchQuery) ||
                    course.category.toLowerCase().contains(searchQuery))
                .toList();

        if (filteredCourses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                const Text(
                  'No courses found',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try a different search term',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.65,
            crossAxisSpacing: 8,
            mainAxisSpacing: 10,
          ),
          itemCount: filteredCourses.length,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: true,
          itemBuilder: (context, index) {
            final course = filteredCourses[index];
            return CommonWidgets.buildCourseCard(
              title: course.title,
              instructor: course.instructor,
              emoji: course.thumbnailEmoji,
              rating: course.rating,
              students: course.students,
              progress: course.progress,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CourseDetailScreen(courseId: course.id),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
