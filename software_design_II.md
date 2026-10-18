1. Domain Driven Design

   1. Strategic DDD: Subdomains i contexts
   2. Event Storming: Discovering the domain
   3. Tactic DDD: Entities and aggregates, value objects, domain events, domain services, repositories, factories...
   4. DDD and Agile
   5. How to apply DDD in legacy systems?
   6. DDD, bounded contexts and microservices
   
2. Arquitectura hexagonal: Puertos y adaptadores 
   A good way to implement DDD.
3. CQRS
4. Event sourcing
5. Change data capture
6Consistencia eventual
-----------------------

## 1. Domain Driven Design

DDD is a software design approach guided by the business domain. So the first and more important step in our design is to understand the business domain and its rules.

In DDD:
```
Business concepts & rules
        ↓
Domain model
        ↓
Application/use cases
        ↓
Infrastructure
```

As an alternative, data driven approach,: 

``` 
Database → ORM → Services → Controllers
```

In the alternative approach, we design our system based on the data model. Typically, we start with an Entity Relationship Diagram (ERD) and one could argue that this is also a model of the business domain, but is not exactly the same.
ERD and DDD model, both models the business domains but the ERD it's build from storage perspective, while the DDD model is optimized for the business domain which includes behavior and rules.
Both models have entities but the DDD model has more behavior and rules, while the ERD is more focused on data and relationships.

### Strategic DDD: Subdomains and contexts


#### Subdomains
Our goal in this stage is to identify the boundaries of the business before we try to model it.
Of course this happens in the problem space, not in the solution space. So a good questions in this stage is:

```
What different business problems that the company is solving?
What are the distinct problems this business has, and which of those problems are strategically important?
```

Each of those problems is a subdomain containing different concepts, rules, terminology and goals.

For example, "content" means something different to:

    - The content adquisition team, which is focused on acquiring content from studios and producers.
    - The content recommendation team, which is focused on recommending content to users based on their preferences
    - The content delivery team, which is focused on delivering content to users in a reliable and efficient way.

Once we've identified the subdomains, we can classify them based on their importance to the business. 

We can classify them in three categories:

- Core domain: The most important part of the business domain, where the business differentiates itself from its competitors. This is where we want to invest more time and effort to get a better model.
- Supporting subdomain: A part of the business domain that is not core but is still important for the business. We want to have a good model, but we don't want to invest too much time and effort in it.
- Generic subdomain: A part of the business domain that is not core and is not important for the business. We don't want to invest time and effort in it, we can use off-the-shelf solutions.

Netflix example: 
        Core domain: Video streaming, Content discovery and personalization. Major competitive differentiator
        Supporting subdomain: User subscription management. Business-specific but relatively standard. Not a competitive advantage.
        Generic subdomain: Payment processing, HR payroll. Commodity capability

This classification tell us where to invest our time and effort in modeling the business domain. 
We want to invest more time and effort in the core domain, less in the supporting subdomain and none in the generic subdomain.

We can already see that we don't want one model for everything. A Movie will have different attributes and behavior in the different subdomains. 
Different subdomains are different business perspectives so they may have different models.


Subdomains give you a map where complexity and business value lives.

To successfully implement strategic DDD, we need the help of domain experts, people that know the business domain and can help us understand it. 


Who are this domain experts in a company? 
    - Product managers: They know about business goals, priorities and customer needs.
    - Business analysts: They know about business processes, rules and requirements.
    - Stakeholders: They know about business strategy, vision and goals.
    - ...

Developers and domain experts should work together to build a shared understanding of the business domain. 
This is called "ubiquitous language", a common language that is used by both developers and domain experts to describe the business domain.

Next to the subdomains identification, we will discover language/model boundaries, which will drive us to define bounded contexts.

#### Bounded contexts


Models:

Let's say we have a certain reality and some purpose, some goal in mind that involves that reality.
As interacting with that piece of reality might be too complex, inconvenient or simply impossible,
we build a model. The model is a kind of metaphor, an alternative representation of the reality that
it behaves like or resembles the reality sufficiently for our purposes.

