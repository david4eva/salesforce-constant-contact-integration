@IsTest
private class Constant_Contact_Integration_Test {
    @IsTest
    static void testCalloutToConstantContact() {
        // Step 1: Set up mock data
        // Create an Account to be used for testing
        Account testAccount = new Account(
                Name = 'Constant Contact Integration',
                AccountNumber = 'CTCT',
                Constant_Contact_Access_Token__c = 'testAccessToken',
                Access_Token_Expiration__c = Datetime.now().addMinutes(-10),
                Is_Constant_Contact_Enabled__c = true
        );
        insert testAccount;

        // Create an Event__c record
        Event__c testEvent = new Event__c(
                Name = 'Test Event',
                Constant_Contact_Sync_Enabled__c = true,
                Start_Time__c = Datetime.now().addMinutes(-100),
                End_Time__c = Datetime.now().addMinutes(-50),
                Program_Format__c = 'Online Course (a formal structured training delivered via the Internet)'
        );
        insert testEvent;

        // Create Contact record
        Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'User',
                Email = 'testuser@example.com',
                Join_Date__c = Date.today().addDays(-10),
                Mailing_Address_Type__c = 'home'
        );
        insert testContact;

        // Create an Event_Registration__c record
        Event_Registration__c testRegistration = new Event_Registration__c(
                Registrant__c = testContact.Id,
                Event__c = testEvent.Id
        );
        insert testRegistration;

        // Step 2: Set up the mock HTTP response
        Test.setMock(HttpCalloutMock.class, new ConstantContactMock());

        // Step 3: Call the method to be tested
        String[] registrantIds = new String[]{
                testRegistration.Id
        };
        String[] eventIds = new String[]{
                testEvent.Id
        };
        Test.startTest();
        Constant_Contact_Integration.calloutToConstantContact(registrantIds, eventIds);
        Test.stopTest();

        // Step 4: Verify the results
        testAccount = [SELECT Constant_Contact_Access_Token__c, Access_Token_Expiration__c FROM Account WHERE Id = :testAccount.Id];
        testEvent = [SELECT Event_Contact_List_Id__c, Event_Contact_List_Name__c FROM Event__c WHERE Id = :testEvent.Id];
        testRegistration = [SELECT Contact_Id_Constant_Contact__c FROM Event_Registration__c WHERE Id = :testRegistration.Id];

        // Assertions to verify that access token was refreshed and event/registrant data was updated
        System.assertNotEquals('testAccessToken', testAccount.Constant_Contact_Access_Token__c, 'Access token should have been updated.');
        System.assertNotEquals(null, testEvent.Event_Contact_List_Id__c, 'Event Contact List ID should be set.');
        System.assertNotEquals(null, testRegistration.Contact_Id_Constant_Contact__c, 'Contact ID should be set for the registrant.');
    }

    private class ConstantContactMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            // Mock HTTP response
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setStatus('OK');
            // Mock response body for token refresh
            if (req.getEndpoint().contains('/token')) {
                res.setBody('{"access_token": "newAccessToken", "expires_in": 3600}');
            } else if (req.getEndpoint().contains('/contact_lists')) {
                res.setBody('{"list_id": "testListId", "name": "Test List"}');
            } else if (req.getEndpoint().contains('/contacts/sign_up_form')) {
                res.setBody('{"contact_id": "testContactId"}');
            }
            return res;
        }
    }
}