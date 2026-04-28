@isTest
private class MyClassTest {
    @isTest
    static void testMathException() {
        Boolean mathExceptionThrown = false;
        try {
            MyClass.methodThatThrowsException();
        } catch (System.MathException ex) {
            mathExceptionThrown = true;
            System.assert(ex.getMessage().contains('Divide by 0'), 'Unexpected exception message: ' + ex.getMessage());
        }
        System.assert(mathExceptionThrown, 'MathException was not thrown as expected');
    }
    
    @isTest
    static void testCustomException() {
        Boolean exceptionThrown = false;
        try {
            MyClass.methodThatThrowsException();
        } catch (MyClass.CustomException ex) {
            exceptionThrown = true;
            System.assertEquals('Expected message', ex.getMessage());
        }
        System.assert(exceptionThrown, 'Custom exception was not thrown');
    }
}