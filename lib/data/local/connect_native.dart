import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

QueryExecutor connectExecutor() => driftDatabase(name: 'brewcraft');
