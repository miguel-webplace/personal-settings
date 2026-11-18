# Auto script for package and desktop installation and configuration

# Usage
`./install.sh`

# Structure
Every package follows a specific structure. See an example:

```
configs/git
├── .gitconfig
└── git.sh
```

here, the git configuration has a git folder inside `configs`, which have a `git.sh` file and also a resource, in this case, gitconfig.

so every package must have a `configs/<package>/<package>.sh` structure and extra resources needed.

`<package>.sh` must be the only place to do everything envolving the package.

to know what to install, the script automatically reads every folder inside `configs` to `source` the scripts and run the functions. The packages are saved in [`packages.txt`](./packages.txt).

[`helpers`](./helpers.cfg)  serve to hanlde log styling functions and to read for packages.
