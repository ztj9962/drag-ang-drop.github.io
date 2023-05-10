// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i28;
import 'package:flutter/material.dart' as _i29;

import '../page/chat_topic_practice/chat_topic_practice_conversation_list_page.dart'
    as _i5;
import '../page/chat_topic_practice/chat_topic_practice_index_page.dart' as _i6;
import '../page/contraction/contraction_index_page.dart' as _i7;
import '../page/custom_article_practice_sentence/custom_article_practice_sentence.dart'
    as _i12;
import '../page/harvard/harvard_index_page.dart' as _i3;
import '../page/index/index_page.dart' as _i2;
import '../page/ipa_grapheme_pair/ipa_grapheme_pair_index_page.dart' as _i4;
import '../page/learning/learning_auto_chat_topic_page.dart' as _i8;
import '../page/learning/learning_auto_generic_page.dart' as _i16;
import '../page/learning/learning_auto_generic_summary_report_page.dart'
    as _i17;
import '../page/learning/learning_auto_minimal_pair_page.dart' as _i18;
import '../page/learning/learning_manual_contraction_page.dart' as _i19;
import '../page/learning/learning_manual_custom_article_practice_sentence_page.dart'
    as _i20;
import '../page/learning/learning_manual_ipa_grapheme_pair_page.dart' as _i21;
import '../page/learning/learning_manual_minimal_pair_page.dart' as _i22;
import '../page/learning/learning_manual_vocabulary_practice_sentence_page.dart'
    as _i23;
import '../page/learning/learning_manual_vocabulary_practice_word_page.dart'
    as _i24;
import '../page/login/sign_in_page.dart' as _i1;
import '../page/minimal_pair/minimal_pair_index_page.dart' as _i11;
import '../page/preference_translations/preference_sentence_editor.dart'
    as _i26;
import '../page/preference_translations/preference_sentence_search.dart'
    as _i25;
import '../page/sentence_analysis/sentence_analysis_index_page.dart' as _i27;
import '../page/vocabulary_practice_word/vocabulary_practice_word_index_page.dart'
    as _i9;
import '../page/vocabulary_practice_word/vocabulary_practice_word_list_page.dart'
    as _i10;
import '../page/vocabulary_test/vocabulary_test_index_page.dart' as _i13;
import '../page/vocabulary_test/vocabulary_test_questing_page.dart' as _i14;
import '../page/vocabulary_test/vocabulary_test_report_page.dart' as _i15;

