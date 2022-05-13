// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i12;
import 'package:flutter/material.dart' as _i13;

import '../page/index/index_page.dart' as _i2;
import '../page/index/index_vocabulary_test_level_select_page.dart' as _i8;
import '../page/index/index_vocabulary_test_questing_page.dart' as _i9;
import '../page/login/sign_in_page.dart' as _i1;
import '../page/syllable_practice/syllable_practice_main_page3.dart' as _i11;
import '../page/syllable_practice/syllable_practice_search_page.dart' as _i10;
import '../page/vocabulary_practice_sentence/vocabulary_practice_sentence_index_page.dart'
    as _i3;
import '../page/vocabulary_practice_sentence/vocabulary_practice_sentence_learn_auto_page.dart'
    as _i4;
import '../page/vocabulary_practice_sentence/vocabulary_practice_sentence_learn_manual_page.dart'
    as _i5;
import '../page/vocabulary_practice_word/vocabulary_practice_word_index_page.dart'
    as _i6;
import '../page/vocabulary_practice_word/vocabulary_practice_word_learn_page.dart'
    as _i7;

class AppRouter extends _i12.RootStackRouter {
  AppRouter([_i13.GlobalKey<_i13.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i12.PageFactory> pagesMap = {
    SignInRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
          routeData: routeData, child: _i1.SignInPage());
    },
    IndexRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.IndexPage());
    },
    VocabularyPracticeSentenceIndexRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
          routeData: routeData,
          child: const _i3.VocabularyPracticeSentenceIndexPage());
    },
    VocabularyPracticeSentenceLearnAutoRoute.name: (routeData) {
      final args =
          routeData.argsAs<VocabularyPracticeSentenceLearnAutoRouteArgs>(
              orElse: () =>
                  const VocabularyPracticeSentenceLearnAutoRouteArgs());
      return _i12.MaterialPageX<dynamic>(
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
      return _i12.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i5.VocabularyPracticeSentenceLearnManualPage(
              key: args.key,
              topicClass: args.topicClass,
              topicName: args.topicName));
    },
    VocabularyPracticeWordIndexRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
          routeData: routeData,
          child: const _i6.VocabularyPracticeWordIndexPage());
    },
    VocabularyPracticeWordLearnRoute.name: (routeData) {
      final args = routeData.argsAs<VocabularyPracticeWordLearnRouteArgs>();
      return _i12.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i7.VocabularyPracticeWordLearnPage(
              key: args.key, word: args.word));
    },
    IndexVocabularyTestLevelSelectRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
          routeData: routeData,
          child: const _i8.IndexVocabularyTestLevelSelectPage());
    },
    IndexVocabularyTestQuestingRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
          routeData: routeData,
          child: const _i9.IndexVocabularyTestQuestingPage());
    },
    SyllablePracticeSearchRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
          routeData: routeData, child: _i10.SyllablePracticeSearchPage());
    },
    SyllablePracticeMainRoute3.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
          routeData: routeData, child: _i11.SyllablePracticeMainPage3());
    }
  };

  @override
  List<_i12.RouteConfig> get routes => [
        _i12.RouteConfig(SignInRoute.name, path: '/'),
        _i12.RouteConfig(IndexRoute.name, path: '/index'),
        _i12.RouteConfig(VocabularyPracticeSentenceIndexRoute.name,
            path: '/voabulary_practice_sentence_index'),
        _i12.RouteConfig(VocabularyPracticeSentenceLearnAutoRoute.name,
            path: '/voabulary_practice_sentence_auto'),
        _i12.RouteConfig(VocabularyPracticeSentenceLearnManualRoute.name,
            path: '/voabulary_practice_sentence_manual'),
        _i12.RouteConfig(VocabularyPracticeWordIndexRoute.name,
            path: '/voabulary_practice_word_index'),
        _i12.RouteConfig(VocabularyPracticeWordLearnRoute.name,
            path: '/voabulary_practice_word_learn'),
        _i12.RouteConfig(IndexVocabularyTestLevelSelectRoute.name,
            path: '/vocabulary_test_select_level'),
        _i12.RouteConfig(IndexVocabularyTestQuestingRoute.name,
            path: '/vocabulary_test_questing'),
        _i12.RouteConfig(SyllablePracticeSearchRoute.name,
            path: '/syllable_practice_search'),
        _i12.RouteConfig(SyllablePracticeMainRoute3.name,
            path: '/syllable_practice_main_page')
      ];
}

/// generated route for
/// [_i1.SignInPage]
class SignInRoute extends _i12.PageRouteInfo<void> {
  const SignInRoute() : super(SignInRoute.name, path: '/');

  static const String name = 'SignInRoute';
}

/// generated route for
/// [_i2.IndexPage]
class IndexRoute extends _i12.PageRouteInfo<void> {
  const IndexRoute() : super(IndexRoute.name, path: '/index');

