---
title: Innersourcing
layout: post

---

## tl; dr;

InnerSourcing is adopting opensource principles in the enterprise: community, transparency, collaboration.
It requires a shift in company culture and processes to gain benefits of InnerSource: increased software reuse, improved quality, open innovation, accelerated development, improved mobility.

Platform and commonly used products (libraries, modules, documentation etc.) can gain most benefit of InnerSource.

Its usage can be fostered by introducing pilot products. I suggest to start from documentation, as it is easy to contribute to and does not result in risk of losing quality.

However, the shift of the culture is also needed (both development and management) to support these principles, as well as focus on products more instead of teams. Community leader(s) and evangelist(s) are needed to help this change to happen.

## Intro

Open source is not just about licensing or free price, it's also about workflows, how to develop software collaboratively. [Sytse Sijbrandij @ GitLab](https://about.gitlab.com/2014/09/05/innersourcing-using-the-open-source-workflow-to-improve-collaboration-within-an-organization/) states OpenSource practices for enterprise:

1. Visibility: all software projects are by default visible to all employees.
1. Forking: everyone who can see the code, can create a copy (fork) where they can make changes freely; these forks are visible for everyone.
1. Pull/merge requests: even people outside the project are able to suggest changes and you can have a conversation about the code with line comments.
1. Testing: software includes unit- and integration-tests so that changes can be made with less fear of causing problems.
1. Continuous Integration: every proposed change is automatically tested and the result is shown with the change.
1. Documentation: all software projects include a readme that describes what the software does, why that is important, how run it and how to develop it.
1. Issue tracker: there is a public issue tracker in which everyone can submit a bug or ask a question.

While for oldskool companies this might seem weird, I think that any company valuing Agile principles more or less is familiar with them.

The most wonderful thing about open source is that these principles can be used not only in developing software, but also writing documentation ([Azure articles](https://azure.microsoft.com/en-us/documentation/), [about.gitlab.com](http://about.gitlab.com/), [RaspberryPi](https://github.com/raspberrypi/documentation)), commonly creating websites. People even collaboratively write books, [develop hardware](https://en.wikipedia.org/wiki/Open-source_hardware) and even [cars](https://en.wikipedia.org/wiki/Open-source_car).

However even in open communities adopting open source principles in [not always a common sense](https://github.com/vilniusphp/vilniusphp-meetups/pull/1).

## What's that InnerSource?

Originally stated by [Tim O'reilly back in 2000](http://archive.oreilly.com/pub/a/oreilly/ask_tim/2000/opengl_1200.html) - it's basically adopting open source principles in the enterprise.

"InnerSource takes the lessons learned from developing open source software and applies them to the way companies develop software internally." - is written in PayPal's [InnerSource commons](https://paypal.github.io/InnerSourceCommons/).

Bas Peters from GitHub had a great talk on InnerSourcing at HighLoadStrategy 2016 conference. Some of my takeaways from his talk:

* Share your work. Single place to collaborate. Ability to contribute. Discoverable code
* Share documentation. Include documentation alongside project. Collaboratively write public documentation
* Share ideas and report bugs. Contribute by providing ideas
* Collaboration via pull requests
* Automate a lot. Test automatically. Ensure quality automatically
* Utilize other tools, i.e. Slack, Hubot
* Dev+Ops is key to success
* Share experiences, pizzas, hackathons, conferences, blogs etc.
* Participate in OpenSource
* Community leader is essential

## How to innersource in the company?

Although it is quite clear what InnerSourcing is, there is very little information how to start it in the company.

[Klaas-Jan Stol and Brian Fitzgerald](https://www.infoq.com/articles/inner-source-open-source-development-practices) define nine factors that influence the adoption of InnerSource in the enterprise:

![Innersource factors]({{ '/assets/img/posts/2016/innersource.jpg' | prepend:site.baseurl }})

[Panna Pavangadkar of Bloomberg, Global Head of Engineering Development Experience](https://text.sourcegraph.com/github-universe-liveblog-innersource-and-reaping-the-benefits-of-open-source-behind-your-firewall-2af906c3e0ae#.8nmrntlcn) states three pillars to making inner source successful:

* getting community excited, creating buzz within your organization
* making it possible to contribute to features you’re not directly responsible for but see an opportunity to add value.
* getting management buy-in on why this is important and getting the encouragement to push the boundaries

My takeaways from these information sources:

* To foster InnerSource engineering culture we need seed products. I see that platform or commonly used projects can benefit most from InnerSource. "If only one team or business unit has a stake in a project, inner source will provide no real benefit because the project won’t leverage the “wisdom of the crowd.”
* You can start even not with the code, but i.e. with documentation, as it is done in [MS Azure documentation](https://azure.microsoft.com/en-us/documentation/).
* InnerSourcing requires cultural shift. OpenSource should be the part of the company DNA, therefore community leaders and evangelists are needed to help with InnerSourcing.
* InnerSourcing (contribution to other product) must be treated as the normal development practice. There must be a common understanding and agreement that InnerSourcing generates unplanned work effort. If the teams try to put EVERY development task to the (sprint) backlog, there will be a conflicting situation, which is likely to lead to the failure of InnerSourcing.
* The team's output should be explicitly defined fine grained products instead of the monolithic result. I.e.: have products as separate repositories, separate Wiki spaces, separate monitoring screens, have product-centric chat channels instead of team-centric etc.

## What are the concerns of InnerSourcing?

According to the recent [interview](https://text.sourcegraph.com/github-universe-liveblog-innersource-and-reaping-the-benefits-of-open-source-behind-your-firewall-2af906c3e0ae#.8nmrntlcn), security is one of the biggest concerns within InnerSourcing.

The cultural shift, knowledge concentration and firewalls are also mentioned as challenges.

## What is the right tool to leverage InnerSourcing?

As InnerSource is about culture, collaboration of the developers community, it says nothing about the tools. Therefore we should focus on processes first, and then choose the most proper tool.

PayPal had a positive experience with GitHub, as described by [Andy Oram in his book](http://www.oreilly.com/programming/free/getting-started-with-innersource.csp), but all this benefit can be achieved with other competitive tools, for example, GitLab or Atlassian product suite.

## References

[https://www.infoq.com/articles/inner-source-open-source-development-practices](https://www.infoq.com/articles/inner-source-open-source-development-practices)

[https://about.gitlab.com/2014/09/05/innersourcing-using-the-open-source-workflow-to-improve-collaboration-within-an-organization/](https://about.gitlab.com/2014/09/05/innersourcing-using-the-open-source-workflow-to-improve-collaboration-within-an-organization/)

[https://paypal.github.io/InnerSourceCommons/](https://paypal.github.io/InnerSourceCommons/)

[http://www.oreilly.com/programming/free/getting-started-with-innersource.csp](http://www.oreilly.com/programming/free/getting-started-with-innersource.csp)

[https://text.sourcegraph.com/github-universe-liveblog-innersource-and-reaping-the-benefits-of-open-source-behind-your-firewall-
2af906c3e0ae#.8nmrntlcn](https://text.sourcegraph.com/github-universe-liveblog-innersource-and-reaping-the-benefits-of-open-source-behind-your-firewall-2af906c3e0ae#.8nmrntlcn)

[https://vimeo.com/191475439](https://vimeo.com/191475439)