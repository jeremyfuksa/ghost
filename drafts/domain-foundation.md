# Domain Foundation

## The weekend between Christmas and New Year's

I'd spent the three months before Christmas throwing things at the wall. A year of research at Oracle had ended with the layoff, and I had a pile of observations — the validation stack, the role inversion, the averaging problem — that didn't yet cohere into a thing I could hand to someone. I kept trying to structure it and kept getting something that sounded like a recap of my last job.

Winter break. Nothing to do. My first real week off in years. The shape arrived on its own, over a few days of not trying — the four layers, the ownership rule, the downstream applications that weren't mine to own. By New Year's I had the methodology written down for the first time as something portable. Not a project I had done. A methodology that had come out of the project and could travel to any high-stakes domain that needed it.

That's the Domain Foundation. The research year [was its own thing](/work/research-year/). This is what I built from it.

## The structural move

The core of the methodology is simple enough to state in a sentence: **encode institutional knowledge as layers, each owned by the role that produces it, and let the model compose from all of them at generation time.**

Four layers is what worked inside the design organization I came from. A base layer of universal design principles, owned by the design system team. A domain layer of industry-specific reasoning, owned by domain experts. A component layer of per-artifact intent metadata — when to use, when not to — owned by component authors. A role layer describing user types and their constraints, owned by researchers.

The ownership matters more than the count. A different org's shape might want five layers, or three. The load-bearing claim is that governance distributes: the people who produce the knowledge also own the layer that encodes it, and no single team becomes the bottleneck.

This is the design group's portion of the context problem. Other institutional knowledge — customer feedback, regulatory correspondence, the pile of decisions made in hallways and never written down — lives in other systems and needs its own ingestion story. The four-layer architecture is what I know how to build because it's what my team owned. The larger context problem extends past it.

The technical shape — vector database, MCP server, LLM — isn't the interesting part. What goes into the database is. Institutional knowledge, not documentation.

## Downstream applications

The encoded corpus is retrievable, which means it can feed more than one pipeline. The obvious next stop is generation — governed Figma or code output that reflects the organization's specific intent. Two others come up in every conversation I have about this work.

The same corpus that generates can also validate. Given a proposed design, does it satisfy the constraints the role layer names for this user type, in this deployment context? That's a check a model can run if the knowledge is reachable.

Evaluation harnesses are the third. Design teams accumulate a pile of historical decisions — patterns adopted, patterns rejected, and the reasoning for both. A retrievable version of that pile is a benchmark for new proposals.

None of those pipelines are mine to own. They're where the corpus can go once it exists. The methodology's job is to make sure the corpus exists in a form those pipelines can actually use.

## The shadow practice

Through 2024, before the layoff, I'd been building my own practice around AI collaboration — separate from the research, separate from any vendor pipeline. Not generating Figma frames. Asking a language model to pressure-test my thinking. Edge cases, interaction logic, the things I hadn't caught on my own. The artifact was always mine. The thoroughness behind it was multi-authored.

That practice carried over. It's now codified as a corpus of skills the methodology runs on my own work through — the [skill ecosystem](/work/skill-ecosystem/) is the demonstration. Domain Foundation isn't a theory I wrote down after leaving Oracle. It's the structure of a thing I'd already been running on myself for most of a year before the research caught up to name it.

## The gap the methodology exists to close

My old team killed a feature for privacy reasons. The AI didn't catch it. A designer did. The [full story](/work/redwood-health-design/) is its own case study; the part that matters here is what the AI missed. It could reason at the surface — workflow, provider needs, clinical framing. It couldn't carry the deployment context. Human expertise killed the feature, not the AI's.

Domain Foundation is a bet that the *why* can be captured in a form a model can use, so the judgment of experienced people doesn't walk out the door when they do.

Design teams whose expertise is encoded — literally, as a retrievable knowledge base tied to the generation pipeline — will do work that doesn't look like everyone else's. Design teams whose expertise lives only in people's heads will produce outputs a PM with a good prompt can already reproduce. That gap is going to decide which design organizations matter a few years from now.

## Where this sits

The methodology isn't a product. It's hard to demo. Half the value is in what an organization chooses to put in the knowledge base, and the choosing is the expertise — the structure is just the container.

The people I find myself talking to now are the ones who've arrived at the same realization: default models produce default output. If you want design that reflects real institutional insight, you have to put that insight somewhere the model can actually reach. Those conversations are where the work sits right now.