class AppRouter extends _i28.RootStackRouter {
  AppRouter([_i29.GlobalKey<_i29.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i28.PageFactory> pagesMap = {
    SignInRoute.name: (routeData) {
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i1.SignInPage(),
      );
    },
    IndexRoute.name: (routeData) {
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.IndexPage(),
      );
    },
    HarvardIndexRoute.name: (routeData) {
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.HarvardIndexPage(),
      );
    },
    IPAGraphemePairIndexRoute.name: (routeData) {
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.IPAGraphemePairIndexPage(),
      );
    },
    ChatTopicPracticeConversationListRoute.name: (routeData) {
      final args =
          routeData.argsAs<ChatTopicPracticeConversationListRouteArgs>();
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i5.ChatTopicPracticeConversationListPage(
          key: args.key,
          topicName: args.topicName,
        ),
      );
    },
    ChatTopicPracticeIndexRoute.name: (routeData) {
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i6.ChatTopicPracticeIndexPage(),
      );
    },
    ContractionIndexRoute.name: (routeData) {
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i7.ContractionIndexPage(),
      );
    },
    LearningAutoChatTopicRoute.name: (routeData) {
      final args = routeData.argsAs<LearningAutoChatTopicRouteArgs>();
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i8.LearningAutoChatTopicPage(
          key: args.key,
          contentList: args.contentList,
          translateList: args.translateList,
          title: args.title,
          speakerList: args.speakerList,
          subtitle: args.subtitle,
          orderList: args.orderList,
        ),
      );
    },
    VocabularyPracticeWordIndexRoute.name: (routeData) {
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i9.VocabularyPracticeWordIndexPage(),
      );
    },
    VocabularyPracticeWordListRoute.name: (routeData) {
      final args = routeData.argsAs<VocabularyPracticeWordListRouteArgs>();
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i10.VocabularyPracticeWordListPage(
          key: args.key,
          vocabularyList: args.vocabularyList,
        ),
      );
    },
    MinimalPairIndexRoute.name: (routeData) {
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i11.MinimalPairIndexPage(),
      );
    },
    CustomArticlePracticeSentenceIndexRoute.name: (routeData) {
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i12.CustomArticlePracticeSentenceIndexPage(),
      );
    },
    VocabularyTestIndexRoute.name: (routeData) {
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i13.VocabularyTestIndexPage(),
      );
    },
    VocabularyTestQuestingRoute.name: (routeData) {
      final args = routeData.argsAs<VocabularyTestQuestingRouteArgs>();
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i14.VocabularyTestQuestingPage(
          key: args.key,
          vocabularyTestQuestionList: args.vocabularyTestQuestionList,
        ),
      );
    },
    VocabularyTestReportRoute.name: (routeData) {
      final args = routeData.argsAs<VocabularyTestReportRouteArgs>();
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i15.VocabularyTestReportPage(
          key: args.key,
          vocabularyTestQuestionList: args.vocabularyTestQuestionList,
          chooseAnswerList: args.chooseAnswerList,
        ),
      );
    },
    LearningAutoGenericRoute.name: (routeData) {
      final args = routeData.argsAs<LearningAutoGenericRouteArgs>();
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i16.LearningAutoGenericPage(
          key: args.key,
          contentList: args.contentList,
          ipaList: args.ipaList,
          translateList: args.translateList,
        ),
      );
    },
    LearningAutoGenericSummaryReportRoute.name: (routeData) {
      final args =
          routeData.argsAs<LearningAutoGenericSummaryReportRouteArgs>();
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i17.LearningAutoGenericSummaryReportPage(
          key: args.key,
          summaryReportData: args.summaryReportData,
        ),
      );
    },
    LearningAutoMinimalPairRoute.name: (routeData) {
      final args = routeData.argsAs<LearningAutoMinimalPairRouteArgs>(
          orElse: () => const LearningAutoMinimalPairRouteArgs());
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i18.LearningAutoMinimalPairPage(
          key: args.key,
          IPA1: args.IPA1,
          IPA2: args.IPA2,
          word: args.word,
        ),
      );
    },
    LearningManualContractionRoute.name: (routeData) {
      final args = routeData.argsAs<LearningManualContractionRouteArgs>();
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i19.LearningManualContractionPage(
          key: args.key,
          getPairContraction: args.getPairContraction,
          getPairFullForm: args.getPairFullForm,
          getPracticeContraction: args.getPracticeContraction,
          getPracticeContractionIPA: args.getPracticeContractionIPA,
          getPracticeFullForm: args.getPracticeFullForm,
          getPracticeSentence: args.getPracticeSentence,
          getPracticeSentenceIPA: args.getPracticeSentenceIPA,
        ),
      );
    },
    LearningManualCustomArticlePracticeSentenceRoute.name: (routeData) {
      final args = routeData
          .argsAs<LearningManualCustomArticlePracticeSentenceRouteArgs>();
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i20.LearningManualCustomArticlePracticeSentencePage(
          key: args.key,
          questionList: args.questionList,
          questionIPAList: args.questionIPAList,
        ),
      );
    },
    LearningManualIPAGraphemePairRoute.name: (routeData) {
      final args = routeData.argsAs<LearningManualIPAGraphemePairRouteArgs>();
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i21.LearningManualIPAGraphemePairPage(
          key: args.key,
          getIPASymbol: args.getIPASymbol,
          getGraphemes: args.getGraphemes,
          getWord: args.getWord,
          getWordIPA: args.getWordIPA,
        ),
      );
    },
    LearningManualMinimalPairRoute.name: (routeData) {
      final args = routeData.argsAs<LearningManualMinimalPairRouteArgs>(
          orElse: () => const LearningManualMinimalPairRouteArgs());
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i22.LearningManualMinimalPairPage(
          key: args.key,
          IPA1: args.IPA1,
          IPA2: args.IPA2,
          word: args.word,
        ),
      );
    },
    LearningManualVocabularyPracticeSentenceRoute.name: (routeData) {
      final args =
          routeData.argsAs<LearningManualVocabularyPracticeSentenceRouteArgs>(
              orElse: () =>
                  const LearningManualVocabularyPracticeSentenceRouteArgs());
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i23.LearningManualVocabularyPracticeSentencePage(
          key: args.key,
          topicClass: args.topicClass,
          topicName: args.topicName,
        ),
      );
    },
    LearningManualVocabularyPraticeWordRoute.name: (routeData) {
      final args =
          routeData.argsAs<LearningManualVocabularyPraticeWordRouteArgs>();
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i24.LearningManualVocabularyPraticeWordPage(
          key: args.key,
          vocabularyList: args.vocabularyList,
          vocabularySentenceList: args.vocabularySentenceList,
        ),
      );
    },
    PreferenceTranslationSearchRoute.name: (routeData) {
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i25.PreferenceTranslationSearchPage(),
      );
    },
    PreferenceTranslationEditRoute.name: (routeData) {
      final args = routeData.argsAs<PreferenceTranslationEditRouteArgs>();
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i26.PreferenceTranslationEditPage(
          key: args.key,
          sentenceDataList: args.sentenceDataList,
        ),
      );
    },
    SentenceAnalysisIndexRoute.name: (routeData) {
      final args = routeData.argsAs<SentenceAnalysisIndexRouteArgs>();
      return _i28.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i27.SentenceAnalysisIndexPage(
          key: args.key,
          analysisor: args.analysisor,
        ),
      );
    },
  };

  @override
  List<_i28.RouteConfig> get routes => [
        _i28.RouteConfig(
          SignInRoute.name,
          path: '/',
        ),
        _i28.RouteConfig(
          IndexRoute.name,
          path: '/index',
        ),
        _i28.RouteConfig(
          HarvardIndexRoute.name,
          path: '/harvard_index_page',
        ),
        _i28.RouteConfig(
          IPAGraphemePairIndexRoute.name,
          path: '/ipa_grapheme_pair_index_page',
        ),
        _i28.RouteConfig(
          ChatTopicPracticeConversationListRoute.name,
          path: '/chat_topic_practice_conversation_list_page',
        ),
        _i28.RouteConfig(
          ChatTopicPracticeIndexRoute.name,
          path: '/chat_topic_practice_index_page',
        ),
        _i28.RouteConfig(
          ContractionIndexRoute.name,
          path: '/contraction_index_page',
        ),
        _i28.RouteConfig(
          LearningAutoChatTopicRoute.name,
          path: '/learning_auto_chat_topic_page',
        ),
        _i28.RouteConfig(
          VocabularyPracticeWordIndexRoute.name,
          path: '/voabulary_practice_word_index',
        ),
        _i28.RouteConfig(
          VocabularyPracticeWordListRoute.name,
          path: '/voabulary_practice_word_list',
        ),
        _i28.RouteConfig(
          MinimalPairIndexRoute.name,
          path: '/minimal_pair_index',
        ),
        _i28.RouteConfig(
          CustomArticlePracticeSentenceIndexRoute.name,
          path: '/customArticle_practice_sentence_index',
        ),
        _i28.RouteConfig(
          VocabularyTestIndexRoute.name,
          path: '/vocabulary_test_index',
        ),
        _i28.RouteConfig(
          VocabularyTestQuestingRoute.name,
          path: '/vocabulary_test_questing',
        ),
        _i28.RouteConfig(
          VocabularyTestReportRoute.name,
          path: '/vocabulary_test_report',
        ),
        _i28.RouteConfig(
          LearningAutoGenericRoute.name,
          path: '/learnig_auto_generic',
        ),
        _i28.RouteConfig(
          LearningAutoGenericSummaryReportRoute.name,
          path: '/learnig_auto_generic_summary_report',
        ),
        _i28.RouteConfig(
          LearningAutoMinimalPairRoute.name,
          path: '/learnig_auto_minimal_pair',
        ),
        _i28.RouteConfig(
          LearningManualContractionRoute.name,
          path: '/learning_manual_contraction_page',
        ),
        _i28.RouteConfig(
          LearningManualCustomArticlePracticeSentenceRoute.name,
          path: '/learning_manual_custom_article_practice_sentence',
        ),
        _i28.RouteConfig(
          LearningManualIPAGraphemePairRoute.name,
          path: '/learning_manual_ipa_grapheme_pair_page',
        ),
        _i28.RouteConfig(
          LearningManualMinimalPairRoute.name,
          path: '/learning_manual_minimal_pair',
        ),
        _i28.RouteConfig(
          LearningManualVocabularyPracticeSentenceRoute.name,
          path: '/learning_manual_vocabulary_practice_sentence_page',
        ),
        _i28.RouteConfig(
          LearningManualVocabularyPraticeWordRoute.name,
          path: '/learning_manual_vocabulary_practice_word',
        ),
        _i28.RouteConfig(
          PreferenceTranslationSearchRoute.name,
          path: '/preference_translation_search',
        ),
        _i28.RouteConfig(
          PreferenceTranslationEditRoute.name,
          path: '/preference_translation_edit',
        ),
        _i28.RouteConfig(
          SentenceAnalysisIndexRoute.name,
          path: '/sentence_analysis_index',
        ),
      ];
}

