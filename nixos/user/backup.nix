{ pkgs, lib, ... }:

let
  calibreBackupScript = pkgs.writeShellScriptBin "backup-calibre-to-cloud" ''
    #!/usr/bin/env bash
    set -eu

    SOURCE_FOLDER="$HOME/Calibre Library"
    PASSWORD_FILE="$HOME/.backup-password"
    RCLONE_REMOTE="Google Drive"
    REMOTE_BACKUP_DIR="backup"

    echo "Starting Calibre backup process..."

    ARCHIVE_NAME="backup-calibre.tar.zst"
    ENCRYPTED_NAME="$ARCHIVE_NAME.gpg"

    echo "Compressing folders..."
    tar --zstd -cvf "$ARCHIVE_NAME" "$SOURCE_FOLDER"

    echo "Encrypting the archive..."
    gpg --symmetric --cipher-algo AES256 --batch --yes --passphrase-file "$PASSWORD_FILE" -o "$ENCRYPTED_NAME" "$ARCHIVE_NAME"

    rm -fr "$ARCHIVE_NAME"

    echo "Uploading to Rclone remote..."
    rclone copy "$ENCRYPTED_NAME" "$RCLONE_REMOTE:$REMOTE_BACKUP_DIR" --log-file=/tmp/rclone-backup.log

    rm -fr "$ENCRYPTED_NAME"
    echo "Backup process completed successfully!"
    exit 0
  '';

  notesBackupScript = pkgs.writeShellScriptBin "backup-notes-to-cloud" ''
    #!/usr/bin/env bash
    set -eu

    SOURCE_FOLDER="$HOME/Dropbox/Vault"
    PASSWORD_FILE="$HOME/.backup-password"
    RCLONE_REMOTE="Google Drive"
    REMOTE_BACKUP_DIR="backup"

    echo "Starting Notes backup process..."

    ARCHIVE_NAME="backup-notes.tar.xz"
    ENCRYPTED_NAME="$ARCHIVE_NAME.gpg"

    echo "Compressing folders..."
    tar cJvf "$ARCHIVE_NAME" "$SOURCE_FOLDER"

    echo "Encrypting the archive..."
    gpg --symmetric --cipher-algo AES256 --batch --yes --passphrase-file "$PASSWORD_FILE" -o "$ENCRYPTED_NAME" "$ARCHIVE_NAME"

    rm -fr "$ARCHIVE_NAME"

    echo "Uploading to Rclone remote..."
    rclone copy "$ENCRYPTED_NAME" "$RCLONE_REMOTE:$REMOTE_BACKUP_DIR" --log-file=/tmp/rclone-notes-backup.log

    rm -fr "$ENCRYPTED_NAME"
    echo "Backup process completed successfully!"
    exit 0
  '';
in
{
  systemd.user.services.calibre-backup = {
    Unit.Description = "Weekly backup for Calibre library";
    Service = {
      Type = "oneshot";
      ExecStart = "${calibreBackupScript}/bin/backup-calibre-to-cloud";
      CPUQuota = "200%";
      Nice = 19;
      IOWeight = 100;
    };
  };

  systemd.user.timers.calibre-backup = {
    Unit.Description = "Timer for weekly Calibre backup";
    Timer = {
      OnCalendar = "Sat 18:00:00";
      RandomizedDelaySec = "2min";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };

  systemd.user.services.notes-backup = {
    Unit.Description = "Backup for notes on boot";
    Service = {
      Type = "oneshot";
      ExecStart = "${notesBackupScript}/bin/backup-notes-to-cloud";
      CPUQuota = "100%";
      Nice = 19;
      IOWeight = 100;
    };
  };

  systemd.user.timers.notes-backup = {
    Unit.Description = "Timer for notes backup on boot";
    Timer = {
      OnStartupSec = "2min";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
