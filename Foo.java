// Copyright statement

package com.google.common.base;

import static java.util.concurrent.TimeUnit.MILLISECONDS;
import static java.util.concurrent.TimeUnit.SECONDS;

import java.util.List;
import java.util.Map;
import java.util.concurrent.*;

/**
 * Class-level javadoc
 * @author foo
 */
@SomeAnnotation("bar")
public class Foo<T extends Foo<T>> extends Bar<List<T>> implements Baz, Qux<T> {

  @FieldType(type = Thingy.FOO)
  private static final int MY_NUM;

  @FlagSpec(name = "foo", count = 23)
  private static final Flag<String> myFlag = Flag.value("blah");

  static {
    MY_NUM = 54;
  }

  public enum Thingy implements Bar<Integer> {
    ABC,
    DEF(23),
    GHI {
      @Override public void run() {}
    };
    public void run() {
        execute(x);  // TODO(sdh): FOR SOME REASON, passing an argument makes us think execute is a primary rather than a method...?
    }
    JKL() {
      public final Thingy next = ABC;
    },;
    Thingy() {}
    Thingy(int num) {}
  }

  /** Some more javadoc */  
}
;
