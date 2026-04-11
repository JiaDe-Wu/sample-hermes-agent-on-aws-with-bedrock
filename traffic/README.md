# GitHub Traffic Data

Auto-collected repository traffic data, updated daily at UTC 1:00.

## Files

- `clones-history.ndjson` — One clone record per line, 14-day rolling window
- `views-history.ndjson` — One views record per line

## Data Format

```json
{"fetched_at":"2026-04-12","clones":{"count":45,"uniques":23,"clones":[...]}}
```

## Note

- GitHub Traffic API only retains the last 14 days of data
- This workflow accumulates historical data via daily auto-commits
