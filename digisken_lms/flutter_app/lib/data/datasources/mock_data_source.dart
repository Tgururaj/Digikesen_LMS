import '../models/course.dart';
import '../models/lesson.dart';

class MockDataSource {
  static final List<Course> mockCourses = [
    Course(
      id: 1,
      title: 'Introduction to Programming',
      description:
          'Learn the basics of programming and start your coding journey.',
      instructor: 'Sarah Johnson',
      lessons: 12,
      category: 'Computer Science',
      rating: 4.8,
      students: 15234,
      duration: '4 weeks',
      price: 49.99,
      progress: 0.45,
      thumbnailEmoji: '💻',
    ),
    Course(
      id: 2,
      title: 'Digital Marketing Fundamentals',
      description:
          'Master the essentials of digital marketing and grow your business online.',
      instructor: 'Mike Chen',
      lessons: 18,
      category: 'Business',
      rating: 4.6,
      students: 8945,
      duration: '6 weeks',
      price: 39.99,
      progress: 0.0,
      thumbnailEmoji: '📱',
    ),
    Course(
      id: 3,
      title: 'English Communication Skills',
      description:
          'Improve your English writing and speaking abilities for work and life.',
      instructor: 'Emma Wilson',
      lessons: 15,
      category: 'Language',
      rating: 4.7,
      students: 12567,
      duration: '5 weeks',
      price: 29.99,
      progress: 0.6,
      thumbnailEmoji: '🌍',
    ),
    Course(
      id: 4,
      title: 'Basic Data Analysis',
      description:
          'Learn to analyze data and make informed business decisions.',
      instructor: 'David Park',
      lessons: 16,
      category: 'Data Science',
      rating: 4.9,
      students: 9876,
      duration: '5 weeks',
      price: 59.99,
      progress: 0.2,
      thumbnailEmoji: '📊',
    ),
    Course(
      id: 5,
      title: 'Graphic Design Basics',
      description:
          'Create stunning visuals and learn the principles of good design.',
      instructor: 'Lisa Brown',
      lessons: 20,
      category: 'Design',
      rating: 4.5,
      students: 7654,
      duration: '6 weeks',
      price: 44.99,
      progress: 0.0,
      thumbnailEmoji: '🎨',
    ),
    Course(
      id: 6,
      title: 'Personal Finance for Beginners',
      description:
          'Master budgeting, saving, and investing to secure your financial future.',
      instructor: 'Robert Smith',
      lessons: 14,
      category: 'Finance',
      rating: 4.7,
      students: 11234,
      duration: '4 weeks',
      price: 34.99,
      progress: 0.8,
      thumbnailEmoji: '💰',
    ),
  ];

