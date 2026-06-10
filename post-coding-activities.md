# Post-coding steps

Follow these steps after each coding activity.

### 0. Formatting

- Use the most appropriate formatter available across the files that have been edited

### 1. Reflection

- Simplfy and make the code more understandable
- Look for opportunities to divide the code into logical groupings
- Look for remaining TODOs in the code and, for each, ask: should it be dealt with immediately / ask again later / stop asking

### 2. Compilation

- Compile the project and review linting information
- Make fixes to reduce any errors and warnings from compiler and linter to 0
- If there's a case where this would be unnecessarily complicated or undersirable, ask the user how to proceed

### 3. Testing

- Run the tests to see if the current set of tests still pass
- Consider the intent behind the code that changed, and any new code
- Write or update tests for the new code, and for code that has been modified
- Remove tests for code that no longer exists
- Test the intent of the code, to ensure that when the tests pass, the code behaves as expected

### 4. Documentation

- Review and update the documentation in the project that relates to the new or changed code
- Remove any documentation referring to code that has been removed
