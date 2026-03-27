# NFR Requirements Plan - Flappy Kiro

## Plan Checkboxes

- [x] Analyze functional design context
- [x] Assess NFR categories (all N/A categories documented below)
- [x] Generate nfr-requirements.md
- [x] Generate tech-stack-decisions.md

## NFR Category Assessment

| Category | Status | Rationale |
|---|---|---|
| Performance | **APPLICABLE** | 60 FPS target, game loop timing |
| Security | **APPLICABLE** | Security Baseline extension enabled |
| Maintainability | **APPLICABLE** | First-time Swift project; detailed docs requested |
| Usability | **APPLICABLE** | Responsive layout, font loading fallback |
| Scalability | N/A | Local desktop app, single user, no load |
| Availability | N/A | No server, no uptime SLA |
| Reliability/Failover | **APPLICABLE** (limited) | Audio fallback, font fallback |
| Compliance | N/A | No PII, no regulated data |
