# Coding standards for all languages

Where not specified below, follow common conventions for the coding language in use...

- Use clear function and variable names
- Group code into directories and files logically by intent
- Use multi-line documentation comments for all classes, interfaces, enums, enum values, methods, functions, variables, consts, loops
- Exceptions: there's no need to comment very simple values or functions
- Comments should represent the intent of the thing, rather than precisely how it works (in this way it's easier to spot an issue because the implementation will not agree with the intent)

## Comment styles

- Use multi-line documentation comments in preference to multiple single-line comments
- When commenting a block of code (eg. a shell script or inside a function/method) if the comment fits on a single line, use a single-line comment, eg. `#` or `//`
- Where possible, link to types/classes/interfaces/parameters/variables referred to in comments, eg. `{@link TheType}` (ts/js) or `<see cref="MyClass.MyNewMethod"/>` (C#)
- Long break comments aren't preferred, eg.
  ```
  // ── Validate inputs ────────────────────────────────────────────────────────
  ```
  - If helpful for clarity, break up the file with single line comments, eg
    ```
    // Validate inputs
    ```