Examples:

 **A kid's toy**:
 - Reality: a car
 - Purpose: as a kid we like cars and we want to play with them
 - Problem: a car is very inconvenient for a kid to play with (too big, dangerous, expensive, etc...)
 - Model: We build a small model of a car that keep some of its behavior (wheels turning, door opening, ...) 
          and its appearance even if it is in a smaller scale.
   
   The kid can play with the model so the model serves it's purpose. The more the model resembles a real car
   the more joy the kid will have. However, the toy car doesn't need to have a working engine that burns gas, 
   this is not needed for our purpose.
 
 **Software of a Model of Business Domain**

 - Reality: An old legacy bank (pre IT).
 - Purpose: We want to enalbe the customers of the bank to deposit money, withdraw money, and transfer money between accounts reliably and automatically at scale.
 - Problem: Managing these operations directly through manual processes is slow, error-prone, and difficult to scale.
 - Model: We build software that represents bank accounts, balances, deposits, withdrawals, and transfers.  
          It implements the business rules that govern these operations, such as preventing a withdrawal that exceeds the available balance.      

   The bank can be operated through the software. The more accurately the model represents the 
   relevant business concepts, rules, and behaviors, the more reliably the software can support the bank's business goals.
   However, the model does not need to reproduce the entire banking reality. For example, it does not need to represent the physical appearance of 
   banknotes or every conversation between a customer and a bank employee. Those aspects are irrelevant to its particular purpose. 

Important. In DDD the model is the set of selected abstractions, concepts, rules and behaviors we use to describe the reality for a particular purpose.
The software is a materialization of the model. A model could have multiple software implementations in different programming languages and
technologies following different paradigms, all honoring the same model.


A bounded context is a boundary around a model that defines the meaning of the terms used in that model.
A Movie inside a given bounded context will have the same meaning and behavior, and the same business rules will apply to it.

It can look that a subdomain corresponds to a bounded context but this is not always the case.

- One subdomain can have multiple bounded contexts, each one with its own model and language.

For example, the Ordering subdomain can have two bounded contexts: 
    - Order Management: Track customer order and triggering fulfillment. 
      Capturing, validating, checking inventory, customer communications, handling returns...
    - Order Fulfillment: Physical work in the warehouse: receiving, processing, packing, shipping...

- One bounded context can have multiple subdomains.
Example: An online learning platform that has the following subdomains:
- Learning Progression: Track student progress through courses and modules.
- Assessments: Tracks student assessments for modules and courses.
- Enrollment: 
- Billing:

The question is whether the concepts from those subdomains can participate in one coherent model with one consistent language

Learning progression says: "The student has completed modules 1, 2 and 3."
Assessment says: "The student has passed the assessment for module 3."
If the concepts StudentProgress, Assessment, Completion, etc. all make sense together and the rules naturally cross those boundaries, one context can be appropriate.


A good example to differentiate subdomains from bounded contexts. This time in a bank. The bank has the following subdomains of the domain of Banking:
- Cash accounts: Deposit (credit), Withdrawal(debit) 
- Credit cards: Payment, Charge
In the bank organization we have a department for each subdomain.  
We identify one bounded context for each subdomain. The concepts of "Deposit" and "Payment" are different and have different rules, so they should be in different bounded contexts.
We are happy because each business subdomain has one bounded context. 
The organization is structured based on how the domain brakes down, and we organize software around that. That's an ideal situation.

But then concepts changes in the business. Somebody says: "We have to align with market segments not with types of accounts"
The organization is restructured. We will have a department for Business Accounts and another for Personal Accounts, and these are our subdomains.
The bounded context remains the same. The software remains the same. 
Now we have two teams and each one needs CashAccounts and CreditCards. 
Stewardship can become unclear because both teams might want to evolve each bounded context so it requires some coordination to do it well.

When each department has his own bounded context, the stewardship is obvious. Cash Accounts department is stewards the CashAccount model.

But now, we are in a situation where we can end up in a Big Ball of Mud if we don't have a clear stewardship of the bounded contexts.

Stewardship of a system means taking ongoing responsibility for the health, evolution, and long-term value of a system, rather than merely being responsible for implementing individual features.
For a Core Domain, stewardship implies making sure the system continues to represent and support the company's competitive advantage.]
For example, if you say:

"The Learning Bounded Context needs a steward."

you're saying someone needs to be responsible for things like:

- maintaining the integrity of the model
- understanding its business purpose
- evolving the ubiquitous language
- deciding how the context should change
- preventing accidental coupling with other contexts
- ensuring the software continues to reflect the domain
- coordinating with domain experts and other contexts

What would have happened if we had started with the new business alignment around market segments and then tried to identify the subdomains and bounded contexts?
Start with the business capabilities, not the departments.

