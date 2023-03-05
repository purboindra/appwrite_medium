import 'package:appwrite/appwrite.dart';
import 'package:appwrite_medium/constants/appwrite_constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appwriteClientProvider = Provider((ref) {
  Client client = Client();
  return client
      .setEndpoint(AppwriteConstant.endPoint)
      .setProject(AppwriteConstant.projectID)
      .setSelfSigned();
});

final appwriteAccountProvider = Provider((ref) {
  return Account(ref.watch(appwriteClientProvider));
});
