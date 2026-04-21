package model;

public class CurrencyResponse {

    private final double amount;
    private final String fromCurrency;
    private final String toCurrency;
    private final double convertedAmount;

    public CurrencyResponse(double amount, String fromCurrency, String toCurrency, double convertedAmount) {
        this.amount = amount;
        this.fromCurrency = fromCurrency;
        this.toCurrency = toCurrency;
        this.convertedAmount = convertedAmount;
    }

    public double getAmount() {
        return amount;
    }

    public String getFromCurrency() {
        return fromCurrency;
    }

    public String getToCurrency() {
        return toCurrency;
    }

    public double getConvertedAmount() {
        return convertedAmount;
    }
}
