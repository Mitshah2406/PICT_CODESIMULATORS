import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pict_frontend/models/BioWaste.dart';
import 'package:pict_frontend/services/biowaste_service.dart';

class BioWasteNotifier extends StateNotifier<List<BioWaste>> {
  BioWasteNotifier() : super(const []);

  Future<List<BioWaste>> getVideoResources() async {
    final response = await BioWasteService.getVideosResource();

    return response;
  }

  Future<List<BioWaste>> getBlogResources() async {
    final response = await BioWasteService.getBlogResources();

    return response;
  }
}

final bioWasteNotifier =
    StateNotifierProvider<BioWasteNotifier, List<BioWaste>>(
  (ref) => BioWasteNotifier(),
);
