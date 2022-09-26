import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/enums/status_enum.dart';
import 'package:whatsapp_clone/features/status/repository/status_repository.dart';

final statusControllerProvider = Provider((ref){
  final statusRepository = ref.read(statusRepositoryProvider);
  return StatusController(ref: ref, statusRepository: statusRepository);
});

class StatusController{
  StatusController({required this.ref, required this.statusRepository});

  final ProviderRef ref;
  final StatusRepository statusRepository;

  void addTextStatus(String text, String backgroundColor){
    statusRepository.addTextStatus(text, backgroundColor);
  }

  Future addFileStatus(File file, String caption, StatusEnum statusType)async{
    statusRepository.addFileStatus(file, statusType, ref, caption);
  }
}
