package spec;

import com.typesafe.config.Config;
import com.typesafe.config.ConfigFactory;

public class CheckTypesafeConfig {
  public static void main(String [] args) {
    Config conf = ConfigFactory.load();
    String myvalue = conf.getString("mykey");
    System.out.print(myvalue);
  }
}
