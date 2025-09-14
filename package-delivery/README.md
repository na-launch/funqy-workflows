# package delivery Workflow

This workflow demonstrates a real-world event-driven process modeled with **Quarkus Funqy Knative Events**.

## Diagram
```
┌──────────────────────────────┐
│ CloudEvent arrives           │
│ ce-type = orderPlaced        │
└──────────┬───────────────────┘
           │ invokes
           ▼
┌──────────────────────────────┐
│ preparePackage(Pkg p)        │
│ - Pick items from warehouse  │
│ - Pack + label               │
└──────────┬───────────────────┘
           │ emits
           ▼
┌────────────────────────────────────────────┐
│ CloudEvent emitted                         │
│ ce-type = orderPlaced.output               │
│ ce-source = preparePackage                 │
└──────────┬─────────────────────────────────┘
           │ triggers config mapping
           ▼
┌──────────────────────────────┐
│ assignCourier(Pkg p)         │
│ - Find local courier         │
│ - Assign route               │
└──────────┬───────────────────┘
           │ emits
           ▼
┌────────────────────────────────────────────┐
│ CloudEvent emitted                         │
│ ce-type = courierAssigned                  │
│ ce-source = courierMapping                 │
└──────────┬─────────────────────────────────┘
           │ matches @CloudEventMapping(trigger="courierAssigned")
           ▼
┌──────────────────────────────┐
│ trackInTransit(Pkg p)        │
│ - GPS updates                │
│ - Notify customer live       │
└──────────┬───────────────────┘
           │ emits
           ▼
┌────────────────────────────────────────────┐
│ CloudEvent emitted                         │
│ ce-type = inTransit                        │
│ ce-source = trackInTransit                 │
└──────────┬─────────────────────────────────┘
           │ triggers final handler
           ▼
┌──────────────────────────────┐
│ deliverPackage(Pkg p)        │
│ - Mark delivered             │
│ - Notify customer            │
└──────────────────────────────┘
```

## Event Flow
- Starts with a CloudEvent of type specific to this workflow (see curl example below).
- Events flow step by step, emitting new CloudEvents at each stage.
- Some transitions use **configChain mappings** (defined in `application.properties`).
- Others use **@CloudEventMapping annotations** to route based on ce-type.

## Expected Output
Each step enriches the object with new status information until the final step completes the workflow.
