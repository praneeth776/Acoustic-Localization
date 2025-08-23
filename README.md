# Acoustic Localization
UCSD Coordinated Robotics Lab

Using a BeagleBone Blue, sound signals were sampled and analyzed for distance measurements. Sound was created using a speaker and sampled at a distance. The libpruio library was used to speed up the ADC sampling rate on the BeagleBone by accessing its PRU in SAMPLING.cpp. Using the fftw library, a cross-correlation algorithm was implemented on the sampled sound signal, comparing it with the reference frequency-modulated signal in Cross Correlation.cpp. The combined sampling and cross correlation gives a distance measurement in localization.cpp. Then, the distance measurements from 4 different speakers playing towards the main sampling computer can be combined in Megha's matlab algorithm to produce its 2D coordinates. We are currently in the process of syncing the clocks between the computers producing the sound signal and the computer sampling it.

Example sound sampling from SAMPLING.cpp at 100 kHz using the PRU (200 kHz is overkill for this project):

<img src="images/ss1.png" width="550">

Output from the theoretical cross-correlation algorithm, demonstrated in matlab for plotting:

<img src="images/ss3.png" width="800">

The signal is shifted by 0.01 seconds, and despite the noise the cross-correlation technique accurately reflects that shift.


