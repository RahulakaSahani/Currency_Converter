package client;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;

public class CurrencyApiClient {

    private static final Map<String, Double> RATE_TO_INR;

    static {
        Map<String, Double> rates = new LinkedHashMap<>();
        rates.put("INR", 1.0);
        rates.put("USD", 83.20);
        rates.put("EUR", 90.50);
        rates.put("GBP", 105.00);
        rates.put("JPY", 0.56);
        RATE_TO_INR = Collections.unmodifiableMap(rates);
    }

    public Map<String, Double> fetchRatesToInr() {
        return RATE_TO_INR;
    }
}
