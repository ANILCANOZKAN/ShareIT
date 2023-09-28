import 'package:algolia/algolia.dart';

class AlgoliaInit {
  AlgoliaInstance() {
    final applicationId = "XCHYJS2FPH";
    final apiKey = "71f4164e057b64ec04a23afd9932e984";
  }

  final algolia = Algolia.init(
      applicationId: "XCHYJS2FPH", apiKey: "71f4164e057b64ec04a23afd9932e984");
}
