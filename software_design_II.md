1. Domain Driven Design

   1. Strategic DDD: Subdominis i contextos
   2. Event Storming: Descobriment de fluxes
   3. Tactic DDD: Entitats i agregats

2. Arquitectura hexagonal: Puertos y adaptadores
3. CQRS
4. Event sourcing
5. Change data capture
6Consistencia eventual
-----------------------

## 5. CDC: Change Data Capture

Extract changes from a database and publish them as events so, as a user, you can react to them.

All databases work with a transaction log, which is the source of truth for the database. Its an append only data structure which records all inserts, updates and deletes done in the database.
From there the table files are materialized. So, hey! a database is already event sourced! 
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

To put an specific example, imagine we update a column in a row of a table:
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

An application receives an order creation request from a REST API. We store it in the database but we also want to notify Shipment service and Payment Service.
If I do everything in my application, I want to make sure that the storage and the kafka message publication happens atomically, or both things happen or non of them does.
But kafka and the database doesn't share transaction boundaries so this might lead to inconsistency (typical dual write problem).
CDC lets you avoid this problem because now is the CDC software who has to track which transactions from the transaction log has been published to kafka and which not by maintaining some kind of pointer to the WAL.

An XA transaction is a distributed transaction implemented as a 2 Phase Commit.
As an alternative we can implement a 2PC but this worsen the availability of the system because now, to place an order we need both systems the database and kafka up. 
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
- If the user doesn't see the order in the screen because is written to the database, he might try to create the order again, which probably will end up in a bad experience.

We could avoid some of this problem by keeping the order created in memory and serve it to the user, but this comes with its own problems too.

It all depends of which guarantees you want to provide to the user and which properties do you want your system to have.
Answer questions like: It's ok to have a little bit of inconsistency? Is it critical to loose a couple events?
These are architectural decisions that you have to take based in the context of the project. If data is coming from a sensor in an agriculture field, sending this temperature of the soild every 5 minutes, if we loose a couple of events, probably is not a big deal. 
But if we are talking about a financial transaction, loosing an event is a big deal. Or even if the temperature sensor is in a rocket engine and we are using this data to calculate the quantity of fuel to inject in the engine, loosing a couple events is a big deal too.



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