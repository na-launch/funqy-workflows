# Funqy Workflows 🚀

This repository contains sample **Quarkus Funqy Knative Event workflows** across different domains.  
Each workflow demonstrates an event-driven process with multiple chained steps, using `configChain` mappings and `@CloudEventMapping` annotations.

## Workflows

- [Baggage Handler (Airline)](./baggage-handler/README.md)  
  Process of checking in baggage, security scanning, loading to aircraft, and final delivery.

- [Employee Onboarding](./employee-onboarding/README.md)  
  HR process for collecting documents, provisioning accounts, orientation, and finalizing onboarding.

- [Package Delivery](./package-delivery/README.md)  
  “Deliver My Package” workflow: order placement, package preparation, courier assignment, transit tracking, and final delivery.

- [Ride Matching (Uber Style)](./ride-matching/README.md)  
  Matching drivers to riders, confirming rides, tracking trips, and completing rides with payments.

- [Supermarket Layaway](./supermarket-layaway/README.md)  
  Reserving items, collecting deposits, tracking payments, and releasing items upon full payment.

- [Insurance Claim](./insurance-claim/README.md)  
  Submitting claims, validating coverage, assessing damages, approving/rejecting, and payout.

- [Mortgage Application](./mortgage-application/README.md)  
  Collecting applicant details, credit checks, underwriting, and final loan approval.

## How to Run

Each workflow directory contains:
- `diagram.txt` → ASCII diagram of event flow
- `README.md` → Step-by-step explanation
- `curl-examples.sh` → Example CloudEvent curl command to trigger the first step
- `application.properties` → Example Quarkus configuration

### Build and Deploy (generic)
From inside a workflow directory:
```bash
mvn clean package -Dquarkus.kubernetes.deploy=true