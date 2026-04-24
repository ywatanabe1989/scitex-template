## Singularity Template
```bash
git clone git@github.com:ywatanabe1989/singularity_template.git .singularity
```

## Enables shell aliases

``` bash
source ./singularity-aliases.sh
```

## Building sandbox container
``` bash
sbuild-sand-latest-again
```









## Singularity as a tool box
The following commands are introduced by sourcing [`./singularity-aliases.sh`](./singularity-aliases.sh).
``` bash
htop, autossh, black, ffmpeg, flake8, git-crypt, htop, pigz, rg, sshpass, tree
```

## Tree

```
# tree . -L 2

.
├── definitions_files
│   ├── tools-2024-0615.def
│   └── tools-2024-0616.def
├── modules
│   ├── dnf
│   ├── pip
│   ├── python
│   ├── system
│   └── test
├── sandbox -> tools-2024-0615/tools-2024-0615-sandbox
├── tools-2024-0615
│   ├── tools-2024-0615.def
│   ├── tools-2024-0615-sandbox
│   └── tools-2024-0615-sandbox.log
├── tools-2024-0616
│   ├── tools-2024-0616.def
│   └── tools-2024-0616-sandbox
├── tools-2024-0616-sandbox.log
└── tools-sandbox -> tools-2024-0616/tools-2024-0616-sandbox
```

## Contact
ywatanabe@alumni.u-tokyo.ac.jp



# From: nvidia/cuda:11.8.0-devel-rockylinux8

# From: nvidia/cuda:12.1.0-devel-rockylinux8

# From: nvidia/cuda:12.5.0-devel-rockylinux9
# From: rockylinux/rockylinux:latest

# From: rockylinux/rockylinux:8.5
# 8.5 accepts writing startup scripts under /.singularity.d/env/