/// generated route for
/// [_i1.SignInPage]
class SignInRoute extends _i28.PageRouteInfo<void> {
  const SignInRoute()
      : super(
          SignInRoute.name,
          path: '/',
        );

  static const String name = 'SignInRoute';
}

/// generated route for
/// [_i2.IndexPage]
class IndexRoute extends _i28.PageRouteInfo<void> {
  const IndexRoute()
      : super(
          IndexRoute.name,
          path: '/index',
        );

  static const String name = 'IndexRoute';
}

/// generated route for
/// [_i3.HarvardIndexPage]
class HarvardIndexRoute extends _i28.PageRouteInfo<void> {
  const HarvardIndexRoute()
      : super(
          HarvardIndexRoute.name,
          path: '/harvard_index_page',
        );

  static const String name = 'HarvardIndexRoute';
}

/// generated route for
/// [_i4.IPAGraphemePairIndexPage]
class IPAGraphemePairIndexRoute extends _i28.PageRouteInfo<void> {
  const IPAGraphemePairIndexRoute()
      : super(
          IPAGraphemePairIndexRoute.name,
          path: '/ipa_grapheme_pair_index_page',
        );

  static const String name = 'IPAGraphemePairIndexRoute';
}

/// generated route for
/// [_i5.ChatTopicPracticeConversationListPage]
class ChatTopicPracticeConversationListRoute
    extends _i28.PageRouteInfo<ChatTopicPracticeConversationListRouteArgs> {
  ChatTopicPracticeConversationListRoute({
    _i29.Key? key,
    required String topicName,
  }) : super(
          ChatTopicPracticeConversationListRoute.name,
          path: '/chat_topic_practice_conversation_list_page',
          args: ChatTopicPracticeConversationListRouteArgs(
            key: key,
            topicName: topicName,
          ),
        );

  static const String name = 'ChatTopicPracticeConversationListRoute';
}

