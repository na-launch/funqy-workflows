package org.example.mortgage;

import io.quarkus.funqy.Funq;
import io.quarkus.funqy.knative.events.CloudEventMapping;
import org.jboss.logging.Logger;

public class MortgageApplication {
    private static final Logger log = Logger.getLogger(MortgageApplication.class);

    @Funq
    public Application submit(Application app) {
        log.infof("Application submitted %s", app.id);
        app.status = "SUBMITTED";
        return app;
    }

    @Funq
    public Application verifyCredit(Application app) {
        log.infof("Verifying credit for %s", app.id);
        app.status = "CREDIT_CHECKED";
        return app;
    }

    @Funq
    @CloudEventMapping(trigger = "CREDIT_CHECKED", responseSource = "mortgage", responseType = "underwriting")
    public Application underwrite(Application app) {
        log.infof("Underwriting application %s", app.id);
        app.status = "UNDERWRITING";
        return app;
    }

    @Funq
    public void finalize(Application app) {
        log.infof("Mortgage approved for %s", app.id);
    }

    public static class Application {
        public String id;
        public String status;
    }
}
