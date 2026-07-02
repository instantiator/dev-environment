---
type: standard
title: React standards
description: Component style, hooks discipline, and structure for React. Read when writing or reviewing React components.
tags: [react, frontend, framework]
---

# React

- Prefer the functional component style.
- Use the linter (eslint-plugin-react-hooks) to check dependencies in `useEffect` and `useCallback`.
- Be careful when updating a state variable that is also in the scoped dependencies list (it can loop).
- Wherever possible use pure functions *outside* the component to calculate states and values.
- Prefer calculating values during render rather than in a `useEffect`; use `useEffect` only where necessary (subscriptions, imperative APIs).
- Prefer `useReducer` over `useState` for related or multi-step state.
- Prefer native platform features over dependencies: `<input type="date">` over a picker library, CSS over JS.
- Comment all pure functions, component functions, and constants; add a comment for each `useEffect` and `useCallback` stating its intent.

## Structure

- One component per file; group components, hooks, and utilities by feature, not by kind.
- Break supporting logic (formatting, calculations) into plain modules that can be unit-tested without rendering.
