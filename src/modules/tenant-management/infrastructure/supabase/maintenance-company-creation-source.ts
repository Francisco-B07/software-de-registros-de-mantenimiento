import { createSupabaseServerClient } from "@infrastructure/supabase/server";

import type {
  CreationOperationId,
  MaintenanceCompanyCreationSource,
} from "../../application/create-maintenance-company";

export async function createSupabaseMaintenanceCompanyCreationSource(): Promise<MaintenanceCompanyCreationSource> {
  const supabase = await createSupabaseServerClient();

  return Object.freeze({
    async create(creationOperationId: CreationOperationId) {
      const response = await supabase.rpc("create_maintenance_company", {
        p_creation_operation_id: creationOperationId,
      });

      if (response.error !== null) {
        throw new Error("Maintenance company creation RPC failed.");
      }

      return response.data;
    },
  });
}
