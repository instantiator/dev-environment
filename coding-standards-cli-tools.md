# CLI tools

When creating CLI tools (applications or shell scripts):

- aim for small sets of simple, easily understood parameters, with sensible defaults (where possible)
- add self-documenting capabilities (ie. when required parameter values are missing, or parameters are incorrect, or when invoked with a `--help` parameter: print a short description of the tool, all parameter options, and usage information)

## Shell scripts

Where writing a supporting shell script for an application, if the application already does parameter validation and usage printing, then it's ok that the shell script does not.

- Break shell scripts into blocks that perform specific activities.
- Add comments to each block, indicating what the intention is.
- Add a comment near the top of each shell script indicating what it is for, and how it should be used.