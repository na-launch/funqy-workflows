package org.example.baggage;

import io.quarkus.funqy.Context;
import io.quarkus.funqy.Funq;
import io.quarkus.funqy.knative.events.CloudEvent;
import io.quarkus.funqy.knative.events.CloudEventMapping;
import org.jboss.logging.Logger;

public class BaggageHandler {
    private static final Logger log = Logger.getLogger(BaggageHandler.class);

    @Funq
    public Bag scanBag(Bag bag) {
        log.infof("Scanning bag %s at check-in…", bag.id);
        bag.status = "SCANNED";
        return bag;
    }

    @Funq
    public Bag securityCheck(Bag bag) {
        log.infof("Security check for bag %s…", bag.id);
        bag.status = bag.flagged ? "FLAGGED" : "CLEARED";
        return bag;
    }

    @Funq
    @CloudEventMapping(trigger = "cleared", responseSource = "baggage", responseType = "loaded")
    public Bag loadToPlane(Bag bag) {
        log.infof("Loading bag %s onto plane…", bag.id);
        bag.status = "LOADED";
        return bag;
    }

    @Funq
    public void settle(Bag bag, @Context CloudEvent event) {
        log.infof("Bag %s is ready for flight with status %s", bag.id, bag.status);
    }

    public static class Bag {
        public String id;
        public boolean flagged;
        public String status;
    }
}
