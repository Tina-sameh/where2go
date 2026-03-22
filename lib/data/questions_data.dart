import 'package:where2go/data/question.dart';
import 'option.dart';

const Map<String, Question> questionsData = {
  'q1': Question(
    id: 'q1',
    text: 'هاى! 👋 تحب نخرج نعمل إيه؟',
    options: [
      Option(label: 'ناكل', emoji: '🍽️', next: 'q_eat'),
      Option(label: 'نحتفل', emoji: '🎉', next: 'q_celebrate'),
      Option(label: 'قعدة حلوة', emoji: '🌙', next: 'q_chill'),
    ],
  ),

  // ================= EAT =================
  'q_eat': Question(
    id: 'q_eat',
    text: 'تاكل إيه؟',
    options: [
      Option(label: 'مطعم', emoji: '🍴', next: 'q_restaurant'),
      Option(label: 'كافيه', emoji: '☕', next: 'q_cafe'),
    ],
  ),

  'q_restaurant': Question(
    id: 'q_restaurant',
    text: 'أكل إيه؟',
    options: [
      Option(label: 'مشويات', emoji: '🥩', next: 'q_people'),
      Option(label: 'سي فود', emoji: '🦐', next: 'q_people'),
      Option(label: 'بيتزا', emoji: '🍕', next: 'q_people'),
    ],
  ),

  'q_cafe': Question(
    id: 'q_cafe',
    text: 'عايز إيه في الكافيه؟',
    options: [
      Option(label: 'قهوة', emoji: '☕', next: 'q_people'),
      Option(label: 'عصير', emoji: '🧃', next: 'q_people'),
    ],
  ),

  // ================= CELEBRATE =================
  'q_celebrate': Question(
    id: 'q_celebrate',
    text: 'بتحتفل بإيه؟',
    options: [
      Option(label: ' عيد ميلاد', emoji: '🎂', next: 'q_people'),
      Option(label: ' خطوبة', emoji: '💍', next: 'q_people'),
      Option(label: ' مناسبة تانية', emoji: '🎊', next: 'q_people'),
    ],
  ),

  // ================= CHILL =================
  'q_chill': Question(
    id: 'q_chill',
    text: 'قعدة إيه بالظبط؟',
    options: [
      Option(label: 'فيلم', emoji: '🎬', next: 'q_people'),
      Option(label: 'نتمشى', emoji: '🌙', next: 'q_people'),
    ],
  ),

  // ================= COMMON FLOW =================

  // عدد الأشخاص
  'q_people': Question(
    id: 'q_people',
    text: 'هتكونوا كام واحد؟ 👥',
    options: [
      Option(label: '1 - 2', emoji: '👤', next: 'q_budget'),
      Option(label: '3 - 5', emoji: '👥', next: 'q_budget'),
      Option(label: '6 - 10', emoji: '👨‍👩‍👧‍👦', next: 'q_budget'),
      Option(label: '+10', emoji: '🎉', next: 'q_budget'),
    ],
  ),

  // الميزانية
  'q_budget': Question(
    id: 'q_budget',
    text: 'تحب الميزانية تبقى في حدود كام؟ 💰',
    options: [
      Option(label: 'قليلة', emoji: '💸', next: 'q_location'),
      Option(label: 'متوسطة', emoji: '💰', next: 'q_location'),
      Option(label: 'عالية', emoji: '💎', next: 'q_location'),
    ],
  ),


  'q_search_location': Question(
    id: 'q_search_location',
    text: 'اكتب المكان اللي عايز تدور فيه 📍',
    type: QuestionType.textInput,
),

  'q_location': Question(
    id: 'q_location',
    text: 'نرشحلك أماكن قريبة منك؟ 📍',
    options: [
      Option(
        label: 'استخدم موقعي',
        emoji: '📍',
        next: 'q_done',
      ),
      Option(
        label: 'اختار مكان',
        emoji: '🗺️',
        next: 'q_search_location', // لازم الاسم ده مطابق
      ),
    ],
  ),
  // النهاية
  'q_done': Question(
    id: 'q_done',
    text: 'تمام 👌 ثانية نجيبلك أحسن أماكن ليك 🔥',
    options: [
      Option(
        label: 'عرض النتائج',
        emoji: '🚀',
        finalMsg: 'جارٍ البحث عن أفضل الأماكن ليك...',
        finalEmoji: '🔍',
      ),
    ],
  ),
};