```
                    BANK
                      │
          ┌───────────┴───────────┐
          │                       │
       Personal                Business
          │                       │
     ┌────┴────┐             ┌────┴────┐
     │         │             │         │
   Cash      Credit        Cash      Credit
 Accounts    Cards       Accounts    Cards
```

So we should have concluded that the business subdomains are CashAccounts and CreditCards (same bounded contexts).

The organization structure could have been to create a department for Personal/Business accounts by country, and this doesn't change our business subdomains and bounded context.
Unless we have very different rules and concepts for CashAccounts by country...

Personal and Business are dimensions cutting across the subdomains, but they are not subdomains themselves.


**How to solve the stewardship problem?** That's an organizational problem
We can add a team to steward each bounded context and Personal/Business teams will be they customers.

```
Cash Account BC
       ↑
Cash Accounts Team
       │
       ├── Personal Banking
       └── Business Banking

Credit Card BC
       ↑
Credit Cards Team
       │
       ├── Personal Banking
       └── Business Banking
```
Although this is an organizational problem, not a software problem, we have to keep it in mind because it affects the stewardship of the bounded contexts.

The reorganization is new information about the business.
Does this new Personal/Business distinction reveal genuinely different business rules?
What is Personal CashAccounts and Business CashAccounts have different rules? If yes, then we have to create two bounded contexts for CashAccounts, one for Personal and another for Business.



**There is a key distinction between organization structure (departments), subdomains (business capabilities) and bounded contexts (models and language).**


- Departments correspond to organization structure
- Subdomains correspond to business capabilities
- Bounded contexts correspond to (often hidden) foundations that give structure and concrete meaning to business activities. 
  It describes how a part of a business activity is understood and modeled: its terminology, rules, concepts, and boundaries.

Strategical DDD provides techniques for discovering and defining bounded contexts.

#### Context mappings

Ways that different bounded context communicates between each other which also represents the team relation between the two involved teams.

Context Mappings grouped by dimension:

- Upstream - Downstream relation:
  - Customer-Supplier Collaboration: The Customer requests its needs in terms of model to the Supplier, they plan expectations together
                       but in the end is the Supplier who will determine what and when the Customer will get.
                       The Supplier may expose a view of its model to satisfy the needs of its Customer.
                       If the Supplier exposes its internal model directly we will end up in the Conformist relationship. 
  - Conformist: The Customer cannot request its needs to the Supplier so it has no other option that adapting its model to 
                the Supplier's model. If Supplier model changes, the Customer will have to adapt whether it likes it or not.
                i.e: Amazon's affiliate sellers has to adapt its business model to Amazon's.
  - ACL (Anti Corruption Layer): The Downstream (Consumer) translate the Upstream (Supplier) language to its own language
                                 via a translation. It has a not negligible maintenance cost. Unavoidable when integrating with a Big Ball of Mud.
  
- How a context expose its model:
  - OHS: Open Host Service. i.e: Http API, publishing events in a Kafka topic
  - PL: Published Language. i.e: Open Api Specification, Protobuf schema, Avro
    
    Usually OHS and PL goes together.  

- Sharing part of the model
  - Shared Kernel: Two bounded context share a small part of their domain and jointly maintain it.
    ex: In a bank Payments and Accounts bounded context shares entities like Money, Currency...


This dimensions can be combined. i.e: Two bounded context can have OHS + PL + Conformist

#### Big ball of Mud
No clear boundaries are set so we end up with inconsistent definitions of concepts and rules, and the system becomes difficult to maintain and evolve. 
Often they are risky to change, have incomplete test coverage, etc..

### Event Storming: Discovering the domain

Event Storming is a collaborative workshop technique used in Domain-Driven Design (DDD) to discover 
and model a business domain by starting from domain events— things that happened in the business.

It was introduced by Alberto Brandolini.

The basic idea

Instead of starting with classes, database tables, or services, you ask:

“What happens in this business process?”

For example, imagine a food-delivery domain:
``` 
OrderPlaced
    ↓
PaymentAuthorized
    ↓
RestaurantAcceptedOrder
    ↓
CourierAssigned
    ↓
FoodPickedUp
    ↓
OrderDelivered
```

Each of these typically represent a Domain Event.

The important characteristic is that events are expressed in past tense:

•OrderPlaced
•PaymentAuthorized
•RestaurantAcceptedOrder
•CourierAssigned

rather than:

•PlaceOrder
•AuthorizePayment
•AssignCourier

The latter are commands—things someone wants to happen.


