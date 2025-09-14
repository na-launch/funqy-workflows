package org.example.rideshare;

import io.quarkus.funqy.Funq;
import io.quarkus.funqy.knative.events.CloudEventMapping;
import org.jboss.logging.Logger;

public class RideMatching {
    private static final Logger log = Logger.getLogger(RideMatching.class);

    @Funq
    public Ride requestRide(Ride ride) {
        log.infof("Ride requested by user %s", ride.riderId);
        ride.status = "REQUESTED";
        return ride;
    }

    @Funq
    public Ride findDriver(Ride ride) {
        log.infof("Finding driver for rider %s", ride.riderId);
        ride.driverId = "driver-123";
        ride.status = "MATCHED";
        return ride;
    }

    @Funq
    @CloudEventMapping(trigger = "MATCHED", responseSource = "rideshare", responseType = "in-progress")
    public Ride startRide(Ride ride) {
        log.infof("Ride started with driver %s", ride.driverId);
        ride.status = "IN_PROGRESS";
        return ride;
    }

    @Funq
    public void complete(Ride ride) {
        log.infof("Ride for %s completed successfully", ride.riderId);
    }

    public static class Ride {
        public String riderId;
        public String driverId;
        public String status;
    }
}
