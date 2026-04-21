<%@ page import="java.util.List,java.util.Map,java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String amountValue = (String) request.getAttribute("amountValue");
    if (amountValue == null) {
        amountValue = request.getParameter("amount");
    }
    if (amountValue == null) {
        amountValue = "";
    }

    String fromValue = (String) request.getAttribute("fromValue");
    if (fromValue == null || fromValue.isEmpty()) {
        fromValue = request.getParameter("from");
    }
    if (fromValue == null || fromValue.isEmpty()) {
        fromValue = "USD";
    }
    fromValue = fromValue.toUpperCase();

    String toValue = (String) request.getAttribute("toValue");
    if (toValue == null || toValue.isEmpty()) {
        toValue = request.getParameter("to");
    }
    if (toValue == null || toValue.isEmpty()) {
        toValue = "INR";
    }
    toValue = toValue.toUpperCase();

    String result = (String) request.getAttribute("result");
    String resultDetail = (String) request.getAttribute("resultDetail");
    String error = (String) request.getAttribute("error");

    List<String> currencies = (List<String>) request.getAttribute("currencies");
    if (currencies == null || currencies.isEmpty()) {
        currencies = java.util.List.of("INR", "USD", "EUR", "GBP", "JPY");
    }

    if (toValue.equals(fromValue)) {
        for (String currency : currencies) {
            if (!currency.equals(fromValue)) {
                toValue = currency;
                break;
            }
        }
    }

    Map<String, Double> rates = (Map<String, Double>) request.getAttribute("rates");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Currency Exchange Studio</title>
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&family=Space+Grotesk:wght@500;700&display=swap");

        :root {
            --bg-900: #07131c;
            --bg-800: #102432;
            --surface: rgba(255, 255, 255, 0.1);
            --surface-strong: rgba(255, 255, 255, 0.16);
            --text-main: #f5f8fa;
            --text-soft: #a8bbc8;
            --teal: #27c7ba;
            --cyan: #7fe0f8;
            --amber: #f7b843;
            --danger: #ff6565;
            --ring: rgba(127, 224, 248, 0.5);
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            color: var(--text-main);
            font-family: "Manrope", "Segoe UI", sans-serif;
            background:
                radial-gradient(circle at 10% 20%, rgba(39, 199, 186, 0.28), transparent 38%),
                radial-gradient(circle at 88% 12%, rgba(247, 184, 67, 0.2), transparent 40%),
                linear-gradient(135deg, var(--bg-900), var(--bg-800));
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
        }

        .bg-grid {
            position: fixed;
            inset: 0;
            pointer-events: none;
            background-image:
                linear-gradient(rgba(255, 255, 255, 0.04) 1px, transparent 1px),
                linear-gradient(90deg, rgba(255, 255, 255, 0.04) 1px, transparent 1px);
            background-size: 34px 34px;
            mask-image: radial-gradient(circle at center, black 40%, transparent 85%);
        }

        .layout {
            width: min(1060px, 100%);
            display: grid;
            grid-template-columns: 1.05fr 1fr;
            gap: 24px;
            position: relative;
            z-index: 1;
        }

        .hero {
            padding: 28px;
            border-radius: 24px;
            background: linear-gradient(155deg, rgba(255, 255, 255, 0.13), rgba(255, 255, 255, 0.05));
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 24px 70px rgba(0, 0, 0, 0.35);
            animation: reveal 0.8s ease-out both;
        }

        .eyebrow {
            margin: 0;
            letter-spacing: 0.18em;
            text-transform: uppercase;
            color: var(--cyan);
            font-size: 0.72rem;
            font-weight: 700;
        }

        h1 {
            margin: 12px 0 10px;
            font-family: "Space Grotesk", "Trebuchet MS", sans-serif;
            font-size: clamp(2rem, 4vw, 3.1rem);
            line-height: 1.05;
        }

        .subtext {
            margin: 0;
            color: var(--text-soft);
            max-width: 44ch;
            line-height: 1.6;
        }

        .chip-wrap {
            margin-top: 20px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .chip {
            padding: 8px 12px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.24);
            font-size: 0.84rem;
            font-weight: 700;
            color: var(--text-main);
        }

        .panel {
            padding: 24px;
            border-radius: 24px;
            background: linear-gradient(180deg, rgba(3, 14, 22, 0.8), rgba(3, 14, 22, 0.55));
            border: 1px solid rgba(255, 255, 255, 0.12);
            box-shadow: 0 24px 70px rgba(0, 0, 0, 0.35);
            animation: reveal 1s ease-out both;
        }

        .converter-form {
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .field label {
            display: block;
            margin-bottom: 8px;
            font-size: 0.82rem;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            color: var(--text-soft);
            font-weight: 700;
        }

        .field input,
        .field select {
            width: 100%;
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            background: rgba(255, 255, 255, 0.08);
            color: var(--text-main);
            font-size: 1rem;
            padding: 13px 14px;
            outline: none;
            transition: 0.2s ease;
        }

        .field select option,
        .field select optgroup {
            background-color: #0a1d28;
            color: #e6f9ff;
            font-weight: 700;
        }

        .field.select-field {
            position: relative;
        }

        .field.select-field select {
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            color-scheme: dark;
            padding-right: 44px;
            font-weight: 700;
            letter-spacing: 0.02em;
            border-color: rgba(127, 224, 248, 0.35);
            background:
                linear-gradient(160deg, rgba(255, 255, 255, 0.16), rgba(255, 255, 255, 0.06)),
                rgba(255, 255, 255, 0.08);
            box-shadow:
                inset 0 0 0 1px rgba(255, 255, 255, 0.06),
                0 8px 20px rgba(0, 0, 0, 0.22);
        }

        .field.select-field::after {
            content: "";
            position: absolute;
            right: 14px;
            top: 58%;
            width: 0;
            height: 0;
            border-left: 6px solid transparent;
            border-right: 6px solid transparent;
            border-top: 7px solid var(--cyan);
            pointer-events: none;
            filter: drop-shadow(0 0 6px rgba(127, 224, 248, 0.4));
            transition: transform 0.2s ease;
        }

        .field.select-field:hover select {
            border-color: rgba(127, 224, 248, 0.55);
            box-shadow:
                inset 0 0 0 1px rgba(255, 255, 255, 0.12),
                0 10px 24px rgba(0, 0, 0, 0.26);
        }

        .field.select-field:focus-within::after {
            transform: translateY(-2px);
        }

        .field.select-field select::-ms-expand {
            display: none;
        }

        .field.select-field select option:checked {
            background-color: #145365;
            color: #e6ffff;
        }

        .field.select-field select option:hover,
        .field.select-field select option:focus {
            background-color: #103f4f;
            color: #e6ffff;
        }

        .field input:focus,
        .field select:focus {
            border-color: var(--cyan);
            box-shadow: 0 0 0 4px var(--ring);
            transform: translateY(-1px);
        }

        .pair-row {
            display: grid;
            grid-template-columns: 1fr auto 1fr;
            align-items: end;
            gap: 10px;
        }

        .swap-btn {
            height: 46px;
            width: 46px;
            border: none;
            border-radius: 50%;
            cursor: pointer;
            font-size: 1.1rem;
            font-weight: 800;
            color: #06393b;
            background: linear-gradient(135deg, var(--teal), var(--cyan));
            box-shadow: 0 10px 24px rgba(39, 199, 186, 0.35);
            transition: 0.18s ease;
        }

        .swap-btn:hover {
            transform: translateY(-2px) rotate(-6deg);
        }

        .cta {
            margin-top: 8px;
            padding: 13px 16px;
            border: none;
            border-radius: 12px;
            font-size: 0.98rem;
            font-weight: 800;
            letter-spacing: 0.02em;
            cursor: pointer;
            color: #042429;
            background: linear-gradient(135deg, var(--teal), #53f2e4);
            box-shadow: 0 14px 28px rgba(39, 199, 186, 0.35);
            transition: 0.2s ease;
        }

        .cta:hover {
            transform: translateY(-2px);
            filter: saturate(1.08);
        }

        .feedback {
            margin-top: 18px;
            border-radius: 14px;
            padding: 14px 16px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            animation: rise 0.45s ease both;
        }

        .feedback h2 {
            margin: 0 0 8px;
            font-size: 0.92rem;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--text-soft);
        }

        .feedback .value {
            margin: 0;
            font-size: 1.2rem;
            font-weight: 800;
            line-height: 1.35;
        }

        .feedback .detail {
            margin: 8px 0 0;
            color: var(--text-soft);
            font-size: 0.9rem;
        }

        .feedback.success {
            background: rgba(39, 199, 186, 0.11);
            border-color: rgba(39, 199, 186, 0.45);
        }

        .feedback.error {
            background: rgba(255, 101, 101, 0.1);
            border-color: rgba(255, 101, 101, 0.5);
            color: #ffd5d5;
        }

        .rates {
            margin-top: 18px;
        }

        .rates h3 {
            margin: 0;
            font-family: "Space Grotesk", "Trebuchet MS", sans-serif;
            font-size: 1rem;
        }

        .rates p {
            margin: 6px 0 12px;
            color: var(--text-soft);
            font-size: 0.88rem;
        }

        .rates-grid {
            display: grid;
            grid-template-columns: repeat(5, minmax(0, 1fr));
            gap: 10px;
        }

        .rate-card {
            border-radius: 12px;
            padding: 10px 8px;
            background: var(--surface);
            border: 1px solid rgba(255, 255, 255, 0.16);
            text-align: center;
            animation: rise 0.5s ease both;
        }

        .rate-card:nth-child(2) { animation-delay: 0.04s; }
        .rate-card:nth-child(3) { animation-delay: 0.08s; }
        .rate-card:nth-child(4) { animation-delay: 0.12s; }
        .rate-card:nth-child(5) { animation-delay: 0.16s; }

        .rate-card .currency {
            display: block;
            font-size: 0.76rem;
            font-weight: 700;
            color: var(--text-soft);
            letter-spacing: 0.08em;
        }

        .rate-card .rate {
            display: block;
            margin-top: 4px;
            font-family: "Space Grotesk", "Trebuchet MS", sans-serif;
            font-size: 1rem;
            font-weight: 700;
            color: #fef9e8;
        }

        @keyframes reveal {
            from {
                opacity: 0;
                transform: translateY(18px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes rise {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @media (max-width: 980px) {
            .layout {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 720px) {
            body {
                padding: 14px;
            }

            .hero,
            .panel {
                border-radius: 18px;
                padding: 18px;
            }

            .pair-row {
                grid-template-columns: 1fr;
            }

            .swap-btn {
                width: 100%;
                border-radius: 12px;
                height: 44px;
            }

            .rates-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }
    </style>
</head>
<body>
    <div class="bg-grid"></div>

    <main class="layout">
        <section class="hero">
            <p class="eyebrow">Business FX Operations</p>
            <h1>Currency Exchange Desk</h1>
            <p class="subtext">
                Reliable currency conversion for cross-border payments, treasury workflows, and operational pricing.
                Built for clarity, speed, and dependable decision support.
            </p>
            <div class="chip-wrap">
                <span class="chip">Cross-Border Payments</span>
                <span class="chip">Treasury Ready</span>
                <span class="chip">Rate Transparency</span>
                <span class="chip">Operational Speed</span>
            </div>
        </section>

        <section class="panel">
            <form class="converter-form" action="convert" method="post">
                <div class="field">
                    <label for="amount">Amount</label>
                    <input id="amount" type="number" step="0.01" min="0" name="amount"
                           value="<%= amountValue %>" placeholder="1000.00" required>
                </div>

                <div class="pair-row">
                    <div class="field select-field">
                        <label for="fromCurrency">From</label>
                        <select id="fromCurrency" name="from" required>
                            <% for (String currency : currencies) { %>
                                <option value="<%= currency %>" <%= currency.equals(fromValue) ? "selected" : "" %>>
                                    <%= currency %>
                                </option>
                            <% } %>
                        </select>
                    </div>

                    <button class="swap-btn" type="button" onclick="swapCurrencies()" aria-label="Swap currencies">
                        SW
                    </button>

                    <div class="field select-field">
                        <label for="toCurrency">To</label>
                        <select id="toCurrency" name="to" required>
                            <% for (String currency : currencies) { %>
                                <% if (!currency.equals(fromValue)) { %>
                                    <option value="<%= currency %>" <%= currency.equals(toValue) ? "selected" : "" %>>
                                        <%= currency %>
                                    </option>
                                <% } %>
                            <% } %>
                        </select>
                    </div>
                </div>

                <button class="cta" type="submit">Convert Now</button>
            </form>

            <% if (result != null) { %>
                <section class="feedback success">
                    <h2>Conversion Quote</h2>
                    <p class="value"><%= result %></p>
                    <p class="detail"><%= resultDetail != null ? resultDetail : "" %></p>
                </section>
            <% } %>

            <% if (error != null) { %>
                <section class="feedback error">
                    <h2>Request Needs Attention</h2>
                    <p class="value"><%= error %></p>
                </section>
            <% } %>

            <section class="rates">
                <h3>Reference FX Rates</h3>
                <p>Indicative rates to INR used for this demonstration environment.</p>
                <div class="rates-grid">
                    <% if (rates != null) { %>
                        <% for (String currency : currencies) { %>
                            <% Double rate = rates.get(currency); %>
                            <% if (rate != null) { %>
                                <article class="rate-card">
                                    <span class="currency"><%= currency %></span>
                                    <span class="rate"><%= String.format(Locale.US, "%.2f", rate) %></span>
                                </article>
                            <% } %>
                        <% } %>
                    <% } %>
                </div>
            </section>
        </section>
    </main>

    <script>
        const allCurrencies = [
            <% for (int i = 0; i < currencies.size(); i++) { %>
                "<%= currencies.get(i) %>"<%= i < currencies.size() - 1 ? "," : "" %>
            <% } %>
        ];

        function syncToOptions(preferredTo) {
            const fromSelect = document.getElementById("fromCurrency");
            const toSelect = document.getElementById("toCurrency");
            const fromValue = fromSelect.value;

            const allowedCurrencies = allCurrencies.filter((currency) => currency !== fromValue);
            const nextTo = preferredTo && preferredTo !== fromValue && allowedCurrencies.includes(preferredTo)
                ? preferredTo
                : allowedCurrencies[0];

            toSelect.innerHTML = "";
            allowedCurrencies.forEach((currency) => {
                const option = document.createElement("option");
                option.value = currency;
                option.textContent = currency;
                if (currency === nextTo) {
                    option.selected = true;
                }
                toSelect.appendChild(option);
            });
        }

        function swapCurrencies() {
            const from = document.getElementById("fromCurrency");
            const to = document.getElementById("toCurrency");
            const previousFrom = from.value;
            const previousTo = to.value;
            from.value = previousTo;
            syncToOptions(previousFrom);
        }

        document.addEventListener("DOMContentLoaded", function () {
            const from = document.getElementById("fromCurrency");
            const to = document.getElementById("toCurrency");
            syncToOptions(to.value);
            from.addEventListener("change", function () {
                syncToOptions(to.value);
            });
        });
    </script>
</body>
</html>
