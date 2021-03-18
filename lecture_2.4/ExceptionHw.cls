public with sharing class ExceptionHw {
  public class CusomException extends Exception {
  }
  public static void testExceptionOne() {
    try {
      Integer i = 0;
      if (i != 2)
        throw new CusomException('EROR 404');
    } catch (CusomException ex) {
      System.debug(ex.getMessage());
    }
  }
  public static void testExceptionTwo() {
    try {
      Integer i = 1 / 0;
    } catch (Exception ex) {
      System.debug(ex.getMessage());
    }
  }
  public static void testExceptionThree() {
    try {
      testExceptionOne();
      testExceptionTwo();
    } finally {
      System.debug('Dont Worry, Be Happy');
    }
  }
}
