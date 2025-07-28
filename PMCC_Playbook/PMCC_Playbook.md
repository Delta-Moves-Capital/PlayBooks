# Poor Man’s Covered Call (PMCC) Playbook

## 🧩 1. What is PMCC?

A **Poor Man’s Covered Call** is a **long-dated deep ITM call (LEAP)** paired with **short-dated calls**, mimicking a covered call but with significantly less capital outlay—leveraging the LEAP instead of actual shares ([projectfinance][1]).

## 🎯 2. Strategy Objectives

* **Capital Efficiency**: Long call priced far below 100-share cost—often just 10–20% of stock’s value ([Elite Trader][2]).
* **Positive Yield**: Short calls generate recurring premium; long call captures upside ([Reddit][3]).
* **Defined Risk**: Maximum loss capped at premium paid for LEAP; less exposure than outright shares.

## ⚙️ 3. Setup Guidelines

| Leg            | Delta      | DTE                 | Position Role                         |
| -------------- | ---------- | ------------------- | ------------------------------------- |
| **Long LEAP**  | \~0.80     | \~12 months         | Synthetic stock, directional exposure |
| **Short Call** | \~0.30 OTM | 1–7 days (up to 45) | Income leg, extrinsic decay focus     |

* **Buy deep ITM**, high-delta LEAP (≥ 0.75), 200+ DTE considered “Super Theta” ([Reddit][3], [optionshawk.com][4]).
* **Sell near-term OTM calls** (delta 0.20 - 0.35) to collect extrinsic premium ([Option Alpha][5]).

### Entry Checklist

1. **Net Debit ≤ 75%** of strike difference ([Reddit][3]).
2. **Short call extrinsic ≥ long call extrinsic** to ensure positive time decay ([Reddit][3]).
3. Choose stable, non-cryptic, blue-chip underlyings ([Medium][6]).

---

## 🧠 4. Risk & Management Plan

### A. Extrinsic Value Strategy

* **Time decay matters**: Monitor extrinsic on short call. Roll or close when it approaches zero (e.g. ≤ \$0.10–\$0.15) ([Tackle Trading][7]).
* **Profit capture**: Roll when 50–70% of max premium is realized ([optionshawk.com][4]).

### B. Avoid Assignment

* **ITM + low extrinsic (≤ \$0.15)** → roll immediately ([Tackle Trading][7]).
* **3–5 days to expiry** with short call nearing ITM → evaluate and roll preemptively.
* **Dividend events**: Roll short call 4–6 days before ex-dividend to avoid early exercise.

### C. Rolling Tactics

* **Roll out** (time only): +30–45 days.
* **Roll up** (strike only): if bullish momentum continues.
* **Combo roll**: Time + strike together in strong moves.
* **Adjust long call** if delta drops below \~0.75 (\~60–90 DTE); roll to maintain synthetic stock exposure.

---

## 📈 5. Strategy Risk & Reward

* **Max Profit**: (Short strike – Long strike) – Net debit paid ([projectfinance][1], [TastyLive][8]).
* **Max Loss**: The premium paid for the LEAP.
* **Breakeven Point**: Long strike + net debit paid ([Tackle Trading][7]).

---

## 🗭 6. Daily Workflow

1. **Review**: DTE, moneyness, extrinsic, profit capture %, dividends.
2. **Act**:

   * Extrinsic ≤ \$0.10–\$0.15 (ITM)? → Roll.
   * 50–70% premium captured? → Consider early roll.
   * 3–5 DTE & shift ITM? → Preemptive roll.
   * Dividend upcoming? → Roll 4–6 days ahead.
   * Delta long <0.75? → Plan LEAP roll.
3. **Monitor IV**:

   * IV drop in rally? Let short decay.
   * IV spike in dip? Lock LEAP value if advantageous.

---

## 🔀 7. Trade Lifecycle Example

> **Setup**
> Stock \$100 → Buy 12-month 90-strike call @ \$15 (\~0.80 delta), Sell 7-day 105-strike call @ \$1.50. Net debit = \$13.50 ≤ 75% of width (\$15) — ✅

> **7-day cycle**
> Short collects \$1.50; monitor extrinsic decay, profit capture.

> **By day 5**
> Short extrinsic ≤ \$0.20 and profit \~60% → Roll to fresh 7-day / maybe 107 strike.

> **Stack cycles**
> Continue repeating short-call cycles, adjusting LEAP as needed when delta drops.

---

## 📚 8. Source Materials

* **Reddit takeaway**: "Pay no more than 75%…Long call within desired allocation, 200+DTE...Sell OTM weeklies" ([Elite Trader][2], [Reddit][3], [Piranha Profits][9], [Reddit][10]).
* **OptionsHawk**: “Long \~70 delta \~90 DTE; short \~30 delta \~30–45 DTE” ([optionshawk.com][4]).
* **Piranha Profits**: Risk of assignment, rolling short calls for protection ([Piranha Profits][9]).
* **OptionAlpha**: Defined risk, capital efficiency trade-offs ([Option Alpha][5]).
* **TastyLive**: Setup rules, extrinsic-parity, defined risk ([TastyLive][8]).
* **TackleTrading**: Rule-of-thumb: close short when extrinsic ≈ zero, roll to keep position live ([Tackle Trading][7]).

---

## ✅ Summary

1. **Allocate capital** via a high -delta, long -dated LEAP.
2. **Generate income** with rolling short calls, capturing extrinsic.
3. **Actively manage** to avoid assignment and maintain exposure.
4. **Adjust long call** before delta decay jeopardizes synthetic stock replication.
5. **Repeat** cycles, balancing yield, risk, and capital preservation.

---

🧠 **Next Steps**:

* Embed trade examples using real option chains.
* Add ThinkScript/Python code to calculate extrinsic, delta, roll triggers.
* Consider automation (e.g. GitHub Actions or Thinkorswim alerts).

[1]: https://www.projectfinance.com/poor-mans-covered-call/?utm_source=chatgpt.com
[2]: https://www.elitetrader.com/et/threads/poor-mans-covered-call-vs-traditional-long-stock-portfolio.361581/?utm_source=chatgpt.com
[3]: https://www.reddit.com/r/thetagang/comments/igr7fn/a_poor_mans_guide_to_covered_calls_aka_pmccs_and/?utm_source=chatgpt.com
[4]: https://optionshawk.com/trading-poor-mans-covered-calls/?utm_source=chatgpt.com
[5]: https://optionalpha.com/learn/poor-mans-covered-call?utm_source=chatgpt.com
[6]: https://erikbassett.medium.com/the-poor-mans-covered-call-what-it-is-why-i-don-t-use-it-97aac9ab6273?utm_source=chatgpt.com
[7]: https://tackletrading.com/tales-of-a-technician-the-preeminence-of-extrinsic-value-in-covered-call-management/?utm_source=chatgpt.com
[8]: https://www.tastylive.com/concepts-strategies/poor-man-covered-call?utm_source=chatgpt.com
[9]: https://www.piranhaprofits.com/blog/poor-mans-covered-call?utm_source=chatgpt.com
[10]: https://www.reddit.com/r/options/comments/1cwpc61/poor_mans_covered_call/?utm_source=chatgpt.com