  static final Map<int, List<Lesson>> mockLessons = {
    1: [
      Lesson(
        id: 1,
        title: 'What is Programming?',
        content: '''
Programming is the process of creating a set of instructions that tell a computer how to perform a task. 

Key concepts:
• Variables: Containers for storing data values
• Functions: Reusable blocks of code
• Loops: Repeating code multiple times
• Conditions: Making decisions in code

Programming allows you to automate tasks and solve complex problems efficiently. Whether you're building applications, websites, or software tools, programming is the foundation of all technology.

In this lesson, you'll learn about:
1. Basic programming concepts
2. How computers understand code
3. Different programming languages
4. Why programming is important
5. Your first coding steps
''',
        contentType: 'text',
        durationMinutes: 8,
        isCompleted: true,
      ),
      Lesson(
        id: 2,
        title: 'Variables and Data Types',
        content: '''
Variables are containers that hold values in your program. Think of them as labeled boxes where you store information.

Main Data Types:
• Integer: Whole numbers (1, 42, -5)
• String: Text ("Hello World")
• Boolean: True or False values
• Float: Decimal numbers (3.14, 2.5)

Example Code Concepts:
- Declaring: Create a variable with a name
- Assigning: Give the variable a value
- Using: Reference the variable in your code

Variables help you:
• Store user input
• Keep track of game scores
• Remember user preferences
• Perform calculations

Practice Activity:
Try creating variables for:
- Your name
- Your age
- Your favorite color
- Your height in meters
''',
        contentType: 'text',
        durationMinutes: 10,
        isCompleted: true,
      ),
      Lesson(
        id: 3,
        title: 'Your First Program',
        content: '''
Congratulations! It's time to write your first program.

A simple program structure:
1. Start with a main function
2. Print output to screen
3. Use variables to store data
4. Combine logic and data

Classic Program: "Hello World"
This is the first program most programmers write.

What You'll Learn:
• How to write basic syntax
• How to run a program
• How to see output on screen
• Debugging simple errors

This foundational project will teach you:
- Program structure
- Basic syntax rules
- How to compile/run code
- Reading error messages

Next Steps:
After mastering this, you'll learn about:
• Taking user input
• Performing calculations
• Making decisions with conditionals
• Creating reusable functions
''',
        videoUrl: 'https://example.com/videos/first_program.mp4',
        contentType: 'video',
        durationMinutes: 12,
        isCompleted: false,
      ),
      Lesson(
        id: 4,
        title: 'Control Flow Basics',
        content: '''
Control flow determines which code gets executed based on conditions.

Types of Control Flow:
1. IF/ELSE: Execute code based on a condition
   - If the condition is true, do this
   - Else, do that instead

2. LOOPS: Repeat code multiple times
   - While loop: Repeat while condition is true
   - For loop: Repeat a set number of times

3. SWITCH: Choose from multiple options

Control flow lets you:
• Make your program interactive
• Handle different scenarios
• Automate repetitive tasks
• Create smart decision-making

Common Patterns:
- Checking user input
- Validating data
- Processing collections of data
- Creating game logic

Quiz Question: What's the difference between a while loop and a for loop?

Continue to the next lesson to practice these concepts!
''',
        contentType: 'text',
        durationMinutes: 15,
        isCompleted: false,
      ),
    ],
    2: [
      Lesson(
        id: 5,
        title: 'What is Digital Marketing?',
        content: '''
Digital marketing is promoting products or services using digital technologies.

Key Channels:
• Social Media: Facebook, Instagram, TikTok
• Email Marketing: Direct communication with customers
• Search Engines: Google Ads, SEO
• Content Marketing: Blogs, videos, podcasts
• Influencer Marketing: Partnering with popular creators

Why Digital Marketing?
✓ Reach millions of people instantly
✓ Target specific audiences
✓ Measure results in real-time
✓ Cost-effective compared to traditional ads
✓ Build relationships with customers

Digital vs Traditional Marketing:
Traditional ads are one-way communication, but digital marketing is interactive. You can see immediate feedback and adjust your strategy.

Skills You'll Learn:
1. Building brand awareness
2. Creating engaging content
3. Understanding analytics
4. Customer engagement strategies
5. Social media management
''',
        contentType: 'text',
        durationMinutes: 10,
        isCompleted: true,
      ),
      Lesson(
        id: 6,
        title: 'Social Media Strategy',
        content: '''
A successful social media strategy requires planning and consistency.

Steps to Build Your Strategy:
1. Define Your Goals
   - Brand awareness
   - Lead generation
   - Sales
   - Community building

2. Know Your Audience
   - Demographics (age, location, interests)
   - Pain points and challenges
   - Preferred platforms
   - Content preferences

3. Choose Your Platforms
   - Facebook: Broad audience
   - Instagram: Visual content
   - LinkedIn: Professional B2B
   - TikTok: Younger demographics

4. Content Planning
   - Create a content calendar
   - Plan posts in advance
   - Mix content types
   - Stay consistent

5. Engagement
   - Respond to comments
   - Build community
   - Share user-generated content
   - Run contests and giveaways

Posting Guidelines:
- Post regularly (3-5 times per week)
- Best times vary by platform
- Use relevant hashtags
- Include calls-to-action

Success Metrics:
- Engagement rate
- Follower growth
- Click-through rate
- Conversion rate
''',
        contentType: 'text',
        durationMinutes: 12,
        isCompleted: false,
      ),
    ],
    3: [
      Lesson(
        id: 7,
        title: 'Pronunciation Guide',
        content: '''
Clear pronunciation is essential for effective communication.

Vowel Sounds:
• A: "cat", "play", "care"
• E: "bed", "see", "pet"
• I: "sit", "like", "bit"
• O: "dog", "go", "hot"
• U: "cup", "blue", "put"

Consonant Tips:
• Practice tongue placement
• Listen to native speakers
• Repeat words slowly
• Record yourself and compare

Common Difficult Sounds for Non-Native Speakers:
1. "TH" sound - Practice with: "the", "think", "thank"
2. "R" sound - Practice with: "red", "right", "wrong"
3. "L" sound - Practice with: "light", "like", "love"

Daily Practice:
- Spend 10 minutes daily on pronunciation
- Focus on one sound per day
- Use mirrors to watch your mouth
- Listen to podcasts and movies
- Read aloud from articles

Remember: Consistency is key to improvement!
''',
        contentType: 'text',
        durationMinutes: 10,
        isCompleted: true,
      ),
    ],
    4: [
      Lesson(
        id: 8,
        title: 'Data Analysis Fundamentals',
        content: '''
Data analysis is the process of examining data to draw conclusions.

The Data Analysis Process:
1. Collect Data
   - Surveys
   - Databases
   - APIs
   - User behavior

2. Clean Data
   - Remove duplicates
   - Handle missing values
   - Fix inconsistencies
   - Prepare for analysis

3. Analyze Data
   - Look for patterns
   - Calculate statistics
   - Create visualizations
   - Find relationships

4. Draw Conclusions
   - Identify trends
   - Make predictions
   - Recommend actions

Key Metrics:
• Average (Mean): Sum of all values ÷ count
• Median: Middle value when sorted
• Mode: Most frequent value
• Standard Deviation: How spread out data is

Tools Used:
- Excel/Google Sheets: Basic analysis
- Python/R: Advanced analysis
- Power BI/Tableau: Visualization
- SQL: Database queries

Common Applications:
✓ Business decision-making
✓ Market research
✓ Customer insights
✓ Financial forecasting
✓ Scientific research

Next: You'll learn specific tools and techniques!
''',
        contentType: 'text',
        durationMinutes: 15,
        isCompleted: false,
      ),
    ],
    5: [
      Lesson(
        id: 9,
        title: 'Design Principles',
        content: '''
Good design combines aesthetics with functionality.

Seven Core Design Principles:

1. BALANCE
   - Distribute visual weight evenly
   - Symmetrical: Mirror images
   - Asymmetrical: Different but equal weight

2. CONTRAST
   - Make important elements stand out
   - Use color, size, or shape differences
   - Improve readability and hierarchy

3. EMPHASIS
   - Draw attention to key elements
   - Use size, color, or position
   - Guide the viewer's eye

4. MOVEMENT
   - Guide the eye through the design
   - Use lines, shapes, and colors
   - Create visual flow

5. PROPORTION
   - Ensure visual harmony
   - Golden ratio: 1:1.618
   - Maintain consistency in sizing

6. REPETITION
   - Create unity and consistency
   - Repeat colors, shapes, fonts
   - Strengthen brand identity

7. WHITE SPACE
   - Use empty space strategically
   - Reduce visual clutter
   - Improve readability

Practice Exercise:
Analyze your favorite website or app. Can you identify these principles in use?

Tools to Start:
- Canva (Free)
- Figma (Professional)
- Adobe Suite (Industry standard)
''',
        contentType: 'text',
        durationMinutes: 14,
        isCompleted: false,
      ),
    ],
    6: [
      Lesson(
        id: 10,
        title: 'Budgeting 101',
        content: '''
A budget is your financial roadmap for spending and saving.

Why Budget?
✓ Control your money
✓ Reach financial goals
✓ Reduce stress
✓ Avoid overspending
✓ Build emergency fund

The 50/30/20 Rule:
• 50% Needs (rent, food, utilities)
• 30% Wants (entertainment, dining out)
• 20% Savings & Debt Repayment

Steps to Create a Budget:
1. Track your income
   - All money coming in

2. List all expenses
   - Fixed: Same every month
   - Variable: Changes monthly

3. Categorize expenses
   - Housing, food, transportation, etc.

4. Set spending limits
   - Be realistic
   - Allow flexibility

5. Review and adjust
   - Monthly check-ins
   - Track progress

Common Budget Categories:
- Housing (30-35%)
- Transportation (15-20%)
- Food (10-15%)
- Insurance (10-25%)
- Savings (10-20%)
- Personal/Entertainment (5-10%)

Tips for Success:
• Use budgeting apps (YNAB, Mint, EveryDollar)
• Review weekly, not just monthly
• Be honest about spending
• Celebrate progress
• Adjust as circumstances change

Your First Budget:
Start by tracking expenses for one month before creating a budget!
''',
        contentType: 'text',
        durationMinutes: 13,
        isCompleted: true,
      ),
    ],
  };

  Future<List<Course>> getCourses() async {
    // Minimal delay for instant local data access
    await Future.delayed(const Duration(milliseconds: 20));
    return mockCourses;
  }

  Future<List<Lesson>> getCourseLessons(int courseId) async {
    await Future.delayed(const Duration(milliseconds: 10));
    return mockLessons[courseId] ?? [];
  }

  Future<Lesson> getLesson(int lessonId) async {
    await Future.delayed(const Duration(milliseconds: 5));
    for (var lessons in mockLessons.values) {
      for (var lesson in lessons) {
        if (lesson.id == lessonId) {
          return lesson;
        }
      }
    }
    throw Exception('Lesson not found');
  }
}
