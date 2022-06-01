// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i21;
import 'package:flutter/foundation.dart' as _i23;
import 'package:flutter/material.dart' as _i22;

import '../page/customArticle_practice_sentence/custom_article_practice_sentence.dart'
    as _i11;
import '../page/customArticle_practice_sentence/custom_article_practice_sentence_learn_auto_page.dart'
    as _i12;
import '../page/customArticle_practice_sentence/custom_article_practice_sentence_learn_manual_page.dart'
    as _i13;
import '../page/index/index_page.dart' as _i2;
import '../page/learning/learning_auto_generic_page.dart' as _i17;
import '../page/learning/learning_manual_vocabulary_practice_word_page.dart'
    as _i18;
import '../page/login/sign_in_page.dart' as _i1;
import '../page/minimal_pair/minimal_pair_index_page.dart' as _i8;
import '../page/minimal_pair/minimal_pair_learn_auto_page.dart' as _i9;
import '../page/minimal_pair/minimal_pair_learn_manual_page.dart' as _i10;
import '../page/new_template/grammar_correction_main_page.dart' as _i19;
import '../page/new_template/index_learn_record_index_page.dart' as _i20;
import '../page/vocabulary_practice_sentence/vocabulary_practice_sentence_index_page.dart'
    as _i3;
import '../page/vocabulary_practice_sentence/vocabulary_practice_sentence_learn_auto_page.dart'
    as _i4;
import '../page/vocabulary_practice_sentence/vocabulary_practice_sentence_learn_manual_page.dart'
    as _i5;
import '../page/vocabulary_practice_word/vocabulary_practice_word_index_page.dart'
    as _i6;
import '../page/vocabulary_practice_word/vocabulary_practice_word_list_page.dart'
    as _i7;
import '../page/vocabulary_test/vocabulary_test_index_page.dart' as _i14;
import '../page/vocabulary_test/vocabulary_test_questing_page.dart' as _i15;
import '../page/vocabulary_test/vocabulary_test_report_page.dart' as _i16;

