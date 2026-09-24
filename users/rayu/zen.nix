{ lib, inputs, osConfig, ... }:

# Declarative Zen Browser setup (privacy-first).
# ⚠ Close Zen before `nixos-rebuild switch` / `home-manager switch`:
#   spaces and pins are written into zen-sessions.jsonlz4 during activation.

let
  # Install an add-on from addons.mozilla.org, keyed by its extension ID.
  extension = slug: extra: {
    install_url = "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
    installation_mode = "force_installed";
    private_browsing = true;
  } // extra;

  # Space IDs (changing an ID re-creates the space and loses its tabs)
  personalSpace = "d7e69647-9aae-4e3e-9dc8-b8537ae9568f";
  universitySpace = "2096a813-b21a-4cd0-8a73-8eb083736403";
in

{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  programs.zen-browser = lib.mkIf osConfig.sys.apps.enable {
    enable = true;
    # Default-browser MIME associations are handled in mime.nix

    # ── Policies (policies.json) ────────────────────────────────────────────
    # Reference: https://mozilla.github.io/policy-templates/
    policies = {
      DisableAppUpdate = true;
      DisableTelemetry = true;
      DisablePocket = true;
      DisableFirefoxStudies = true;
      DisableFeedbackCommands = true;
      DisableSetDesktopBackground = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;

      # Passwords/autofill are handled by Bitwarden
      PasswordManagerEnabled = false;
      OfferToSaveLogins = false;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableFormHistory = true;

      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
      };
      Cookies = {
        Behavior = "reject-tracker-and-partition-foreign";
        BehaviorPrivateBrowsing = "reject-tracker-and-partition-foreign";
      };
      HttpsOnlyMode = "enabled";
      PostQuantumKeyAgreementEnabled = true;

      SearchSuggestEnabled = false;
      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
        Locked = true;
      };
      FirefoxHome = {
        Search = true;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
        Locked = true;
      };
      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = true;
        MoreFromMozilla = false;
        FirefoxLabs = false;
        Locked = true;
      };
      GenerativeAI = {
        Enabled = false;
        Locked = true;
      };

      # ── Extensions ────────────────────────────────────────────────────────
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = extension "ublock-origin" { default_area = "navbar"; };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = extension "bitwarden-password-manager" { default_area = "navbar"; };
        "addon@darkreader.org" = extension "darkreader" { };
        "{34daeb50-c2d2-4f14-886a-7160b24d66a4}" = extension "youtube-shorts-block" { };
        "{88ebde3a-4581-4c6b-8019-2a05a9e3e938}" = extension "hide-youtube-shorts" { };
      };

      # uBlock Origin: default lists + extra privacy lists (re-applied every start)
      "3rdparty".Extensions."uBlock0@raymondhill.net".toOverwrite.filterLists = [
        "user-filters"
        "ublock-filters"
        "ublock-badware"
        "ublock-privacy"
        "ublock-quick-fixes"
        "ublock-unbreak"
        "easylist"
        "easyprivacy"
        "urlhaus-1"
        "plowe-0"
        "adguard-spyware-url"
      ];
    };

    profiles.default = {
      # Betterfox (BetterZen) privacy/telemetry/performance prefs;
      # anything in `settings` below overrides it.
      presets.betterfox.enable = true;

      settings = {
        "privacy.globalprivacycontrol.enabled" = true;
        "privacy.donottrackheader.enabled" = true;
        "browser.contentblocking.category" = "strict";
        "network.prefetch-next" = false;
        "network.dns.disablePrefetch" = true;
        "network.predictor.enabled" = false;
        "browser.urlbar.speculativeConnect.enabled" = false;
        "browser.places.speculativeConnect.enabled" = false;
        "media.peerconnection.ice.default_address_only" = true; # WebRTC IP leak
        "geo.enabled" = false;
        "dom.security.https_only_mode_send_http_background_request" = false;

        # Needed for essentials to show up across windows
        "zen.window-sync.enabled" = true;
        "zen.workspaces.continue-where-left-off" = true;
      };

      search = {
        force = true;
        default = "ddg";
        privateDefault = "ddg";
        engines = {
          google.metaData.hidden = true;
          bing.metaData.hidden = true;
        };
      };

      # ── Essentials (global, shown in every space) ─────────────────────────
      pinsForce = true;
      pins = {
        "WhatsApp" = {
          id = "7b94c2ba-71b0-4458-b5ab-e69c8d1e9a7c";
          url = "https://web.whatsapp.com";
          isEssential = true;
          position = 101;
        };
        "GitHub" = {
          id = "4533f482-33bb-49e7-ba84-39b9666669d6";
          url = "https://github.com";
          isEssential = true;
          position = 102;
        };
        "VTechno Git" = {
          id = "abb36f64-492c-48c0-a575-00ee71f04d30";
          url = "https://git.vtechno.ca";
          isEssential = true;
          position = 103;
        };
        "VTechno Cloud" = {
          id = "03b7541d-c819-412e-a01e-e38253970fdb";
          url = "https://cloud.vtechno.ca";
          isEssential = true;
          position = 104;
        };
      };

      # ── Spaces ────────────────────────────────────────────────────────────
      spacesForce = true;
      spaces = {
        "Personal" = {
          id = personalSpace;
          position = 1000;
          icon = "🏠";
          pins."Proton Mail" = {
            id = "f5b0489a-d495-4179-8afe-1be4ca9a532d";
            url = "https://mail.protonmail.com";
            position = 201;
          };
        };
        "University" = {
          id = universitySpace;
          position = 2000;
          icon = "🎓";
          pins."Canvas" = {
            id = "a754e236-ed2c-4f2e-ae1b-738981ea6c3c";
            url = "https://canvas.ualberta.ca";
            position = 301;
          };
          pins."Bear Tracks" = {
            id = "2b46c918-cfe0-48ed-b512-a054afabd69b";
            url = "https://uab.ca/beartracks";
            position = 302;
          };
        };
      };
    };
  };
}