  static const String name = 'IndexRoute';
}

/// generated route for
/// [_i3.VocabularyPracticeSentenceIndexPage]
class VocabularyPracticeSentenceIndexRoute extends _i12.PageRouteInfo<void> {
  const VocabularyPracticeSentenceIndexRoute()
      : super(VocabularyPracticeSentenceIndexRoute.name,
            path: '/voabulary_practice_sentence_index');

  static const String name = 'VocabularyPracticeSentenceIndexRoute';
}

/// generated route for
/// [_i4.VocabularyPracticeSentenceLearnAutoPage]
class VocabularyPracticeSentenceLearnAutoRoute
    extends _i12.PageRouteInfo<VocabularyPracticeSentenceLearnAutoRouteArgs> {
  VocabularyPracticeSentenceLearnAutoRoute(
      {_i13.Key? key,
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

  final _i13.Key? key;

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
    extends _i12.PageRouteInfo<VocabularyPracticeSentenceLearnManualRouteArgs> {
  VocabularyPracticeSentenceLearnManualRoute(
      {_i13.Key? key, String topicClass = '', String topicName = ''})
      : super(VocabularyPracticeSentenceLearnManualRoute.name,
            path: '/voabulary_practice_sentence_manual',
            args: VocabularyPracticeSentenceLearnManualRouteArgs(
                key: key, topicClass: topicClass, topicName: topicName));

  static const String name = 'VocabularyPracticeSentenceLearnManualRoute';
}

class VocabularyPracticeSentenceLearnManualRouteArgs {
  const VocabularyPracticeSentenceLearnManualRouteArgs(
      {this.key, this.topicClass = '', this.topicName = ''});

  final _i13.Key? key;

  final String topicClass;

  final String topicName;

  @override
  String toString() {
    return 'VocabularyPracticeSentenceLearnManualRouteArgs{key: $key, topicClass: $topicClass, topicName: $topicName}';
  }
}

/// generated route for
/// [_i6.VocabularyPracticeWordIndexPage]
class VocabularyPracticeWordIndexRoute extends _i12.PageRouteInfo<void> {
  const VocabularyPracticeWordIndexRoute()
      : super(VocabularyPracticeWordIndexRoute.name,
            path: '/voabulary_practice_word_index');

  static const String name = 'VocabularyPracticeWordIndexRoute';
}

/// generated route for
/// [_i7.VocabularyPracticeWordLearnPage]
class VocabularyPracticeWordLearnRoute
    extends _i12.PageRouteInfo<VocabularyPracticeWordLearnRouteArgs> {
  VocabularyPracticeWordLearnRoute({_i13.Key? key, required String word})
      : super(VocabularyPracticeWordLearnRoute.name,
            path: '/voabulary_practice_word_learn',
            args: VocabularyPracticeWordLearnRouteArgs(key: key, word: word));

  static const String name = 'VocabularyPracticeWordLearnRoute';
}

class VocabularyPracticeWordLearnRouteArgs {
  const VocabularyPracticeWordLearnRouteArgs({this.key, required this.word});

  final _i13.Key? key;

  final String word;

  @override
  String toString() {
    return 'VocabularyPracticeWordLearnRouteArgs{key: $key, word: $word}';
  }
}

/// generated route for
/// [_i8.IndexVocabularyTestLevelSelectPage]
class IndexVocabularyTestLevelSelectRoute extends _i12.PageRouteInfo<void> {
  const IndexVocabularyTestLevelSelectRoute()
      : super(IndexVocabularyTestLevelSelectRoute.name,
            path: '/vocabulary_test_select_level');

  static const String name = 'IndexVocabularyTestLevelSelectRoute';
}

/// generated route for
/// [_i9.IndexVocabularyTestQuestingPage]
class IndexVocabularyTestQuestingRoute extends _i12.PageRouteInfo<void> {
  const IndexVocabularyTestQuestingRoute()
      : super(IndexVocabularyTestQuestingRoute.name,
            path: '/vocabulary_test_questing');

  static const String name = 'IndexVocabularyTestQuestingRoute';
}

/// generated route for
/// [_i10.SyllablePracticeSearchPage]
class SyllablePracticeSearchRoute extends _i12.PageRouteInfo<void> {
  const SyllablePracticeSearchRoute()
      : super(SyllablePracticeSearchRoute.name,
            path: '/syllable_practice_search');

  static const String name = 'SyllablePracticeSearchRoute';
}

/// generated route for
/// [_i11.SyllablePracticeMainPage3]
class SyllablePracticeMainRoute3 extends _i12.PageRouteInfo<void> {
  const SyllablePracticeMainRoute3()
      : super(SyllablePracticeMainRoute3.name,
            path: '/syllable_practice_main_page');

  static const String name = 'SyllablePracticeMainRoute3';
}
