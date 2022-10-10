# A Simple Messenger for IEx

This project is meant to be a very simple and basic example of process
communication between nodes in a cluster using Elixir.

## Installing

You can install the required dependencies with `asdf` (you'll need the `elixir`
and `erlang` plugins).

```sh
$ asdf install
```

## Running

You'll need to connect your node to a cluster. To do that, start the IEx session
with the `--name` and `--cookie` options:

```sh
$ iex --name example@0.0.0.0 --cookie 123 -S mix
```

You can also use the included `start` script, that will execute the above
command for you:

```sh
$ ./script node0 # iex --name node0@0.0.0.0 --cookie 123456 -S mix
```

By naming your nodes as `nodeX`, the `.iex.exs` will automatically try to
connect with nodes `node0` all the way to `node9`.

## Using

The provided `.iex.exs` is already configured to import all functions from
`Messenger.IExClient`.

### Available commands

* `signin [user]`: sign-in in the cluster with the given user name
* `signout`: sign-out from the cluster
* `whoami`: returns the current user that's signed in
* `inbox`: prints the inbox
* `sent`: prints all sent messages
* `last_msg`: prints the last message
* `msg [recipient], [message]`: send the given `message` to the `recipient`


## License

`messenger` source code is released under Apache License 2.0.

Check [NOTICE](/NOTICE) and [LICENSE](/LICENSE) files for more information.