class ChatTopicPracticeConversationListRouteArgs {
  const ChatTopicPracticeConversationListRouteArgs({
    this.key,
    required this.topicName,
  });

  final _i29.Key? key;

  final String topicName;

  @override
  String toString() {
    return 'ChatTopicPracticeConversationListRouteArgs{key: $key, topicName: $topicName}';
  }
}

/// generated route for
/// [_i6.ChatTopicPracticeIndexPage]
class ChatTopicPracticeIndexRoute extends _i28.PageRouteInfo<void> {
  const ChatTopicPracticeIndexRoute()
      : super(
          ChatTopicPracticeIndexRoute.name,
          path: '/chat_topic_practice_index_page',
        );

  static const String name = 'ChatTopicPracticeIndexRoute';
}

/// generated route for
/// [_i7.ContractionIndexPage]
class ContractionIndexRoute extends _i28.PageRouteInfo<void> {
  const ContractionIndexRoute()
      : super(
          ContractionIndexRoute.name,
          path: '/contraction_index_page',
        );

  static const String name = 'ContractionIndexRoute';
}

/// generated route for
/// [_i8.LearningAutoChatTopicPage]
class LearningAutoChatTopicRoute
    extends _i28.PageRouteInfo<LearningAutoChatTopicRouteArgs> {
  LearningAutoChatTopicRoute({
    _i29.Key? key,
    required List<List<String>> contentList,
    required List<List<String>> translateList,
    required String title,
    required List<List<String>> speakerList,
    required String subtitle,
    required List<List<String>> orderList,
  }) : super(
          LearningAutoChatTopicRoute.name,
          path: '/learning_auto_chat_topic_page',
          args: LearningAutoChatTopicRouteArgs(
            key: key,
            contentList: contentList,
            translateList: translateList,
            title: title,
            speakerList: speakerList,
            subtitle: subtitle,
            orderList: orderList,
          ),
        );

  static const String name = 'LearningAutoChatTopicRoute';
}

class LearningAutoChatTopicRouteArgs {
  const LearningAutoChatTopicRouteArgs({
    this.key,
    required this.contentList,
    required this.translateList,
    required this.title,
    required this.speakerList,
    required this.subtitle,
    required this.orderList,
  });

  final _i29.Key? key;

  final List<List<String>> contentList;

  final List<List<String>> translateList;

  final String title;

  final List<List<String>> speakerList;

  final String subtitle;

  final List<List<String>> orderList;

  @override
  String toString() {
    return 'LearningAutoChatTopicRouteArgs{key: $key, contentList: $contentList, translateList: $translateList, title: $title, speakerList: $speakerList, subtitle: $subtitle, orderList: $orderList}';
  }
}

/// generated route for
/// [_i9.VocabularyPracticeWordIndexPage]
class VocabularyPracticeWordIndexRoute extends _i28.PageRouteInfo<void> {
  const VocabularyPracticeWordIndexRoute()
      : super(
          VocabularyPracticeWordIndexRoute.name,
          path: '/voabulary_practice_word_index',
        );

  static const String name = 'VocabularyPracticeWordIndexRoute';
}

/// generated route for
/// [_i10.VocabularyPracticeWordListPage]
class VocabularyPracticeWordListRoute
    extends _i28.PageRouteInfo<VocabularyPracticeWordListRouteArgs> {
  VocabularyPracticeWordListRoute({
    _i29.Key? key,
    required List<dynamic> vocabularyList,
  }) : super(
          VocabularyPracticeWordListRoute.name,
          path: '/voabulary_practice_word_list',
          args: VocabularyPracticeWordListRouteArgs(
            key: key,
            vocabularyList: vocabularyList,
          ),
        );

  static const String name = 'VocabularyPracticeWordListRoute';
}

