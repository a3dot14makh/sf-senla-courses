public class ExceptionsPlayground {
    public class CusomException extends Exception {
    }
    public static void generateCustomException() {
        Integer i = 0;
        if (i != 2)
          throw new CusomException('EROR 404');
    }

    public static void generateRegularException() { 
        Integer i = 1 / 0;
    }

    public static void handleExceptions() {
      try {
        generateCustomException();
        generateRegularException();
      }catch(Exception ex){
          System.debug(' Don\'t Worry, Be Happy ');  
      } 
    }
}
