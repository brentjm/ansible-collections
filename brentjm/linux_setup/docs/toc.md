# Ansible Playbooks for Linux Setup

## Table of Contents

- [About](#about)
- [workstation](#workstation)
- [server](#server)

## About

Playbooks to help set up workstations and servers. The workstation playbook is
focused on setting up a Linux workstation for development work. The server
playbook is focussed on setting up VMs and LXCs on a Linux server for home lab
(like a Proxmox server).

## Workstation

This playbook is intended to build a development station:

- Docker
- Neovim
  - Use the Neovim repo for setting up LSP, ...
- Nerdfonts
- Lazygit
- Languates
  - NodeJS
  - Python
    - Was using Anaconda, but may switch to Poetry
  - Golang
- Snaps
- LaTeX

## Server

This playbook is used to install all the services for the Home Lab.

- [Ubuntu](./ubuntu.md)
- [Home Assistant](./home_assistant.md)
