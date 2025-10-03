# Install Python tool with uv with a single shell script

Install any Python package as a tool with a single shell script.

## Usage

Copy/paste the following command, and replace the `<package-name>` with your package name.

```shell
curl -LsSf https://uhd-urz.github.io/py/install.sh | sh -s -- <package-name>
```

Optional dependencies can also be passed. E.g.,

```shell
curl -LsSf https://uhd-urz.github.io/py/install.sh | sh -s -- <package-name>["optional-dep"]
```

# What does this script do?

This script mainly just installs `uv` if it doesn't already exist in the system, and then installs the provided
Python package. See: https://github.com/astral-sh/uv/issues/6533.