class AppRouter extends _i21.RootStackRouter {
  AppRouter([_i22.GlobalKey<_i22.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i21.PageFactory> pagesMap = {
    SignInRoute.name: (routeData) {
      return _i21.MaterialPageX<dynamic>(
          routeData: routeData, child: _i1.SignInPage());
    },
    IndexRoute.name: (routeData) {
      return _i21.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.IndexPage());
    },
    VocabularyPracticeSentenceIndexRoute.name: (routeData) {
      return _i21.MaterialPageX<dynamic>(
          routeData: routeData,
          child: const _i3.VocabularyPracticeSentenceIndexPage());
    },
    VocabularyPracticeSentenceLearnAutoRoute.name: (routeData) {
      final args =
          routeData.argsAs<VocabularyPracticeSentenceLearnAutoRouteArgs>(
              orElse: () =>
                  const VocabularyPracticeSentenceLearnAutoRouteArgs());
      return _i21.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i4.VocabularyPracticeSentenceLearnAutoPage(
              key: args.key,
              topicClass: args.topicClass,
              topicName: args.topicName,
              sentencesIDData: args.sentencesIDData,
              quizID: args.quizID,
              wordSet: args.wordSet));
    },
    VocabularyPracticeSentenceLearnManualRoute.name: (routeData) {
      final args =
          routeData.argsAs<VocabularyPracticeSentenceLearnManualRouteArgs>(
              orElse: () =>
                  const VocabularyPracticeSentenceLearnManualRouteArgs());
      return _i21.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i5.VocabularyPracticeSentenceLearnManualPage(
              key: args.key,
              topicClass: args.topicClass,
              topicName: args.topicName));
    },
    VocabularyPracticeWordIndexRoute.name: (routeData) {
      return _i21.MaterialPageX<dynamic>(
          routeData: routeData,
          child: const _i6.VocabularyPracticeWordIndexPage());
    },
    VocabularyPracticeWordListRoute.name: (routeData) {
      final args = routeData.argsAs<VocabularyPracticeWordListRouteArgs>();
      return _i21.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i7.VocabularyPracticeWordListPage(
              key: args.key, vocabularyList: args.vocabularyList));
    },
    MinimalPairIndexRoute.name: (routeData) {
      return _i21.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i8.MinimalPairIndexPage());
    },
    MinimalPairLearnAutoRoute.name: (routeData) {
      final args = routeData.argsAs<MinimalPairLearnAutoRouteArgs>(
          orElse: () => const MinimalPairLearnAutoRouteArgs());
      return _i21.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i9.MinimalPairLearnAutoPage(
              key: args.key,
              IPA1: args.IPA1,
              IPA2: args.IPA2,
              word: args.word));
    },
    MinimalPairLearnManualRoute.name: (routeData) {
      final args = routeData.argsAs<MinimalPairLearnManualRouteArgs>(
          orElse: () => const MinimalPairLearnManualRouteArgs());
      return _i21.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i10.MinimalPairLearnManualPage(
              key: args.key,
              IPA1: args.IPA1,
              IPA2: args.IPA2,
              word: args.word));
    },
    CustomArticlePracticeSentenceIndexRoute.name: (routeData) {
      return _i21.MaterialPageX<dynamic>(
          routeData: routeData,
          child: const _i11.CustomArticlePracticeSentenceIndexPage());
    },
    CustomArticlePracticeSentenceLearnAutoRoute.name: (routeData) {
      final args =
          routeData.argsAs<CustomArticlePracticeSentenceLearnAutoRouteArgs>();
      return _i21.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i12.CustomArticlePracticeSentenceLearnAutoPage(
              key: args.key, questionList: args.questionList));
    },
    CustomArticlePracticeSentenceLearnManualRoute.name: (routeData) {
      final args =
          routeData.argsAs<CustomArticlePracticeSentenceLearnManualRouteArgs>();
      return _i21.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i13.CustomArticlePracticeSentenceLearnManualPage(
              key: args.key,
              questionList: args.questionList,
              questionIPAList: args.questionIPAList));
    },
    VocabularyTestIndexRoute.name: (routeData) {
      return _i21.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i14.VocabularyTestIndexPage());
    },
    VocabularyTestQuestingRoute.name: (routeData) {
      final args = routeData.argsAs<VocabularyTestQuestingRouteArgs>();
      return _i21.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i15.VocabularyTestQuestingPage(
              key: args.key,
              vocabularyTestQuestionList: args.vocabularyTestQuestionList));
    },
    VocabularyTestReportRoute.name: (routeData) {
      final args = routeData.argsAs<VocabularyTestReportRouteArgs>();
      return _i21.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i16.VocabularyTestReportPage(
              key: args.key,
              vocabularyTestQuestionList: args.vocabularyTestQuestionList,
              chooseAnswerList: args.chooseAnswerList));
    },
    LearningAutoGenericRoute.name: (routeData) {
      final args = routeData.argsAs<LearningAutoGenericRouteArgs>();
      return _i21.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i17.LearningAutoGenericPage(
              key: args.key,
              contentList: args.contentList,
              ipaList: args.ipaList,
              translateList: args.translateList));
    },
    LearningManualVocabularyPraticeWordRoute.name: (routeData) {
      final args =
          routeData.argsAs<LearningManualVocabularyPraticeWordRouteArgs>();
      return _i21.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i18.LearningManualVocabularyPraticeWordPage(
              key: args.key,
              vocabularyList: args.vocabularyList,
              vocabularySentenceList: args.vocabularySentenceList));
    },
    GrammarCorrectionMainRoute.name: (routeData) {
      return _i21.MaterialPageX<dynamic>(
          routeData: routeData, child: _i19.GrammarCorrectionMainPage());
    },
    IndexLearnRecordIndexRoute.name: (routeData) {
      return _i21.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i20.IndexLearnRecordIndexPage());
    }
  };

  @override
  List<_i21.RouteConfig> get routes => [
        _i21.RouteConfig(SignInRoute.name, path: '/'),
        _i21.RouteConfig(IndexRoute.name, path: '/index'),
        _i21.RouteConfig(VocabularyPracticeSentenceIndexRoute.name,
            path: '/voabulary_practice_sentence_index'),
        _i21.RouteConfig(VocabularyPracticeSentenceLearnAutoRoute.name,
            path: '/voabulary_practice_sentence_auto'),
        _i21.RouteConfig(VocabularyPracticeSentenceLearnManualRoute.name,
            path: '/voabulary_practice_sentence_manual'),
        _i21.RouteConfig(VocabularyPracticeWordIndexRoute.name,
            path: '/voabulary_practice_word_index'),
        _i21.RouteConfig(VocabularyPracticeWordListRoute.name,
            path: '/voabulary_practice_word_list'),
        _i21.RouteConfig(MinimalPairIndexRoute.name,
            path: '/minimal_pair_index'),
        _i21.RouteConfig(MinimalPairLearnAutoRoute.name,
            path: '/minimal_pair_auto'),
        _i21.RouteConfig(MinimalPairLearnManualRoute.name,
            path: '/minimal_pair_manual'),
        _i21.RouteConfig(CustomArticlePracticeSentenceIndexRoute.name,
            path: '/customArticle_practice_sentence_index'),
        _i21.RouteConfig(CustomArticlePracticeSentenceLearnAutoRoute.name,
            path: '/customArticle_practice_sentence_auto'),
        _i21.RouteConfig(CustomArticlePracticeSentenceLearnManualRoute.name,
            path: '/customArticle_practice_sentence_manual'),
        _i21.RouteConfig(VocabularyTestIndexRoute.name,
            path: '/vocabulary_test_index'),
        _i21.RouteConfig(VocabularyTestQuestingRoute.name,
            path: '/vocabulary_test_questing'),
        _i21.RouteConfig(VocabularyTestReportRoute.name,
            path: '/vocabulary_test_report'),
        _i21.RouteConfig(LearningAutoGenericRoute.name,
            path: '/learnig_auto_generic'),
        _i21.RouteConfig(LearningManualVocabularyPraticeWordRoute.name,
            path: '/learning_manual_vocabulary_practice_word'),
        _i21.RouteConfig(GrammarCorrectionMainRoute.name,
            path: '/grammar_correction_main_page'),
        _i21.RouteConfig(IndexLearnRecordIndexRoute.name,
            path: '/vocabulary_record_index_page')
      ];
}

