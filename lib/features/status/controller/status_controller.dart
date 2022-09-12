import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/status/repository/status_repository.dart';

final statusControllerProvider = Provider((ref){
  final statusRepository = ref.read(statusRepositoryProvider);
  return StatusController(ref: ref, statusRepository: statusRepository);
});

class StatusController{
  StatusController({required this.ref, required this.statusRepository});

  final ProviderRef ref;
  final StatusRepository statusRepository;

  void addTextStatus(String text){
    statusRepository.addTextStatus(text);
  }
}