# Fingerprint reader support, Apple-style: the sensor only unlocks a session
# that is already logged in. PAM never offers fingerprints, so logging in,
# sudo, polkit prompts and password changes stay password-only.
#
# Why PAM-wide rather than per-service: pam_fprintd runs before pam_unix and
# takes exclusive control of the reader while it waits, so a typed password
# sits queued until the scan times out. It also makes a fingerprint a valid
# privilege escalation credential for sudo/su/polkit, which is weaker than a
# password and breaks non-interactive and remote flows.
#
# The lock screen is unaffected: Noctalia drives fprintd directly over D-Bus
# (org.freedesktop.DBus / net.reactivated.Fprint) rather than through PAM, so
# disabling fprintAuth only removes the password-path blocking, not the unlock.
#
# NixOS defaults every service's `fprintAuth` to `services.fprintd.enable`, so
# the daemon below must stay enabled for the lock screen while each PAM
# service opts out explicitly.
{ lib, ... }:
let
  # Services NixOS attaches pam_fprintd to. Extend this list if a system update
  # introduces another one; `mkDefault` leaves room for a host to opt back in.
  passwordOnlyPamServices = [
    "chfn"
    "chpasswd"
    "chsh"
    "cosmic-greeter"
    "cups"
    "groupadd"
    "groupdel"
    "groupmems"
    "groupmod"
    "login" # also the stack greetd substacks
    "passwd"
    "polkit-1"
    "runuser"
    "runuser-l"
    "sshd"
    "su"
    "sudo"
    "swaylock"
    "systemd-run0"
    "systemd-user"
    "useradd"
    "userdel"
    "usermod"
    "vlock"
  ];
in
{
  # Provides the daemon and pam_fprintd; the daemon is what the lock screen uses.
  services.fprintd.enable = true;

  security.pam.services = lib.genAttrs passwordOnlyPamServices (_: {
    fprintAuth = lib.mkDefault false;
  });
}
