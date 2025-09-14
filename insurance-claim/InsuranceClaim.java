package org.example.insurance;

import io.quarkus.funqy.Funq;
import io.quarkus.funqy.knative.events.CloudEventMapping;
import org.jboss.logging.Logger;

public class InsuranceClaim {
    private static final Logger log = Logger.getLogger(InsuranceClaim.class);

    @Funq
    public Claim submit(Claim claim) {
        log.infof("Claim submitted %s", claim.id);
        claim.status = "SUBMITTED";
        return claim;
    }

    @Funq
    public Claim review(Claim claim) {
        log.infof("Reviewing claim %s", claim.id);
        claim.status = "IN_REVIEW";
        return claim;
    }

    @Funq
    @CloudEventMapping(trigger = "IN_REVIEW", responseSource = "insurance", responseType = "approved")
    public Claim approve(Claim claim) {
        log.infof("Claim %s approved", claim.id);
        claim.status = "APPROVED";
        return claim;
    }

    @Funq
    public void payout(Claim claim) {
        log.infof("Claim %s payout sent", claim.id);
    }

    public static class Claim {
        public String id;
        public String status;
    }
}
