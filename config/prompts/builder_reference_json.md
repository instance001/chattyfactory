# Builder Reference: JSON Plan Schema (Do Not Inject Into Model Prompts)

This file is for humans/debugging. The GUI planning flow is Plan.md-first; once confirmed, the system compiles to WorkOrder JSON deterministically.

```json
{
  "steps": [
    {
      "id": 1,
      "title": "Plan-only title",
      "kind": "plan_only",
      "done_means": ["facts to verify"],
      "checks": ["exists: path", "not_exists: path", "contains: path|needle"]
    }
  ]
}
```

