package spec;

import java.util.Properties;

public class CheckProperties {
  public static void main(String [] args) {
    Properties properties = System.getProperties();
	  properties.forEach((k, v) -> System.out.println(k + ":" + v));
  }
}
