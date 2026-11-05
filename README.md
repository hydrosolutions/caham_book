# CAHAM Book - Central Asia Hydrology: Applied Modeling

## Overview

This is a course book on the hydrology of semi-arid Central Asia and the applied modeling of the hydrological systems there. This course book shall serve young and aspiring water experts in the region as a reference for applied hydrological modeling.

The book is a work in progress. It is currently in its 2024 iteration and is regularly updated. The authors aim to make the complex and far-ranging materials accessible to a broad audience.

The online book can easily be translated into other languages using the built-in translation feature of modern browsers.

The book is published at https://hydrosolutions.github.io/caham_book/.

## How to contribute

The book is written in markdown and compiled using the Quarto toolchain. There are always improvements to be made. If you see issues, please file them via GitHub so we can address them. If you want to contribute, please fork the repository, make changes, and file a pull request.

## Errata for edition 2024.Q1

The online book is the 2024.Q1 edition. It will not be rebuilt before the 2027 edition, which corrects the
errors listed here. Until then, please read the affected passages as follows. Last updated: 5 November 2026.

### Chapter 8, Hydrological-Hydraulic Modeling

1.  **Section "The Simplest Model - The Linear Reservoir Model", discretised water balance.** The first term
    averages precipitation over both time steps:

    ```math
    \frac{P(t_1)+P(t_2)}{2} - \frac{Q(t_1)+Q(t_2)}{2} = \frac{k}{t_2-t_1} \cdot \big(Q(t_2)-Q(t_1)\big)
    ```

2.  **Section "First Model Run", Nash-Sutcliffe efficiency.** The denominator uses the observed discharge,
    not the simulated discharge:

    ```math
    \text{Nash} = 1 - \frac{\sum_{t=1}^{N} \big( Q_{sim}(t) - Q_{obs}(t) \big)^2}{\sum_{t=1}^{N} \big( Q_{obs}(t) - \overline{Q_{obs}} \big)^2}
    ```

3.  **Section "Model Calibration", calibration objective.** Raw differences cancel between over- and
    underestimation. The differences are squared, or taken as absolute values, before they are summed:

    ```math
    \min_{\boldsymbol{P}} \sum_{t=1}^{N} \big( Q_{sim}(t, \boldsymbol{P}) - Q_{obs}(t) \big)^2
    ```

4.  **Section "Calibration of Snow Water Equivalent", code above Figure 8.29.** The line that computes the
    root mean squared error lacks the square. The computed value is not used in the figure or the text.

    ```r
    RMSE = sqrt(mean(compare_swe$`Obs-Sim`^2, na.rm = TRUE))
    ```

5.  **Section "Comparing Computed to Observed Glacier Thinning Rates", Figure 8.32.** The observed bar shows
    the specific mass change rate of Hugonnet et al. (2021), in metres water equivalent per year, not an
    elevation change rate. The simulated bar shows a change in glacier thickness. The axis label "dH/dt [m]"
    and the term "thinning rate" are therefore imprecise, and the comparison is qualitative only. Hugonnet et
    al. (2021) convert volume change to mass change with a density of 850 kg m⁻³.

### Chapter 9, Long-term Water Balance Modeling

6.  **Equation 9.12, Choudhury equation.** The outer exponent is negative. With the printed exponent the
    evaporative fraction would exceed 1.

    ```math
    \frac{E}{P} = \left[ 1 + \left( \frac{E_{pot}}{P} \right)^{-n} \right]^{-1/n}
    ```

### Chapter 10, Modeling Using Predictive Inference

7.  **Figure 10.3, caption.** The Charvak Reservoir station is 38464. The caption should read: Pskem (38462),
    Charvak Reservoir (38464) and Chatkal (38471).
8.  **Section "Anomalies and Outliers".** The exceptionally wet year is 1969, not "19169".
9.  **Figure 10.21, caption.** The figure shows the cross-correlation between precipitation, not temperature,
    at station 38471 and the discharge at station 16279.
10. **Section on the regression with lagged discharge ("This is clearly an astonishing result").** The close
    fit is an in-sample result: the model was not tested on data outside the fitting period, as point 4 of
    the list below that sentence notes. It should not be read as demonstrated forecast skill.

### Chapter 12, Quantification of Climate Change Impacts

11. **Equation 12.1, water balance.** The printed equation counts snowmelt in addition to precipitation and
    has no storage term. With *P* as total precipitation (rain and snow), the balance of a watershed is

    ```math
    P - ET - Q = \Delta S
    ```

    where Δ*S* is the change in storage in snow, ice, soil water and groundwater. Snowmelt and
    infiltration move water between these stores and are not separate terms of the balance.

### Cross-references

In several places a cross-reference appears as raw text such as `\@ref(fig:...)` or as a link shown in
square brackets. The name in the brackets identifies the figure or section meant.

If you find another error, please [open an issue](../../issues).

## Maintenance status
🟡 **Maintenance Mode**
This project has concluded. Security updates are provided as needed.
For questions, please [open an issue](../../issues).

## Change Log

-   2023-10-17: Compiling book for the identification of problems.
-   2024-02-13: Starting to work on improvements along several fronts.
-   2024-02-14: Revised hydrological_systems.qmd, discharge_station_data.qmd, and example_river_basin.qmd.
-   2026-11-05: Added errata for edition 2024.Q1. The corrections enter the book with the 2027 edition.
