## Coding standards for React

- Prefer the functional React component style
- Use the linter to check the dependencies in `useEffect`, `useCallback` functions
- Be careful when updating a state variable that is also in the scoped dependencies list
- Wherever possible use pure functions outside a component to calculate states and values
- Where possible, prefer calculating values during render rather than in a `useEffect`
- Where necessary, you can still use `useEffect`
- Prefer `useReducer` over `useState`
- Comment all pure functions, Component functions, constants
- Add a comment for each `useEffect`, and each `useCallback`
