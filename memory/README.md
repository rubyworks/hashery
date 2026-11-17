# Project memory

Notes that AI agents working on this project keep for each other: status,
plans, decisions in progress and lessons that are not obvious from the code
or the git history. Read these before starting work; update them when
something here changes. `../config.yml` gives this project's `handle`:
other projects' agents write to it at `@` plus the handle.

`.ai/` is a git worktree of the repository's orphan `ai` branch, ignored by
the code checkout. Run git against it (`git -C .ai ...`), stage by path,
never `git add -A`, and push it by name (`git -C .ai push origin ai`). In a
public repository the branch is public too. Settled knowledge that anyone
working on the code needs belongs in the project's own docs, not here.

| File | What it holds |
|---|---|

Keep each note short and dated (`*Updated YYYY-MM-DD*`), with absolute
dates and commit hashes. Check the code or `git log` before acting on
anything here; notes go stale. Machine-specific facts don't belong here.
Never commit credentials or keys.

## Handling mail that arrives

Messages from other projects' agents land in `.ai/mail/inbox/`, which holds
only mail not yet read and is never committed. Read them oldest first (the
order they list in), and for each one:

1. Put what matters into the memory notes here, in your own words. A
   message to consult again, such as a spec or a design, can be cited by
   its path in `mail/received/` instead of summarized.
2. Move it, unchanged and under the same name, to `.ai/mail/received/`.
3. Commit the notes and the message together.

`mail/received/` and `mail/sent/` are never edited: they're the record of
what other projects said and what this one said back.

## Outbound mail

The lead agent (the main session the user works with) writes mail on the
user's behalf, one file per message named by the time it was written (UTC)
and its address: `<time>-<address>--<topic>.md`
(`20261010-180322Z-@datadungeon--schema.md`). A file keeps its name as it
moves between folders.

- Routine mail (status, notices of things done, answers from settled facts,
  requests for information) goes straight to `.ai/mail/outbox/`.
  Delivery puts it in the recipient project's `mail/inbox/` and moves it
  to `mail/sent/`, the committed record of what was said.
- Anything that commits the user or the project, makes a decision the user
  hasn't made, pushes back, shares something private, or that the user
  asked to see goes to `mail/drafts/` with a `Held: <why>` line, and waits
  for the user's approval. When unsure, hold. `mail.review: all` in
  `../config.yml` holds everything.
- Helpers (subagents, other sessions) never send: they put messages in
  `mail/drafts/` with a `By: <who>` line, and the lead reviews them like
  its own.
- Drafts and the outbox are machine-local and never committed. Never write
  into another project's `.ai/`, except to deliver into its `mail/inbox/`.

## Transcripts and records

`.ai/transcript/` holds session transcripts written by the agent runtime,
one tagged entry per event (`<E1043 …>…</E1043>`), always redacted before
they're committed, and encrypted with git-crypt if `transcript.encrypt` is
set. Each person numbers their own stream; a file's header names whose it
is. Read them, never edit them; find an entry with
`grep -rn '^<E1043 ' .ai/transcript`. Files that look like binary mean the
worktree is locked (`cd .ai && git-crypt unlock`).

`.ai/records/<handle>/` holds the records the runtime curates from them
(notes, summaries, memories), one file per version, never edited.

## Intake and Outtake

Two folders in the project's own directory, next to `.ai/`, pass files
between the user and the agents, and nothing else: `Intake/` holds files
the user shares (look there when starting a session; don't move, edit or
delete them unless asked), and `Outtake/` holds files an agent, usually the
lead, shares with the user. Each holds a `.gitignore` of `*`, so neither is
ever committed.

## Arcana

Where the project uses the Arcana bus, messages sent over it are mail like
any other: they go through the outbox or drafts as above, and are filed
under `mail/sent/`. A message received off the bus is written to
`mail/inbox/` at once and handled like any other, so every message between
projects is recorded, whichever way it went. A topic (`#name`) isn't mail:
the bus keeps its log. A notice of a post in one is read and deleted,
never filed.
