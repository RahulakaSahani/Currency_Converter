package service;

import client.CurrencyApiClient;
import model.CurrencyResponse;

import java.util.List;
import java.util.Map;

public class CurrencyService {

    private static final List<String> SUPPORTED_CURRENCIES = List.of("INR", "USD", "EUR", "GBP", "JPY");

    private final CurrencyApiClient currencyApiClient;

    public CurrencyService() {
        this.currencyApiClient = new CurrencyApiClient();
    }

    public CurrencyResponse convert(String amountRaw, String fromRaw, String toRaw) {
        if (amountRaw == null || amountRaw.trim().isEmpty()) {
            throw new IllegalArgumentException("Amount is required.");
        }

        double amount;
        try {
            amount = Double.parseDouble(amountRaw.trim());
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Amount must be a valid number.");
        }

        if (amount < 0) {
            throw new IllegalArgumentException("Amount cannot be negative.");
        }

        String from = normalize(fromRaw);
        String to = normalize(toRaw);

        if (!SUPPORTED_CURRENCIES.contains(from) || !SUPPORTED_CURRENCIES.contains(to)) {
            throw new IllegalArgumentException("Supported currencies: INR, USD, EUR, GBP, JPY");
        }

        Map<String, Double> rateToInr = currencyApiClient.fetchRatesToInr();
        Double fromRate = rateToInr.get(from);
        Double toRate = rateToInr.get(to);

        if (fromRate == null || toRate == null) {
            throw new IllegalStateException("Exchange rates are unavailable right now.");
        }

        double amountInInr = amount * fromRate;
        double convertedAmount = amountInInr / toRate;

        return new CurrencyResponse(amount, from, to, convertedAmount);
    }

    public List<String> getSupportedCurrencies() {
        return SUPPORTED_CURRENCIES;
    }

    public Map<String, Double> getRatesToInr() {
        return currencyApiClient.fetchRatesToInr();
    }

    private String normalize(String currency) {
        if (currency == null) {
            return "";
        }
        return currency.trim().toUpperCase();
    }
}
