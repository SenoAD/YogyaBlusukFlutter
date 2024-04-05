import 'package:yogya_blusuk/Domain/Entities/api_domain_entities.dart';

abstract class VacationPlanRepository {
  Future<List<VacationPlan>> GetVacationPlanByUserIdUC(int userId);
  Future InsertVacationPlanUC(CreateVacationPlan createVacationPlan);
  Future<VacationPlan> GetVacationPlanByPlanIdUC(int planId);
}
