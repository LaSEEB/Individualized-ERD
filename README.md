# Individualized ERD

This repository provides the code for an EEGLAB (tested for EEGLAB v2023.1) plugin to calculate individualized ERD (Event-Related Desynchronization).

## Description
When analysing EEG data, for a lot of research, we focus on alpha and beta frequency bands. These are usually analysed in a fixed band of 8 to 12 HZ and 13 to 30 Hz, respectively. Nevertheless, if we want to look at the Event-Related Desynchronization in these bands, since these change a lot according to individual and time, we thought of analysing these frequency features in an individual maner, and in an automatic way. For this reason, we developed this code.
In a simple maner, what you can do with this code is provide a broad frequency band, where you want to look for the ERD, and the algorithm will give you the individual band for each EEG signal provided (this needs to be for only one subject, and also for one single electrode, to use this for more than one electrode look below for an example on how to use the code in a script).


## How to install
To use this code as an EEGLAB plugin you will need to download this repository into the 'eeglab/plugins/' folder in your computer.

## How to use
### Through the EEGLAB GUI
To use this through the EEGLAB GUI, just access the `Plot` button and select `Plot ERD`.
After this, a new prompt window will appear for you to select the electrode: "Channel number", the broad frequency band: "Frequency band", and the "Wavelet cycles" used for the transformation of the signal into time-frequency space.

<p align="center">
    <img src="https://github.com/user-attachments/assets/e6fbf042-bda5-4687-b876-91fa401e165f"
            alt="individual_erd_pop">

And then you will get a plot of the ERD (%) value/shape across time.
<p align="center">
    <img src="https://github.com/user-attachments/assets/bcd65248-d895-4232-b61e-f16181afa01c"
            alt="iERD_plot">

### Through a script
You can also use the functions from this plugin in a script, following the example below on how to call them.

For one electrode:
```
[individual_erd, times, freq_range] = pop_individual_erd(EEG, 15, [6 14], 0);

plot_erd(EEG,times,individual_erd)
```
To do this for various electrodes, just do a simple `for` loop with `pop_inidividual_erd()` inside.

## Contributor
- Madalena Valente (2024 -)