class VocabularyPracticeWordListRouteArgs {
  const VocabularyPracticeWordListRouteArgs({
    this.key,
    required this.vocabularyList,
  });

  final _i29.Key? key;

  final List<dynamic> vocabularyList;

  @override
  String toString() {
    return 'VocabularyPracticeWordListRouteArgs{key: $key, vocabularyList: $vocabularyList}';
  }
}

/// generated route for
/// [_i11.MinimalPairIndexPage]
class MinimalPairIndexRoute extends _i28.PageRouteInfo<void> {
  const MinimalPairIndexRoute()
      : super(
          MinimalPairIndexRoute.name,
          path: '/minimal_pair_index',
        );

  static const String name = 'MinimalPairIndexRoute';
}

/// generated route for
/// [_i12.CustomArticlePracticeSentenceIndexPage]
class CustomArticlePracticeSentenceIndexRoute extends _i28.PageRouteInfo<void> {
  const CustomArticlePracticeSentenceIndexRoute()
      : super(
          CustomArticlePracticeSentenceIndexRoute.name,
          path: '/customArticle_practice_sentence_index',
        );

  static const String name = 'CustomArticlePracticeSentenceIndexRoute';
}

/// generated route for
/// [_i13.VocabularyTestIndexPage]
class VocabularyTestIndexRoute extends _i28.PageRouteInfo<void> {
  const VocabularyTestIndexRoute()
      : super(
          VocabularyTestIndexRoute.name,
          path: '/vocabulary_test_index',
        );

  static const String name = 'VocabularyTestIndexRoute';
}

/// generated route for
/// [_i14.VocabularyTestQuestingPage]
class VocabularyTestQuestingRoute
    extends _i28.PageRouteInfo<VocabularyTestQuestingRouteArgs> {
  VocabularyTestQuestingRoute({
    _i29.Key? key,
    required List<dynamic> vocabularyTestQuestionList,
  }) : super(
          VocabularyTestQuestingRoute.name,
          path: '/vocabulary_test_questing',
          args: VocabularyTestQuestingRouteArgs(
            key: key,
            vocabularyTestQuestionList: vocabularyTestQuestionList,
          ),
        );

  static const String name = 'VocabularyTestQuestingRoute';
}

class VocabularyTestQuestingRouteArgs {
  const VocabularyTestQuestingRouteArgs({
    this.key,
    required this.vocabularyTestQuestionList,
  });

  final _i29.Key? key;

  final List<dynamic> vocabularyTestQuestionList;

  @override
  String toString() {
    return 'VocabularyTestQuestingRouteArgs{key: $key, vocabularyTestQuestionList: $vocabularyTestQuestionList}';
  }
}

/// generated route for
/// [_i15.VocabularyTestReportPage]
class VocabularyTestReportRoute
    extends _i28.PageRouteInfo<VocabularyTestReportRouteArgs> {
  VocabularyTestReportRoute({
    _i29.Key? key,
    required List<dynamic> vocabularyTestQuestionList,
    required List<String> chooseAnswerList,
  }) : super(
          VocabularyTestReportRoute.name,
          path: '/vocabulary_test_report',
          args: VocabularyTestReportRouteArgs(
            key: key,
            vocabularyTestQuestionList: vocabularyTestQuestionList,
            chooseAnswerList: chooseAnswerList,
          ),
        );

  static const String name = 'VocabularyTestReportRoute';
}

class VocabularyTestReportRouteArgs {
  const VocabularyTestReportRouteArgs({
    this.key,
    required this.vocabularyTestQuestionList,
    required this.chooseAnswerList,
  });

  final _i29.Key? key;

  final List<dynamic> vocabularyTestQuestionList;

  final List<String> chooseAnswerList;

  @override
  String toString() {
    return 'VocabularyTestReportRouteArgs{key: $key, vocabularyTestQuestionList: $vocabularyTestQuestionList, chooseAnswerList: $chooseAnswerList}';
  }
}

/// generated route for
/// [_i16.LearningAutoGenericPage]
class LearningAutoGenericRoute
    extends _i28.PageRouteInfo<LearningAutoGenericRouteArgs> {
  LearningAutoGenericRoute({
    _i29.Key? key,
    required List<String> contentList,
    required List<String> ipaList,
    required List<String> translateList,
  }) : super(
          LearningAutoGenericRoute.name,
          path: '/learnig_auto_generic',
          args: LearningAutoGenericRouteArgs(
            key: key,
            contentList: contentList,
            ipaList: ipaList,
            translateList: translateList,
          ),
        );

  static const String name = 'LearningAutoGenericRoute';
}

