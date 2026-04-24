# Changelog

All notable changes to this project are tracked here. Format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Project documentation scaffolding: `docs/{prd,designs,adr,tasks,history,templates}`.
- Slash commands: `/prd`, `/adr`, `/task-breakdown`, `/session-log`, `/snapshot`.
- CHANGELOG file.
- `PreCompact` hook (`.claude/hooks/pre-compact.sh`) that freezes git state,
  recent commits, latest docs, and open tasks into `.claude/context/pack.md`
  before context compaction.
- `SessionStart` hook now announces when a context pack is available.
- CLAUDE.md "Context management" section: rules for surviving `/compact`
  via the pack file + `docs/history/*.md` dual record.
