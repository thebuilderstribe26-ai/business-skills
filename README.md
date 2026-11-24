# Business skills for Claude Code

20 finance, accounting, HR and operations skills for small business owners, installed in one step.

## Install

Paste this into Claude Code:

```text
Install the business skills from github.com/thebuilderstribe26-ai/business-skills: clone it, read install.sh, then run it.
```

Or run it yourself in Terminal:

```bash
git clone https://github.com/thebuilderstribe26-ai/business-skills.git /tmp/business-skills && bash /tmp/business-skills/install.sh
```

Then restart Claude Code or open a new session.

## What the installer does

- Downloads each skill from its original GitHub repo, pinned to the exact commit that was reviewed. This repo holds no copies of the skills.
- Copies them into `~/.claude/skills`. A skill folder that already exists is skipped, never overwritten.
- Makes two small path fixes so the skills work outside their original plugin: the six small-business skills get their shared reference files, and hard-call gets `hard_things.md`.
- Checks the skills' helper scripts for network or shell calls and tells you if it finds any.
- Never runs any code from the source repos.

None of the skills needs an API key, and none moves money or sends messages on its own.

## The skills

| Department | Skill | Use it for |
|---|---|---|
| Finance | cash-flow-snapshot | 30/60/90-day cash forecast from the ledger, Stripe or a CSV |
| Finance | financial-analyst | Statement analysis, DCF, budget variance, rolling forecasts |
| Finance | saas-metrics-coach | MRR, churn, LTV and CAC for memberships |
| Finance | business-investment-advisor | ROI, payback, build vs buy on a big spend |
| Finance | launch-economics | Unit economics and a go/not-yet call before a launch |
| Accounting | invoice-organizer | Rename and sort invoices and receipts for tax time |
| Accounting | petty-cash-management | Petty cash register with running balance and counts |
| HR | job-post-builder | Job post, interview guide, scoring rubric, offer template |
| HR | hiring-screener | Ranked shortlist from a pile of applications, drafted replies |
| HR | culture-architect | Values turned into behaviors and team rituals |
| Ops | business-pulse | One-page snapshot of cash, sales, pipeline and this week |
| Ops | report-builder | Repeatable weekly or monthly KPI reports |
| Ops | inventory-planner | What to reorder and when, from sales velocity |
| Ops | procurement-optimizer | Which tools and suppliers to cut |
| Ops | pre-mortem | Launch risks before an event or launch |
| Ops | postmortem | Blameless review after a launch that missed |
| Ops | stress-test | Pressure-test a plan's assumptions |
| Ops | hard-call | Decisions where every option hurts |
| Ops | brainstorm-okrs | Quarterly OKRs with measurable key results |
| Ops | meeting-analyzer | Coaching from meeting and call transcripts |

## Sources and credit

All skills belong to their authors and are downloaded from their repos under those repos' own terms.

| Repo | Skills | License |
|---|---|---|
| [anthropics/knowledge-work-plugins](https://github.com/anthropics/knowledge-work-plugins) | cash-flow-snapshot, hiring-screener, job-post-builder, business-pulse, inventory-planner, report-builder | Apache-2.0 |
| [alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills) | financial-analyst, saas-metrics-coach, business-investment-advisor, culture-architect, procurement-optimizer, hard-call, stress-test, postmortem, meeting-analyzer | MIT |
| [borghei/Claude-Skills](https://github.com/borghei/Claude-Skills) | launch-economics, pre-mortem, brainstorm-okrs | see repo |
| [ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills) | invoice-organizer | see repo |
| [sickn33/agentic-awesome-skills](https://github.com/sickn33/agentic-awesome-skills) | petty-cash-management | MIT |

The installer script itself is MIT licensed.

Using a long list of skills costs a little context in every Claude session, so remove any you don't use from `~/.claude/skills`.
