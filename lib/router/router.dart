import 'package:alicsnet_app/page/chat_topic_practice/chat_topic_practice_conversation_list_page.dart';
import 'package:alicsnet_app/page/chat_topic_practice/chat_topic_practice_class_mobile_page.dart';
import 'package:alicsnet_app/page/chat_topic_practice/chat_topic_practice_index_page.dart';
import 'package:alicsnet_app/page/chat_topic_practice/chat_topic_practice_topic_mobile_page.dart';
import 'package:alicsnet_app/page/contraction/contraction_index_page.dart';
import 'package:alicsnet_app/page/custom_article_practice_sentence/custom_article_practice_sentence.dart';
import 'package:alicsnet_app/page/harvard/harvard_index_page.dart';
import 'package:alicsnet_app/page/index/index_page.dart';
import 'package:alicsnet_app/page/index/index_pronunciation_page.dart';
import 'package:alicsnet_app/page/ipa_grapheme_pair/ipa_grapheme_pair_index_page.dart';
import 'package:alicsnet_app/page/learning/learning_auto_chat_topic_page.dart';
import 'package:alicsnet_app/page/learning/learning_auto_generic_page.dart';
import 'package:alicsnet_app/page/learning/learning_auto_generic_summary_report_page.dart';
import 'package:alicsnet_app/page/learning/learning_auto_minimal_pair_page.dart';
import 'package:alicsnet_app/page/learning/learning_manual_contraction_page.dart';
import 'package:alicsnet_app/page/learning/learning_manual_custom_article_practice_sentence_page.dart';
import 'package:alicsnet_app/page/learning/learning_manual_harvard_page.dart';
import 'package:alicsnet_app/page/learning/learning_manual_ipa_grapheme_pair_page.dart';
import 'package:alicsnet_app/page/learning/learning_manual_minimal_pair_page.dart';
import 'package:alicsnet_app/page/learning/learning_manual_tongue_twisters_page.dart';
import 'package:alicsnet_app/page/learning/learning_manual_vocabulary_practice_sentence_page.dart';
import 'package:alicsnet_app/page/learning/learning_manual_vocabulary_practice_word_page.dart';
import 'package:alicsnet_app/page/login/sign_in_page.dart';
import 'package:alicsnet_app/page/minimal_pair/minimal_pair_index_page.dart';
import 'package:alicsnet_app/page/minimal_pair/minimal_pair_word_index_page.dart';
import 'package:alicsnet_app/page/preference_translations/preference_sentence_editor.dart';
import 'package:alicsnet_app/page/preference_translations/preference_sentence_search.dart';
import 'package:alicsnet_app/page/sentence_analysis/sentence_analysis_index_page.dart';
import 'package:alicsnet_app/page/tongue_twisters/tongue_twisters_index_page.dart';
import 'package:alicsnet_app/page/vocabulary_match_up/vocabulary_match_up_index_page.dart';
import 'package:alicsnet_app/page/vocabulary_match_up/vocabulary_match_up_practice_page.dart';
import 'package:alicsnet_app/page/vocabulary_practice_word/vocabulary_practice_word_index_page.dart';
import 'package:alicsnet_app/page/vocabulary_practice_word/vocabulary_practice_word_list_page.dart';
import 'package:alicsnet_app/page/vocabulary_test/vocabulary_test_index_page.dart';
import 'package:alicsnet_app/page/vocabulary_test/vocabulary_test_questing_page.dart';
import 'package:alicsnet_app/page/vocabulary_test/vocabulary_test_report_page.dart';
import 'package:auto_route/auto_route.dart';