/// generated route for
/// [_i1.SignInPage]
class SignInRoute extends _i21.PageRouteInfo<void> {
  const SignInRoute() : super(SignInRoute.name, path: '/');

  static const String name = 'SignInRoute';
}

/// generated route for
/// [_i2.IndexPage]
class IndexRoute extends _i21.PageRouteInfo<void> {
  const IndexRoute() : super(IndexRoute.name, path: '/index');

  static const String name = 'IndexRoute';
}

/// generated route for
/// [_i3.VocabularyPracticeSentenceIndexPage]
class VocabularyPracticeSentenceIndexRoute extends _i21.PageRouteInfo<void> {
  const VocabularyPracticeSentenceIndexRoute()
      : super(VocabularyPracticeSentenceIndexRoute.name,
            path: '/voabulary_practice_sentence_index');

  static const String name = 'VocabularyPracticeSentenceIndexRoute';
}

/// generated route for
/// [_i4.VocabularyPracticeSentenceLearnAutoPage]
class VocabularyPracticeSentenceLearnAutoRoute
    extends _i21.PageRouteInfo<VocabularyPracticeSentenceLearnAutoRouteArgs> {
  VocabularyPracticeSentenceLearnAutoRoute(
      {_i23.Key? key,
      String topicClass = '',
      String topicName = '',
      List<int> sentencesIDData = const [],
      int quizID = 0,
      Map<String, dynamic> wordSet = const {
        'learningClassification': '',
        'learningPhase': ''
      }})
      : super(VocabularyPracticeSentenceLearnAutoRoute.name,
            path: '/voabulary_practice_sentence_auto',
            args: VocabularyPracticeSentenceLearnAutoRouteArgs(
                key: key,
                topicClass: topicClass,
                topicName: topicName,
                sentencesIDData: sentencesIDData,
                quizID: quizID,
                wordSet: wordSet));

  static const String name = 'VocabularyPracticeSentenceLearnAutoRoute';
}

