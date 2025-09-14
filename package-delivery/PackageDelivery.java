package org.example.delivery;

import io.quarkus.funqy.Funq;
import io.quarkus.funqy.knative.events.CloudEventMapping;
import org.jboss.logging.Logger;

public class PackageDelivery {
    private static final Logger log = Logger.getLogger(PackageDelivery.class);

    @Funq
    public Parcel pickup(Parcel parcel) {
        log.infof("Picked up package %s", parcel.id);
        parcel.status = "PICKED_UP";
        return parcel;
    }

    @Funq
    public Parcel sort(Parcel parcel) {
        log.infof("Sorting package %s", parcel.id);
        parcel.status = "SORTED";
        return parcel;
    }

    @Funq
    @CloudEventMapping(trigger = "SORTED", responseSource = "delivery", responseType = "out-for-delivery")
    public Parcel outForDelivery(Parcel parcel) {
        log.infof("Package %s is out for delivery", parcel.id);
        parcel.status = "OUT_FOR_DELIVERY";
        return parcel;
    }

    @Funq
    public void delivered(Parcel parcel) {
        log.infof("Package %s delivered!", parcel.id);
    }

    public static class Parcel {
        public String id;
        public String status;
    }
}
