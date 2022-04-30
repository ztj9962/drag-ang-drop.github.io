import 'package:auto_route/auto_route.dart';
import 'package:alicsnet_app/page/index/index_page.dart';
import 'package:alicsnet_app/page/vocabulary_practice_sentence/vocabulary_practice_sentence_index_page.dart';
import 'package:alicsnet_app/page/vocabulary_practice_sentence/vocabulary_practice_sentence_learn_auto_page.dart';
import 'package:alicsnet_app/page/vocabulary_practice_sentence/vocabulary_practice_sentence_learn_manual_page.dart';
import 'package:alicsnet_app/page/vocabulary_practice_word/vocabulary_practice_word_index_page.dart';
import 'package:alicsnet_app/page/login/sign_in_page.dart';
import 'package:alicsnet_app/page/vocabulary_practice_word/vocabulary_practice_word_learn_page.dart';

// flutter pub run build_runner watch --delete-conflicting-outputs

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(path: '/', page: SignInPage, initial: true),
    AutoRoute(path: '/index', page: IndexPage),
    AutoRoute(path: '/voabulary_practice_sentence_index', page: VocabularyPracticeSentenceIndexPage),
    AutoRoute(path: '/voabulary_practice_sentence_auto', page: VocabularyPracticeSentenceLearnAutoPage),
    AutoRoute(path: '/voabulary_practice_sentence_manual', page: VocabularyPracticeSentenceLearnManualPage),
    AutoRoute(path: '/voabulary_practice_word_index', page: VocabularyPracticeWordIndexPage),
    AutoRoute(path: '/voabulary_practice_word_learn', page: VocabularyPracticeWordLearnPage),
  ],
)
class $AppRouter {}