Event Storming usually evolves into something like this

                COMMAND
                   │
                   ▼
             ┌───────────┐
             │ PlaceOrder│
             └─────┬─────┘
                   │
                   ▼
              OrderPlaced
                   │
                   ▼
             ┌───────────┐
             │Authorize  │
             │Payment    │
             └─────┬─────┘
                   │
                   ▼
          PaymentAuthorized
                   │
                   ▼
          ┌────────────────┐
          │Restaurant      │
          │Accepts Order   │
          └───────┬────────┘
                  │
                  ▼
       RestaurantAcceptedOrder

You then identify other important concepts around these events:

Actor:	Customer
Command:	PlaceOrder
Domain Event:	OrderPlaced
Aggregate:	Order with various items and information about the customer and restaurant
Policy/Business rule:	“When payment is authorized, notify restaurant”
Read Model:	Order status
External System:	Payment provider

The important part is the collaborative exploration of the domain, starting from domain events to end up
discovering other concepts like actors, commands, aggregates, business rules.


Why start with events?

Because events describe business facts.

Compare:

Order
├── status
├── customerId
├── restaurantId
└── items

with:

CustomerPlacedOrder
PaymentWasAuthorized
RestaurantAcceptedOrder
RestaurantStartedPreparingFood
CourierPickedUpOrder
OrderWasDelivered

The second representation tells you much more about how the business actually works.

It can reveal:

• Business processes
• Terminology
• Business rules
• Dependencies
• Responsibilities
• Exceptions
• Different actors
• Important state transitions
• Integration points

And, importantly for DDD, it can expose boundaries.


Event Storming and Bounded Contexts

This is where Event Storming becomes particularly useful for DDD.

Suppose you have:

```
OrderPlaced
    ↓
PaymentAuthorized
    ↓
RestaurantAcceptedOrder
    ↓
CourierAssigned
    ↓
FoodPickedUp
    ↓
OrderDelivered
```

As you discuss the events, you may discover different business areas:

```
       Ordering
          │
          ▼
       Payment
          │
          ▼
     Restaurant
          │
          ▼
      Logistics
```
Those areas may eventually suggest bounded contexts.

For example:
```
┌──────────────────┐
│ Ordering Context │
│                  │
│ Order            │
│ OrderPlaced      │
└────────┬─────────┘
         │
         │ event
         ▼
┌──────────────────┐
│ Payment Context  │
│                  │
│ Payment          │
│ PaymentAuthorized│
└────────┬─────────┘
         │
         ▼
┌─────────────────────┐
│ Logistics Context   │
│                     │
│ Delivery            │
│ CourierAssigned     │
└─────────────────────┘
```
The boundaries aren’t automatically determined by the event storming session. Rather, 
the conversations and language differences discovered during the session provide evidence for where boundaries might belong.


Two common forms

1.Big Picture Event Storming

Used to understand a large business domain.

You might start with:

```
Customer
   ↓
OrderPlaced
   ↓
PaymentAuthorized
   ↓
RestaurantAccepted
   ↓
  ...
```

Then explore:

• Who does what? (Actors)
• Why does this happen?(Commands)
• What can go wrong? (Exceptions)
• Which teams care about this? (Organizational boundaries)
• Where does terminology change? (Bounded context)
• Which systems are involved? (Integration points/External systems)

This is useful for discovering domains, subdomains and potential bounded contexts.

2. Process-Level Event Storming

Much more detailed.

For example:
```
Customer
   │
   │ PlaceOrder
   ▼
OrderPlaced
   │
   │
   ├──► PaymentRequested
   │         │
   │         ▼
   │   PaymentAuthorized
   │
   └──► RestaurantNotified
             │
             ▼
       RestaurantAccepted

```

Here you’re investigating a particular business process and its rules.


One important DDD distinction

Don’t think:

Event Storming = drawing an event-driven architecture.

That’s a common misunderstanding. The discovered domain events are not necessarily meant to be published to a message bus or event stream. 
They are simply a way to understand the business domain.

You don’t need Kafka, event sourcing, microservices, or even asynchronous communication.
We are working in the problem space, not the solution space. We are discovering the business domain, not designing a software architecture.


A domain event such as:

OrderPlaced

simply means:

The business recognizes that an order has been placed.

It could be implemented internally as a method call, a message, a database transaction, Kafka event, etc.

Event Storming is primarily a domain discovery and modeling technique, not an architectural technology.



A useful mental model

Think of Event Storming as moving through these levels:

```
Business activity
       ↓
Domain events
       ↓
Commands + actors + policies
       ↓
Business rules / aggregates
       ↓
Boundaries
       ↓
Bounded contexts
       ↓
Potential architecture
```
The key idea is:

Don’t start by designing the software. Start by discovering how the business works.

That makes Event Storming particularly useful when you want to distinguish departments, subdomains 
and bounded contexts—because you can discover the boundaries from the business language and 
responsibilities rather than imposing your organizational structure onto the model.

Who participates in Event Storming sessions?
Domain experts, developers, architects, product managers, business analysts, and anyone else who
can contribute to understanding the business domain.


### DDD and Agile

One might think that DDD is incompatible with Agile because DDD emphasizes upfront modeling and Agile emphasizes iterative development.
That might be true for strategic DDD, but not for tactical DDD.
The trick is to treat the model as evolving knowledge, rather than a specification produced before implementation.
The model is not a blueprint, it is a representation of your current understanding of the business domain.
You can Event Storm a specific business capability, process, or feature. 
So event storming can become one activity of an Agile sprint, and the model can evolve as you learn more about the domain.  

```
                 PRODUCT BACKLOG
                       │
                       ↓
              Select valuable slice
                       │
                       ↓
                Event Storming
                       │
                       ↓
             Domain understanding
                       │
                       ↓
              Design / implement
                       │
                       ↓
                Working software
                       │
                       ↓
                  Demo / feedback
                       │
                       ↓
              New domain knowledge
                       │
                       └──────→ Backlog
```


Agile answers how to develop?
DDD answers how to discover and model the business domain


Strategic DDD is more like an upfront activity. You don't want to rediscover your entire strategic architecture every sprint
But even this should be treated as hypotheses, not immutable architecture.

### How to apply DDD in legacy systems?

What happens when the existing system's boundaries don't correspond to the business boundaries.
The key is to distinguish discovering the domain from redesigning the existing software.

Meet the Bubble Context technique:
The idea is to create a new, clean domain model inside a “bubble” around part of the legacy system, rather than trying to clean up the entire legacy model first.

```
┌─────────────────────────────────────┐
│          LEGACY SYSTEM              │
│                                     │
│  Customer  Order  Payment  Account  │
│       everything interconnected     │
│                                     │
└─────────────────────────────────────┘
```

Create a DDD bubble inside the legacy system, with a new model, new language, and new rules. 
It will communicate with the legacy system through a translation layer or an anti-corruption layer (ACL).
So we will have our new model completely isolated so it can evolve independently.   
```
        Legacy
┌──────────────────────────────┐
│                              │
│     ┌──────────────────┐     │
│     │   NEW DDD        │     │
│     │   "BUBBLE"       │     │
│     │                  │     │
│     │  New model       │     │
│     │  New language    │     │
│     │  New rules       │     │
│     └────────┬─────────┘     │
│              │               │
└──────────────┼───────────────┘
               │
        Translation / ACL
```

Eventually you can extract the bubble into a new service, or you can keep it as a module inside the legacy system.

Help yourself with some patterns to incrementally migrate from a legacy system to a new system:
Strangler Fig Pattern — gradually replace parts of a legacy system (do not rewrite the whole legacy at once).
Branch by Abstraction — introduce an abstraction and migrate implementations incrementally.

### DDD, bounded contexts and microservices

Sounds good but I can also have bounded contexts as modules inside a monolith, or as serverless functions.
Or some bounded contexts can be implemented as microservices and some others as modules inside a monolith.
And in the future I can extract them as microservices if I want to. 
This a change in the solution space, the software architecture, not in the problem space. 


## 5. CDC: Change Data Capture

Extract changes from a database and publish them as events so, as a user, you can react to them.

All databases work with a transaction log, which is the source of truth for the database. It's an append only data structure which records all inserts, updates and deletes done in the database.
From there the table files are materialized. So, hey! a database is already event sourced! 


The main purpose for the transaction log is Replication in a Leader-Replica setup, so we can also call it Replication Log.
Implementations of the transaction log (or Replication Log):

- **Statement Based Replication**: Every write statement (Insert, update and delete) is written in the log. Each follower or reader
  Executes that SQl statement it had been received from the client. While this sounds reasonable there are several ways in this approach that can break down:
   
   - Any statement that calls non-deterministic functions like NOW() or RAND() is likely to generate an different value when read to be replicated.
   - If statements has side effects like firing triggers, stored procedures or user defined functions, this side effects need to be absolutely deterministic.
  
  It's possible for the reader to substitute the nondeterministic functions by they final value so every reader sees the same value. 
  However, this is fragile and there are a lot of edge cases.
  
  MySQL before version 5.1 used this.

