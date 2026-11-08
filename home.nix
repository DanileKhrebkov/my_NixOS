{ config, pkgs, lib, ... }:

{
  home.username = "hogintosh";
  home.homeDirectory = "/home/hogintosh";
  home.stateVersion = "26.05";

  # --- Базовые пакеты ---
  home.packages = with pkgs; [
    # Терминал / launcher / bar
    kitty
    wofi
    waybar

    # Скриншоты
    grim
    slurp
    wl-clipboard

    # Управление
    brightnessctl
    swaylock
    swayidle
    wl-clipboard
    libnotify
    mako                  # уведомления (лёгкие)

    # Сеть
    networkmanagerapplet  # nm-applet (можно не использовать, но пусть будет)

    # Темы / иконки / шрифты
    papirus-icon-theme
    adwaita-icon-theme
    adwaita-icon-theme

    # Шрифты
    jetbrains-mono
    inter
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    font-awesome

    # Разработка
    rustup
    gcc
    gnumake
    pkg-config
    openssl

    # Редактор / браузер
    vscode
    firefox

    # Утилиты
    htop
    btop
    ripgrep
    fd
    jq
    unzip
    file
    which
  ];

  # --- Шрифты ---
  fonts.fontconfig.enable = true;

  # --- Kitty ---
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrains Mono";
      font_size = "12.0";
      background = "#1a1b26";
      foreground = "#c0caf5";
      cursor = "#2dd4bf";          # бирюзовый
      selection_background = "#334155";
      url_color = "#2dd4bf";
      active_border_color = "#2dd4bf";
      inactive_border_color = "#475569";
    };
  };

  # --- Git (базовый) ---
  programs.git = {
    enable = true;
    settings = {
	user = {
	name = "hogintosh";
	email = "artsavyt@gmail.com";
};
};
  };

  # --- Bash (автозапуск Sway) ---
  programs.bash = {
    enable = true;
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
        exec sway
      fi
    '';
  };

  # --- GTK тема (тёмная) ---
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "Inter";
      size = 11;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # --- Qt ---
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };

  # --- Sway ---
  wayland.windowManager.sway = {
    enable = true;
	checkConfig = false;
    package = pkgs.swayfx;        # можно заменить на pkgs.sway, если хочешь совсем ванильный
    wrapperFeatures.gtk = true;

    config = {
      modifier = "Mod4";          # Super
      terminal = "kitty";
      menu = "wofi --show drun";

      # Вывод (подставь свои, если нужно)
      output = {
        "*" = {
          bg = "#0f172a solid_color";   # тёмно-серый/синий фон
        };
      };

      gaps = {
        inner = 6;
        outer = 4;
      };

      window = {
        border = 2;
        titlebar = false;
      };

      colors = {
        focused = {
          border = "#2dd4bf";
          background = "#1e293b";
          text = "#f1f5f9";
          indicator = "#2dd4bf";
          childBorder = "#2dd4bf";
        };
        focusedInactive = {
          border = "#475569";
          background = "#1e293b";
          text = "#94a3b8";
          indicator = "#475569";
          childBorder = "#475569";
        };
        unfocused = {
          border = "#334155";
          background = "#0f172a";
          text = "#64748b";
          indicator = "#334155";
          childBorder = "#334155";
        };
      };

      keybindings = let
        mod = "Mod4";
      in {
        # Основные
        "${mod}+Return" = "exec kitty";
        "${mod}+b" = "exec firefox";
        "${mod}+d" = "exec wofi --show drun";
        "${mod}+Shift+q" = "kill";
        "${mod}+l" = "exec swaylock -f -c 0f172a";

        # Фокус
        "${mod}+Left"  = "focus left";
        "${mod}+Down"  = "focus down";
        "${mod}+Up"    = "focus up";
        "${mod}+Right" = "focus right";

        # Перемещение окон
        "${mod}+Shift+Left"  = "move left";
        "${mod}+Shift+Down"  = "move down";
        "${mod}+Shift+Up"    = "move up";
        "${mod}+Shift+Right" = "move right";

        # Воркспейсы
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";
        "${mod}+0" = "workspace number 10";

        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        "${mod}+Shift+0" = "move container to workspace number 10";

        # Скриншоты
        "${mod}+Shift+s" = "exec grim -g \"$(slurp)\" - | wl-copy";
        "Print" = "exec grim - | wl-copy";

        # Яркость
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
        "XF86MonBrightnessUp"   = "exec brightnessctl set 5%+";

        # Звук
        "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute"        = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

        # Перезагрузка конфига
        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+e" = "exec swaynag -t warning -m 'Exit sway?' -b 'Yes' 'swaymsg exit'";
      };

      input = {
        "*" = {
          xkb_layout = "us,ru";
          xkb_options = "grp:alt_shift_toggle";
        };
	"type:touchpad" = {tap = "enabled"; natural_scroll = "enabled"; dwt = "enabled";
	};
      };

      bars = [{ command = "waybar"; }];

      startup = [
        { command = "mako"; }
        { command = "swayidle -w timeout 300 'swaylock -f -c 0f172a' timeout 600 'swaymsg \"output * power off\"' resume 'swaymsg \"output * power on\"'"; }
      ];
    };
  };

  # --- Waybar (минимальный каркас) ---
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 4;

        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "clock" ];
        modules-right = [ "cpu" "memory" "battery" "network" "pulseaudio" "tray" ];

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };

        clock = {
          format = "{:%H:%M  %d.%m}";
          tooltip-format = "{:%A, %d %B %Y}";
        };

        cpu = {
          format = "cpu {usage}%";
          interval = 2;
        };

        memory = {
          format = "mem {percentage}%";
          interval = 2;
        };

        battery = {
          format = "{capacity}% {icon}";
          format-icons = [ "" "" "" "" "" ];
          states = {
            warning = 30;
            critical = 15;
          };
        };

        network = {
          format-wifi = "{essid} ({signalStrength}%)";
          format-ethernet = "eth";
          format-disconnected = "no network";
          on-click = "nm-connection-editor";
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-muted = "muted";
          format-icons = {
            default = [ "" "" "" ];
          };
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: JetBrains Mono, Inter, monospace;
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: #0f172a;
        color: #e2e8f0;
      }

      #workspaces button {
        padding: 0 8px;
        background: transparent;
        color: #94a3b8;
      }

      #workspaces button.focused {
        background: #1e293b;
        color: #2dd4bf;
        border-bottom: 2px solid #2dd4bf;
      }

      #clock, #cpu, #memory, #battery, #network, #pulseaudio, #tray {
        padding: 0 10px;
        margin: 0 2px;
      }

      #battery.warning { color: #fbbf24; }
      #battery.critical { color: #f87171; }
    '';
  };

  # Уведомления
  services.mako = {
    enable = true;
    settings = {
      background-color = "#1e293b";
      text-color = "#e2e8f0";
      border-color = "#2dd4bf";
      border-size = 2;
      border-radius = 6;
      default-timeout = 5000;
    };
  };

  # XDG
  xdg.enable = true;
  xdg.userDirs.enable = true;
  xdg.userDirs.createDirectories = true;

  # Сессионные переменные
  home.sessionVariables = {
    EDITOR = "code";
    BROWSER = "firefox";
    TERMINAL = "kitty";
    NIXOS_OZONE_WL = "1";          # VS Code / Electron на Wayland
  };
}
