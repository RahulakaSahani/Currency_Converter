package servlet;

import java.io.IOException;
import java.util.Locale;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.CurrencyResponse;
import service.CurrencyService;

public class CurrencyApiServlet extends HttpServlet {

    private final CurrencyService currencyService = new CurrencyService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");

        String amount = request.getParameter("amount");
        String from = request.getParameter("from");
        String to = request.getParameter("to");

        try {
            CurrencyResponse conversion = currencyService.convert(amount, from, to);

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(String.format(
                    Locale.US,
                    "{\"amount\":%.2f,\"from\":\"%s\",\"to\":\"%s\",\"convertedAmount\":%.2f}",
                    conversion.getAmount(),
                    escapeJson(conversion.getFromCurrency()),
                    escapeJson(conversion.getToCurrency()),
                    conversion.getConvertedAmount()));
        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Unexpected server error.\"}");
        }
    }

    private String escapeJson(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
