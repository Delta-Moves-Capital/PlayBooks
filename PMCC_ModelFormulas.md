# PMCC\_ModelFormulas.md

## 📘 Poor Man's Covered Call – Formula Companion

This file contains formulas and logic used to evaluate a PMCC position, including key risk metrics, breakeven, return, and roll criteria. Use as a Markdown reference or print-friendly companion to the notebook.

---

### 🔹 1. Max Profit

```
MaxProfit = ShortCallStrike - LongCallStrike - NetDebit
```

### 🔹 2. Max Loss

```
MaxLoss = NetDebitPaid (typically cost of LEAP)
```

### 🔹 3. Breakeven

```
Breakeven = LongCallStrike + NetDebit
```

### 🔹 4. ROI (Return on Investment)

```
ROI = MaxProfit / NetDebit
```

### 🔹 5. Short Call Extrinsic Value

```
ExtrinsicShort = OptionPriceShort - IntrinsicValueShort
               = OptionPriceShort - max(0, UnderlyingPrice - StrikeShort)
```

### 🔹 6. Long Call Extrinsic Value

```
ExtrinsicLong = OptionPriceLong - IntrinsicValueLong
              = OptionPriceLong - max(0, UnderlyingPrice - StrikeLong)
```

### 🔹 7. Time Decay Capture Rule (Rolling Trigger)

```
If ExtrinsicShort ≤ $0.10 or has decayed ≥ 60%, roll to next expiration
```

### 🔹 8. LEAP Roll Condition

```
If DeltaLong ≤ 0.70 and DTE ≤ 90, consider rolling to maintain synthetic stock
```

### 🔹 9. Entry Criteria Validation

```
NetDebit ≤ 75% × (ShortCallStrike - LongCallStrike)
ExtrinsicShort ≥ ExtrinsicLong
```

---

✅ Use these formulas in the accompanying Jupyter notebook for modeling.
