# AGENTS.md

This document is the **README for AI coding agents**. It complements the human-facing `README.md` so that agents can develop safely and efficiently.

---

## Documentation of Process vs Policy

This repository separates **policy** from **how-to guidance**:

- **AGENTS.md = Policy (MUST/MUST NOT)**  
  Contains the mandatory rules agents must follow (for example language requirements, required sections, validation expectations, and safety boundaries). Keep it short and stable.

- **SKILLS = Procedure / Templates / Checklists**  
  Contains step-by-step workflows, templates, and checklists used to comply with policy. Prefer updating skills when improving writing structure or workflow details.

Rule of thumb:
- If it is a non-negotiable rule for reviews or CI, put it in **AGENTS.md**.
- If it is an example, template, or writing process, put it in a **skill**.

---

## Setup Steps

* Recommended: VS Code Dev Container / GitHub Codespaces (use `.devcontainer/`).
* On the first run, execute `vorbere run setup` at the project root to prepare the workspace.
* Task runner: `vorbere` (CI should use the same tasks described later).
* This repository targets **Ubuntu/Linux environment operations**, so prefer validating changes inside the provided Ubuntu-based development environment.

---

## Build & Run

* Build: `vorbere run build`
* Check: `vorbere run check`
* Test: `vorbere run test`
* Setup: `vorbere run setup`
* If helper scripts are added, document their invocation in `README.md` or `docs/` and prefer running them through `vorbere` tasks when practical.

---

## Project Structure

This repository manages Ubuntu/Linux environments with scripts, task-runner commands, and related configuration. The current tree may be small, but new files should follow these conventions:

```text
.
├─ scripts/                  # Operational scripts for provisioning, setup, cleanup, and maintenance
├─ config/                   # Configuration files, templates, and static data consumed by scripts
├─ overlays/                 # Files copied into target environments or root filesystems
├─ tests/                    # Automated tests and fixtures for scripts and generated artifacts
├─ docs/                     # Detailed user guides and specification references
├─ .devcontainer/            # Ubuntu-based development environment definition
├─ vorbere.yaml              # Task definitions for setup, checks, tests, and build flows
├─ README.md                 # Human-facing onboarding document
└─ AGENTS.md                 # Policy for AI coding agents
```

### Roles and Guidelines

* Put reusable operational logic in `scripts/` instead of embedding complex shell directly in CI or README examples.
* Put configuration, template files, and generated-input defaults under `config/` or another clearly named data directory.
* Put files intended to be copied into a target filesystem or machine image under `overlays/` or an equivalently explicit directory.
* Mirror script behavior with tests under `tests/` when automated verification exists.
* Avoid introducing unnecessary top-level directories; prefer extending the layout above.

### Agent-Specific Rules

* Place new files according to the directory guidance above.
* When modifying script behavior, add or update tests when the repository already has an appropriate test pattern.
* When writing files, mounting images, or touching system-like paths during tests, use disposable directories so host or fixture data is not overwritten.

---

## Coding Standards

* Always run `vorbere run check` and ensure there are no warnings.
* Prefer Bash for non-trivial scripts and declare the interpreter explicitly with a shebang.
* For Bash scripts, prefer `set -euo pipefail` unless there is a documented reason not to use it.
* Quote variable expansions, validate inputs early, and avoid relying on implicit current-directory state when an absolute or repository-relative path is safer.
* Keep scripts idempotent where practical so repeated runs do not leave the environment in an inconsistent state.
* Do not silently discard errors; surface failures clearly and exit non-zero when an operation cannot be completed safely.
* Extract repeated paths, package names, URLs, and flags into clearly named variables or constants within the script.
* Avoid large unrelated refactors; keep the change surface minimal.
* Keep comments and implementation consistent; add comments only where shell logic would otherwise be difficult to follow.

---

## Testing & Verification

* Primary verification commands:
  * `vorbere run check`
  * `vorbere run test`
  * `vorbere run build`
