package servlet;

import java.io.IOException;
import java.util.Locale;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.CurrencyResponse;
import service.CurrencyService;

public class CurrencyServlet extends HttpServlet {

    private final CurrencyService currencyService = new CurrencyService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        setViewModel(request, "", "USD", "INR");
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String amountRaw = safeTrim(request.getParameter("amount"));
        String from = normalize(request.getParameter("from"));
        String to = normalize(request.getParameter("to"));

        setViewModel(request, amountRaw, from, to);

        try {
            CurrencyResponse conversion = currencyService.convert(amountRaw, from, to);
            double directRate = conversion.getAmount() == 0
                    ? 0
                    : conversion.getConvertedAmount() / conversion.getAmount();

            request.setAttribute("result", String.format(
                    Locale.US,
                    "%,.2f %s = %,.2f %s",
                    conversion.getAmount(),
                    conversion.getFromCurrency(),
                    conversion.getConvertedAmount(),
                    conversion.getToCurrency()));
            request.setAttribute("resultDetail", String.format(
                    Locale.US,
                    "1 %s = %.4f %s",
                    conversion.getFromCurrency(),
                    directRate,
                    conversion.getToCurrency()));
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
        }

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    private void setViewModel(HttpServletRequest request, String amountRaw, String from, String to) {
        request.setAttribute("amountValue", amountRaw);
        request.setAttribute("fromValue", from.isEmpty() ? "USD" : from);
        request.setAttribute("toValue", to.isEmpty() ? "INR" : to);
        request.setAttribute("currencies", currencyService.getSupportedCurrencies());
        request.setAttribute("rates", currencyService.getRatesToInr());
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    private String normalize(String currency) {
        return safeTrim(currency).toUpperCase();
    }
}
