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

## Backlog composition, task types

While it sometimes seems that agile product development is about the new feature development, however in practice the engineering team's capacity consists of:

 * Feature development
 * Operations/maintenance
 * Unplanned effort (i.e. defects in production)

These are very different activities and there is no treat them the same. Instead, we can use differentiate these types of work. In case we use Jira or other tool for task and backlog management, it would reflect in different task types:

 * User story
 * Task
 * Defect

Different task types allow us to treat them differently: apply different Definition of Ready, Definition of Done, task description, estimate etc.

**User story** brings business value as added functionality to the end user. It naturally follows the User Story format (*"As a ... I want ... so I could ..."*). It usually has a direct interaction with the end-user via some interface (UI, API). They are estimated using Story Points (by comparing User Story complexity), prioritized by Product Owner and planned in a roadmap.

**Task** may be technical task, task for technical analysis, operational activity, maintenance task or enabler for other user story. It brings business value by increased system stability, visibility, security, customer satisfaction, managed (reduced) risks. The nature of these tasks is very different, therefore it is difficult to use a comparative them. Estimating them using Story Points doesn't make sense either. The format doesn't need to meet the User Story format, but the value still need to be defined and measured where applicable.

**Defect** is the incorrect system functional or non-functional behavior, discovered after completion of the original task/user story. Like the Task, it doesn't have a User Story estimate nor User Story format. However, in order to prioritize the defects accordingly, it is needed to identify the threat that is caused by the defect and the risk it poses.

## Backlog prioritization, definition of ready

As different task are treated differently, there are obvious differences in specifying details and prioritizing them.

The **user stories** are prioritized by Product Owner according to the expected Business Value and Estimate (Story Points value).

The **tasks** are usually the prerequisites for the User Stories, therefore they are naturally prioritized higher and planned to be implemented one or more sprints in advance. The operational or maintenance tasks are usually included to the sprint by default to ensure the stability of the system.

The **defects** are prioritized according to the Risk they pose. There is no silver bullet how to prioritize them along Business items (User Stories) - the company has to define itself how to measure the value of the Risk mitigation.
One of the options is to define the expected remediation time for certain Risk ratings, and then after evaluation of the defect, plan the remediation according to this expectation.

In order to prepare the backlog items for implementation, the **Definition of Ready** needs to be defined. The DoR is the alignment between the Team, Product Owner and other stakeholders on the criteria the item needs to meet, so it could be accepted to Sprint for implementation.

The example of the DoR for the User Story:

* The User Story is written in a proper format, all parts (actor, function, value) is clear to the team
* Acceptance Criteria (functional and non-functional requirements) is clear (not ambiguous) and testable
* Meets INVEST criteria
* Dependencies are identified and impediments are removed (i.e. the wireframes/mockups are prepared by UX team; the translations are provided by Translations team etc.)

The example of the DoR of the Defect:

* The defect is reproducible
* The impact (damage, scope etc.) is defined

The DoR for the Task does not have most of these requirements, so it defining them brings value to your team, you can do it for your specific case.


## Sprint planning, estimating

While the product roadmap (backlog) is owned and maintained by the Product Owner, the sprint plan is the team's commitment for the certain timebox (sprint).

The content of the sprint is usually the following:

* New feature development (User Stories from Product Backlog)
* Technical tasks
* Maintenance and operational tasks
* Leftovers from previous sprints
* Unplanned urgent items

As only User Stories are initially estimated using Story Points, the team's velocity is not sufficient to ensure accuracy of the sprint content.
Also, having in mind that the team's capacity isn't constant: team member rotation, annual vacations, planned absences, partial availability etc. directly impacts the sprint capacity. Also, certain factors (i.e. seasonal events) impact how much operations and maintenance is needed. Therefore the mean team's velocity (Story Points completed per sprint) cannot be automatically planned for the Sprint's delivery.

What I found useful for the team is to split the tasks into subtasks, estimate them in timed units during the Sprint Planning activity and use this metric to plan the sprint.
In such case the team knows up-front its capacity, the operational task effort (from empirical data) and how much feature tasks (User Stories) can be planned.

Additionally, during the planning the team may assign certain tasks in advance to specific team members. Due to different knowledge and experience, the esimate can also differ (i.e. during the onboarding period of a team member), although the complexity and the Story Point estimate does not and should not correlate.

> It is very important not to try correlating them and to leave purely for the team. While management usually tries to include time in various calculations, it brings more harm, as it results in either "safe" overestimates or cutting quality corners in favor of meeting estimates. I've seen this both behaviour and both of them cause negative impact and, what is even worse, this impact is hidden behind good-looking KPIs.

## Tracking time, definition of done, leftovers

TBD: physical board, trello, jira

## Draft ideas:

Different issue types:

 - User story. Links with Epic. Brings business value as added functionality
 - Task. Technical work.
 - Defect

Different task types have different DoRs, DoDs. Only USs are estimated in SPs (bringing actual business value). Only USs follow US format.
US have funcspec, include mockups/wireframes etc, other types - technical info, analysis tasks, operational, maintenance tasks, which do not generate the business value as new features. Value is better stability, visibility, customer satisfaction, reduced risks...

TBD: include example of DoR, DoD, example of common NFRs for UI, API, backend etc.

Version means release. Useful for higher-level business planning and communication.

Subtasks cover all work.

Remaining work is what matters. Spent time has a meaning for operational, maintenance tasks - in order to plan such capacity in advance.

For consistency, some functions in organization might be centralized. I.e.: UI/UX design,

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
