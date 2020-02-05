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

In this blogpost I am sharing what practices I found to be working best, including the answers to the aforementioned questions.

Surely, your mileage may vary, as we're all working in different environments, have different management and stakeholder expectations and constraints.

## Backlog composition

While it sometimes seems that agile product development is about the new feature development, however in practice the engineering team's effort consists of:

* Feature development
* Operations/maintenance
* Unplanned effort (i.e. defects in production)

These are very different activities and should not be treated the same way. Instead, these types of work should be differentiated. In case we use Jira or other tool for task and backlog management, it would reflect in different task types:

* User story
* Task
* Defect

Different task types allow us to treat them differently: apply different Definition of Ready, Definition of Done, task description, estimate etc.

**User story** brings business value as added functionality to the end user. It naturally follows the User Story format (*"As a ... I want ... so I could ..."*). It usually has a direct interaction with the end-user via some interface (UI, API). They are estimated using Story Points (by comparing User Story complexity), prioritized by Product Owner and planned in a roadmap.

**Task** may be technical task, task for technical analysis (research), operational activity, maintenance task or enabler for other user story. It brings business value by increased system stability, visibility, security, customer satisfaction, managed (reduced) risks and enabling other backlog item delivery. The nature of these tasks is very different, therefore it is difficult to threat them the same way. Estimating them using Story Points doesn't make sense either. The format doesn't need to meet the User Story format, but the value still need to be defined and measured where applicable.

**Defect** is the incorrect system functional or non-functional behavior, discovered after completion of the original task/user story. Like the Task, it doesn't have a User Story estimate nor User Story format. However, in order to prioritize the defects accordingly, it is needed to identify the threat that is caused by the defect and the risk it poses.

## Backlog prioritization, definition of ready

As different task are treated differently, there are obvious differences in specifying details and prioritizing them.

The **user stories** are prioritized by Product Owner according to the expected Business Value and Estimate (Story Points value).

The **tasks** are usually the prerequisites for the User Stories, therefore they are naturally prioritized higher and planned to be implemented one or more sprints in advance. The operational or maintenance tasks are usually included to the sprint by default to ensure the stability of the system.

The **defects** are prioritized according to the Risk they pose. There is no silver bullet how to prioritize them along Business items (User Stories) - the company has to define itself how to measure the value of the Risk mitigation.
One of the options is to define the expected remediation time for certain Risk ratings, and then after evaluation of the defect, plan the remediation according to this expectation.

In order to prepare the backlog items for implementation, the **Definition of Ready** (DoR) needs to be defined. The DoR is the alignment between the Team, Product Owner and other stakeholders on the criteria the item needs to meet, so it could be accepted to Sprint for implementation.

The example of the DoR for the User Story:

* The User Story is written in a proper format, all parts (actor, function, value) is clear to the team
* Acceptance Criteria (functional and non-functional requirements) is clear (not ambiguous) and testable
* Meets INVEST criteria
* Dependencies are identified and impediments are removed (i.e. the wireframes/mockups are prepared by UX team; the translations are provided by Translations team etc.)
* Business metrics are defined for monitoring

The example of the DoR of the Defect:

* The defect is reproducible
* The impact (damage, scope etc.) is defined

The DoR for the Task does not have most of these requirements, so if defining them brings value to your team, you can do it for your specific case. The good example of such DoR would be "Service Level Objectives (SLO) are defined", which results in a mutual business and technical effort, and impacts the Service Level Agreement (SLA) of the product.

In order to meet all criteria for DoR, the backlog items need to be refined in advance (at least 1-2 sprints before the actual implementation), so missing information could be provided either by Product Owner or by certain stakeholders.

## Sprint planning, estimating

While the product roadmap (backlog) is owned and maintained by the Product Owner, the sprint plan is the team's commitment for the certain timebox (sprint).

The content of the sprint is usually the following:

* New feature development (User Stories from Product Backlog)
* Technical tasks
* Maintenance and operational tasks
* Leftovers from previous sprints
* Unplanned urgent items

As only User Stories are initially estimated using Story Points, the team's velocity is not sufficient to ensure accuracy of the sprint content.
Also, the team's capacity isn't constant: team member rotation, annual vacations, planned absences, partial availability etc. directly impacts the sprint capacity. Also, certain factors (i.e. seasonal events) impact how much operations and maintenance is needed. Therefore the mean team's velocity (Story Points completed per sprint) cannot be automatically planned for the Sprint's delivery.

The consensus however must be achieved between the Product Owner, team and other stakeholders which features and technical tasks are aimed to be planned for the sprint. This is usually done during the Sprint Planning first part.

