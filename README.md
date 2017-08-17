# Haskell Cloud

Haskell Cloud is a [Source-to-Image](https://github.com/openshift/source-to-image) builder for building Haskell source into a runnable Docker image.
It can be used directly with `s2i`, or deployed on [OpenShift](https://www.openshift.com/).

Haskell Cloud includes:

- GHC
- cabal-install
- gold linker
- pre-built web frameworks

## Usage

Haskell Cloud is built in various flavours, with different pre-installed packages. See the [Haskell wiki](http://www.haskell.org/haskellwiki/Web/Cloud#OpenShift) for details.

These examples show how to use [ghc-network](https://hub.docker.com/r/accursoft/ghc-network/) builder with the [sample repository](https://github.com/accursoft/Haskell-Cloud-template).

### Source-to-Image

Download S2I from [GitHub](https://github.com/openshift/source-to-image/releases), and build an image with:

`s2i build --rm https://github.com/accursoft/Haskell-Cloud-template accursoft/ghc-network haskell-cloud`

The resulting image can be run with:

`docker run --name haskell-cloud -d -p 8080:8080 haskell-cloud`

See it in action:

`curl localhost:8080`

### OpenShift

Download the [CLI](https://docs.openshift.com/online/cli_reference/get_started_cli.html#installing-the-cli) from your OpenShift console, and follow the instructions for logging in.
Create a project (through the console or CLI) if you do not already have one, and select it with `oc project`.

To create the application:

`oc new-app accursoft/ghc-network~https://github.com/accursoft/haskell-cloud-template --name="haskell-cloud"`

To see it in action, create a route from the console, or `oc expose service haskell-cloud`.
Note that it can take a few minutes for OpenShift to begin routing traffic.

## Incremental Builds

Incremental builds re-use compiled dependencies and the hackage index from the previous build.

- **s2i**: Pass the `--incremental` flag to `s2i build`.
- **OpenShift**: `oc patch buildconfig haskell-cloud -p '{"spec":{"strategy":{"sourceStrategy":{"incremental":true}}}}'`

Old packages are never removed from incremental builds, so an occasional clean build may be required to avoid image bloat.

Apply the `cabal_update` marker (see below) to force `cabal update` before incremental builds.

## Haskell

The application's cabal file must define an executable called `server`, which listens on port 8080.
This is provided as the `PORT` environment variable and as a command line argument.

## Markers and Hooks

[Markers](https://bitbucket.org/accursoft/haskell-cloud-template/src/tip/.s2i/markers/README) and [hooks](https://bitbucket.org/accursoft/haskell-cloud-template/src/tip/.s2i/hooks/README) can be created in `.s2i/` to modify the build process.