- WAL: Write Ahead Log
    
  The WAL is a data structure (SSTables, LSM-Tree, B-Tree) forming an append only sequence of bytes containing all writes of the database.
  WAL contains the bytes changed in disk blocks so it is a very low level structure.
  Although PostgresSQL and Oracle implement the replication like this, this makes the replication close to the storage engine.
  If we change the storage engine from version to version we can no longer preform a zero downtime rolling update of our running replicas.  
 
- Logical log (row based) replications

  A logical representation of changes allows the replication log to be decoupled of the storage engine.
  For a relational database the logical log looks like this:
    - For an inserted row the log contains the new values of all columns
    - For a deleted row it contains enough information to uniquely identify the deleted row. Usually the PK.
    - For an update, it contains the id of the row and the new values of all columns or at least the new values for the columns that changed.

  Logical log reduce the operational rollout problems mentioned and make it easier fot external applications to parse its information and it is used for Change Data Capture.

The problem is that the transaction log is not exposed to the user, so we have to use some mechanism to extract the changes from the database and publish them as events.

Transaction log has two reasons to exist:
- Recovery: If the database crashes, we can recover it by replaying the transaction log.
- Replication: If we have a replica of the database, we can keep it in sync. By streaming the contents of the transaction log to a node we can create a replica.

Change Data Capture is a mechanism to extract the changes from the transaction log and publish them as events in a message queue or kafka topic.
It's usually implemented by the database vendor, but there are also open source implementations like Debezium.

>Debezium is an open-source change data capture (CDC) platform that streams database changes into event systems in near real time

CDC vs Event Sourcing:

CDC says: "The database changed like this."

              PostgreSQL
              source of truth
                    │
                    ▼
                   WAL
                    │
                    ▼
                   CDC
                    │
             ┌──────┴──────┐
             ▼             ▼
           Kafka       Data Warehouse
             │
       ┌─────┼─────┐
       ▼     ▼     ▼
    Search  Cache  Other services

Event Sourcing says: "The business says this happened."

The crucial difference is that database changes are not necessarily the same as business events. 
For example, if a user updates their address in a web form, the database may record an update to the address field, but the business event is that the user has changed their address. The business event may trigger other actions, such as sending a confirmation email or updating related records.
A change in the database may correspond to a business event, but it may also be the result of a batch job, a data migration, or a correction of an error. Therefore, CDC captures all changes to the database, while event sourcing captures only the events that are relevant to the business domain.

To put a specific example, imagine we update a column in a row of a table:
- Propagate changes to a microservice, may be you want to propagate the full state of the row.
- Maybe we are find by propagating the changed column only plus the primary key of the row.

    ```json 
    {
      "id": 42,
      "changed": {
        "status": "PAID"
      }
    }
    ```
- Maybe we are interested in the previous state plus the new state of the row.
  Example:
    ```json
    {
      "before": {
        "id": 42,
        "status": "PENDING",
        "amount": 100
      },
      "after": {
        "id": 42,
        "status": "PAID",
        "amount": 100
      },
      "op": "u"
    }
    ```

You have to configure the database to capture the desired data in the transaction log plus the Debezium component.

>ALTER TABLE orders REPLICA IDENTITY FULL; tells PostgreSQL to log the entire row into the Write-Ahead Log (WAL) during UPDATE and DELETE operations for the orders table.

CDC software component (Debezium) acts as a replication client from the database point of view.

There's no standard interface for CDC, so tools like Debezium have to implement a connector for each database vendor.

Those implementation details are mentioned to illustrate that CDC is a after thought, a hack to extract events from a database that was not designed to be event sourced.
Some younger databases like YugaByteDB or CockroachDB are designed to be event sourced from the beginning, so they have a native CDC interface.
In the kafka ecosystem, Debezium is a de facto standard for CDC.

3 ways to use Debezium:
    - Kafka Connect: Debezium is a Kafka Connect source connector that streams changes from the database into Kafka topics.
    - Embedded Engine: Debezium can be embedded into a Java application and react to events from the database. Useful to publish events to a custom service. Ex: to build a connector from postgres to Apache Flink
    - Debezium Server: Debezium runs as a service and provides connectivity to other messaging systems like RabbitMQ, AWS Kinesis, Google Pub/Sub, etc.

