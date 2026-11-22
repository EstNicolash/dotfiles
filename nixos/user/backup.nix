# ==============================================================================
# Automated Encrypted Cloud Backups (nixos/user/backup.nix)
#
# Configures systemd user services and timers for compressed (zstd) and
# encrypted backups of Obsidian notes, Calibre library, and Zotero database
# to Google Drive via `rclone`, with automatic retention cleanup and desktop
# notifications on failure.
# ==============================================================================
{ pkgs, ... }:

let
  mkBackupScript = { name, sources, archivePrefix, retentionDays ? "60d" }:
    pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = with pkgs; [
        coreutils
        gnutar
        zstd
        gnupg
        rclone
        libnotify
      ];

      text = ''
        PASSWORD_FILE="$HOME/.backup-password"
        RCLONE_REMOTE="Google Drive"
        REMOTE_DIR="backup"
        TIMESTAMP="$(date +%Y-%m-%d_%H-%M)"
        TMP_DIR="$(mktemp -d)"

        cleanup() {
          rm -rf "$TMP_DIR"
        }
        on_error() {
          notify-send -u critical "Backup Falhou: ${archivePrefix}" "Verifique os logs do systemd (${name})." || true
        }
        trap cleanup EXIT
        trap on_error ERR

        if [[ ! -f "$PASSWORD_FILE" ]]; then
          echo "Error: Password file not found at $PASSWORD_FILE" >&2
          exit 1
        fi

        ARCHIVE_PATH="$TMP_DIR/${archivePrefix}-$TIMESTAMP.tar.zst"
        ENCRYPTED_PATH="$ARCHIVE_PATH.gpg"

        echo "Compressing sources for ${archivePrefix}..."
        tar --zstd -cf "$ARCHIVE_PATH" ${sources}

        echo "Encrypting archive..."
        gpg --symmetric --cipher-algo AES256 --batch --yes \
          --passphrase-file "$PASSWORD_FILE" \
          -o "$ENCRYPTED_PATH" "$ARCHIVE_PATH"

        echo "Uploading to $RCLONE_REMOTE:$REMOTE_DIR..."
        rclone copy "$ENCRYPTED_PATH" "$RCLONE_REMOTE:$REMOTE_DIR"

        echo "Pruning remote backups older than ${retentionDays}..."
        rclone delete "$RCLONE_REMOTE:$REMOTE_DIR" \
          --include "${archivePrefix}-*.tar.zst.gpg" \
          --min-age "${retentionDays}"

        echo "Backup ${archivePrefix} completed successfully!"
      '';
    };

  libraryBackupScript = mkBackupScript {
    name = "backup-library-to-cloud";
    archivePrefix = "backup-library";
    sources = ''-C "$HOME" "Calibre Library" "Zotero"'';
    retentionDays = "90d";
  };

  notesBackupScript = mkBackupScript {
    name = "backup-notes-to-cloud";
    archivePrefix = "backup-notes";
    sources = ''-C "$HOME/Dropbox" "Vault"'';
    retentionDays = "60d";
  };
in
{
  # ----------------------------------------------------------------------------
  # Weekly Academic Library Backup (Calibre + Zotero)
  # ----------------------------------------------------------------------------
  systemd.user.services.library-backup = {
    Unit.Description = "Weekly encrypted backup for Calibre and Zotero libraries";
    Service = {
      Type = "oneshot";
      ExecStart = "${libraryBackupScript}/bin/backup-library-to-cloud";
      CPUQuota = "200%";
      Nice = 19;
      IOWeight = 100;
    };
  };

  systemd.user.timers.library-backup = {
    Unit.Description = "Weekly timer for Calibre and Zotero backup";
    Timer = {
      OnCalendar = "Sat 18:00:00";
      RandomizedDelaySec = "2min";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };

  # ----------------------------------------------------------------------------
  # Obsidian Vault Backup (On Boot)
  # ----------------------------------------------------------------------------
  systemd.user.services.notes-backup = {
    Unit.Description = "Encrypted backup for Obsidian Vault on boot";
    Service = {
      Type = "oneshot";
      ExecStart = "${notesBackupScript}/bin/backup-notes-to-cloud";
      CPUQuota = "100%";
      Nice = 19;
      IOWeight = 100;
    };
  };

  systemd.user.timers.notes-backup = {
    Unit.Description = "Boot timer for Obsidian Vault backup";
    Timer = {
      OnStartupSec = "2min";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
