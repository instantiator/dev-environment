# Post-coding steps

Follow these steps after each coding activity.

### 0. Formatting

- Use the most appropriate formatter available across the files that have been edited

### 1. Quality and reflection

- Always run `npx aislop scan` for the following languages/environments: TypeScript, JavaScript, Expo / React Native, Python, Go, Rust, Ruby, PHP
  - NB. the results from this are opnionated, and may (for instance) disagree with our specific requirements around code commenting
  - Where there's a conflict, continue to follow our documented coding standards in this suite of documents
  - Where there's an opportunity to clean up, make those changes
- Review the tests created, and ensure that they are thorough
  - Add additional tests for any missed cases or edge cases
  - If a new testing framework/project is required (eg. to introduce a new class of test, eg. integration), offer to tackle this next
- Review the new code, and simplfy it to make it more understandable
- Look for opportunities to divide the code into logical groupings
- Review code comments - they should represent intent
  - Look for comments that are out of date because a function, class, interface, or type has been changed
  - Look for comments that indicate a problem has been set aside for later (eg. `TODO` / `qq` / `LATER`)
    - Those comments MUST have an indication of WHEN or under what CONDITIONS the problem should be dealt with
    - If they don't, then add those details (and consult the user if it's not clear)
    - Decide if it's appropriate to deal with those parts of the code yet
    - If it is, offer to tackle them next

### 2. Compilation

- Compile the project and review the linting information
- Make fixes to reduce any errors and warnings from the compiler and linter to 0
- If there's a case where this would be unnecessarily complicated or undersirable, ask the user how to proceed

### 3. Testing

- Run the tests to see if the current set of tests still pass
  - Always run the unit tests
  - Run all other test suites, where each is expected to take less than 1 minute
  - For any remaining test suites, ask the user if you should run them
- Consider the intent behind the code that changed, and any new code
- Write or update tests for the new code, and for code that has been modified
- Remove tests for code that no longer exists
- Test the intent of the code, to ensure that when the tests pass, the code behaves as expected

### 4. Documentation

- Review and update the documentation in the project that relates to the new or changed code
- Remove any documentation referring to code that has been removed
