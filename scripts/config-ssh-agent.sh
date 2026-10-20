#! /bin/bash
# Enable the per-user ssh-agent service and keep it alive across logouts,
# so that detached tmux/mosh sessions can keep using it.
systemctl --user daemon-reload
systemctl --user enable --now ssh-agent.service
loginctl enable-linger "$USER"