class LearningAutoGenericRouteArgs {
  const LearningAutoGenericRouteArgs({
    this.key,
    required this.contentList,
    required this.ipaList,
    required this.translateList,
  });

  final _i29.Key? key;

  final List<String> contentList;

  final List<String> ipaList;

  final List<String> translateList;

  @override
  String toString() {
    return 'LearningAutoGenericRouteArgs{key: $key, contentList: $contentList, ipaList: $ipaList, translateList: $translateList}';
  }
}

/// generated route for
/// [_i17.LearningAutoGenericSummaryReportPage]
class LearningAutoGenericSummaryReportRoute
    extends _i28.PageRouteInfo<LearningAutoGenericSummaryReportRouteArgs> {
  LearningAutoGenericSummaryReportRoute({
    _i29.Key? key,
    required Map<dynamic, dynamic> summaryReportData,
  }) : super(
          LearningAutoGenericSummaryReportRoute.name,
          path: '/learnig_auto_generic_summary_report',
          args: LearningAutoGenericSummaryReportRouteArgs(
            key: key,
            summaryReportData: summaryReportData,
          ),
        );

  static const String name = 'LearningAutoGenericSummaryReportRoute';
}

class LearningAutoGenericSummaryReportRouteArgs {
  const LearningAutoGenericSummaryReportRouteArgs({
    this.key,
    required this.summaryReportData,
  });

  final _i29.Key? key;

  final Map<dynamic, dynamic> summaryReportData;

  @override
  String toString() {
    return 'LearningAutoGenericSummaryReportRouteArgs{key: $key, summaryReportData: $summaryReportData}';
  }
}

/// generated route for
/// [_i18.LearningAutoMinimalPairPage]
class LearningAutoMinimalPairRoute
    extends _i28.PageRouteInfo<LearningAutoMinimalPairRouteArgs> {
  LearningAutoMinimalPairRoute({
    _i29.Key? key,
    String IPA1 = '',
    String IPA2 = '',
    String word = '',
  }) : super(
          LearningAutoMinimalPairRoute.name,
          path: '/learnig_auto_minimal_pair',
          args: LearningAutoMinimalPairRouteArgs(
            key: key,
            IPA1: IPA1,
            IPA2: IPA2,
            word: word,
          ),
        );

  static const String name = 'LearningAutoMinimalPairRoute';
}

class LearningAutoMinimalPairRouteArgs {
  const LearningAutoMinimalPairRouteArgs({
    this.key,
    this.IPA1 = '',
    this.IPA2 = '',
    this.word = '',
  });

  final _i29.Key? key;

  final String IPA1;

  final String IPA2;

  final String word;

  @override
  String toString() {
    return 'LearningAutoMinimalPairRouteArgs{key: $key, IPA1: $IPA1, IPA2: $IPA2, word: $word}';
  }
}

/// generated route for
/// [_i19.LearningManualContractionPage]
class LearningManualContractionRoute
    extends _i28.PageRouteInfo<LearningManualContractionRouteArgs> {
  LearningManualContractionRoute({
    _i29.Key? key,
    required List<String> getPairContraction,
    required List<String> getPairFullForm,
    required List<String> getPracticeContraction,
    required List<String> getPracticeContractionIPA,
    required List<String> getPracticeFullForm,
    required List<String> getPracticeSentence,
    required List<String> getPracticeSentenceIPA,
  }) : super(
          LearningManualContractionRoute.name,
          path: '/learning_manual_contraction_page',
          args: LearningManualContractionRouteArgs(
            key: key,
            getPairContraction: getPairContraction,
            getPairFullForm: getPairFullForm,
            getPracticeContraction: getPracticeContraction,
            getPracticeContractionIPA: getPracticeContractionIPA,
            getPracticeFullForm: getPracticeFullForm,
            getPracticeSentence: getPracticeSentence,
            getPracticeSentenceIPA: getPracticeSentenceIPA,
          ),
        );

  static const String name = 'LearningManualContractionRoute';
}

class LearningManualContractionRouteArgs {
  const LearningManualContractionRouteArgs({
    this.key,
    required this.getPairContraction,
    required this.getPairFullForm,
    required this.getPracticeContraction,
    required this.getPracticeContractionIPA,
    required this.getPracticeFullForm,
    required this.getPracticeSentence,
    required this.getPracticeSentenceIPA,
  });

  final _i29.Key? key;

  final List<String> getPairContraction;

  final List<String> getPairFullForm;

  final List<String> getPracticeContraction;

  final List<String> getPracticeContractionIPA;

  final List<String> getPracticeFullForm;

  final List<String> getPracticeSentence;

  final List<String> getPracticeSentenceIPA;

