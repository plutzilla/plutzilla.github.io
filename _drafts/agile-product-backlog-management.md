---
title: Agile product backlog management
layout: post
---

Capacity = feature development + operations/maintenance

Different issue types:

 - User story. Links with Epic
 - Task
 - Bug

Different task types have different DoRs, DoDs. Only USs are estimated in SPs (bringing actual business value). Only USs follow US format.
US have funcspec, include mockups/wireframes etc, other types - technical info, analysis tasks, operational, maintenance tasks, which do not generate the business value as new features. Value is better stability, visibility, customer satisfaction, reduced risks...

TBD: include example of DoR, DoD, example of common NFRs for UI, API, backend etc.

Version means release. Useful for higher-level business planning and communication.

Subtasks cover all work.

US have SPs. Used for planning/prediction of future releases/sprints. Can have preliminary plan of multiple future sprints if needed.
Reviewed and refined periodically to reflect the actual situation. Fine-grain refinement done 1 sprint in advance, so missing details could be provided until the actual planning.

Planning:

 * US - with PO
 * Tech items and implementation - without PO (2nd planning part). Common agreement on the needed capacity for tech. tasks

Sub-tasks estimated in timed units (hours).
Sub-task estimation is used to plan the capacity of sprint.
Time may be tracked to know the operational costs, also to know the needed operational capacity for upcoming sprint(s)

Wrong to anyhow relate SPs to time.

DoD includes deployment.

It is OK not to deploy in the end of the sprint, if only development is left. US is not closed.
Although velocity is lower, only the average velocity value within multiple sprints is meaningful.
However, not done tasks indicate incomplete features within sprint.
Velocity and US completeness ratio is not treated as the team's performance indicator.
Hour-completeness ratio may indicate team's estimation accuracy. It might indicate unforeseen issues (underestimate), or found opportunities (overestimate), that can be reviewed during the retrospective.

US moved to next sprint consume only the subtask-estimated capacity from the sprint capacity. Not the SPs.

Sprint swimlanes (in Jira case) are USs/tasks ordered by priority.
Columns are very team workflow-specific.

If US/task spans multiple (>2) sprints, it may indicate the obstacles (i.e. blocking dependencies), that may need to be resolved or escalated.
Closing partial USs create fake sense of achievement, hiding potential issues. Should be avoided.
