# Health Member Portal Demo

An Experience-Cloud-style member portal dashboard - coverage, recent claims,
and care team in one view - built with LWC + Apex against a **fictional**
health plan ("ClearPath Health Plan").

> Portfolio demo. Every member, plan, provider and claim is synthetic.
> This is not a medical product, holds no real PHI, and contains no code,
> data or configuration from any employer or client.

## Scenario

Members logging into a health plan portal ask three questions: *"Am I
covered? What happened with my claim? Who is my care team?"* This demo
answers all three on one dashboard, using the same shape a real member-360
portal uses - a thin controller, a service layer, and small presentational
child components.

## What's Inside

| Piece | Description |
|---|---|
| `memberDashboard` LWC | Parent: wires `getDashboard`, composes the three cards, shows YTD billed total |
| `coverageCard` / `claimsList` / `careTeamList` | Presentational children receiving data via `@api` (no Apex calls) |
| `MemberPortalController` | Thin `@AuraEnabled(cacheable=true)` controller with input validation |
| `MemberPortalService` | Dashboard assembly: member, coverage, claims, care team + `SUM(Billed_Amount__c)` aggregate in 5 flat queries |
| Objects | `Member_Profile__c`, `Coverage__c`, `Claim__c` (CLM-####), `Care_Team_Member__c` |
| Tests | Dashboard assembly, status filter, null-member error, query-count guard |

## Design Notes

- **One wire, three cards.** The parent fetches once and passes slices down
  via `@api`, so children stay dumb, reusable and easy to Jest-test.
- **Flat query budget.** The dashboard uses a fixed 5 queries regardless of
  data volume - asserted by `bulkMembersDashboardQueriesStayFlat`.
- **Portal-ready targets.** Components expose `lightningCommunity__Page`
  in addition to record/app pages.
- **Health-data hygiene.** Sharing is `Private`/`with sharing` throughout;
  a real implementation would add person-account sharing, HIPAA review,
  encryption and audit logging - out of scope for a synthetic demo.

## Getting Started

```bash
sf org login web --alias demo
sf project deploy start --target-org demo
sf apex run test --test-level RunLocalTests --target-org demo
```

Create a `Member_Profile__c` plus a few Coverage/Claim/Care Team rows
(or adapt `MemberPortalTestFactory.createFullDemoMember` in Anonymous Apex),
then put **Member Dashboard** on the member record page.

## License

MIT - see [LICENSE](LICENSE).
