---
title: Secure application development
layout: post

---

I have had an opportunity to take part in OWASP [AppSecEU 2016](http://2016.appsec.eu/) conference and trainings “Managing web and application security” by OWASP board member Tobias Gondrom.

My major focus and goal of the attendance was the adoption and management of application security program in the company.

> The [slides and videos of the conference](http://2016.appsec.eu/?page_id=914) are available! 

While “security” is a very broad topic, let’s be more specific here - AppSec (Application Security) focuses on developing secure applications. Information/IT security is a separate topic, as [Dinis Cruz shows in his presentation](http://2016.appsec.eu/wp-content/uploads/2016/07/AppSecEU2016-Dinis-Cruz-Using-Jira-To-Manage-Risks.pdf):

![Appsec vs Infosec]({{ "/assets/img/posts/2016/appsec-vs-infosec.png"|prepend:site.baseurl }})

This post is the subjective summary of takeaways from the AppSecEU 2016 event on how to ensure the secure application development in the company.

The security in general stands on three pillars: people, process and technology. The effective organization must fulfill all these areas in order to ensure the security:

 * People must be aware of the potential threats and risks and have sufficient knowledge to avoid vulnerabilities
 * Process makes activities consistent and company predictable in general
 * Technology eases the security assurance with tools and frameworks, but it cannot work as the standalone security measure, not involving people and processes

According Tobias Gondrom suggestion, the web and application security can be implemented in the company using these steps:

![Appsec agenda]({{ "/assets/img/posts/2016/appsec-agenda.png"|prepend:site.baseurl }})

### Benchmarking/maturity

Benchmarking the current situation in the company should be the prime step. There are various Maturity Models that can be used - [OpenSAMM](https://www.owasp.org/index.php/OWASP_SAMM_Project), [BSIMM](https://www.cigital.com/services/software-security-strategy/bsimm-assessment/), [CMM](https://en.wikipedia.org/wiki/Capability_Maturity_Model)... OpenSAMM is the easiest one for the company to start, while BSIMM has more security controls than OpenSAMM and CMM is the most comprehensive one, at the same time the most complex to implement.

While measuring the security situation is an essential step, it is worth to mention that in larger organizations situation is different per-department or per-team, therefore it might be necessary to have multiple benchmarks to see the whole picture.

Also, it is important not just to answer "yes" or "no" (lightweight assessment), but to know "how" each control is applied in the company (detailed assessment).

In addition to measuring maturity, the awareness needs to be raised in order to continue with further activities. Tobias suggests to use OWASP TOP10 project raise the awareness).
Also I suggest to include [OWASP CISO survey](https://www.owasp.org/index.php/OWASP_CISO_Survey) data and [IBM cost of data breach](http://www.ibm.com/security/infographics/data-breach/) to the awareness for the business stakeholders, also state that 75% of vulnerabilities exist at application level (Gartner report).

It is important to agree that business line owns and manages the risks while security people show and create awareness around them, as well as assist in reducing them.
However, business stakeholders must be managed closely in the following steps: risk management, security strategy and organizational design.

### Risk management

As mentioned before, the owner of the risk is the business owner. The same applies to the assets/data. The ones that cry most if the asset is shut down, should be the owner. Not security or IT guys.

Many companies do [threat modeling](https://www.owasp.org/index.php/Application_Threat_Modeling) to define threats at high business level, then rate them, and based on the results define security requirements, also considering compliance topic.

Methods that can be used for risk management are [OWASP risk rating methodology](https://www.owasp.org/index.php/OWASP_Risk_Rating_Methodology), ISO-27005, [FAIR](https://en.wikipedia.org/wiki/Factor_analysis_of_information_risk) etc.

[STRIDE](https://en.wikipedia.org/wiki/STRIDE_(security)) can be used to identify threats and [DREAD](https://en.wikipedia.org/wiki/DREAD_(risk_assessment_model)) can be used for risk rating.

While thread modeling is beneficial, it is difficult to show the evidence or metric to prove it. Also, there are companies that do not do threat modeling and still are successful. Design and code reviews might replace threat modeling for very professional teams.

However, threat modeling helps developers understand each other. It can also help to cover privacy and data flow compliance requirements.

Conducting threat modeling activity requires experienced facilitator. As this activity is boring in general, gamification using Microsoft "Elevation of Privilege" or [OWASP Cornucopia](https://www.owasp.org/index.php/OWASP_Cornucopia) might help.

When managing risks it's important to understand what and how much is enough. Sometimes it might become too expensive to reduce risks that the [ALE (Annual Loss Expectancy)](https://en.wikipedia.org/wiki/Annualized_loss_expectancy) is.

However, although it might seem that risks can be evaluated using quantitative metrics, in most cases such data just does not exist. Therefore using qualitative data and risk heatmaps is the better way to rate the risks.

If the risk is accepted, the risk owner (business owner) should explicitly acknowledge it. Either by signing something, or at least by clicking on a button "I accept this risk". This was stated in multiple presentations of the conference.

ROSI (return of security investment) can be a good way to communicate with CFO. However, as ALE is a part of ROSI, and it's difficult to predict, such calculations are somewhat artificial as well...

### Security strategy

Security strategy must cover the following topics:

 * Stakeholders: Who are your key stakeholders and potential threat agents?
 * Assets: What are your information assets and how do they (and their protection) generate value for your clients inside and outside the organization?
 * Capabilities: What are the essential security and protection capabilities that the organization and its stakeholders need to deliver that value proposition?

With business and corporate strategy, IT strategy, compliance and legal rules, analysis of risks and threats and current maturity as input elements the security strategy output is:

 * General guiding principles and priorities
 * Risk Management and risk acceptance levels
 * Security roadmap
 * Security architecture and Processes
 * Continuity of Business Plan and Incident Response

It is mandatory to know the business strategy and align security strategy with it.

According to OWASP CISO Survey 2013, most security actions are planned for 1 (37%) or 2 (27,8%) years period. It can be beneficial to plan investments more than 1 year in advance, mostly due to annual budget assignments.

### Organizational design

In order to reduce the gap between the developers and security office alongside central function, there must be the presence of security experts in every team. This was mentioned in almost every process-related presentation of the conference, as well as in the workshop by Tobias Gondrom. These guys are mostly called "security champions", and managing this community, empowering, evaluating and awarding its members is a very important activity of security office.

### SDLC

Although (very weird) not many CISOs (according OWASP CISO Survey 2013) think of S-SDLC as their responsibility, it mainly covers the secure process part of the application development.

![S-SDLC]({{ "/assets/img/posts/2016/sdlc.png"|prepend:site.baseurl }})

S-SDLC should not be implemented literally according the papers - it should be risk-driven according the specifics of the company.
The roll-out should be phased and there should be sufficient measures to track the progress.

There are several great secure development lifecycle implementations. Lessons learned by Tobias Gondrom:

 * Microsoft SDL: Heavyweight, good for large ISVs
 * Adobe: similarities to MS, great idea with the training program
 * Touchpoints: High-level, not enough details to execute against
 * CLASP: Large collection of activities, but no priority ordering
 * ALL: Good for experts to use as a guide, but hard for non-security folks to use off the shelf

### Training

OWASP has great materials that can be used for training people:

 * [TOP 10](https://www.owasp.org/index.php/Category:OWASP_Top_Ten_Project)
 * [Secure Coding Practices](https://www.owasp.org/index.php/OWASP_Secure_Coding_Practices_-_Quick_Reference_Guide)
 * [Cheatsheets](https://www.owasp.org/index.php/Cheat_Sheets)
 * [Webgoat](https://www.owasp.org/index.php/Category:OWASP_WebGoat_Project)
 * [etc](https://www.owasp.org/index.php/Category:OWASP_Project).

Since development guides can be too excessive for all developers, it can be the resource for security champions, while OWASP TOP-10 overview and protection measures can be enough for the rest.


### Bottom line

Running an application security program requires sufficient knowledge and preparation, including creating awareness and gaining support from upper management. Alignment with business strategy is an essential step, as security in general helps protecting the business assets.

Below here's the list of OWASP project that can be helpful in this journey. Good luck!

 * [Cheatsheets](https://www.owasp.org/index.php/Cheat_Sheets)
 * [TOP 10](https://www.owasp.org/index.php/Category:OWASP_Top_Ten_Project)
 * [ASVS](https://www.owasp.org/index.php/Category:OWASP_Application_Security_Verification_Standard_Project)
 * [Development guide](https://www.owasp.org/index.php/Category:OWASP_Guide_Project)
 * [Secure Coding Practices](https://www.owasp.org/index.php/OWASP_Secure_Coding_Practices_-_Quick_Reference_Guide)
 * [Testing Guide](https://www.owasp.org/index.php/OWASP_Testing_Project)
 * [Code Review Guide](https://www.owasp.org/index.php/Category:OWASP_Code_Review_Project)
 * [OWASP CISO Survey](https://www.owasp.org/index.php/OWASP_CISO_Survey)
 * [OpenSAMM](https://www.owasp.org/index.php/OWASP_SAMM_Project)
 * [Application Security Guide For CISOs](https://www.owasp.org/index.php/Application_Security_Guide_For_CISOs)
 * [Security Ninjas AppSec Training Program](https://www.owasp.org/index.php/Category:OWASP_Security_Ninjas_AppSec_Training_Program)