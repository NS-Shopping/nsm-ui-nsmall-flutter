import 'package:flutter_riverpod/flutter_riverpod.dart';

final appInitializedProvider = StateProvider<bool>((ref) => false);

final loadingProvider = StateProvider<bool>((ref) => false);

final errorProvider = StateProvider<String?>((ref) => null);