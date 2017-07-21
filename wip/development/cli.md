+++
title = "Installing the CLI"
weight = 1
+++

The `cx` Command Line Interface (CLI) is a tool to manage apps on your computer and in the cloud.

## Install the CLI

{{% tabs %}}
1. MacOS
2. Linux
3. Windows
{{% /tabs %}}

{{% tab-contents %}}
1. MacOS

    ```bash
    $ curl https://s3.amazonaws.com/praxis-releases/cli/darwin/cx -o /usr/local/bin/cx
    $ chmod +x /usr/local/bin/cx
    ```

2. Linux

    ```
    $ curl https://s3.amazonaws.com/praxis-releases/cli/linux/cx -o /usr/local/bin/cx
    $ chmod +x /usr/local/bin/cx
    ```

3. Windows

    Not yet supported. Contact support@convox.com to discuss.
{{% /tab-contents %}}

## Update the CLI

Confirm that cx is correctly installed and up to date:

```bash
$ cx update
updating cli to 20170628170448: OK
```

## Usage

You can see how to use the CLI with the `cx help` or `--help` flag:

```bash
$ cx help
cx: convox management tool

Usage:
cx <command> [args...]

Subcommands: (cx help <subcommand>)
apps        list applications
builds      list builds
deploy      build and promote an application
env         display current env
logs        show app logs
ps          list processes
releases    list releases
resources   list resources
run         run a new process
services    list services
start       start the app in development mode
test        run tests

Options:
--app value   app name
--rack value  rack name
--version     print the version
```


## Further reading:

* [CLI Reference](/cli/)