class VocabularyPracticeSentenceLearnAutoRouteArgs {
  const VocabularyPracticeSentenceLearnAutoRouteArgs(
      {this.key,
      this.topicClass = '',
      this.topicName = '',
      this.sentencesIDData = const [],
      this.quizID = 0,
      this.wordSet = const {
        'learningClassification': '',
        'learningPhase': ''
      }});

  final _i23.Key? key;

  final String topicClass;

  final String topicName;

  final List<int> sentencesIDData;

  final int quizID;

  final Map<String, dynamic> wordSet;

  @override
  String toString() {
    return 'VocabularyPracticeSentenceLearnAutoRouteArgs{key: $key, topicClass: $topicClass, topicName: $topicName, sentencesIDData: $sentencesIDData, quizID: $quizID, wordSet: $wordSet}';
  }
}

/// generated route for
/// [_i5.VocabularyPracticeSentenceLearnManualPage]
class VocabularyPracticeSentenceLearnManualRoute
    extends _i21.PageRouteInfo<VocabularyPracticeSentenceLearnManualRouteArgs> {
  VocabularyPracticeSentenceLearnManualRoute(
      {_i23.Key? key, String topicClass = '', String topicName = ''})
      : super(VocabularyPracticeSentenceLearnManualRoute.name,
            path: '/voabulary_practice_sentence_manual',
            args: VocabularyPracticeSentenceLearnManualRouteArgs(
                key: key, topicClass: topicClass, topicName: topicName));

  static const String name = 'VocabularyPracticeSentenceLearnManualRoute';
}

class VocabularyPracticeSentenceLearnManualRouteArgs {
  const VocabularyPracticeSentenceLearnManualRouteArgs(
      {this.key, this.topicClass = '', this.topicName = ''});

  final _i23.Key? key;

  final String topicClass;

  final String topicName;

  @override
  String toString() {
    return 'VocabularyPracticeSentenceLearnManualRouteArgs{key: $key, topicClass: $topicClass, topicName: $topicName}';
  }
}

/// generated route for
/// [_i6.VocabularyPracticeWordIndexPage]
class VocabularyPracticeWordIndexRoute extends _i21.PageRouteInfo<void> {
  const VocabularyPracticeWordIndexRoute()
      : super(VocabularyPracticeWordIndexRoute.name,
            path: '/voabulary_practice_word_index');

  static const String name = 'VocabularyPracticeWordIndexRoute';
}

/// generated route for
/// [_i7.VocabularyPracticeWordListPage]
class VocabularyPracticeWordListRoute
    extends _i21.PageRouteInfo<VocabularyPracticeWordListRouteArgs> {
  VocabularyPracticeWordListRoute(
      {_i23.Key? key, required List<dynamic> vocabularyList})
      : super(VocabularyPracticeWordListRoute.name,
            path: '/voabulary_practice_word_list',
            args: VocabularyPracticeWordListRouteArgs(
                key: key, vocabularyList: vocabularyList));

  static const String name = 'VocabularyPracticeWordListRoute';
}

