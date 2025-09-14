package org.example.layaway;

import io.quarkus.funqy.Funq;
import io.quarkus.funqy.knative.events.CloudEventMapping;
import org.jboss.logging.Logger;

public class LayawayProcess {
    private static final Logger log = Logger.getLogger(LayawayProcess.class);

    @Funq
    public Item reserve(Item item) {
        log.infof("Reserving item %s", item.name);
        item.status = "RESERVED";
        return item;
    }

    @Funq
    public Item makePayment(Item item) {
        log.infof("Payment made on item %s", item.name);
        item.status = "PARTIALLY_PAID";
        return item;
    }

    @Funq
    @CloudEventMapping(trigger = "PARTIALLY_PAID", responseSource = "layaway", responseType = "paid-off")
    public Item completePayment(Item item) {
        log.infof("Item %s fully paid", item.name);
        item.status = "PAID_OFF";
        return item;
    }

    @Funq
    public void pickup(Item item) {
        log.infof("Customer picked up item %s", item.name);
    }

    public static class Item {
        public String id;
        public String name;
        public String status;
    }
}
