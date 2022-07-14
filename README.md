# Argument parser for posix compaitable shells

- Add flags.sh to your project.

- Add the flags you want in flags.sh

- Source both `parser.sh` and `flags.sh`.

- Add below to your script:

```
# _parse_arguments is the function defined in parser.sh
# _parser_setup_flags is the function in flags.sh
_parse_arguments "_parser_setup_flags" "${@}" || return 1
```

To see it in action, see https://github.com/akianonymus/gdrive-downloader.

Use it as a reference if something isn't clear enough.