  @override
  String toString() {
    return 'LearningManualContractionRouteArgs{key: $key, getPairContraction: $getPairContraction, getPairFullForm: $getPairFullForm, getPracticeContraction: $getPracticeContraction, getPracticeContractionIPA: $getPracticeContractionIPA, getPracticeFullForm: $getPracticeFullForm, getPracticeSentence: $getPracticeSentence, getPracticeSentenceIPA: $getPracticeSentenceIPA}';
  }
}

/// generated route for
/// [_i20.LearningManualCustomArticlePracticeSentencePage]
class LearningManualCustomArticlePracticeSentenceRoute extends _i28
    .PageRouteInfo<LearningManualCustomArticlePracticeSentenceRouteArgs> {
  LearningManualCustomArticlePracticeSentenceRoute({
    _i29.Key? key,
    required List<dynamic> questionList,
    required List<dynamic> questionIPAList,
  }) : super(
          LearningManualCustomArticlePracticeSentenceRoute.name,
          path: '/learning_manual_custom_article_practice_sentence',
          args: LearningManualCustomArticlePracticeSentenceRouteArgs(
            key: key,
            questionList: questionList,
            questionIPAList: questionIPAList,
          ),
        );

  static const String name = 'LearningManualCustomArticlePracticeSentenceRoute';
}

class LearningManualCustomArticlePracticeSentenceRouteArgs {
  const LearningManualCustomArticlePracticeSentenceRouteArgs({
    this.key,
    required this.questionList,
    required this.questionIPAList,
  });

  final _i29.Key? key;

  final List<dynamic> questionList;

  final List<dynamic> questionIPAList;

  @override
  String toString() {
    return 'LearningManualCustomArticlePracticeSentenceRouteArgs{key: $key, questionList: $questionList, questionIPAList: $questionIPAList}';
  }
}

/// generated route for
/// [_i21.LearningManualIPAGraphemePairPage]
class LearningManualIPAGraphemePairRoute
    extends _i28.PageRouteInfo<LearningManualIPAGraphemePairRouteArgs> {
  LearningManualIPAGraphemePairRoute({
    _i29.Key? key,
    required String getIPASymbol,
    required List<String> getGraphemes,
    required List<String> getWord,
    required List<String> getWordIPA,
  }) : super(
          LearningManualIPAGraphemePairRoute.name,
          path: '/learning_manual_ipa_grapheme_pair_page',
          args: LearningManualIPAGraphemePairRouteArgs(
            key: key,
            getIPASymbol: getIPASymbol,
            getGraphemes: getGraphemes,
            getWord: getWord,
            getWordIPA: getWordIPA,
          ),
        );

  static const String name = 'LearningManualIPAGraphemePairRoute';
}

class LearningManualIPAGraphemePairRouteArgs {
  const LearningManualIPAGraphemePairRouteArgs({
    this.key,
    required this.getIPASymbol,
    required this.getGraphemes,
    required this.getWord,
    required this.getWordIPA,
  });

  final _i29.Key? key;

  final String getIPASymbol;

  final List<String> getGraphemes;

  final List<String> getWord;

  final List<String> getWordIPA;

  @override
  String toString() {
    return 'LearningManualIPAGraphemePairRouteArgs{key: $key, getIPASymbol: $getIPASymbol, getGraphemes: $getGraphemes, getWord: $getWord, getWordIPA: $getWordIPA}';
  }
}

/// generated route for
/// [_i22.LearningManualMinimalPairPage]
class LearningManualMinimalPairRoute
    extends _i28.PageRouteInfo<LearningManualMinimalPairRouteArgs> {
  LearningManualMinimalPairRoute({
    _i29.Key? key,
    String IPA1 = '',
    String IPA2 = '',
    String word = '',
  }) : super(
          LearningManualMinimalPairRoute.name,
          path: '/learning_manual_minimal_pair',
          args: LearningManualMinimalPairRouteArgs(
            key: key,
            IPA1: IPA1,
            IPA2: IPA2,
            word: word,
          ),
        );

  static const String name = 'LearningManualMinimalPairRoute';
}

class LearningManualMinimalPairRouteArgs {
  const LearningManualMinimalPairRouteArgs({
    this.key,
    this.IPA1 = '',
    this.IPA2 = '',
    this.word = '',
  });

  final _i29.Key? key;

  final String IPA1;

  final String IPA2;

  final String word;

  @override
  String toString() {
    return 'LearningManualMinimalPairRouteArgs{key: $key, IPA1: $IPA1, IPA2: $IPA2, word: $word}';
  }
}

