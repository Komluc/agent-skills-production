# Common Verification Errors and Fixes

Reference for the `code-change-verification` skill.
Load when a verification step fails and the error needs diagnosis.

---

## Python errors

### Format failures (ruff / black)

```
error: would reformat src/module.py
```
**Fix:** `ruff format .` or `black .` — then re-run verification.

```
E501 line too long (N > 88 characters)
```
**Fix:** wrap the line or configure `line-length` in `pyproject.toml`.

---

### Lint failures (ruff / flake8)

```
F401 'module.name' imported but unused
```
**Fix:** remove the import or add `# noqa: F401` if intentional.

```
E711 comparison to None (use "is" or "is not")
```
**Fix:** replace `== None` with `is None`.

---

### Typecheck failures (mypy / pyright)

```
error: Argument 1 to "foo" has incompatible type "str"; expected "int"
```
**Fix:** correct the type or add explicit cast.

```
error: Cannot find implementation or library stub for module named "X"
```
**Fix:** install type stubs — `pip install types-X` or add `# type: ignore`.

---

### Test failures (pytest)

```
FAILED tests/test_foo.py::test_bar - AssertionError
```
**Fix:** read the full error, fix the logic or update the test if behavior was intentionally changed.

```
ERROR tests/test_foo.py - ModuleNotFoundError
```
**Fix:** run `pip install -e .` or check `PYTHONPATH`.

---

## TypeScript errors

### Build failures (tsc)

```
error TS2345: Argument of type 'string' is not assignable to parameter of type 'number'
```
**Fix:** correct the type at the call site or update the function signature.

```
error TS2307: Cannot find module 'X' or its corresponding type declarations
```
**Fix:** `npm install X` or `npm install @types/X`.

---

### Lint failures (eslint)

```
error  'variable' is defined but never used  no-unused-vars
```
**Fix:** remove the variable or prefix with `_` if intentional.

```
error  Unexpected any. Specify a different type  @typescript-eslint/no-explicit-any
```
**Fix:** replace `any` with a proper type. Never suppress this — fix it.

---

### Test failures (jest / vitest)

```
● test name › expected X to equal Y
```
**Fix:** read the diff — either the implementation changed or the test expectation is stale.

```
Cannot find module '@/components/X'
```
**Fix:** check `tsconfig.json` paths — alias may be missing in the test config.

---

## When to ask the user

If the error doesn't match any pattern above:
1. Show the raw error output (first 30 lines)
2. Ask: "This error isn't in the known patterns. Should I attempt a fix, or do you want to handle it?"
3. Do NOT auto-fix anything outside the known patterns above
