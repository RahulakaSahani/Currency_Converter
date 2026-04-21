package service;

import model.CurrencyResponse;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

class CurrencyServiceTest {

    private final CurrencyService currencyService = new CurrencyService();

    @Test
    void shouldConvertUsdToInr() {
        CurrencyResponse response = currencyService.convert("10", "USD", "INR");

        assertEquals(10.0, response.getAmount());
        assertEquals("USD", response.getFromCurrency());
        assertEquals("INR", response.getToCurrency());
        assertEquals(832.0, response.getConvertedAmount(), 0.0001);
    }

    @Test
    void shouldRejectEmptyAmount() {
        IllegalArgumentException exception = assertThrows(
                IllegalArgumentException.class,
                () -> currencyService.convert(" ", "USD", "INR"));

        assertEquals("Amount is required.", exception.getMessage());
    }

    @Test
    void shouldRejectNegativeAmount() {
        IllegalArgumentException exception = assertThrows(
                IllegalArgumentException.class,
                () -> currencyService.convert("-1", "USD", "INR"));

        assertEquals("Amount cannot be negative.", exception.getMessage());
    }

    @Test
    void shouldRejectUnsupportedCurrency() {
        IllegalArgumentException exception = assertThrows(
                IllegalArgumentException.class,
                () -> currencyService.convert("100", "AUD", "INR"));

        assertEquals("Supported currencies: INR, USD, EUR, GBP, JPY", exception.getMessage());
    }
}
