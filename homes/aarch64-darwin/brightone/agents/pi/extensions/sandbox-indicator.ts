/**
 * Sandbox Indicator
 *
 * Shows a persistent footer status reflecting whether this pi session is
 * running inside an agent-sandbox.nix sandbox (sandbox-exec on macOS) or
 * with full host access.
 *
 * Detection: agent-sandbox.nix sets HOME to /private/tmp/sandbox-home.XXXXXX
 * for the duration of the session, so matching on that prefix is reliable.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const SANDBOXED = /\/tmp\/sandbox-home\./.test(process.env.HOME ?? "");

export default function (pi: ExtensionAPI) {
  pi.on("session_start", async (_event, ctx) => {
    const { theme } = ctx.ui;
    if (SANDBOXED) {
      ctx.ui.setStatus("sandbox-indicator", theme.fg("success", "⬡ sandboxed"));
    } else {
      ctx.ui.setStatus("sandbox-indicator", theme.fg("warning", "⬡ unboxed"));
    }
  });
}