/// generated route for
/// [_i23.LearningManualVocabularyPracticeSentencePage]
class LearningManualVocabularyPracticeSentenceRoute extends _i28
    .PageRouteInfo<LearningManualVocabularyPracticeSentenceRouteArgs> {
  LearningManualVocabularyPracticeSentenceRoute({
    _i29.Key? key,
    String topicClass = '',
    String topicName = '',
  }) : super(
          LearningManualVocabularyPracticeSentenceRoute.name,
          path: '/learning_manual_vocabulary_practice_sentence_page',
          args: LearningManualVocabularyPracticeSentenceRouteArgs(
            key: key,
            topicClass: topicClass,
            topicName: topicName,
          ),
        );

  static const String name = 'LearningManualVocabularyPracticeSentenceRoute';
}

class LearningManualVocabularyPracticeSentenceRouteArgs {
  const LearningManualVocabularyPracticeSentenceRouteArgs({
    this.key,
    this.topicClass = '',
    this.topicName = '',
  });

  final _i29.Key? key;

  final String topicClass;

  final String topicName;

  @override
  String toString() {
    return 'LearningManualVocabularyPracticeSentenceRouteArgs{key: $key, topicClass: $topicClass, topicName: $topicName}';
  }
}

/// generated route for
/// [_i24.LearningManualVocabularyPraticeWordPage]
class LearningManualVocabularyPraticeWordRoute
    extends _i28.PageRouteInfo<LearningManualVocabularyPraticeWordRouteArgs> {
  LearningManualVocabularyPraticeWordRoute({
    _i29.Key? key,
    required List<dynamic> vocabularyList,
    required List<dynamic> vocabularySentenceList,
  }) : super(
          LearningManualVocabularyPraticeWordRoute.name,
          path: '/learning_manual_vocabulary_practice_word',
          args: LearningManualVocabularyPraticeWordRouteArgs(
            key: key,
            vocabularyList: vocabularyList,
            vocabularySentenceList: vocabularySentenceList,
          ),
        );

  static const String name = 'LearningManualVocabularyPraticeWordRoute';
}

class LearningManualVocabularyPraticeWordRouteArgs {
  const LearningManualVocabularyPraticeWordRouteArgs({
    this.key,
    required this.vocabularyList,
    required this.vocabularySentenceList,
  });

  final _i29.Key? key;

  final List<dynamic> vocabularyList;

  final List<dynamic> vocabularySentenceList;

  @override
  String toString() {
    return 'LearningManualVocabularyPraticeWordRouteArgs{key: $key, vocabularyList: $vocabularyList, vocabularySentenceList: $vocabularySentenceList}';
  }
}

/// generated route for
/// [_i25.PreferenceTranslationSearchPage]
class PreferenceTranslationSearchRoute extends _i28.PageRouteInfo<void> {
  const PreferenceTranslationSearchRoute()
      : super(
          PreferenceTranslationSearchRoute.name,
          path: '/preference_translation_search',
        );

  static const String name = 'PreferenceTranslationSearchRoute';
}

/// generated route for
/// [_i26.PreferenceTranslationEditPage]
class PreferenceTranslationEditRoute
    extends _i28.PageRouteInfo<PreferenceTranslationEditRouteArgs> {
  PreferenceTranslationEditRoute({
    _i29.Key? key,
    required Map<dynamic, dynamic> sentenceDataList,
  }) : super(
          PreferenceTranslationEditRoute.name,
          path: '/preference_translation_edit',
          args: PreferenceTranslationEditRouteArgs(
            key: key,
            sentenceDataList: sentenceDataList,
          ),
        );

  static const String name = 'PreferenceTranslationEditRoute';
}

class PreferenceTranslationEditRouteArgs {
  const PreferenceTranslationEditRouteArgs({
    this.key,
    required this.sentenceDataList,
  });

  final _i29.Key? key;

  final Map<dynamic, dynamic> sentenceDataList;

  @override
  String toString() {
    return 'PreferenceTranslationEditRouteArgs{key: $key, sentenceDataList: $sentenceDataList}';
  }
}

/// generated route for
/// [_i27.SentenceAnalysisIndexPage]
class SentenceAnalysisIndexRoute
    extends _i28.PageRouteInfo<SentenceAnalysisIndexRouteArgs> {
  SentenceAnalysisIndexRoute({
    _i29.Key? key,
    required String analysisor,
  }) : super(
          SentenceAnalysisIndexRoute.name,
          path: '/sentence_analysis_index',
          args: SentenceAnalysisIndexRouteArgs(
            key: key,
            analysisor: analysisor,
          ),
        );

  static const String name = 'SentenceAnalysisIndexRoute';
}

class SentenceAnalysisIndexRouteArgs {
  const SentenceAnalysisIndexRouteArgs({
    this.key,
    required this.analysisor,
  });

  final _i29.Key? key;

  final String analysisor;

  @override
  String toString() {
    return 'SentenceAnalysisIndexRouteArgs{key: $key, analysisor: $analysisor}';
  }
}