* When command behavior changes, keep usage examples in `README.md`, `docs/`, and test fixtures consistent.
* Prefer testing scripts in disposable environments, temporary directories, containers, or chroots rather than mutating the developer host.
* Before and after your work, confirm `vorbere run check`, `vorbere run test`, and `vorbere run build` succeed. If they fail, report the cause and mitigation.

### Static Analysis / Checks / Safety Validation

* Static analysis and formatting should be executed through `vorbere run check`.
* If shell-specific linting or formatting tools are configured by the repository, use them through the existing `vorbere` tasks rather than invoking ad hoc alternatives.
* If dependency or package-audit steps are added later, document and run them through the repository task runner.

---

## CI Requirements

CI should run the same repository tasks used locally:

* `vorbere run check`
* `vorbere run test`
* `vorbere run build`

Confirm the same commands succeed locally before opening a PR. If they fail, fix the issue or clearly report the blocker.

---

## Security & Data Handling

* Do not commit secrets, private keys, tokens, or host-specific confidential information.
* Do not log credentials, SSH material, or other sensitive environment data.
* Obtain user approval before accessing external networks.
* Be conservative with destructive Linux operations (`rm`, partitioning, formatting, mount changes, package removal, service changes, permission changes, and writes outside the repository).
* Do not modify system directories, package-manager state, or running services unless that behavior is explicitly required, well understood, and safely testable.
* Use fictitious hostnames, addresses, usernames, and credentials in fixtures and examples.

---

## Agent Notes

* When instructions conflict, prioritize explicit user prompts and clarify any uncertainties.
* Prefer repository-local, reproducible workflows over one-off host mutations.

---

## Branch Workflow (GitHub Flow)

This project follows **GitHub Flow** based on `main`.

* **main branch**: Always releasable. Direct commits are forbidden; use pull requests.
* **Feature branches (`feature/<topic>`)**: Branch from `main` for new features or enhancements, then open a PR when done.
* **Hotfix branches (`hotfix/<issue>`)**: Branch from `main` for urgent fixes, merge promptly after CI passes.

### Rules

* Always branch from `main`.

---

## Commit Message Policy

Commit messages MUST follow **Conventional Commits** and MUST be written in **English**.

For structured authoring (template, checklist), use the skill: `conventional-commits-authoring`.

---

## Documentation Policy

- **Language**: All documentation (`README.md`, `docs/`, inline comments intended as documentation) MUST be written in **English**.
- **README.md (top level)** is onboarding-first: overview, setup, and one quick-start. Keep it short and link to details in `docs/`.
- **docs/** holds detailed documentation and is organized as:
  - **User guides** (practical operation / workflows)
  - **Specification references** (inputs, outputs, flags, processing rules, filesystem layout, environment assumptions)
  - If content mixes both, split it into the appropriate documents.
- **Source of truth**
  - For post-implementation updates, treat **scripts/configuration + passing tests** as SoT and use `docs-maintenance-implementation-sync`.
  - For design-first work where the **spec is SoT**, use the spec-driven skills (`spec-driven-doc-authoring` / `spec-to-code-implementation`).
- **PR hygiene**: Update docs with behavior changes. If no doc updates are needed, explicitly note **"No documentation changes"** in the PR description.

---

## Dependency Management Policy

* Keep repository dependencies and required tools declared in tracked repository files such as `.devcontainer/`, `vorbere.yaml`, install scripts, or other dedicated manifests.
* When adding Ubuntu packages or external CLI dependencies, document where they are installed and why.
* Prefer reproducible installation paths over undocumented manual setup steps.
* For dependency updates, state the target tool/package and reason in the PR body.

---

## Release Process

* Follow **SemVer** for versioning.

---

## PR Template

PR descriptions MUST be written in **English** and MUST include:
- Motivation
- Design
- Tests (only what was actually run)
- Risks

For structured authoring (template, checklist), use the skill: `pr-description-authoring`.

---

## Checklist

* [ ] `vorbere run check`
* [ ] `vorbere run test`
* [ ] `vorbere run build`
