# Fuzzy Software Quality Assessment — Mamdani FIS

![MATLAB](https://img.shields.io/badge/MATLAB-Fuzzy%20Logic%20Toolbox-orange)
![Type](https://img.shields.io/badge/model-Mamdani%20FIS-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Status](https://img.shields.io/badge/status-academic%20project-lightgrey)

A **Mamdani fuzzy inference system** in MATLAB that estimates the quality of software versions from three internal code-quality attributes — **Maintainability, Complexity, Reliability** — and validates the estimate against the real share of problematic classes. Built on a dataset of open-source Java repositories (Spring Framework and JUnit 5).

> **Course:** Computer Modeling and Simulation · **Topic 11 — Fuzzy assessment of software quality**

---

## Highlights

- Fuzzy set boundaries are **derived from the data** (quantiles), not set by hand.
- **27 IF–THEN rules**, centroid defuzzification, three inputs / five output levels.
- **Quantitative influence analysis** (correlation + sensitivity) of each input.
- **Membership-function parameter optimization** via local search (base MATLAB, no extra toolbox).
- **Classification-based evaluation** appropriate for a binary target (confusion matrix, accuracy, precision, recall, F1) — not just MAE/RMSE.
- Honest **representativeness analysis** of the dataset with clearly stated limitations.

---

## Results

| Metric | Value |
|---|---|
| Accuracy | 1.00 |
| Precision / Recall / F1 | 1.00 / 1.00 / 1.00 |
| Correlation (fuzzy score vs. problem ratio) | −0.97 |
| Input influence (r vs. problem ratio) | Maintainability −0.97 · Complexity +0.98 · Reliability +0.96 |
| RMSE before → after optimization | 21.96 → 9.92 |

> **Important context:** the perfect classification is **not** evidence of a strong model — it is a consequence of the dataset containing only two projects that differ on almost everything, making them trivially separable. See [Limitations](#limitations).

### Decision surface
![Decision surface](figures/fig_v2_surface.png)

### Sensitivity analysis (input influence)
![Sensitivity](figures/fig_v2_senzitivnost.png)

### Fuzzy score vs. real problems
![Validation scatter](figures/fig_v2_scatter.png)

---

## Methodology

1. **Feature derivation** — the three fuzzy inputs are derived from raw code metrics and scaled to 0–100:
   - `Complexity` = LOC / number of classes (larger classes → higher complexity)
   - `Maintainability` = 100 − (classes / package) (better modularity → higher maintainability)
   - `Reliability` = 100 − (external classes / classes) (lower coupling / CBO → higher reliability)
   - `Quality` (target) = 100 − (% of problematic classes)
2. **Data-driven membership functions** — for each input, the Low/Medium/High breakpoints come from the 25th, 50th and 75th percentiles:
   - `Low = [min, min, p25, p50]`, `Medium = [p25, p50, p75]`, `High = [p50, p75, max, max]`
3. **Mamdani FIS** — 3 inputs × 3 sets = 27 rules; output `Quality` with 5 levels; centroid defuzzification.
4. **Evaluation** — because the target is binary (problematic vs. clean version), the system is evaluated with classification metrics.
5. **Optimization** — output MF centers are tuned by a simple local search that minimizes RMSE against the continuous target.

![Membership functions](figures/membership_functions.png)
![Confusion matrix](figures/confusion_matrix.png)

---

## Repository structure

```
.
├── src/                     MATLAB source
│   ├── run_all.m            runs the full pipeline
│   ├── prepare_data.m       derives inputs/target from the dataset
│   ├── build_mamdani.m      builds the Mamdani FIS (data-driven MFs, 27 rules)
│   ├── evaluate_mamdani.m   classification metrics + influence + plots
│   ├── optimize_mamdani.m   MF parameter optimization (local search)
│   └── pctl.m               percentile helper (no Statistics Toolbox needed)
├── data/                    dataset (CSV)
├── fis/                     saved fuzzy systems (.fis)
├── figures/                 generated charts
└── docs/                    report and representativeness analysis
```

---

## How to run

Requirements: **MATLAB** with **Fuzzy Logic Toolbox**.

```matlab
cd src
run_all
```

This derives the inputs, builds the Mamdani FIS, evaluates it, runs the optimization, and saves the figures and `.fis` files.

---

## Dataset

Three CSV files describing open-source Java repositories:

- `repositories.csv` — 10 repositories with GitHub popularity (stars, forks, commits, contributors).
- `versions.csv` — internal code metrics per version (LOC, classes, packages, external/problematic classes).
- `attribute-details.csv` — dictionary of software quality attributes (Coupling, Complexity, Cohesion, Size, CBO, WMC, LCOM, …).

Internal code metrics are available for **only 2 of the 10 projects** (Spring, JUnit), because these must be computed by static analysis of each version's source code rather than pulled from GitHub.

---

## Limitations

This is a **demonstration on two projects**, not a general model:

- Only 2 of 10 projects have measured internal metrics (20% coverage).
- The 12 rows are yearly versions of the same 2 projects → highly correlated → effective sample size ≈ 2.
- The two measured projects sit at opposite extremes (Spring large/popular, JUnit small); the middle of the range is not represented.
- Consequently the classification is perfect **because the two projects are trivially separable** — a larger, more diverse dataset would give more realistic (lower) accuracy.

**Future work:** measure internal metrics for more projects of varying size and popularity, treat versions of one project as dependent, and clean missing values.

---

## License

Released under the [MIT License](LICENSE).
