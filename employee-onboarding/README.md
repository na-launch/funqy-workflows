# employee onboarding Workflow

This workflow demonstrates a real-world event-driven process modeled with **Quarkus Funqy Knative Events**.

## Diagram
```
┌──────────────────────────────┐
│ CloudEvent arrives           │
│ ce-type = startOnboarding    │
└──────────┬───────────────────┘
           │ invokes
           ▼
┌──────────────────────────────┐
│ collectDocuments(Employee e) │
│ - Capture ID, tax forms      │
│ - Verify completeness        │
└──────────┬───────────────────┘
           │ emits
           ▼
┌────────────────────────────────────────────┐
│ CloudEvent emitted                         │
│ ce-type = collectDocuments.output          │
│ ce-source = collectDocuments               │
└──────────┬─────────────────────────────────┘
           │ triggers config mapping
           ▼
┌──────────────────────────────┐
│ provisionAccounts(Employee e)│
│ - Create email, VPN, laptop  │
│ - Assign software licenses   │
└──────────┬───────────────────┘
           │ emits
           ▼
┌────────────────────────────────────────────┐
│ CloudEvent emitted                         │
│ ce-type = provisioned                      │
│ ce-source = accountProvisionMapping        │
└──────────┬─────────────────────────────────┘
           │ matches @CloudEventMapping(trigger="provisioned")
           ▼
┌──────────────────────────────┐
│ scheduleOrientation(Employee)│
│ - Add to HR orientation      │
│ - Notify manager             │
└──────────┬───────────────────┘
           │ emits
           ▼
┌────────────────────────────────────────────┐
│ CloudEvent emitted                         │
│ ce-type = scheduled                        │
│ ce-source = scheduleOrientation            │
└──────────┬─────────────────────────────────┘
           │ triggers final handler
           ▼
┌──────────────────────────────┐
│ finalizeOnboarding(Employee) │
│ - Mark "Active Employee"     │
│ - Notify payroll + IT        │
└──────────────────────────────┘
```

## Event Flow
- Starts with a CloudEvent of type specific to this workflow (see curl example below).
- Events flow step by step, emitting new CloudEvents at each stage.
- Some transitions use **configChain mappings** (defined in `application.properties`).
- Others use **@CloudEventMapping annotations** to route based on ce-type.

## Expected Output
Each step enriches the object with new status information until the final step completes the workflow.
