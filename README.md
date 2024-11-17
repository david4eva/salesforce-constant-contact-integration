# Salesforce Constant Contact Integration
## Summary
This Salesforce integration enables seamless data flow between Salesforce and Constant Contact, allowing for automated event and event registration management. With this solution, users can synchronize event lists and registrant information directly from Salesforce to Constant Contact, maintaining an active connection. Automated token management ensures uninterrupted data updates.

## Features
* **Automated Token Management**: Refreshes access tokens every 24 hours to ensure continuous connectivity.
* **Event List Synchronization**: Automatically creates Constant Contact event lists based on Salesforce event data.
* **Registrant Management**: Adds and updates event registrants as contacts within Constant Contact, directly from Salesforce.
* **API Request Handling**: Implements secure OAuth 2.0 token handling, with dynamic refresh capability using Named Credentials.

## Using the Integration
  
### **Instructions**
- Log in to the public Experience site [here](https://integration-experts-dev-ed.my.site.com/s/). No authentication required.  
- Take 30 seconds to read the **Data Purge Policy** on the home page.
1. Click the **Contact** tab to open the contacts list view. <img width="1728" alt="2024-11-17_14-09-58 copy" src="https://github.com/user-attachments/assets/865c496b-d3c0-4de2-9387-d1cd741e19ce">
2. Click the **New** button in the top-right corner to create a new contact.<img width="1728" alt="2024-11-08_07-32-44" src="https://github.com/user-attachments/assets/62e5c4ae-c306-41ef-a06b-e9a250052b8f">
3. Fill out the required fields and then click **Save**.<img width="1728" alt="2024-11-08_07-37-11" src="https://github.com/user-attachments/assets/bb024fb1-2a42-46ba-a5ed-e1eca3a65d0c">
4. In the navigation bar, click the **Event** tab.<img width="1728" alt="2024-11-08_07-45-58 (1)" src="https://github.com/user-attachments/assets/e21f0433-3650-4345-a524-6d2fe5519c0f">
5. Click the **New** button in the top-right corner to create a new event.<img width="1728" alt="2024-11-08_07-15-38 (1)" src="https://github.com/user-attachments/assets/2b9b8de2-7763-4ca7-bf44-e508962f3efb">
6. Enter a name for the event (e.g., **How to Start a Business**) and fill in the remaining required fields marked with a red asterisk (*). Then, click **Save**.<img width="1728" alt="2024-11-08_07-16-51 (1)" src="https://github.com/user-attachments/assets/dcc7598e-a98f-41df-bb5e-7a2336f6c9cd">
7. Click the **Related** tab. <img width="1728" alt="2024-11-17_14-14-32" src="https://github.com/user-attachments/assets/83a78621-2ede-4e0c-885e-8bb167ea470b">
8. Click the **New** button to create a new event registration record.<img width="1728" alt="2024-11-17_14-21-48" src="https://github.com/user-attachments/assets/c0d5e5f2-4ab0-4af2-b3c2-cf7e8a78690c">
9. Start typing the name of the contact you created in step 1, select the contact, then click **Save** to associate the event registration record to the event.<img width="1728" alt="2024-11-17_14-29-24" src="https://github.com/user-attachments/assets/1b2e4cd4-7ca9-472c-ab00-f52e6428d581">
10. Navigate to the newly created event record to verify that the **Event Contact List Name** and **Event Contact List Id** fields have been populated with the event list details returned from the integration response. This confirms that the list was successfully created in Constant Contact.<img width="1728" alt="2024-11-17_14-16-20" src="https://github.com/user-attachments/assets/949d3fb1-5917-4762-951b-7de64e7b45c9">
11. Navigate to the newly created event registration record to verify that the **Contact Id – Constant Contact** field has been populated with the registrant Id returned from the integration response. This confirms that the registrant was successfully created and added to the event list in Constant Contact.<img width="1728" alt="2024-11-17_14-17-06" src="https://github.com/user-attachments/assets/52fd6ea1-38fb-418f-9636-493a512961ed">

## Limitations
* Refer to the [Constant Contact Rate Limits](https://developer.constantcontact.com/api_guide/rate_limits.html#:~:text=You%20can%20use%20your%20API,and%204%20requests%20per%20second.) for more information on the Constant Contact API limits.

## Access Token Expiration
* Tokens expire after 1,440 minutes (24 hours); refresh logic is included to keep the integration active.

## Documentation
This project was developed using various documentation resources that provide essential guidance on setup, functionality, and best practices. Below are some key references:

- **Official Salesforce Documentation**: Comprehensive guide on Salesforce APIs, development best practices, and integration techniques.  
  [Salesforce Future Method](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_invoking_future_methods.htm)  
  [Testing HTTP Callouts](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_restful_http_testing.htm)

- **Constant Contact API Documentation**: Detailed information on API endpoints and authentication for seamless integration.  
  [Constant Contact API Reference](https://v3.developer.constantcontact.com/api_guide/getting_started.html)
