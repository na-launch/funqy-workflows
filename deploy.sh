#!/usr/bin/env bash
set -e

BASE_DIR=$(pwd)

echo "📦 Generating detailed workflow diagrams..."

# Baggage Handler
mkdir -p "$BASE_DIR/baggage-handler"
cat > "$BASE_DIR/baggage-handler/diagram.txt" <<'EOF'
┌──────────────────────────────┐
│ CloudEvent arrives           │
│ ce-type = checkInBaggage     │
└──────────┬───────────────────┘
           │ invokes
           ▼
┌──────────────────────────────┐
│ checkInBaggage(Bag bag)      │
│ - Tag + Scan bag             │
│ - Assign destination         │
└──────────┬───────────────────┘
           │ emits
           ▼
┌───────────────────────────────────────────┐
│ CloudEvent emitted                        │
│ ce-type = checkInBaggage.output           │
│ ce-source = checkInBaggage                │
└──────────┬────────────────────────────────┘
           │ triggers config mapping
           ▼
┌──────────────────────────────┐
│ securityScan(Bag bag)        │
│ - X-ray scan                 │
│ - Flag suspicious items      │
└──────────┬───────────────────┘
           │ emits
           ▼
┌───────────────────────────────────────────┐
│ CloudEvent emitted                        │
│ ce-type = scanned                         │
│ ce-source = securityMapping               │
└──────────┬────────────────────────────────┘
           │ matches @CloudEventMapping(trigger="scanned")
           ▼
┌──────────────────────────────┐
│ loadToAircraft(Bag bag)      │
│ - Sort bags to correct plane │
│ - Mark "Loaded"              │
└──────────┬───────────────────┘
           │ emits
           ▼
┌───────────────────────────────────────────┐
│ CloudEvent emitted                        │
│ ce-type = loaded                          │
│ ce-source = loadToAircraft                │
└──────────┬────────────────────────────────┘
           │ triggers final handler
           ▼
┌──────────────────────────────┐
│ finalDelivery(Bag bag)       │
│ - Update system "Bag onboard"│
│ - Notify passenger app       │
│ - End of chain               │
└──────────────────────────────┘
EOF
echo "✅ Created baggage-handler/diagram.txt"

# Employee Onboarding
mkdir -p "$BASE_DIR/employee-onboarding"
cat > "$BASE_DIR/employee-onboarding/diagram.txt" <<'EOF'
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
EOF
echo "✅ Created employee-onboarding/diagram.txt"

# Package Delivery
mkdir -p "$BASE_DIR/package-delivery"
cat > "$BASE_DIR/package-delivery/diagram.txt" <<'EOF'
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
EOF
echo "✅ Created package-delivery/diagram.txt"

# Ride Matching
mkdir -p "$BASE_DIR/ride-matching"
cat > "$BASE_DIR/ride-matching/diagram.txt" <<'EOF'
┌──────────────────────────────┐
│ CloudEvent arrives           │
│ ce-type = requestRide        │
└──────────┬───────────────────┘
           │ invokes
           ▼
┌──────────────────────────────┐
│ matchDriver(Ride r)          │
│ - Find nearby driver         │
│ - Check availability         │
└──────────┬───────────────────┘
           │ emits
           ▼
┌────────────────────────────────────────────┐
│ CloudEvent emitted                         │
│ ce-type = driverMatched                    │
│ ce-source = matchDriver                    │
└──────────┬─────────────────────────────────┘
           │ matches @CloudEventMapping(trigger="driverMatched")
           ▼
┌──────────────────────────────┐
│ confirmRide(Ride r)          │
│ - Driver accepts ride        │
│ - Notify passenger           │
└──────────┬───────────────────┘
           │ emits
           ▼
┌────────────────────────────────────────────┐
│ CloudEvent emitted                         │
│ ce-type = confirmed                        │
│ ce-source = confirmRide                    │
└──────────┬─────────────────────────────────┘
           │ matches @CloudEventMapping(trigger="confirmed")
           ▼
┌──────────────────────────────┐
│ trackRide(Ride r)            │
│ - GPS tracking               │
│ - Update ETA continuously    │
└──────────┬───────────────────┘
           │ emits
           ▼
┌────────────────────────────────────────────┐
│ CloudEvent emitted                         │
│ ce-type = rideInProgress                   │
│ ce-source = trackRide                      │
└──────────┬─────────────────────────────────┘
           │ triggers final handler
           ▼
┌──────────────────────────────┐
│ completeRide(Ride r)         │
│ - Mark finished              │
│ - Process payment            │
└──────────────────────────────┘
EOF
echo "✅ Created ride-matching/diagram.txt"

# Supermarket Layaway
mkdir -p "$BASE_DIR/supermarket-layaway"
cat > "$BASE_DIR/supermarket-layaway/diagram.txt" <<'EOF'
┌──────────────────────────────┐
│ CloudEvent arrives           │
│ ce-type = startLayaway       │
└──────────┬───────────────────┘
           │ invokes
           ▼
┌──────────────────────────────┐
│ reserveItem(Order o)         │
│ - Mark inventory as held     │
│ - Assign reservation ID      │
└──────────┬───────────────────┘
           │ emits
           ▼