class VocabularyPracticeWordListRouteArgs {
  const VocabularyPracticeWordListRouteArgs(
      {this.key, required this.vocabularyList});

  final _i23.Key? key;

  final List<dynamic> vocabularyList;

  @override
  String toString() {
    return 'VocabularyPracticeWordListRouteArgs{key: $key, vocabularyList: $vocabularyList}';
  }
}

/// generated route for
/// [_i8.MinimalPairIndexPage]
class MinimalPairIndexRoute extends _i21.PageRouteInfo<void> {
  const MinimalPairIndexRoute()
      : super(MinimalPairIndexRoute.name, path: '/minimal_pair_index');

  static const String name = 'MinimalPairIndexRoute';
}

/// generated route for
/// [_i9.MinimalPairLearnAutoPage]
class MinimalPairLearnAutoRoute
    extends _i21.PageRouteInfo<MinimalPairLearnAutoRouteArgs> {
  MinimalPairLearnAutoRoute(
      {_i23.Key? key, String IPA1 = '', String IPA2 = '', String word = ''})
      : super(MinimalPairLearnAutoRoute.name,
            path: '/minimal_pair_auto',
            args: MinimalPairLearnAutoRouteArgs(
                key: key, IPA1: IPA1, IPA2: IPA2, word: word));

  static const String name = 'MinimalPairLearnAutoRoute';
}

class MinimalPairLearnAutoRouteArgs {
  const MinimalPairLearnAutoRouteArgs(
      {this.key, this.IPA1 = '', this.IPA2 = '', this.word = ''});

  final _i23.Key? key;

  final String IPA1;

  final String IPA2;

  final String word;

  @override
  String toString() {
    return 'MinimalPairLearnAutoRouteArgs{key: $key, IPA1: $IPA1, IPA2: $IPA2, word: $word}';
  }
}

/// generated route for
/// [_i10.MinimalPairLearnManualPage]
class MinimalPairLearnManualRoute
    extends _i21.PageRouteInfo<MinimalPairLearnManualRouteArgs> {
  MinimalPairLearnManualRoute(
      {_i23.Key? key, String IPA1 = '', String IPA2 = '', String word = ''})
      : super(MinimalPairLearnManualRoute.name,
            path: '/minimal_pair_manual',
            args: MinimalPairLearnManualRouteArgs(
                key: key, IPA1: IPA1, IPA2: IPA2, word: word));

  static const String name = 'MinimalPairLearnManualRoute';
}

class MinimalPairLearnManualRouteArgs {
  const MinimalPairLearnManualRouteArgs(
      {this.key, this.IPA1 = '', this.IPA2 = '', this.word = ''});

  final _i23.Key? key;

  final String IPA1;

  final String IPA2;

  final String word;

  @override
  String toString() {
    return 'MinimalPairLearnManualRouteArgs{key: $key, IPA1: $IPA1, IPA2: $IPA2, word: $word}';
  }
}

/// generated route for
/// [_i11.CustomArticlePracticeSentenceIndexPage]
class CustomArticlePracticeSentenceIndexRoute extends _i21.PageRouteInfo<void> {
  const CustomArticlePracticeSentenceIndexRoute()
      : super(CustomArticlePracticeSentenceIndexRoute.name,
            path: '/customArticle_practice_sentence_index');

  static const String name = 'CustomArticlePracticeSentenceIndexRoute';
}

/// generated route for
/// [_i12.CustomArticlePracticeSentenceLearnAutoPage]
class CustomArticlePracticeSentenceLearnAutoRoute extends _i21
    .PageRouteInfo<CustomArticlePracticeSentenceLearnAutoRouteArgs> {
  CustomArticlePracticeSentenceLearnAutoRoute(
      {_i23.Key? key, required List<dynamic> questionList})
      : super(CustomArticlePracticeSentenceLearnAutoRoute.name,
            path: '/customArticle_practice_sentence_auto',
            args: CustomArticlePracticeSentenceLearnAutoRouteArgs(
                key: key, questionList: questionList));

  static const String name = 'CustomArticlePracticeSentenceLearnAutoRoute';
}

