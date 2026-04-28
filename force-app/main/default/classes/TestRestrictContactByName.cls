@isTest
public class TestRestrictContactByName {
    @isTest
    static void testValidLastName() {
        // Test a valid last name
        Contact validContact = new Contact(LastName = 'Smith');
        insert validContact;
        // No error should be added
        System.assertEquals(null, validContact.getErrors());
    }
    
    @isTest
    static void testInvalidLastName() {
        // Test an invalid last name
        Contact invalidContact = new Contact(LastName = 'INVALIDNAME');
        Test.startTest();
        try {
            insert invalidContact;
            // The above line should throw an exception due to the validation rule
            System.assert(false, 'An exception should have been thrown');
        } catch (DmlException e) {
            // Verify that the error message is as expected
            System.assertEquals('The Last Name "INVALIDNAME" is not allowed for DML', e.getDmlMessage(0));
        }
        Test.stopTest();
    }
    
    @isTest
    static void testUpdateWithInvalidLastName() {
        // Test updating a contact with an invalid last name
        Contact invalidContact = new Contact(LastName = 'Doe');
        insert invalidContact;
        
        invalidContact.LastName = 'INVALIDNAME';
        Test.startTest();
        try {
            update invalidContact;
            // The above line should throw an exception due to the validation rule
            System.assert(false, 'An exception should have been thrown');
        } catch (DmlException e) {
            // Verify that the error message is as expected
            System.assertEquals('The Last Name "INVALIDNAME" is not allowed for DML', e.getDmlMessage(0));
        }
        Test.stopTest();
    }
}