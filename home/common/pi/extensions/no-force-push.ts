/**
 * No Force Push Extension
 *
 * Blocks git force push commands before they execute.
 * Catches: git push --force, git push -f, git push --force-with-lease
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  const forcePushPattern = /\bgit\s+push\b.*(\s--force\b|\s-f\b|\s--force-with-lease\b)/;

  pi.on("tool_call", async (event, _ctx) => {
    if (event.toolName !== "bash") return undefined;

    const command = event.input.command as string;

    if (forcePushPattern.test(command)) {
      return { block: true, reason: "Git force push is not allowed" };
    }

    return undefined;
  });
}
