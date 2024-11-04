// Wrapper class for sending data to /sign_up_form endpoint
public without sharing class Constant_Contact_Integration_Wrapper {
    // eventListWrapper object properties
    public String name;

    // registrantListWrapper object properties
    public String email_address;
    public String first_name;
    public String last_name;
    public String phone_numbers { get; set; }
    public Map<String, String> street_address { get; set; }
    public String[] list_memberships { get; set; }

    // eventListWrapper object
    public Constant_Contact_Integration_Wrapper(String listName) {
        this.name = listName;
    }

    // registrantListWrapper object
    public Constant_Contact_Integration_Wrapper(
            String email, String firstName, String lastName, String phone,
            String addressKind, String mailingStreet, String mailingCity, String mailingState,
            String mailingPostalCode, String country, String listId
    ) {
        this.email_address = email;
        this.first_name = firstName;
        this.last_name = lastName;
        this.phone_numbers = phone;
        this.street_address = new Map<String, String>{
                'country' => country,
                'postal_code' => mailingPostalCode,
                'state' => mailingState,
                'city' => mailingCity,
                'street' => mailingStreet,
                'kind' => addressKind
        };
        this.list_memberships = new String[]{
                listId
        };
    }
}