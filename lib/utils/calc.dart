import 'dart:math';

class Calculate {
  const Calculate._();

  static num derivativeTerm(String pTerm, int val) {
    // Get coefficient
    String coeffStr = "";
    int i;
    for (i = 0; pTerm[i] != 'x'; i++) {
      if (pTerm[i] == ' ') continue;
      coeffStr += pTerm[i];
    }

    print("COEFF STR: " + coeffStr);

    num coeff = num.parse(coeffStr);

    // Get Power (Skip 2 characters for x and ^)
    String powStr = "";
    for (i = i + 2; i != pTerm.length && pTerm[i] != ' '; i++) {
      powStr += pTerm[i];
    }

    num power = num.parse(powStr);

    // For ax^n, we return a(n)x^(n-1)
    return coeff * power * pow(val, power - 1);
  }

  static num derivativeVal(String poly, int val) {
    num ans = 0;

    int i = 0;
    final stSplit = poly.split("+");
    while (i < stSplit.length) {
      ans = (ans + derivativeTerm(stSplit[i], val));
      i++;
    }
    return ans;
  }
}