┌────────────────────────────────────────────┐
│ CloudEvent emitted                         │
│ ce-type = itemReserved                     │
│ ce-source = reserveItem                    │
└──────────┬─────────────────────────────────┘
           │ triggers config mapping
           ▼
┌──────────────────────────────┐
│ acceptDeposit(Order o)       │
│ - Record partial payment     │
│ - Issue receipt              │
└──────────┬───────────────────┘
           │ emits
           ▼
┌────────────────────────────────────────────┐
│ CloudEvent emitted                         │
│ ce-type = depositReceived                  │
│ ce-source = paymentMapping                 │
└──────────┬─────────────────────────────────┘
           │ matches @CloudEventMapping(trigger="depositReceived")
           ▼
┌──────────────────────────────┐
│ trackPayments(Order o)       │
│ - Monitor installments       │
│ - Send reminders             │
└──────────┬───────────────────┘
           │ emits
           ▼
┌────────────────────────────────────────────┐
│ CloudEvent emitted                         │
│ ce-type = paymentsUpdated                  │
│ ce-source = trackPayments                  │
└──────────┬─────────────────────────────────┘
           │ triggers final handler
           ▼
┌──────────────────────────────┐
│ releaseItem(Order o)         │
│ - Final payment complete     │
│ - Customer collects item     │
└──────────────────────────────┘
EOF
echo "✅ Created supermarket-layaway/diagram.txt"

# Insurance Claim
mkdir -p "$BASE_DIR/insurance-claim"
cat > "$BASE_DIR/insurance-claim/diagram.txt" <<'EOF'
┌──────────────────────────────┐
│ CloudEvent arrives           │
│ ce-type = submitClaim        │
└──────────┬───────────────────┘
           │ invokes
           ▼
┌──────────────────────────────┐
│ validateClaim(Claim c)       │
│ - Check policy validity      │
│ - Verify documents           │
└──────────┬───────────────────┘
           │ emits
           ▼
┌────────────────────────────────────────────┐
│ CloudEvent emitted                         │
│ ce-type = claimValidated                   │
│ ce-source = validateClaim                  │
└──────────┬─────────────────────────────────┘
           │ triggers config mapping
           ▼
┌──────────────────────────────┐
│ assessDamage(Claim c)        │
│ - Inspect damage evidence    │
│ - Estimate cost              │
└──────────┬───────────────────┘
           │ emits
           ▼
┌────────────────────────────────────────────┐
│ CloudEvent emitted                         │
│ ce-type = damageAssessed                   │
│ ce-source = damageAssessment               │
└──────────┬─────────────────────────────────┘
           │ matches @CloudEventMapping(trigger="damageAssessed")
           ▼
┌──────────────────────────────┐
│ approveOrReject(Claim c)     │
│ - Apply rules                │
│ - Approve or deny claim      │
└──────────┬───────────────────┘
           │ emits
           ▼
┌────────────────────────────────────────────┐
│ CloudEvent emitted                         │
│ ce-type = claimDecision                    │
│ ce-source = approveOrReject                │
└──────────┬─────────────────────────────────┘
           │ triggers final handler
           ▼
┌──────────────────────────────┐
│ payout(Claim c)              │
│ - Send funds to customer     │
│ - Notify claimant            │
└──────────────────────────────┘
EOF
echo "✅ Created insurance-claim/diagram.txt"

# Mortgage Application
mkdir -p "$BASE_DIR/mortgage-application"
cat > "$BASE_DIR/mortgage-application/diagram.txt" <<'EOF'
┌──────────────────────────────┐
│ CloudEvent arrives           │
│ ce-type = submitApplication  │
└──────────┬───────────────────┘
           │ invokes
           ▼
┌──────────────────────────────┐
│ collectDetails(App a)        │
│ - Capture applicant info     │
│ - Upload docs                │
└──────────┬───────────────────┘
           │ emits
           ▼
┌────────────────────────────────────────────┐
│ CloudEvent emitted                         │
│ ce-type = detailsCollected                 │
│ ce-source = collectDetails                 │
└──────────┬─────────────────────────────────┘
           │ triggers config mapping
           ▼
┌──────────────────────────────┐
│ creditCheck(App a)           │
│ - Run credit bureau check    │
│ - Compute score              │
└──────────┬───────────────────┘
           │ emits
           ▼
┌────────────────────────────────────────────┐
│ CloudEvent emitted                         │
│ ce-type = creditChecked                    │
│ ce-source = creditCheckMapping             │
└──────────┬─────────────────────────────────┘
           │ matches @CloudEventMapping(trigger="creditChecked")
           ▼
┌──────────────────────────────┐
│ underwriting(App a)          │
│ - Risk models                │
│ - Approve/reject conditions  │
└──────────┬───────────────────┘
           │ emits
           ▼
┌────────────────────────────────────────────┐
│ CloudEvent emitted                         │
│ ce-type = underwritten                     │
│ ce-source = underwriting                   │
└──────────┬─────────────────────────────────┘
           │ triggers final handler
           ▼
┌──────────────────────────────┐
│ finalizeLoan(App a)          │
│ - Approve loan + rate        │
│ - Notify applicant           │
└──────────────────────────────┘
EOF
echo "✅ Created mortgage-application/diagram.txt"

echo "🎉 All detailed diagrams generated successfully."