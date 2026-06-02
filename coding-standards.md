# Coding standards

## All languages

- Use clear function and variable names
- Group code logically by intent
- Use multi-line documentation comments for all classes, interfaces, enums, enum values, methods, functions, variables, consts
- Exceptions: there's no need to comment very simple properties
- Comments should represent the intent of the thing, rather than precisely how it works (in this way it's easier to spot an issue because the implementation will not agree with the intent)

## Typescript

- Use strict mode

## C#

## .NET MVC

## React

- Prefer the functional React component style
- Use the linter to check the dependencies in `useEffect`, `useCallback` functions
- Be careful when updating a state variable that is also in the scoped dependencies list
- Wherever possible use pure functions outside a component to calculate states and values
- Prefer `useReducer` over `useState`

