# Linux setup Ansible collection

## Getting started

to run locally:
`ansible-playbook playbooks/workstation.yml`

to run as installed collection
`ansible-playbook playbooks/workstation_collection.yml`

## TODO

Automate gh cli installation
Install Copilot for gh cli

Project structure
    .
    ├── brentjm
    │   └── proxmox_setup
    │       ├── docs
    │       ├── galaxy.yml
    │       ├── meta
    │       │   └── runtime.yml
    │       ├── plugins
    │       │   └── README.md
    │       ├── README.md
    │       └── roles
    └── linux_setup
        ├── ansible.cfg
        ├── extensions
        │   └── molecule
        │       └── default
        │           ├── converge.yml
        │           ├── create.yml
        │           ├── destroy.yml
        │           └── molecule.yml
        ├── galaxy.yml
        ├── meta
        │   └── runtime.yml
        ├── node_modules
        ├── package.json
        ├── package-lock.json
        ├── playbooks
        │   ├── workstation_collection.yml
        │   └── workstation.yml
        ├── plugins
        │   └── README.md
        ├── README.md
        └── roles
            └── workstation
                ├── defaults
                │   └── main.yml
                ├── handlers
                │   └── main.yml
                ├── meta
                │   └── main.yml
                ├── README.md
                ├── tasks
                │   ├── anaconda.yml
                │   ├── bash.yml
                │   ├── csharp.yml
                │   ├── docker.yml
                │   ├── go.yml
                │   ├── latex.yml
                │   ├── lazygit.yml
                │   ├── main.yml
                │   ├── neovim.yml
                │   ├── nerdfonts.yml
                │   ├── nodejs.yml
                │   ├── snaps.yml
                │   ├── test.yml
                │   └── virtualbox.yml
                ├── tests
                │   ├── inventory
                │   └── test.yml
                └── vars
                    └── main.yml

    22 directories, 38 files
