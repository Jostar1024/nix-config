{pkgs, ...}: {
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      # see example in: https://github.com/NixOS/nixpkgs/pull/224042
      (fcitx5-rime.override {
        rimeDataPkgs = with pkgs.nur.repos.linyinfeng.rimePackages; let
          rime-ice-modified = rime-ice.overrideAttrs (finalAttrs: previousAttrs: {
            installPhase = ''
              runHook preInstall

              mkdir -p "$out/share/rime-data"
              cp -r cn_dicts "$out/share/rime-data/cn_dicts"
              cp -r en_dicts "$out/share/rime-data/en_dicts"
              cp -r opencc   "$out/share/rime-data/opencc"
              cp -r lua      "$out/share/rime-data/lua"

              install -Dm644 *.{schema,dict}.yaml -t "$out/share/rime-data/"
              install -Dm644 *.lua                -t "$out/share/rime-data/"
              install -Dm644 custom_phrase.txt    -t "$out/share/rime-data/"
              install -Dm644 symbols_v.yaml       -t "$out/share/rime-data/"
              install -Dm644 symbols_caps_v.yaml  -t "$out/share/rime-data/"

              install -Dm644 default.yaml "$out/share/rime-data/default.yaml"

              install -Dm644 build/* -t "$out/share/rime-data/build"

              runHook postInstall
            '';
            passthru.rimeDependencies = [];
          });
        in [
          rime-essay
          rime-luna-pinyin
          rime-ice-modified
          # rime-prelude
        ];
      })
      fcitx5-rime
      fcitx5-configtool
      fcitx5-chinese-addons
    ];
  };
}