// router generator 指令: flutter packages pub run build_runner build --delete-conflicting-outputs

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(path: '/', page: SignInPage, initial: true),
    AutoRoute(path: '/index', page: IndexPage),
    AutoRoute(path: '/index_pronunciation_page', page: IndexPronunciationPage),
    AutoRoute(path: '/harvard_index_page', page: HarvardIndexPage),
    AutoRoute(path: '/ipa_grapheme_pair_index_page', page: IPAGraphemePairIndexPage),

    AutoRoute(
        path: '/chat_topic_practice_conversation_list_page',
        page: ChatTopicPracticeConversationListPage),

    AutoRoute(
        path: '/chat_topic_practice_index_page',
        page: ChatTopicPracticeIndexPage),

    AutoRoute(
        path: '/contraction_index_page',
        page: ContractionIndexPage,),

    AutoRoute(
        path: '/learning_auto_chat_topic_page',
        page: LearningAutoChatTopicPage),

    AutoRoute(
        path: '/voabulary_practice_word_index',
        page: VocabularyPracticeWordIndexPage),
    AutoRoute(
        path: '/voabulary_practice_word_list',
        page: VocabularyPracticeWordListPage),

    AutoRoute(path: '/minimal_pair_index', page: MinimalPairIndexPage),
    AutoRoute(path: '/minimal_pair_word_index', page: MinimalPairWordIndexPage),

    AutoRoute(
        path: '/customArticle_practice_sentence_index',
        page: CustomArticlePracticeSentenceIndexPage),

    AutoRoute(path: '/vocabulary_test_index', page: VocabularyTestIndexPage),
    AutoRoute(
        path: '/vocabulary_test_questing', page: VocabularyTestQuestingPage),
    AutoRoute(path: '/vocabulary_test_report', page: VocabularyTestReportPage),

    AutoRoute(path: '/learnig_auto_generic', page: LearningAutoGenericPage),
    AutoRoute(
        path: '/learnig_auto_generic_summary_report',
        page: LearningAutoGenericSummaryReportPage),
    AutoRoute(
        path: '/learnig_auto_minimal_pair', page: LearningAutoMinimalPairPage),
    AutoRoute(
        path: '/learning_manual_contraction_page',
        page: LearningManualContractionPage),
    AutoRoute(
        path: '/learning_manual_custom_article_practice_sentence',
        page: LearningManualCustomArticlePracticeSentencePage),
    AutoRoute(
        path: '/learning_manual_harvard_page',
        page: LearningManualHarvardPage),
    AutoRoute(
        path: '/learning_manual_ipa_grapheme_pair_page',
        page: LearningManualIPAGraphemePairPage),
    AutoRoute(
        path: '/learning_manual_minimal_pair',
        page: LearningManualMinimalPairPage),
    AutoRoute(
        path: '/learning_manual_tongue_twisters_page',
        page: LearningManualTongueTwistersPage),
    AutoRoute(
        path: '/learning_manual_vocabulary_practice_sentence_page',
        page: LearningManualVocabularyPracticeSentencePage),
    AutoRoute(
        path: '/learning_manual_vocabulary_practice_word',
        page: LearningManualVocabularyPraticeWordPage),

    AutoRoute(
        path: '/preference_translation_search',
        page: PreferenceTranslationSearchPage),
    AutoRoute(
        path: '/preference_translation_edit',
        page: PreferenceTranslationEditPage),

    AutoRoute(
        path: '/sentence_analysis_index', page: SentenceAnalysisIndexPage),
    AutoRoute(
        path: '/tongue_twisters_index_page', page: TongueTwistersIndexPage),
    AutoRoute(path: '/chat_topic_practice_class_mobile_page', page: ChatTopicPracticeClassMobilePage),
    AutoRoute(path: '/chat_topic_practice_topic_mobile_page', page: ChatTopicPracticeTopicMobilePage),
    AutoRoute(path: '/vocabulary_match_up_index_page', page: VocabularyMatchUpIndexPage),
    AutoRoute(path: '/vocabulary_match_up_practice_page', page: VocabularyMatchUpPracticePage),
    //New Pages Below ↓↓↓
    /*
    AutoRoute(path: '/grammar_correction_main_page',page: GrammarCorrectionMainPage),
    AutoRoute(path: '/vocabulary_record_index_page',page: IndexLearnRecordIndexPage),
     */
  ],
)
class $AppRouter {}
