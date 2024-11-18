/*
* Author: David Elias
* Description: This Apex class facilitates seamless communication between Salesforce and Constant Contact.
               It handles API callouts for contact & contact list synchronization and token refresh logic.
*/
public without sharing class Constant_Contact_Integration {
    private static String accessToken;
    private static Boolean accessTokenExpired;
    private static Event__c[] events;
    private static Event_Registration__c[] registrants;
    private static String ctctListId;
    private static String ctctEventName;
    private static Integer expiresIn;
    private static Account ctctAcct;

    /* Main method for calling class methods conditionally
    *  @param registrantIds: Array of Event_Registration__c record Ids
    *  @param eventIds: Array of Event__c record Ids */
    @Future(Callout=true)
    public static void calloutToConstantContact(String[]registrantIds, String[]eventIds) {
        ctctAcct = [
                SELECT Constant_Contact_Access_Token__c, Access_Token_Expiration__c, Is_Constant_Contact_Enabled__c
                FROM Account
                WHERE Name = 'Constant Contact Integration'
                AND AccountNumber = 'CTCT'
        ];

        if (ctctAcct.Is_Constant_Contact_Enabled__c) {
            // Validate access token
            accessTokenExpired = false;
            validateAccessToken();

            // Refresh access token & update Constant Contact integration Account
            if (accessTokenExpired == true) {
                refreshAccessToken();
            }

            // Create event lists via endpoint & update sObjects with responses
            if (eventIds.size() > 0) {
                createEventLists(accessToken, eventIds);
                createEventRegistrants(accessToken, registrantIds);
                updateRecords();
            }
        }
    }

    // Validate access token by checking the access token expiration date/time
    private static Boolean validateAccessToken() {
        Datetime fiveMinutesAgo = Datetime.now().addMinutes(-5);
        accessToken = ctctAcct.Constant_Contact_Access_Token__c;

        // Refresh access token within 5 minutes or less of expiration or if null
        if (ctctAcct.Access_Token_Expiration__c <= fiveMinutesAgo || ctctAcct.Access_Token_Expiration__c == null) {
            accessTokenExpired = true;
        } else {
            accessTokenExpired = false;
        }
        return accessTokenExpired;
    }

    // Callout to /token endpoint to get new access token
    private static Account refreshAccessToken() {
        // Retrieve authorization metadata
        Constant_Contact__mdt ctctMetadata = [
                SELECT Client_Id__c, Client_Secret__c, Refresh_Token__c, Access_Token_Endpoint__c
                FROM Constant_Contact__mdt
                LIMIT 1
        ];

        // Http objects
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();

        // Encode the authorization code
        String decodedAuthString = ctctMetadata.Client_Id__c + ':' + ctctMetadata.Client_Secret__c;
        Blob blobAuthValue = Blob.valueOf(decodedAuthString);
        String encodedAuthString = EncodingUtil.base64Encode(blobAuthValue);

        // Create request
        req.setEndpoint(ctctMetadata.Access_Token_Endpoint__c + '?refresh_token=' + ctctMetadata.Refresh_Token__c + '&grant_type=refresh_token');
        req.setMethod('POST');
        req.setHeader('Authorization', 'Basic ' + encodedAuthString);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');

        // Create response
        res = http.send(req);

        if (res.getStatusCode() == 200 || res.getStatusCode() == 201) {
            // Deserialize JSON response into Map
            Map<String, Object> resBody = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            // Extract values using keys
            accessToken = (String) resBody.get('access_token');
            expiresIn = (Integer) resBody.get('expires_in');
        }

        // Save new access token data to Constant Contact account
        ctctAcct.Constant_Contact_Access_Token__c = accessToken;
        ctctAcct.Access_Token_Expiration__c = (Datetime.now().addSeconds(expiresIn));
        ctctAcct.Access_Token_Expiration__c = (Datetime.now().addSeconds(expiresIn));
        return ctctAcct;
    }

    // Create events as contact lists in Constant Contact
    private static void createEventLists(String accessToken, String[] eventIds) {
        // Get events with no list Ids
        events = [
                SELECT Name, Event_Contact_List_Name__c, Event_Contact_List_Id__c
                FROM Event__c
                WHERE Id IN :eventIds
                AND Constant_Contact_Sync_Enabled__c = TRUE
                AND (Event_Contact_List_Id__c = NULL
                OR Event_Contact_List_Name__c = NULL)
        ];

        if (events.size() > 0) {
            for (Event__c e : events) {

                // Send event sObjects to Wrapper object
                Constant_Contact_Integration_Wrapper eventListWrapper = new Constant_Contact_Integration_Wrapper(
                        e.Name + ' - ' + generateRandomString(5)
                );

                // Serialize sObject into JSON object
                String reqBody = JSON.serialize(eventListWrapper, true);

                // Http objects
                HttpRequest req = new HttpRequest();
                HttpResponse res = new HttpResponse();
                Http http = new Http();

                // Create request
                req.setEndpoint('callout:Constant_Contact_API' + '/contact_lists');
                req.setMethod('POST');
                req.setHeader('Authorization', 'Bearer ' + accessToken);
                req.setHeader('Content-Type', 'application/json');
                req.setBody(reqBody);

                // Create response
                res = http.send(req);

                if (res.getStatusCode() == 201 || res.getStatusCode() == 200) {
                    // Deserialize JSON response into Map
                    Map<String, Object> resBody = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

                    if (resBody.containsKey('list_id')) {
                        // Get list_id value
                        ctctListId = (String) resBody.get('list_id');
                        ctctEventName = (String) resBody.get('name');
                        e.Event_Contact_List_Id__c = ctctListId;
                        e.Event_Contact_List_Name__c = ctctEventName;
                    }
                }
            }
        }
    }

    // Create event registrants as contacts in Constant Contact
    private static void createEventRegistrants(String accessToken, String[] registrantIds) {
        // Get registrants with event
        registrants = [
                SELECT Email__c, First_Name__c, Last_Name__c, Phone__c, Registrant__r.Mailing_Address_Type__c,
                        Registrant__r.MailingStreet, Registrant__r.MailingCity, Registrant__r.MailingState,
                        Registrant__r.MailingPostalCode, Registrant__r.MailingCountry, Event__r.Event_Contact_List_Id__c
                FROM Event_Registration__c
                WHERE Id IN :registrantIds
        ];

        if (registrants.size() > 0) {
            for (Event_Registration__c eR : registrants) {
                /* Ternary operator to check whether Event Contact List Id is from the registrants query is null
                If the Event Contact List Id is null then set the value using ctctListId variable in global scope */
                String getEventListId = eR.Event__r.Event_Contact_List_Id__c == null ? ctctListId : eR.Event__r.Event_Contact_List_Id__c;

                // Send registrant sObjects to Wrapper object
                Constant_Contact_Integration_Wrapper registrantListWrapper = new Constant_Contact_Integration_Wrapper(
                        eR.Email__c,
                        eR.First_Name__c,
                        eR.Last_Name__c,
                        eR.Phone__c,
                        eR.Registrant__r.Mailing_Address_Type__c,
                        eR.Registrant__r.MailingStreet,
                        eR.Registrant__r.MailingCity,
                        eR.Registrant__r.MailingState,
                        eR.Registrant__r.MailingPostalCode,
                        eR.Registrant__r.MailingCountry,
                        getEventListId
                );

                // Serialize registrantListWrapper objects in JSON
                String reqBody = JSON.serialize(registrantListWrapper, true);

                // Http objects
                HttpRequest req = new HttpRequest();
                HttpResponse res = new HttpResponse();
                Http http = new Http();

                // Create request
                req.setEndpoint('callout:Constant_Contact_API' + '/contacts/sign_up_form');
                req.setMethod('POST');
                req.setHeader('Authorization', 'Bearer ' + accessToken);
                req.setHeader('Content-Type', 'application/json');
                req.setBody(reqBody);


                // Create response
                res = http.send(req);

                if (res.getStatusCode() == 200 || res.getStatusCode() == 201) {
                    // Deserialize JSON response into Map
                    Map<String, Object> resBody = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

                    if (resBody.containsKey('contact_id')) {
                        // Get contact_id value
                        String contactId = (String) resBody.get('contact_id');
                        eR.Contact_Id_Constant_Contact__c = contactId;
                    }

                }
            }
        }
    }

    // Generate 5 character random String
    private static String generateRandomString(Integer length) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        String randomString = '';

        // Generate a random character for each position in the result string
        for (Integer i = 0; i < length; i++) {
            Integer randomIndex = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randomString += chars.substring(randomIndex, randomIndex + 1);
        }
        return randomString;
    }

    private static void updateRecords() {
        update ctctAcct;
        update events;
        update registrants;
    }
}
