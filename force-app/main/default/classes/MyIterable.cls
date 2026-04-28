public class MyIterable Implements Iterable<String>{
	private List<String> strings;
    
    public MyIterable(List<String> strings){
        this.strings = strings;
    }
    
    public Iterator<String> iterator() {
      return strings.iterator();
   }
}