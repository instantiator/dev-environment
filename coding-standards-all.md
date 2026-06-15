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
  - If helpful for clarity, break up the file with single line comments, eg.
    ```
    // Validate inputs
    ```

## Short testing loops

- Where possible, group changes by their purpose
- Favour short testing cycles - ie.
  1. make a small group of changes
  2. write tests and run them 
  3. fix anything that fails, or move on to the next change

## Dependencies (very important)

Ensure that when adding a new dependency, you use the latest version that dependency. Check what's available. GitHub Actions often fall foul of this: Your training data could be outdated.

Use the latest LTS version of Node, .NET, and any other frameworks that the project needs. Again, check what's available - your training data could be outdated.

After including a dependency, don't automatically update it unless there are vulnerability reports (eg. from Dependabot, or `npm audit`), or a user request to do so, or a specific feature that's required from a later version, or because another dependency must update (for those reasons) and relies on it.
