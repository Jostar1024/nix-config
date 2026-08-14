import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { isToolCallEventType } from "@earendil-works/pi-coding-agent";
import { existsSync } from "node:fs";
import { dirname, join } from "node:path";

function findMixProject(filePath: string): string | null {
  let dir = dirname(filePath);
  while (dir !== "/") {
    if (existsSync(join(dir, "mix.exs"))) return dir;
    dir = dirname(dir);
  }
  return null;
}

export default function (pi: ExtensionAPI) {
  let elixirFilesTouched = new Set<string>();

  // Track writes/edits to .ex/.exs files during a prompt
  pi.on("tool_call", async (event, ctx) => {
    if (isToolCallEventType("write", event) || isToolCallEventType("edit", event)) {
      const path: string = event.input.path ?? "";
      console.log(`[elixir-verify] tool_call: ${event.toolName} path=${path}`);
      if (path.endsWith(".ex") || path.endsWith(".exs")) {
        elixirFilesTouched.add(path);
        ctx.ui.setStatus("elixir", `ex: ${elixirFilesTouched.size} file(s) tracked`);
        console.log(`[elixir-verify] tracked: ${path} (total: ${elixirFilesTouched.size})`);
      }
    }
  });

  // After agent finishes all tool calls, run mix format per project
  pi.on("agent_end", async (_event, ctx) => {
    if (elixirFilesTouched.size === 0) return;

    const files = [...elixirFilesTouched];
    elixirFilesTouched = new Set();

    // Group files by their mix project root
    const projectRoots = new Set<string>();
    for (const file of files) {
      const root = findMixProject(file);
      if (root) projectRoots.add(root);
    }

    if (projectRoots.size === 0) {
      console.log(`[elixir-verify] no mix.exs found for ${files.length} file(s), skipping`);
      ctx.ui.setStatus("elixir", undefined);
      return;
    }

    console.log(`[elixir-verify] agent_end: formatting ${projectRoots.size} project(s) for ${files.length} file(s)`);

    for (const root of projectRoots) {
      const depsResult = await pi.exec("mix", ["deps.get"], { cwd: root, timeout: 60000 });
      if (depsResult.code !== 0) {
        ctx.ui.notify(`mix deps.get failed in ${root}: ${depsResult.stderr}`, "warning");
        console.log(`[elixir-verify] mix deps.get failed in ${root}: code=${depsResult.code} stderr=${depsResult.stderr}`);
        continue;
      }
      console.log(`[elixir-verify] mix deps.get succeeded in ${root}`);

      const result = await pi.exec("mix", ["format"], { cwd: root, timeout: 15000 });
      if (result.code === 0) {
        console.log(`[elixir-verify] mix format succeeded in ${root}`);
      } else {
        ctx.ui.notify(`mix format failed in ${root}: ${result.stderr}`, "warning");
        console.log(`[elixir-verify] mix format failed in ${root}: code=${result.code} stderr=${result.stderr}`);
      }
    }

    ctx.ui.notify(`mix format: ${projectRoots.size} project(s)`, "info");
    ctx.ui.setStatus("elixir", undefined);
  });
}
