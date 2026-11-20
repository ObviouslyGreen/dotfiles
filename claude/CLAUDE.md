# Coding Principles

Prioritize: correctness > clarity > maintainability > robustness > pragmatism.

## Design Decisions

When a task involves a **non-trivial design choice** (architecture, library selection, data modeling, API shape, state management, etc.):

- **Pause and present options** before building. Each option should include a short name, explanation, pros, cons, and trade-offs.
- If one option is clearly superior, **recommend it** with reasoning — but still present alternatives.
- **Wait for the user to decide** before writing implementation code.
- For trivial/mechanical decisions with one obvious answer, just proceed.
- Before starting a substantial multi-task build (new infra, a new service, a multi-repo rollout), restate the actual end goal in one sentence and check that the proposed scope is the simplest thing that gets there — not just the most thorough. Catches cases where a big build turns out to be solving a smaller problem than it looks like.

## Code Style

- Favor **composition over inheritance**, **immutable data**, and **pure functions**.
- Use **guard clauses and early returns** to reduce nesting.
- Extract non-obvious literals into **named constants**.
- Keep functions small with a single, well-defined purpose.
- Comments explain *why*, not *what* — code should be self-documenting.

## Error Handling

- Handle errors and edge cases at the **beginning of functions**.
- Use the **if-return pattern** instead of else blocks.
- Place the happy path last for readability.

## Pragmatism

- **YAGNI**: implement only what's explicitly requested.
- Justify every abstraction with immediate value — favor simplicity.
- Optimize only when driven by profiling data.
- **Scope discipline in PRs and reviews**: stick to the diff/brief in scope. Flag adjacent issues or dead code instead of fixing them inline, and don't expand scope without being asked — note it as a follow-up instead.
- Docs/specs may grow or be edited across review rounds only when load-bearing — don't pad them on every pass just because a round happened.
- Specs are a living source of truth for the current design, not a review log — edit them to reflect the latest decision; don't accumulate rounds of review commentary or editorial framing inside them.
- Plans and scratch review artifacts (e.g. superpowers planning output) default to `~/Code/docs/plans` or a tmp file; specs default to `~/Code/docs/specs` (also the home for specs that belong to no repo). Neither is committed into the target repo by default. Commit a spec into the repo's own `docs/specs/` only when that repo's conventions require it (e.g. a doc site that builds from committed specs) or the user explicitly asks — never the tool-specific `docs/superpowers/specs/` path.

## Idiomatic Python

- Python **3.12+** syntax and features.
- **Type hints** on all function signatures; prefer builtins over `typing` module (e.g., `list` not `typing.List`).
- Leverage the standard library (`pathlib`, `collections`, `datetime`, comprehensions, context managers).
- `async/await` with `asyncio` for async code.
- **`uv`** for environment and package management.

## Idiomatic TypeScript

- **Strict mode** enabled in `tsconfig.json`.
- Strong static typing with interfaces, type aliases, and generics.
- **`pnpm`** for package management.

## Testing

- Write tests **alongside** implementation code.
- Use **table-driven/parameterized tests** for multiple input-output scenarios.
- Prefer **unit tests** for pure logic; integration tests for boundaries.
- Test names describe **scenario and expected outcome** (e.g., `test_expired_token_returns_401`).

## Refactoring

Focus specifically on the target principle, pattern, or quality attribute mentioned in the prompt. Avoid scope creep into unrelated improvements.

## Output Hygiene

- Omit hedging, meta-commentary, and process-rationale asides from generated text — PR summaries, specs, tool/API descriptions, code comments. State the decision, not the deliberation behind it, unless the caveat is load-bearing (a real limitation the reader needs to know).
- No em-dashes, and no "negative parallelism" or similar rhetorical comparisons ("not just X, but Y"), in PR summaries, commit messages, or review replies. Keep this prose plain and concise, not "LLM-sounding."

# Git & PR Workflow

- **Default to holding `git push` for a separate explicit go-ahead**, even after commit/branch/PR-draft steps were approved — unless the user's instructions for the session already make clear that push is in scope. Prep work (commits, branch creation, drafting the PR body) can proceed without re-asking.

# Subagent Dispatch

- **After `/compact`, resume an in-flight subagent-driven-development run from its ledger** instead of switching to inline implementation.
- **Default to subagent-driven-development for implementation work.** Once a plan or spec exists, delegate implementation via superpowers' `subagent-driven-development` unless told otherwise — this is a durable preference, not a one-off.
- **Pin the worker model on every parallel dispatch.** superpowers' `dispatching-parallel-agents` skill is silent on model selection — an omitted model makes each worker inherit the Opus session model and pay Opus rates across the whole fan-out. Set it explicitly per worker, choosing the tier via superpowers' Model Selection guidance.
- **When that guidance calls for Opus-tier, use the exact ID `claude-opus-5-5` wherever the model field accepts one** (skill, agent, and command frontmatter), so a future alias bump never silently changes the model. The Agent tool accepts tier names only; pass `opus` there.
- **Demand dense output on Fable dispatches.** Fable output is 5× its input cost, so instruct Fable subagents to be concise and skimmable — trim filler, never substance. Keep the full reasoning, options, and trade-offs.
