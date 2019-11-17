---
title: Agile product backlog management
layout: post
---

During my career in product development I've been working on Agile Product Backlog Management in different roles: as a software engineer, product owner, engineering manager and other stakeholder.

With every team I was working on we had the same questions:

 * How to accurately plan a Scrum sprint?
 * How to make a long-term plan?
 * Should we estimate in story points or hours?
 * Should we log hours?
 * When to treat the user story as "Completed"?
 * Should we reduce the estimate of the incomplete task after the sprint?
 * Should technical, maintenance tasks and defects (bugs) be treated as the user stories?
 * etc.

In this blogpost I am sharing what I found to be working best, including the answers to the aforementioned questions.

Surely, your mileage may vary, as we're all working in different environments, have different management and stakeholder expectations and constraints.

## Backlog composition and task types

While it sometimes seems that agile product development is only the new feature development, however in practice the engineering team's capacity consists of:

 * Feature development
 * Operations/maintenance
 * Unplanned effort (i.e. defects in production)

These are very different activities and there is no treat them the same. Instead, we can use differentiate these types of work. In case we use Jira or other tool for task and backlog management, it would reflect in different task types:

 * User story
 * Task
 * Defect

Different task types allow us to treat them differently: apply different Definition of Ready, Definition of Done, task description, estimate etc.

**User story** brings business value as added functionality to the end user. It naturally follows the user story format (*"As a ... I want ... so I could ..."*)

## DoR, DoD

## Planning, estimating


Different issue types:

 - User story. Links with Epic. Brings business value as added functionality
 - Task. Technical work.
 - Defect

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
