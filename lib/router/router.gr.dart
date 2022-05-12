// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i9;
import 'package:flutter/material.dart' as _i10;

import '../page/customArticle_practice_sentence/custom_article_practice_sentence.dart'
    as _i8;
import '../page/index/index_page.dart' as _i2;
import '../page/login/sign_in_page.dart' as _i1;
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

class AppRouter extends _i9.RootStackRouter {
  AppRouter([_i10.GlobalKey<_i10.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    SignInRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData, child: _i1.SignInPage());
    },
    IndexRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.IndexPage());
    },
    VocabularyPracticeSentenceIndexRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData,
          child: const _i3.VocabularyPracticeSentenceIndexPage());
    },
    VocabularyPracticeSentenceLearnAutoRoute.name: (routeData) {
      final args =
          routeData.argsAs<VocabularyPracticeSentenceLearnAutoRouteArgs>(
              orElse: () =>
                  const VocabularyPracticeSentenceLearnAutoRouteArgs());
      return _i9.MaterialPageX<dynamic>(
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
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i5.VocabularyPracticeSentenceLearnManualPage(
              key: args.key,
              topicClass: args.topicClass,
              topicName: args.topicName));
    },
    VocabularyPracticeWordIndexRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData,
          child: const _i6.VocabularyPracticeWordIndexPage());
    },
    VocabularyPracticeWordLearnRoute.name: (routeData) {
      final args = routeData.argsAs<VocabularyPracticeWordLearnRouteArgs>();
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i7.VocabularyPracticeWordLearnPage(
              key: args.key, word: args.word));
    },
    CustomArticlePracticeSentenceIndexRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData,
          child: const _i8.CustomArticlePracticeSentenceIndexPage());
    }
  };

  @override
  List<_i9.RouteConfig> get routes => [
        _i9.RouteConfig(SignInRoute.name, path: '/'),
        _i9.RouteConfig(IndexRoute.name, path: '/index'),
        _i9.RouteConfig(VocabularyPracticeSentenceIndexRoute.name,
            path: '/voabulary_practice_sentence_index'),
        _i9.RouteConfig(VocabularyPracticeSentenceLearnAutoRoute.name,
            path: '/voabulary_practice_sentence_auto'),
        _i9.RouteConfig(VocabularyPracticeSentenceLearnManualRoute.name,
            path: '/voabulary_practice_sentence_manual'),
        _i9.RouteConfig(VocabularyPracticeWordIndexRoute.name,
            path: '/voabulary_practice_word_index'),
        _i9.RouteConfig(VocabularyPracticeWordLearnRoute.name,
            path: '/voabulary_practice_word_learn'),
        _i9.RouteConfig(CustomArticlePracticeSentenceIndexRoute.name,
            path: '/customArticle_practice_sentence_index')
      ];
}

/// generated route for
/// [_i1.SignInPage]
class SignInRoute extends _i9.PageRouteInfo<void> {
  const SignInRoute() : super(SignInRoute.name, path: '/');

  static const String name = 'SignInRoute';
}

/// generated route for
/// [_i2.IndexPage]
class IndexRoute extends _i9.PageRouteInfo<void> {
  const IndexRoute() : super(IndexRoute.name, path: '/index');

  static const String name = 'IndexRoute';
}

/// generated route for
/// [_i3.VocabularyPracticeSentenceIndexPage]
class VocabularyPracticeSentenceIndexRoute extends _i9.PageRouteInfo<void> {
  const VocabularyPracticeSentenceIndexRoute()
      : super(VocabularyPracticeSentenceIndexRoute.name,
            path: '/voabulary_practice_sentence_index');

  static const String name = 'VocabularyPracticeSentenceIndexRoute';
}

/// generated route for
/// [_i4.VocabularyPracticeSentenceLearnAutoPage]
class VocabularyPracticeSentenceLearnAutoRoute
    extends _i9.PageRouteInfo<VocabularyPracticeSentenceLearnAutoRouteArgs> {
  VocabularyPracticeSentenceLearnAutoRoute(
      {_i10.Key? key,
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

  final _i10.Key? key;

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
    extends _i9.PageRouteInfo<VocabularyPracticeSentenceLearnManualRouteArgs> {
  VocabularyPracticeSentenceLearnManualRoute(
      {_i10.Key? key, String topicClass = '', String topicName = ''})
      : super(VocabularyPracticeSentenceLearnManualRoute.name,
            path: '/voabulary_practice_sentence_manual',
            args: VocabularyPracticeSentenceLearnManualRouteArgs(
                key: key, topicClass: topicClass, topicName: topicName));

  static const String name = 'VocabularyPracticeSentenceLearnManualRoute';
}

class VocabularyPracticeSentenceLearnManualRouteArgs {
  const VocabularyPracticeSentenceLearnManualRouteArgs(
      {this.key, this.topicClass = '', this.topicName = ''});

  final _i10.Key? key;

  final String topicClass;

  final String topicName;

  @override
  String toString() {
    return 'VocabularyPracticeSentenceLearnManualRouteArgs{key: $key, topicClass: $topicClass, topicName: $topicName}';
  }
}

/// generated route for
/// [_i6.VocabularyPracticeWordIndexPage]
class VocabularyPracticeWordIndexRoute extends _i9.PageRouteInfo<void> {
  const VocabularyPracticeWordIndexRoute()
      : super(VocabularyPracticeWordIndexRoute.name,
            path: '/voabulary_practice_word_index');

  static const String name = 'VocabularyPracticeWordIndexRoute';
}

/// generated route for
/// [_i7.VocabularyPracticeWordLearnPage]
class VocabularyPracticeWordLearnRoute
    extends _i9.PageRouteInfo<VocabularyPracticeWordLearnRouteArgs> {
  VocabularyPracticeWordLearnRoute({_i10.Key? key, required String word})
      : super(VocabularyPracticeWordLearnRoute.name,
            path: '/voabulary_practice_word_learn',
            args: VocabularyPracticeWordLearnRouteArgs(key: key, word: word));

  static const String name = 'VocabularyPracticeWordLearnRoute';
}

class VocabularyPracticeWordLearnRouteArgs {
  const VocabularyPracticeWordLearnRouteArgs({this.key, required this.word});

  final _i10.Key? key;

  final String word;

  @override
  String toString() {
    return 'VocabularyPracticeWordLearnRouteArgs{key: $key, word: $word}';
  }
}

/// generated route for
/// [_i8.CustomArticlePracticeSentenceIndexPage]
class CustomArticlePracticeSentenceIndexRoute extends _i9.PageRouteInfo<void> {
  const CustomArticlePracticeSentenceIndexRoute()
      : super(CustomArticlePracticeSentenceIndexRoute.name,
            path: '/customArticle_practice_sentence_index');

  static const String name = 'CustomArticlePracticeSentenceIndexRoute';
}
