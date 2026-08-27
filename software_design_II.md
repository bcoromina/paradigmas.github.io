1. Domain Driven Design

   1. Strategic DDD: Subdominis i contextos
   2. Event Storming: Descobriment de fluxes
   3. Tactic DDD: Entitats i agregats

2. Arquitectura hexagonal: Puertos y adaptadores
3. CQRS
4. Event sourcing
5. Consistencia eventual
-----------------------



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
     that will be listened by IQ, then CM doesn't have to know about IQ, it's IQ who has to know about CM by knowing about its emited event.

Events vs Commands (ex: CustomerAddressUpdated vs RecuoteQuotationForCustomer)
Determines the intention and the communication patterns. If you publish an event you are not interested in derived actions triggered by its publication. 
Events allows multiples consumer of the event to react to it without having to tell CM, so completely decoupled. 

But, there's no central place that tells you what happens when the customer change its address.
No statement of overall behavior. Decoupling but the flow is difficult to follow

### 2- Event-carried State Transfer

Following the previous example, in the insurance company,
CM has a database on customer
 What to put in the event? from more generic to more specific
  - SomethingCanged: All subscribers will have to react asking what has changed
  - Something about Bob changed. All subscribers will have to ask what changed about Bob
  - Bob's address has changed. All subscribers will have to ask what is the new address

    So we see the publication of the event is creating extra traffic in our system, so if we want to reduce that
    I will put all the needed information in the event, so I don't have to go back to the producer.
 - Bob's address has changed and I include old and new address.
     But maybe the IQ service needs to know extra info from the user when it calculates the new quotation and event consumers will have to ask CM every time it publishes an event. Can I eliminate this load?

**Event-carried State Transfer**
Event contains all the data that its downstream system will ever need. And the downstream systems will have to keep a copy of this data.
IQ will keep a copy of all data so it has all the data it needs not the entire CustomerDB owned by CM but a good portion of it.

- Benefit: No calls to CM improve performance, reduces load to CM, improve availability (if CM goes down IQ continues working)
- Drawbacks: High availability comes with... rolling drums... lack of consistency: eventual consistency

3- Event Sourcing

When I want to change one person's address I go and delete its old address and I create the new address and I store the final state of my system in a database. Tipically with a user table and a address table relational schema.

Alternatively:
Create AddressChangedEvent and store it in a different storage area like a WAL (Write Append Log), then I process the event traditionally and update the current state of my system in the DB.
WAL is a write append log: a write only store of ordered events where the sole operation that I can do is append an event.

This leads two representations of the state:
    - Application State: Current state
    - Log: all the events ever changed application state
At any time we can delete the application state and recalculate it by replaying the whole event log

>**Example for devs**: git. log: commits. Application state: working copy. Snapshots for optimizations
>**Example for people**: Acccounting ledger. Application state: how much money do I have. Log: every single debit and credit ever applied

Benefits: 

- Audit: Inspect how we reached a certain state
- Debugging: Copy the system and feed the same events one by one reproducing the application state at every step.
- Alternative State: Copy of all log and introduce an hypothetical event at a certain point so you get the application state under the hypothesis the event would have occurred. Branching in git
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

5-  Change data capture
My traditional SQL database captures every change and publish it in a stream of events.


DDD cheat sheet https://github.com/ddd-crew/context-mapping?tab=readme-ov-file#context-map-cheat-sheet