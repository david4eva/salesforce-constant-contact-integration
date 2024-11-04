trigger Event_Registration on Event_Registration__c (after insert) {
    switch on Trigger.operationType {
        when AFTER_INSERT {
            String[]registrantIds = new String[]{};
            String[]eventIds = new String[]{};

            for (Event_Registration__c eR: Trigger.new) {
                registrantIds.add(eR.Id);
                eventIds.add(eR.Event__c);
            }

            Constant_Contact_Integration.calloutToConstantContact(registrantIds, eventIds);
        }
    }
}