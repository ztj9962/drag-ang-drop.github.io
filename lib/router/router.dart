import 'package:alicsnet_app/page/preference_translations/preference_sentence_editor.dart';
import 'package:alicsnet_app/page/preference_translations/preference_sentence_search.dart';
import 'package:alicsnet_app/page/vocabulary_practice_lite/vocabulary_practice_lite_auto.dart';
import 'package:alicsnet_app/page/vocabulary_practice_lite/vocabulary_practice_lite_index.dart';
import 'package:alicsnet_app/page/vocabulary_practice_lite/vocabulary_practice_lite_list.dart';
import 'package:alicsnet_app/page/vocabulary_test/vocabulary_test_report_page.dart';
import 'package:alicsnet_app/page/learning/learning_auto_generic_page.dart';
import 'package:alicsnet_app/page/learning/learning_manual_vocabulary_practice_word_page.dart';
import 'package:alicsnet_app/page/vocabulary_practice_word/vocabulary_practice_word_list_page.dart';
import 'package:auto_route/auto_route.dart';
import 'package:alicsnet_app/page/minimal_pair/minimal_pair_index_page.dart';
import 'package:alicsnet_app/page/minimal_pair/minimal_pair_learn_auto_page.dart';
import 'package:alicsnet_app/page/minimal_pair/minimal_pair_learn_manual_page.dart';
import 'package:alicsnet_app/page/customArticle_practice_sentence/custom_article_practice_sentence_learn_auto_page.dart';
import 'package:alicsnet_app/page/customArticle_practice_sentence/custom_article_practice_sentence_learn_manual_page.dart';
import 'package:alicsnet_app/page/new_template/grammar_correction_main_page.dart';
import 'package:alicsnet_app/page/new_template/index_learn_record_index_page.dart';
import 'package:alicsnet_app/page/vocabulary_test/vocabulary_test_index_page.dart';
import 'package:alicsnet_app/page/vocabulary_test/vocabulary_test_questing_page.dart';
import 'package:alicsnet_app/page/index/index_page.dart';
import 'package:alicsnet_app/page/vocabulary_practice_sentence/vocabulary_practice_sentence_index_page.dart';
import 'package:alicsnet_app/page/vocabulary_practice_sentence/vocabulary_practice_sentence_learn_manual_page.dart';
import 'package:alicsnet_app/page/vocabulary_practice_word/vocabulary_practice_word_index_page.dart';
import 'package:alicsnet_app/page/login/sign_in_page.dart';
import 'package:alicsnet_app/page/customArticle_practice_sentence/custom_article_practice_sentence.dart';



// router generator 指令: flutter packages pub run build_runner build --delete-conflicting-outputs

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(path: '/', page: SignInPage, initial: true),
    AutoRoute(path: '/index', page: IndexPage),

    AutoRoute(path: '/voabulary_practice_sentence_index', page: VocabularyPracticeSentenceIndexPage),
    AutoRoute(path: '/voabulary_practice_sentence_manual', page: VocabularyPracticeSentenceLearnManualPage),

    AutoRoute(path: '/voabulary_practice_word_index', page: VocabularyPracticeWordIndexPage),
    AutoRoute(path: '/voabulary_practice_word_list', page: VocabularyPracticeWordListPage),

    AutoRoute(path: '/minimal_pair_index', page: MinimalPairIndexPage),
    AutoRoute(path: '/minimal_pair_auto', page: MinimalPairLearnAutoPage),
    AutoRoute(path: '/minimal_pair_manual', page: MinimalPairLearnManualPage),
    
    AutoRoute(path: '/customArticle_practice_sentence_index',page: CustomArticlePracticeSentenceIndexPage),
    AutoRoute(path: '/customArticle_practice_sentence_auto',page: CustomArticlePracticeSentenceLearnAutoPage),
    AutoRoute(path: '/customArticle_practice_sentence_manual',page: CustomArticlePracticeSentenceLearnManualPage),

    AutoRoute(path: '/vocabulary_test_index', page: VocabularyTestIndexPage),
    AutoRoute(path: '/vocabulary_test_questing', page: VocabularyTestQuestingPage),
    AutoRoute(path: '/vocabulary_test_report', page: VocabularyTestReportPage),
    
    AutoRoute(path: '/learnig_auto_generic',page: LearningAutoGenericPage),
    AutoRoute(path: '/learning_manual_vocabulary_practice_word',page: LearningManualVocabularyPraticeWordPage),

    //New Pages Below ↓↓↓
    AutoRoute(path: '/grammar_correction_main_page',page: GrammarCorrectionMainPage),
    AutoRoute(path: '/vocabulary_record_index_page',page: IndexLearnRecordIndexPage),
    AutoRoute(path: '/preference_translation_search',page: PreferenceTranslationSearchPage),
    AutoRoute(path: '/preference_translation_edit',page: PreferenceTranslationEditPage),
    //Lite ↓↓↓
    AutoRoute(path: '/vocabulary_lite_index_page',page: VocabularyPracticeLiteIndexPage),
    AutoRoute(path: '/vocabulary_lite_list_page',page: VocabularyPracticeLiteListPage),
    AutoRoute(path: '/vocabulary_lite_auto_page',page: VocabularyPracticeLiteAutoPage),
  ],
)
class $AppRouter {}