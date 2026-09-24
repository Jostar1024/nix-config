{...}: {
  home.file = {
    ".pi/agent/extensions/elixir-verify.ts".source = ./extensions/elixir-verify.ts;
    ".pi/agent/extensions/no-force-push.ts".source = ./extensions/no-force-push.ts;

    ".pi-personal/extensions/elixir-verify.ts".source = ./extensions/elixir-verify.ts;
    ".pi-personal/extensions/no-force-push.ts".source = ./extensions/no-force-push.ts;
  };
}
