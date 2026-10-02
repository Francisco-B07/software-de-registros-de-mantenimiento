import type { LaterUserVerificationCodeDelivery } from "../../application/later-user-enrollment";

export function createUnavailableLaterUserVerificationDelivery(): LaterUserVerificationCodeDelivery {
  return Object.freeze({
    async deliver() {
      throw new Error("No production later-user delivery provider is configured.");
    },
  });
}
