class QuizQuestion {
  final String id;
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;

  QuizQuestion({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'questionText': questionText,
        'options': options,
        'correctOptionIndex': correctOptionIndex,
        'explanation': explanation,
      };

  factory QuizQuestion.fromMap(Map<String, dynamic> map) => QuizQuestion(
        id: map['id'],
        questionText: map['questionText'],
        options: List<String>.from(map['options']),
        correctOptionIndex: map['correctOptionIndex'],
        explanation: map['explanation'] ?? '',
      );
}

class Quiz {
  final String id;
  final String title;
  final int passScore; // Percentage, e.g. 70
  final List<QuizQuestion> questions;

  Quiz({
    required this.id,
    required this.title,
    this.passScore = 70,
    required this.questions,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'passScore': passScore,
        'questions': questions.map((q) => q.toMap()).toList(),
      };

  factory Quiz.fromMap(Map<String, dynamic> map) => Quiz(
        id: map['id'],
        title: map['title'],
        passScore: map['passScore'] ?? 70,
        questions: (map['questions'] as List)
            .map((q) => QuizQuestion.fromMap(q))
            .toList(),
      );
}

enum LessonType { video, pdf, quiz }

class Lesson {
  final String id;
  final String title;
  final int durationMinutes;
  final LessonType type;
  final String contentUrl;
  final String notes;
  final Quiz? quiz;

  Lesson({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.type,
    required this.contentUrl,
    required this.notes,
    this.quiz,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'durationMinutes': durationMinutes,
        'type': type.name,
        'contentUrl': contentUrl,
        'notes': notes,
        'quiz': quiz?.toMap(),
      };

  factory Lesson.fromMap(Map<String, dynamic> map) => Lesson(
        id: map['id'],
        title: map['title'],
        durationMinutes: map['durationMinutes'] ?? 10,
        type: LessonType.values.firstWhere(
          (t) => t.name == map['type'],
          orElse: () => LessonType.video,
        ),
        contentUrl: map['contentUrl'] ?? '',
        notes: map['notes'] ?? '',
        quiz: map['quiz'] != null ? Quiz.fromMap(map['quiz']) : null,
      );
}

class CourseModule {
  final String id;
  final String title;
  final List<Lesson> lessons;

  CourseModule({
    required this.id,
    required this.title,
    required this.lessons,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'lessons': lessons.map((l) => l.toMap()).toList(),
      };

  factory CourseModule.fromMap(Map<String, dynamic> map) => CourseModule(
        id: map['id'],
        title: map['title'],
        lessons:
            (map['lessons'] as List).map((l) => Lesson.fromMap(l)).toList(),
      );
}

class Course {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String category;
  final String instructor;
  final double price;
  final double rating;
  final int reviewCount;
  final String level;
  final int totalDurationHours;
  final List<CourseModule> modules;
  final List<String> learningOutcomes;
  final String badge;

  Course({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.category,
    required this.instructor,
    required this.price,
    this.rating = 4.9,
    this.reviewCount = 120,
    this.level = 'Intermediate',
    required this.totalDurationHours,
    required this.modules,
    required this.learningOutcomes,
    this.badge = 'Bestseller',
  });

  int get totalLessons =>
      modules.fold(0, (sum, m) => sum + m.lessons.length);

  Course copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    String? category,
    String? instructor,
    double? price,
    double? rating,
    int? reviewCount,
    String? level,
    int? totalDurationHours,
    List<CourseModule>? modules,
    List<String>? learningOutcomes,
    String? badge,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      category: category ?? this.category,
      instructor: instructor ?? this.instructor,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      level: level ?? this.level,
      totalDurationHours: totalDurationHours ?? this.totalDurationHours,
      modules: modules ?? this.modules,
      learningOutcomes: learningOutcomes ?? this.learningOutcomes,
      badge: badge ?? this.badge,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'description': description,
        'category': category,
        'instructor': instructor,
        'price': price,
        'rating': rating,
        'reviewCount': reviewCount,
        'level': level,
        'totalDurationHours': totalDurationHours,
        'modules': modules.map((m) => m.toMap()).toList(),
        'learningOutcomes': learningOutcomes,
        'badge': badge,
      };

  factory Course.fromMap(Map<String, dynamic> map) => Course(
        id: map['id'],
        title: map['title'],
        subtitle: map['subtitle'] ?? '',
        description: map['description'] ?? '',
        category: map['category'] ?? 'Leadership',
        instructor: map['instructor'] ?? 'MT Alchemy Senior Consultant',
        price: (map['price'] as num).toDouble(),
        rating: (map['rating'] as num?)?.toDouble() ?? 4.8,
        reviewCount: map['reviewCount'] ?? 100,
        level: map['level'] ?? 'All Levels',
        totalDurationHours: map['totalDurationHours'] ?? 6,
        modules: (map['modules'] as List)
            .map((m) => CourseModule.fromMap(m))
            .toList(),
        learningOutcomes: List<String>.from(map['learningOutcomes'] ?? []),
        badge: map['badge'] ?? 'Popular',
      );
}

