# Utopia — open-source enterprise world model (DeepLethe, Apache-2.0). Deploy on Railway with one click.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/_R4rxR)

[Utopia](https://github.com/deeplethe/utopia) is DeepLethe's temporal knowledge base: it turns contracts, records and documents into dated facts (valid time + learned time) over an ontology, flags conflicts into a review queue, and exposes the base to agents over MCP. This template runs the upstream `ghcr.io/deeplethe/utopia:0.1.0-rc9` image (Rust server + web UI, pinned by digest), wrapped as `ghcr.io/onepush-dev/utopia:0.1.0-rc9`, with Postgres 16 + pgvector.

## Features
- Temporal facts with evidence, ontology and axioms, conflict detection and a human review queue
- Full-text (Tantivy) + vector search, document extraction (PDF via poppler)
- Per-knowledge-base members and roles, optional OIDC single sign-on
- MCP endpoint so Claude Desktop, Cursor or your own agents can read the base

## Services
| Service | Image | Port | Volume |
|---|---|---|---|
| Utopia | `ghcr.io/onepush-dev/utopia:0.1.0-rc9` | Railway `PORT` (public HTTPS), health `/api/v1/health` | `/app/data` (raw files, search index, `secret.key`) |
| Postgres | `pgvector/pgvector:0.8.7-pg16` | 5432 (private) | `/var/lib/postgresql/data` |

## First login
Zero inputs at deploy time. Open the public URL and **register: the first account becomes the system administrator** (do it right after deploy). Then:
1. Administration → Models: add a chat model and an embedding model (any OpenAI-compatible endpoint).
2. Administration → turn off open registration if only invited users should join.

`UTOPIA_JWT_SECRET` and `UTOPIA_SECRET_KEY` are intentionally left unset: Utopia generates the JWT secret on first start (stored in the database) and the credential-sealing key in `/app/data/secret.key` (on the volume). Back up both the volume and the database.

## What the wrapper adds
`railway/railway-start.sh` binds Utopia to Railway's injected `PORT` (fallback 1516) and waits up to 180 s for Postgres before starting, so first-boot migrations never race the database. Image defaults: `UTOPIA_DATA_DIR=/app/data`, `UTOPIA_WEB_DIST=/app/web-dist`, `UTOPIA_DB_MAX_CONNECTIONS=32`, `RUST_LOG=info`.

## License
Utopia is Apache-2.0 licensed by DeepLethe. This repo only holds Railway packaging.