What I found useful for the team is to split the tasks into subtasks, estimate them in timed units during the Sprint Planning activity and use this metric to plan the sprint.
In such case the team knows up-front its capacity, the operational task effort (from empirical data) and how much feature tasks (User Stories) can be planned. This can be done during the Sprint Planning second part, where the Product Owner participation is rather optional.

Additionally, during the planning, the team may assign certain tasks in advance to specific team members. Due to different knowledge and experience, the esimate can also differ (i.e. during the onboarding period of a team member), although the complexity and the Story Point estimate does not and should not correlate.

> It is very important not to try correlating them and to leave purely for the team. While management usually tries to include time in various calculations, it brings more harm, as it results in either "safe" overestimates or cutting quality corners in favor of meeting estimates. I've seen this both behaviour and both of them cause negative impact and, what is even worse, this impact is hidden behind good-looking KPIs.

## Tracking time, leftovers

When the sprint is planned, there is a question - should the spent time be tracked. Unless there is a strict management requirement to do so, estimating spent time should be done only if the team finds value in it.

I find the value of estimating the operational and maintenance tasks, as such information is useful for planning operational effort. Also, for the finance department it might be relevant when calculating the product capitalization.
Regarding tracking feature tasks, it is up for the particualar team whether there is value in doing it. Just beware that exposing such information to other stakeholders is risky, as I mentioned previously.

Another common question is how to handle unfinished sprint items. The common example is "Everything is implemented, tested, but not deployed. Should we complete the User Story?". I've seen various ways teams deal with such leftovers:

* Completing the User Story and creating another one
* Reestimating the User Story (changing the Story Points) and moving it to the upcoming sprint

Both of these ways are **wrong** - they create a fake sense of achievement, hide the information of the lead time (the feature is not yet in a production) and distort the User Story attributes (complexity evaluation).

This topic naturally leads to the **Definition of Done** (DoD) topic. Like the Definition of Ready, the common agreement of the DoD is needed within the team and depends on the product development lifecycle.
For example, for products with the timeboxed release cycles (i.e. software is physically shipped every 6 weeks or so), the implementation, testing and integration might be enough to treat the User Story as completed, but for the products where the features are released once they are implemented, the deployment (and likely some post-development activities) should be included in the DoD, meaning that the User Story can be treated as Completed only when the DoD is fully met.

This results in some cases when deployment is left to the upcoming spring on purpose (i.e. if there is a team agreement not to deploy on fridays, or there is some external dependency). And while the User Story would not be completed within the sprint, from the long-term perspective it would not matter that much, as the long-term average team velocity would not change.

As such Subtask would have relatively small timed estimate, the remaining time of the User Story would be quite small as well, so moving the User Story to the upcoming sprint would consume a small part of the upcoming sprint capacity.
Also, moving the User Story between sprints ensures the visibility of the lead time. It is a good indicator (i.e. if User Story spans more than 2 sprints) for the Scrum Master to review the impediments for the delivery of the User Story in order to resolve or escalate it.

Velocity and Story Point completeness ratio should not treated as the team's performance indicator, as it would lead to faking this metric.
Hour-completeness ratio may indicate team's estimation accuracy. It might indicate unforeseen issues (underestimate), or found opportunities (overestimate), that can be reviewed during the retrospective, but this should be left solely to the team.

## Definition of Done and non-functional requirements

Here is the example of the Definition of Done:

* Functionality is implemented and meets functional requirements (workflows, wireframes and other supplementary functional specifications for the specific User Story)
* Code is written and meets non-functional requirements
* Code is reviewed by other engineer and merged to the appropriate branch
* Functionality is reviewed and verified (accepted) by the Product Owner (applicable to User Stories; for technical tasks QA acceptance might be sufficient)
* Functionality is tested (integration tests are implemented, running in certain environment and passing)
* Deployed in production (if applicable according to your SDLC)

The DoD needs to be defined and aligned within the engineering team.

For functional requirements we use Confluence and link the specific pages to the Jira task. For easier navigation we prefix the Confluence pages with the Jira issue ID.

The non-functional requirements are both task-specific and generic (applicable for all tasks) for the team. Also, in a large scale organizations, it makes sense to have the generic non-functional requirements within all organization. As a prerequisite, certain requirements, guidelines, policies, services and teams need to be established, but the benefit is the consistency between multiple teams, and engineering efficiency due to centralized services and technical solutions.

## Epilogue

Despite certain good practices, it is most important to keep the Agile mindset and support its values. The practices are very specific for the certain organization, product and team, so we need to experiment and look for what works best in the certain situation. The other people's experience can help achieving results faster, but the specific organizational and technical context should always be considered.
