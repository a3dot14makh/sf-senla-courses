public class NumberUtility {
  public static List<Integer> showPrimeNumbers(Integer enteredNumber) {
    if (enteredNumber <= 1) {
      return new List<Integer>();
    }
    //Метод решения - "Решето Эратосфена"
    List<Integer> listOfPrimeNumbers = new List<Integer>();
    List<Integer> startList = new List<Integer>(enteredNumber + 1);

    for (Integer i = 2; i <= enteredNumber; i++) {
      startList[i] = 1;
    }
    for (Integer i = 2; i <= enteredNumber; i++) {
      if (startList[i] == 1) {
        for (Integer j = i * i; j <= enteredNumber; j = j + i) {
          startList[j] = 0;
        }
        listOfPrimeNumbers.add(i);
      }
    }
    return listOfPrimeNumbers;
  }

  public static List<Integer> fibonacciNumbers(Integer enteredNumber) {
    if (enteredNumber <= 1) {
      return new List<Integer>();
    }

    List<Integer> listFibonacciNumbers = new List<Integer>{ 1, 1 };
    Integer x = 1;
    Integer y = 1;

    for (Integer i = 2; i < enteredNumber; i++) {
      y = x + y;
      x = y - x;
      listFibonacciNumbers.add(y);
    }

    return listFibonacciNumbers;
  }

  public static Boolean checkingNumberForPalindromicity(Integer enteredNumber) {
    String num = String.valueOf(enteredNumber);
    String numReverse = num.reverse();

    return (num == numReverse);
  }
}