Use cases for CDC:

An application receives an order creation request from a REST API. We store it in the database, but we also want to notify Shipment service and Payment Service.
If I do everything in my application, I want to make sure that the storage and the kafka message publication happens atomically, or both things happen or none of them does.
But kafka and the database doesn't share transaction boundaries so this might lead to inconsistency (typical dual write problem).
CDC lets you avoid this problem because now is the CDC software who has to track which transactions from the transaction log has been published to kafka and which not by maintaining some kind of pointer to the WAL.

An XA transaction is a distributed transaction implemented as a 2 Phase Commit.
As an alternative we can implement a 2PC but this worsens the availability of the system because now, to place an order we need both systems the database and kafka up. 
If one of them is down, we cannot place an order. 
With CDC, if kafka is down, we can still place the order because the kafka publication is deferred by this kind of queue that the WAL is. 
Kafka is not in the critical path.

Notice if we achieve availability by using CDC, we are sacrificing consistency because now the order is placed but the downstream services are not notified yet.
We are taped by the CAP theorem: in case of partition (ex: kafka is down) we can choose between availability and consistency. We choose availability.

Alternatively we could implement a SAGA pattern to achieve availability with eventual consistency. The SAGA pattern can be implemented with a choreography approach or an orchestration approach.
Each service part of the SAGA has to implement a command and an undo command. In fact: Event and UndoEvent.
- Orchestration: The orchestrator will be able to tell each service what to do and what to undo in case of failure.
- Choreography: Once the service receive the Event, it will react to it and publish an event (OK or Err) to notify the next service in the SAGA to proceed or to undo the previous command. The SAGA is implemented as a chain of events.

> Advice: Do not implement a SAGA pattern ort 2PC if you can avoid it.

What if the application receive a request to place an order and we simply publish it to kafka? Then we will have multiple consumers and one of them will write it to the database.
Which problems can you see in this architecture?
- If the consumer that writes to the database is down, we will lose the order.
- There is a lack of consistency if the order is shipped before it is stored in the database.
- If the user doesn't see the order in the screen because it is not written to the database, he might try to create the order again, which probably will end up in a bad experience.

We could avoid some of this problem by keeping the order created in memory and serve it to the user, but this comes with its own problems too.

It all depends on which guarantees you want to provide to the user and which properties do you want your system to have.
Answer questions like: It's ok to have a little bit of inconsistency? Is it critical to lose a couple events?
These are architectural decisions that you have to take based in the context of the project. If data is coming from a sensor in an agriculture field, sending this temperature of the soil every 5 minutes, if we loose a couple of events, probably is not a big deal. 
But if we are talking about a financial transaction, loosing an event is a big deal. Or even if the temperature sensor is in a rocket engine, and we are using this data to calculate the quantity of fuel to inject in the engine, loosing a couple events is a big deal too.



**Event Driven Architecture**
https://www.youtube.com/watch?v=STKCRSUsyP0

## 4. Event Driven Architecture

When people in software engineering talk about event-driven architecture, what they are talking about?
The response is not always the same, but in general they are talking about some of the following things:

### 1- Event Notification:
Emit an event as a mechanism to reverse the dependencies among two components.
Like a TextBox in a GUI that emits an event instead of the test box calling the code to execute which would make the textbox depend on the business logic.
So if the TextBox fires an event is the business logic that depends on knowing about the event, not the other way around.

 >Ex:
     We have two services in an insurance company: CustomerManagement and InsuranceQuoting
     The user interacts with CustomerManagement to change its address, but it turns out that we have to update its quotation based on that.
     If we make CM to call IQ endpoint, we have a nasty dependency. If we make CM to publish an event CustomerAddressUpdated
     that will be listened by IQ, then CM doesn't have to know about IQ, it's IQ who has to know about CM by knowing about its emitted event.

Events vs Commands (ex: CustomerAddressUpdated vs RecuoteQuotationForCustomer)
Determines the intention and the communication patterns. If you publish an event you are not interested in derived actions triggered by its publication. 
Events allows multiples consumer of the event to react to it without having to tell CM, so completely decoupled. 

But, there's no central place that tells you what happens when the customer change its address.
No statement of overall behavior. Decoupling but the flow is difficult to follow

### 2- Event-carried State Transfer