class CustomArticlePracticeSentenceLearnAutoRouteArgs {
  const CustomArticlePracticeSentenceLearnAutoRouteArgs(
      {this.key, required this.questionList});

  final _i23.Key? key;

  final List<dynamic> questionList;

  @override
  String toString() {
    return 'CustomArticlePracticeSentenceLearnAutoRouteArgs{key: $key, questionList: $questionList}';
  }
}

/// generated route for
/// [_i13.CustomArticlePracticeSentenceLearnManualPage]
class CustomArticlePracticeSentenceLearnManualRoute extends _i21
    .PageRouteInfo<CustomArticlePracticeSentenceLearnManualRouteArgs> {
  CustomArticlePracticeSentenceLearnManualRoute(
      {_i23.Key? key,
      required List<dynamic> questionList,
      required List<dynamic> questionIPAList})
      : super(CustomArticlePracticeSentenceLearnManualRoute.name,
            path: '/customArticle_practice_sentence_manual',
            args: CustomArticlePracticeSentenceLearnManualRouteArgs(
                key: key,
                questionList: questionList,
                questionIPAList: questionIPAList));

  static const String name = 'CustomArticlePracticeSentenceLearnManualRoute';
}

class CustomArticlePracticeSentenceLearnManualRouteArgs {
  const CustomArticlePracticeSentenceLearnManualRouteArgs(
      {this.key, required this.questionList, required this.questionIPAList});

  final _i23.Key? key;

  final List<dynamic> questionList;

  final List<dynamic> questionIPAList;

  @override
  String toString() {
    return 'CustomArticlePracticeSentenceLearnManualRouteArgs{key: $key, questionList: $questionList, questionIPAList: $questionIPAList}';
  }
}

/// generated route for
/// [_i14.VocabularyTestIndexPage]
class VocabularyTestIndexRoute extends _i21.PageRouteInfo<void> {
  const VocabularyTestIndexRoute()
      : super(VocabularyTestIndexRoute.name, path: '/vocabulary_test_index');

  static const String name = 'VocabularyTestIndexRoute';
}

/// generated route for
/// [_i15.VocabularyTestQuestingPage]
class VocabularyTestQuestingRoute
    extends _i21.PageRouteInfo<VocabularyTestQuestingRouteArgs> {
  VocabularyTestQuestingRoute(
      {_i23.Key? key, required List<dynamic> vocabularyTestQuestionList})
      : super(VocabularyTestQuestingRoute.name,
            path: '/vocabulary_test_questing',
            args: VocabularyTestQuestingRouteArgs(
                key: key,
                vocabularyTestQuestionList: vocabularyTestQuestionList));

  static const String name = 'VocabularyTestQuestingRoute';
}

class VocabularyTestQuestingRouteArgs {
  const VocabularyTestQuestingRouteArgs(
      {this.key, required this.vocabularyTestQuestionList});

  final _i23.Key? key;

  final List<dynamic> vocabularyTestQuestionList;

  @override
  String toString() {
    return 'VocabularyTestQuestingRouteArgs{key: $key, vocabularyTestQuestionList: $vocabularyTestQuestionList}';
  }
}

/// generated route for
/// [_i16.VocabularyTestReportPage]
class VocabularyTestReportRoute
    extends _i21.PageRouteInfo<VocabularyTestReportRouteArgs> {
  VocabularyTestReportRoute(
      {_i23.Key? key,
      required List<dynamic> vocabularyTestQuestionList,
      required List<String> chooseAnswerList})
      : super(VocabularyTestReportRoute.name,
            path: '/vocabulary_test_report',
            args: VocabularyTestReportRouteArgs(
                key: key,
                vocabularyTestQuestionList: vocabularyTestQuestionList,
                chooseAnswerList: chooseAnswerList));

  static const String name = 'VocabularyTestReportRoute';
}

