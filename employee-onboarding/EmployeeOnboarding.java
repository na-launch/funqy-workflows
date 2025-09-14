package org.example.hr;

import io.quarkus.funqy.Funq;
import io.quarkus.funqy.knative.events.CloudEventMapping;
import org.jboss.logging.Logger;

public class EmployeeOnboarding {
    private static final Logger log = Logger.getLogger(EmployeeOnboarding.class);

    @Funq
    public Employee collectDocs(Employee emp) {
        log.infof("Collecting documents for %s", emp.name);
        emp.status = "DOCS_COLLECTED";
        return emp;
    }

    @Funq
    public Employee provisionAccess(Employee emp) {
        log.infof("Provisioning access for %s", emp.name);
        emp.status = "ACCESS_GRANTED";
        return emp;
    }

    @Funq
    @CloudEventMapping(trigger = "ACCESS_GRANTED", responseSource = "onboarding", responseType = "equipment")
    public Employee assignEquipment(Employee emp) {
        log.infof("Assigning laptop and badge to %s", emp.name);
        emp.status = "EQUIPPED";
        return emp;
    }

    @Funq
    public void finalize(Employee emp) {
        log.infof("Onboarding completed for %s with status %s", emp.name, emp.status);
    }

    public static class Employee {
        public String id;
        public String name;
        public String status;
    }
}
