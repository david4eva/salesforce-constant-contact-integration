# 📧 Salesforce Constant Contact Integration
## 📊✨ Summary:
This Salesforce integration enables seamless data flow between Salesforce and Constant Contact, allowing for automated event and event registration management. With this solution, users can synchronize event lists and registrant information directly from Salesforce to Constant Contact, maintaining an active connection. Automated token management ensures uninterrupted data updates.

## 🛠️ Features
* **Automated Token Management**: Refreshes access tokens every 24 hours to ensure continuous connectivity.
* **Event List Synchronization**: Automatically creates Constant Contact event lists based on Salesforce event data.
* **Registrant Management**: Adds and updates event registrants as contacts within Constant Contact, directly from Salesforce.
* **API Request Handling**: Implements secure OAuth 2.0 token handling, with dynamic refresh capability using Named Credentials.

## 📝 Using the Integration
  
### **Instructions**
1. Log in to the public Experience site [here](https://integration-experts-dev-ed.my.site.com/s/). No authentication required.
2. Take 30 seconds to read the **Data Purge Policy** on the home page.
3. Click the **Contacts** tab to open the contacts list view. <img width="1728" alt="2024-11-08_07-32-10 (1)" src="https://github.com/user-attachments/assets/2825ffc1-c73f-4598-9e43-a6e0ee9af3af">
4. Click the **New** button in the top-right corner to create a new contact.<img width="1728" alt="2024-11-08_07-32-44" src="https://github.com/user-attachments/assets/62e5c4ae-c306-41ef-a06b-e9a250052b8f">

## ⚠️ Limitations
* Refer to the [Constant Contact Rate Limits](https://developer.constantcontact.com/api_guide/rate_limits.html#:~:text=You%20can%20use%20your%20API,and%204%20requests%20per%20second.) for more information on the Constant Contact API limits.

## ⌛️ Access Token Expiration
* Tokens expire after 1,440 minutes (24 hours); refresh logic is included to keep the integration active.

## 📚 Documentation
This project was developed using various documentation resources that provide essential guidance on setup, functionality, and best practices. Below are some key references:

- **Official Salesforce Documentation**: Comprehensive guide on Salesforce APIs, development best practices, and integration techniques.  
  [Salesforce Future Method](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_invoking_future_methods.htm)  
  [Testing HTTP Callouts](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_restful_http_testing.htm)

- **Constant Contact API Documentation**: Detailed information on API endpoints and authentication for seamless integration.  
  [Constant Contact API Reference](https://v3.developer.constantcontact.com/api_guide/getting_started.html)
