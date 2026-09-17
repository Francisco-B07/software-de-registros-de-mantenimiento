import {
  createMaintenanceCompanyWithSource,
  type CreateMaintenanceCompanyInput,
} from "./application/create-maintenance-company";
import { createSupabaseMaintenanceCompanyCreationSource } from "./infrastructure/supabase/maintenance-company-creation-source";

export type {
  CreationOperationId,
  CreateMaintenanceCompanyInput,
  CreateMaintenanceCompanyResult,
} from "./application/create-maintenance-company";

export function createMaintenanceCompany(input: CreateMaintenanceCompanyInput) {
  return createMaintenanceCompanyWithSource(
    input,
    createSupabaseMaintenanceCompanyCreationSource,
  );
}