class VocabularyTestReportRouteArgs {
  const VocabularyTestReportRouteArgs(
      {this.key,
      required this.vocabularyTestQuestionList,
      required this.chooseAnswerList});

  final _i23.Key? key;

  final List<dynamic> vocabularyTestQuestionList;

  final List<String> chooseAnswerList;

  @override
  String toString() {
    return 'VocabularyTestReportRouteArgs{key: $key, vocabularyTestQuestionList: $vocabularyTestQuestionList, chooseAnswerList: $chooseAnswerList}';
  }
}

/// generated route for
/// [_i17.LearningAutoGenericPage]
class LearningAutoGenericRoute
    extends _i21.PageRouteInfo<LearningAutoGenericRouteArgs> {
  LearningAutoGenericRoute(
      {_i23.Key? key,
      required List<String> contentList,
      required List<String> ipaList,
      required List<String> translateList})
      : super(LearningAutoGenericRoute.name,
            path: '/learnig_auto_generic',
            args: LearningAutoGenericRouteArgs(
                key: key,
                contentList: contentList,
                ipaList: ipaList,
                translateList: translateList));

  static const String name = 'LearningAutoGenericRoute';
}

class LearningAutoGenericRouteArgs {
  const LearningAutoGenericRouteArgs(
      {this.key,
      required this.contentList,
      required this.ipaList,
      required this.translateList});

  final _i23.Key? key;

  final List<String> contentList;

  final List<String> ipaList;

  final List<String> translateList;

  @override
  String toString() {
    return 'LearningAutoGenericRouteArgs{key: $key, contentList: $contentList, ipaList: $ipaList, translateList: $translateList}';
  }
}

/// generated route for
/// [_i18.LearningManualVocabularyPraticeWordPage]
class LearningManualVocabularyPraticeWordRoute
    extends _i21.PageRouteInfo<LearningManualVocabularyPraticeWordRouteArgs> {
  LearningManualVocabularyPraticeWordRoute(
      {_i23.Key? key,
      required List<dynamic> vocabularyList,
      required List<dynamic> vocabularySentenceList})
      : super(LearningManualVocabularyPraticeWordRoute.name,
            path: '/learning_manual_vocabulary_practice_word',
            args: LearningManualVocabularyPraticeWordRouteArgs(
                key: key,
                vocabularyList: vocabularyList,
                vocabularySentenceList: vocabularySentenceList));

  static const String name = 'LearningManualVocabularyPraticeWordRoute';
}

class LearningManualVocabularyPraticeWordRouteArgs {
  const LearningManualVocabularyPraticeWordRouteArgs(
      {this.key,
      required this.vocabularyList,
      required this.vocabularySentenceList});

  final _i23.Key? key;

  final List<dynamic> vocabularyList;

  final List<dynamic> vocabularySentenceList;

  @override
  String toString() {
    return 'LearningManualVocabularyPraticeWordRouteArgs{key: $key, vocabularyList: $vocabularyList, vocabularySentenceList: $vocabularySentenceList}';
  }
}

/// generated route for
/// [_i19.GrammarCorrectionMainPage]
class GrammarCorrectionMainRoute extends _i21.PageRouteInfo<void> {
  const GrammarCorrectionMainRoute()
      : super(GrammarCorrectionMainRoute.name,
            path: '/grammar_correction_main_page');

  static const String name = 'GrammarCorrectionMainRoute';
}

/// generated route for
/// [_i20.IndexLearnRecordIndexPage]
class IndexLearnRecordIndexRoute extends _i21.PageRouteInfo<void> {
  const IndexLearnRecordIndexRoute()
      : super(IndexLearnRecordIndexRoute.name,
            path: '/vocabulary_record_index_page');

  static const String name = 'IndexLearnRecordIndexRoute';
}