Following the previous example, in the insurance company,
Customer Management Service has a database of customers.
What to put in the event? from more generic to more specific
  - SomethingCanged: All subscribers will have to react asking what has changed
  - Something about Bob changed. All subscribers will have to ask what changed about Bob
  - Bob's address has changed. All subscribers will have to ask what is the new address

    So we see the publication of the event is creating extra traffic in our system, so if we want to reduce that
    I will put all the needed information in the event, so I don't have to go back to the producer.
 - Bob's address has changed and I include old and new address.
     But maybe the Insurance Quotation service needs to know extra info from the user when it calculates the new quotation and event consumers will have to ask CM every time it publishes an event. Can I eliminate this load?

**Event-carried State Transfer**
Event contains all the data that its downstream system will ever need. And the downstream systems will have to keep a copy of this data.
IQ will keep a copy of all data so it has all the data it needs not the entire CustomerDB owned by CM but a good portion of it.

- Benefit: No calls to CM improve performance, reduces load to CM, improve availability (if CM goes down IQ continues working)
- Drawbacks: High availability comes with... rolling drums... lack of consistency: eventual consistency

### 3- Event Sourcing

When I want to change one person's address I go and delete its old address and I create the new address and I store the final state of my system in a database. Typically, with a user table and a address table relational schema.

Alternatively:
Create AddressChangedEvent and store it in a different storage area like a WAL (Write Append Log), then I process the event traditionally and update the current state of my system in the DB.
WAL is a write append log: a write only store of ordered events where the sole operation that I can do is append an event.

This leads two representations of the state:
    - Application State: Current state
    - Event Log: all the events ever changed application state
At any time we can delete the application state and recalculate it by replaying the whole event log

>**Example for devs**: git. log: commits. Application state: working copy. Snapshots for optimizations
>**Example for people**: Accounting ledger. Application state: how much money do I have. Log: every single debit and credit ever applied

Benefits: 

- Audit: Inspect how we reached a certain state
- Debugging: Copy the system and feed the same events one by one reproducing the application state at every step.
- Alternative State: Copy of all log and introduce a hypothetical event at a certain point so you get the application state under the hypothesis the event would have occurred. Branching in git
   >Payroll example:
        somebody worked 35 hours in a week, we record that, we send him a check, we update the sick pay, update pension benefits, etc.. all sort of downstream happened. 
        And 6 month later someone says Ohh it wasn't 35 hours, it was 40. Now we have to recalculate all the adjustments. You can do it by hand or in an event sourced system you can copy the event log with the updated event and replay it to calculate the Application State, compare the two application states, do the diff and apply the changes.
- Memory Image: 
     Why do I need to store my application state in a relational database if I can restore it my replaying event log?
     I can keep application state in memory which is a lot faster (low latency 6M transactions per seconds). 

Costs:
- Unfamiliar system
- Calling external system. Other systems cannot time travel. I can not ask what response I got for this call two weeks ago.
Then I have to put every response of an external system as an event and make it part of the replay mechanism.
- Event Schema: How can I store may events in a way I can replay them even if I change the code of my system.
- Identifiers:
    - CorrelationId: Used to tie together all events triggered by the same request
    - EventId: unique identifiers
    - Aggregate Id: Identifies the entity whose state is reconstructed by replaying events.
    - Aggregate: Order, AggregateId = order-123
  
            OrderCreated
            AggregateId: order-123

            ItemAdded
            AggregateId: order-123
            
            OrderConfirmed
            AggregateId: order-123
            
            
            When loading `order-123`, the event store fetches all events with that Aggregate ID and replays them.

    - Causation Id: Id of the event causing the current event. Allows to reconstruct causal chains.
    - SequenceNumber: Used in aggregates for optimistic concurrency.
            OrederCreated 1, Add Item 2. If I store a Confirmed event I expect it to be sotred with seq id 4.
            Timestamps
            
A useful way to think about these identifiers is to group them into three categories:

- **Identity**: Aggregate ID, Event ID, Stream ID.
- **Consistency**: Aggregate Version (or Sequence Number).
- **Observability**: Correlation ID, Causation ID, Command ID, User ID, Tenant ID.
    
Snapshot every day: We don't need to process older events. Parttial event sourcing

4- **CQRS**:
- One path handle state updates
- It updates 3 different schemas variants corresponding to different query needs

Problem: Eventual consistency (inconsistency window)
Suited when the write path is very different that the read path. Like unfrequent writes that triggers complex calculations, frequent simple reads.

DDD cheat sheet https://github.com/ddd-crew/context-mapping?tab=readme-ov-file#context-map-cheat-sheet