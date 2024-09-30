# Setting up a development environment for R for macOS

> [!Note]: This is my experience trying to set up a proper R development environment for STA2016 Spatial Data Analysis at UofT, which requires the use of certain packages.

If you can avoid using `R`, do so. Setup is such a drain, running virtual environments with `renv` are not ergonomic at all, certain packages such as `MASS` and `nlme` require building from source with `gfortran` and `gcc`, while macOS ships with `clang`.

The main culprits for a horrible DX are `MASS` and `nlme`, packages that require building from source. `geoR` also sucks since it requires legacy X11 tooling, which requires `XQuartz` on macOS.

## Requirements

```bash
# Casks
cask "r"
cask "rstudio"
cask "xquartz" # And this is why you try not to use the geoR package

# Formulae
brew "gcc"
brew "tcl-tk" # For some bs package
```

## Setup using `renv`

In your default `R` environment, you can setup `renv` by first installing it using:

```r
install.packages("renv")
```

Then initializing it in your target directory:

```r
renv::init()
```

If you have already initialized it but `renv` is not activated, you can activate with:

```r
renv::activate()

# To deactivate
renv::deactivate()
```

To install a package, you can use:

```r
# Ideally you should set your installation source before using
# Ref: https://github.com/rstudio/renv/issues/1832#issuecomment-2076049132
options(repos=c(CRAN="https://cran.rstudio.com/"))

# Install your package
renv::install("package_name")
```

You can create a lockfile with:

```r
renv::snapshot()
```

You can check your environment status with:

```r
renv::status()
```

You can clean your environment with:

```r
renv::clean()
```

And finally you can start a rebuild of your environment from scratch with:

```r
renv::rebuild()
```

which builds all your packages from the lockfile that you have saved in `renv.lock`.

## Troubleshooting

I experienced build errors first for `nlme`, then for `MASS`, then back to `nlme`. Why? `nlme` requires `gfortran` which is installed with `gcc` from `brew`. When you setup your `R` environment to use `gcc` instead of `clang`, guess what? `MASS` now has build errors.

There's also one package that requires `tcl-tk`, but then R can't find it. Add this to your PATH in `~/.bash_profile` cause you don't want to fuck with your `.zshrc` or `.bashrc`.

```bash
# Add tcl-tk to PATH
export PATH="${PATH}:/usr/local/opt/tcl-tk/bin/"
```

This is my `~/.R/Makevars` file. This should help things build correctly.

```bash
# This is the gcc version that I found after
# searching for it in /usr/local/opt/,
# where brew stores its binaries
VER=-14
CC=gcc$(VER)
CXX=g++$(VER)
CFLAGS=-mtune=native -g -O2 -Wall -pedantic -Wconversion
CXXFLAGS=-mtune=native -g -O2 -Wall -pedantic -Wconversion
FLIBS=-L/usr/local/opt/gcc/lib
FC=gfortran$(VER)
```

Create a `~/.R/Makevars` file, and hopefully this should fix your setup issues.
