import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:polynomial/model/question.dart';
import 'package:polynomial/model/user.dart';
import 'package:polynomial/utils/calc.dart';
import 'package:polynomial/utils/exeptions.dart';
import 'package:rxdart/rxdart.dart';

abstract class Repository {
  Future<Either<String, Unit>> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
  });

  Future<Either<String, Unit>> signUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<String, bool>> fetchAuthUser();
  Future<Either<String, String>> logout();

  Future<Either<String, num>> solve({
    required String question,
    required int value,
  });

  Future<Either<String, QuestionModel>> saveSolution(QuestionModel model);
  Stream<Either<String, List<QuestionModel>>> watchQuestions();
}

@LazySingleton(as: Repository)
class RepositoryImpl implements Repository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firebaseFirestore;

  RepositoryImpl(this._auth, this._firebaseFirestore);

  @override
  Future<Either<String, Unit>> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      UserModel _user = UserModel.empty;
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((credentials) async {
        if (credentials.user != null) {
          _user = UserModel(
            id: credentials.user!.uid,
            email: email,
            name: name,
          );

          await _firebaseFirestore
              .collection("users")
              .doc(credentials.user!.uid)
              .set(_user.toJson())
              .onError((error, stackTrace) => throw Exception());
        }
      });
      return right(unit);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return left(getAuthMessage(e));
    }
  }

  @override
  Future<Either<String, Unit>> signUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return right(unit);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return left(getAuthMessage(e));
    }
  }

  @override
  Future<Either<String, bool>> fetchAuthUser() async {
    try {
      final _user = _auth.currentUser;
      print("$_user");
      return right(_user != null);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return left(getAuthMessage(e));
    }
  }

  @override
  Future<Either<String, String>> logout() async {
    try {
      await _auth.signOut();
      return right("Logged out");
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return left(getAuthMessage(e));
    }
  }

  @override
  Future<Either<String, num>> solve(
      {required String question, required int value}) async {
    try {
      final _res = Calculate.derivativeVal(question, value);
      return right(_res);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, QuestionModel>> saveSolution(
      QuestionModel model) async {
    try {
      final _user = _auth.currentUser;
      if (_user == null) return left("Unauthenticated");
      await _firebaseFirestore
          .collection("question")
          .doc(_user.uid)
          .set(model.copyWith(userId: _user.uid).toJson())
          .onError((error, stackTrace) => throw Exception());
      return right(model);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return left(getAuthMessage(e));
    }
  }

  @override
  Stream<Either<String, List<QuestionModel>>> watchQuestions() async* {
    final _user = _auth.currentUser;
    if (_user == null) yield left("Unauthenticated");
    yield* _firebaseFirestore
        .collection("question")
        .snapshots()
        .map((snapshots) => right<String, List<QuestionModel>>(snapshots.docs
            .map((doc) => QuestionModel.fromFirestore(doc))
            .where((element) => element.userId == _user!.uid)
            .toList()))
        .onErrorReturnWith((e, s) {
      log(e.toString());
      log(s.toString());
      return left(e.toString());
    });
  }
}
