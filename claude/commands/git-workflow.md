Follow these git workflow conventions for all branching, commits, and pull requests:

## Branch Strategy

- One **dedicated branch per logical unit of work** (feature, bugfix, refactor).
- Branch naming: `<TICKET>_<short-description>` (e.g., `ABC-123_add-response-caching`). Lowercase kebab-case for description.
- Keep branches short-lived. Rebase frequently.

## Commits

- **Small, atomic commits** — each should compile, pass tests, and represent one logical step.
- One concern per commit (never bundle a bugfix with a formatting pass).
- Clean up history before opening a PR with non-interactive rebase: `git commit --fixup <sha>`, then `git rebase --autosquash <base>`.
- Prefer `rebase` over `merge` for linear history on feature branches.

### Commit Message Format

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>
```

- Extract JIRA ticket from branch name as scope, uppercase (e.g., `ABC-123` from `ABC-123_feature-name`)
- Subject: imperative mood, lowercase, no trailing period, ~50 chars
- Body: explain *why* not *how*, wrap at 72 chars
- Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`

Example:
```
feat(ABC-123): add caching to search results

Reduce latency for repeat queries by caching results.
```

## Pull Requests

- Each PR = **one cohesive change**. Split unrelated concerns.
- Aim for ~200-400 lines of diff (reviewable in one sitting).
- PR title: conventional commits format (e.g., `feat(ABC-123): add caching to search results`).
- PR description: **Summary** (1-3 bullet points of what/why) + **Test plan**.

## Stacked PRs

For larger features, decompose into dependent PRs:
1. Base infrastructure / data model changes
2. Core logic / service layer
3. API / UI integration

Each PR should be independently reviewable, pass CI, and ideally be deployable on its own. Use `git rebase --onto` or a stacking tool (`graphite`, `git-town`) to manage the chain.
