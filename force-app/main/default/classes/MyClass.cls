public class MyClass {
    public class CustomException extends Exception {}

    public static void methodThatThrowsException() {
        throwsExtecption();
    }
    
    private static void throwsExtecption(){
        Integer a = 1/0;
    }
}