# 📧 Constant Contact Integration for Salesforce
## 📊✨ Summary:
This Salesforce integration enables seamless data flow between Salesforce and Constant Contact, allowing for automated event and event registration management. With this solution, users can synchronize event lists and registrant information directly from Salesforce to Constant Contact, maintaining an active connection. Automated token management ensures uninterrupted data updates.

## 🛠️ Features
* **Automated Token Management**: Refreshes access tokens every 24 hours to ensure continuous connectivity.
* **Event List Synchronization**: Automatically creates Constant Contact event lists based on Salesforce event data.
* **Registrant Management**: Adds and updates event registrants as contacts within Constant Contact, directly from Salesforce.
* **API Request Handling**: Implements secure OAuth 2.0 token handling, with dynamic refresh capability using Named Credentials.

## 📝 Using the Integration
* 🎥 Watch the minute video demo [Salesforce Contact Integration](https://drive.google.com/file/d/1YxndPJ09ljkylPQUS9Y-aLOKvYS4Y1VF/view?usp=sharing) on how to use the integration  
  
### **Instructions**
1. Log in to the live environment [here](https://integration-experts-dev-ed.my.site.com/s/).
2. Take 30 seconds to read the **Data Purge Policy**.
3. In the navigation bar, click the **Event** tab.
4. Click the **New** button in the top-right corner.
5. Enter a name for the event (e.g., **How to Start a Business**) and fill in the remaining required fields marked with a red asterisk (*). Then, click **Save**.
6. Click the **Contacts** tab to open the contacts list view. Note the full name of one contact—you'll need it in **Step 8** below.
7. Click the **Event** tab, then click the name of the event you created earlier. **Expected:** The **Event Contact List Name** and **Event Contact List Id** fields are blank.
9. In the **Event** record, go to the **Related** tab and click **New**. Begin typing the first name of the contact you noted in **Step 6**; their record should appear in the **Registrants** field.
11. Select the contact’s full name and click **Save**.
12. Under the **View Record** column, click **View** to open the **Event Registration** record.**Expected:**: Confirm that the **Contact Id – Constant Contact** field contains the contact ID returned from the Constant Contact API.
13. Click the event name link under the **Event** field to return to the **Event** record.**Expected**: On the Event record, verify that both the **Event Contact List Name** and **Event Contact List Id** fields are populated with data returned from the Constant Contact API.

## ⌛️ Access Token Expiration
* Tokens expire after 1,440 minutes (24 hours); refresh logic is included to keep the integration active. 
