/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Knox-nethan Aviles
 */


public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        // Create a new Account instance
       Account acc = new Account();
        // Set some fields on the Account
        acc.Name = 'Knox';
        acc.Phone = '4074880195';
        // Insert the Account into the database
        Insert acc;
        // Return the Id of the newly created Account
        return acc.Id;
    }
    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account and set the fields inline
        Account acc = new Account();
        acc.Name = name;
        acc.Industry = industry;
        // Insert the Account
        insert acc;
    }
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance
        Contact ccc = new Contact();
        // Set some fields on the Contact
        ccc.FirstName = 'John';
        ccc.LastName = 'Anderson';
        ccc.AccountId = accountId;  // Set the AccountId field to the given accountId
        // Insert the Contact into the database
        Insert ccc;
        // Return the Id of the newly created Contact
        return ccc.id;
    }
    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database
        List<Contact> contacts = [SELECT Id, firstName, lastName FROM contact WHERE Id = :contactId];
        // [SELECT Id FROM Contact WHERE Id = :contactId]
         if(!contacts.isEmpty()){
            Contact contactToUpdate = contacts[0];
            contactToUpdate.LastName = newLastName;
            Update contactToUpdate;
         }
    }
    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
        // [SELECT Id FROM Opportunity WHERE Id = :oppId]
        List<Opportunity> opportunity = [SELECT Id, Name FROM opportunity WHERE Id = :oppId];
        // Update the Opportunity's stage
           Opportunity opportunityUpdateStage = Opportunity[0];
           opportunityUpdateStage.StageName = newStage;
        // Update the Opportunity in the database
         Update opportunityUpdateStage;
    }
    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        // Query the account
        // [SELECT Id FROM Account WHERE Id = :accountId]
         List<Account> accList = [SELECT Id, Name,Industry FROM Account WHERE Id = :accountId];
        // Update the Account with the given Id with the new name and industry
          Account accountToUpdate = accList[0];
          accountToUpdate.Id = accountId;
          accountToUpdate.name = newName;
          accountToUpdate.Industry = newIndustry;
          Update accountToUpdate;
    }
    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
          for(opportunity opp: opportunities){
            opp.StageName = 'Qualification';
            opp.CloseDate = Date.today().addMonths(3);
            opp.Amount = 50000;
          }
          //Updating an existing Opportunity
          List<Opportunity> existingOpportunity = [SELECT Id, Name, StageName 
          FROM Opportunity 
          WHERE Name = 'Opp2'
          Limit 1];
          // If opportunity is greater zero run this condition
          if(existingOpportunity.size() > 0){
            Opportunity updateOpportunity = existingOpportunity[0];
            updateOpportunity.stageName = 'Qualification';
            opportunities.add(updateOpportunity);
          }
        // Upsert the opportunities List so that records are either updated or created
        upsert opportunities;
    }

    /**
     * Question 8
     * Insert or updates opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
            public static void upsertOpportunities(String accountName, List<String> oppNames) {
           
                // Query accountName
            Account acc = [SELECT Id FROM Account WHERE Name =: accountName LIMIT 1];
            
                  // Assert that the account is not null
            System.assert(acc == null, 'Account with name ' + accountName + ' not found.');
            
            
            if(acc != null) {
                List<Opportunity> opportunitiesToUpsert = new List<Opportunity>();
                // Loop through each Opportunity name
                for(String oppName : oppNames) {
                    Opportunity opp = new Opportunity ();
                    opp.Name = oppName;
                    opp.AccountId = acc.Id;
                    opportunitiesToUpsert.add(opp); // Add the Opportunity to the list
                }
                upsert opportunitiesToUpsert;  // Create an Opportunity with the given name
            }   
                
            }
    
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {
		// Query for the Account
		List<Account> accounts = [SELECT Id FROM Account WHERE Name = :accountName];
        Account upsertAccount;
		// if the Account exists, update the description
        if(!accounts.isEmpty()) {  
           Account existingAccount = accounts[0]; // Finding the existing account in the list by index
           existingAccount.description = 'Updated Account'; 
           Update existingAccount;  // Update the existing account into production
           upsertAccount = existingAccount;
           
        }else{
            Account newAccount = New Account();
            newAccount.name = accountName;
            newAccount.description = 'New Account';
            Insert newAccount; // Insert the new account into production
            upsertAccount = newAccount;
        }
		// otherwise, create a new Account and set the description
          
		// Upsert the Account
	      return upsertAccount;
	}
        /**
         * Question 10
         * Manage the association between Contacts and Accounts
         * Ensure that for each Contact in the provided list, there is a corresponding Account Name that matches the Contact's last name.
         * If such an Account does not exist, the method creates it; if it does, the method ensures the Contact is associated with it. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
         * Example Contact.LastName = 'Doe' Link to Account.Name = 'Doe' 
         * Example Contact.LastName = 'Jane' Link to Account.Name = 'Jane'
         * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
         */
        public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
            List<Account> accToStore = new List<Account>();
            // Loop through each Contact
            for(Contact contact : contactsToUpsert) {
                String lastName = contact.LastName; // Corrected to LastName (not lastName)
                Account upsertAccount;
                //Query account with name that equals the last name
                List<Account> matchingAccounts = [SELECT Id FROM Account WHERE Name = :lastName];
                if(!matchingAccounts.isEmpty()) { // check if the last name equals the same as the account name
                    upsertAccount = matchingAccounts[0];
                } else {
                    upsertAccount = new Account(Name = lastName); // This will create the Account with the same last name as the contact name
                    accToStore.add(upsertAccount);
                }
            }
            // Loop through contacts to link them to their respective accounts
            for (Contact contact : contactsToUpsert) {
                Account relatedAccount;
                for(Account account : accToStore) {
                    if(account.Name == contact.LastName) {
                        relatedAccount = account;
                        break;
                    }
                }
                // Link contact to its account
                contact.AccountId = relatedAccount.Id;
            }
            // Upsert the contacts
            upsert contactsToUpsert;
        }

    }

        /**
         * Question 11
         * Insert a list of Leads and then deletes them.
         * @param leadNames The list of Lead names to be inserted.
         */
        public static void insertAndDeleteLeads(List<String> leadNames) {
            // Loop through each Lead name
            List<Lead> leadList = [SELECT Id, Name FROM Lead WHERE name =: leadNames];
            for(String leadName : leadNames) {
                insert leadlist;   // Insert the Leads
            }
                // Delete the Leads
                delete leadlist;
        } 
    
        /**
         * Question 12
         * Dynamically create the number of cases and relate it to the accountId, then deletes them.
         * @param accountId The account for which the cases will be created and then deleted.
         * @param numOfCases The number of cases to create.
         */
        public static void createAndDeleteCases(String accountId, Integer numOfCases) {
            List<Case> newCase = new List<Case>();
            for(Integer i = numOfCases; i < 5; i++) {
                Case case = new Case();
                case.accountId = accountId;
                case.subject = 'case' + i;
                newCase.add(case);
            }
            // Insert the cases
            if(!newCase.isEmpty()) {
                insert newCase;
            }
            // Delete the cases
            if(!newCase.isEmpty()) {
                delete newCase;
            }
    }