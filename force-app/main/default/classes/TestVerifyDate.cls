@isTest
private class TestVerifyDate {
    
    @isTest
    static void testCheckDates_Date2Within30Days() {
        // Test scenario where date2 is within 30 days of date1
        Date date1 = Date.today();
        Date date2 = date1.addDays(15); // date2 is 15 days after date1
        Date result = VerifyDate.CheckDates(date1, date2);
        System.assertEquals(date2, result, 'Expected date2 to be returned');
    }
    
    @isTest
    static void testCheckDates_Date2After30Days() {
        // Test scenario where date2 is more than 30 days after date1
        Date date1 = Date.today();
        Date date2 = date1.addDays(35); // date2 is 35 days after date1
        Date endOfMonth = Date.newInstance(date1.year(), date1.month(), Date.daysInMonth(date1.year(), date1.month()));
        Date result = VerifyDate.CheckDates(date1, date2);
        System.assertEquals(endOfMonth, result, 'Expected end of month to be returned');
    }
    
    @isTest
    static void testCheckDates_Date2BeforeDate1() {
        // Test scenario where date2 is before date1
        Date date1 = Date.today();
        Date date2 = date1.addDays(-5); // date2 is 5 days before date1
        Date endOfMonth = Date.newInstance(date1.year(), date1.month(), Date.daysInMonth(date1.year(), date1.month()));
        Date result = VerifyDate.CheckDates(date1, date2);
        System.assertEquals(endOfMonth, result, 'Expected end of month to be returned');
    }
    
    
}