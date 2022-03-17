# This is all still under constuction. Not final version

<br />
<p align="center">
  <a href="https://github.com/CognitiveNeuroLab/Illusory-Contours/">
    <img src="images/logo.jpeg" alt="Logo" width="160" height="160">
  </a> 

<h3 align="center">Illusory Contours</h3>

<h4 align="center"> Illusory-Contours. This task is created as a stand allone study and is later addapted to be part of the Sfari project. It is created for our ASD research. This experiment is coded for Presentation® NeuroBehavioral Systems, and coded in Scenario Description Language (SDL) & Presentation Control Language (PCL)) </h4>


**Table of Contents**
  
1. [About the project](#about-the-project)
    - [Built With](#built-with)
    - [Installation](#installation)
3. [Info about the experiment](#info-about-the-experiment)
    - [Stimuli](#stimuli)
    - [Logfiles](#logfiles)
    - [Sequences](#sequences)
    - [Inter stimulus interval](#inter-stimulus-interval)
    - [Instructions](#instructions)
    - [Trigger codes](#trigger-codes)
    - [Timing](#timing)
    - [Data collection](#data-collection)
    - [Piloting Results](#piloting-results)
3. [Sfari project changes](#sfari-project-changes)    
3. [License](#license)
3. [Contact](#contact)
3. [Acknowledgements](#acknowledgements)



<!-- ABOUT THE PROJECT -->
## About The Project

<!--This project is part of a larger group of experiments for the SFARI grant. All of these paradigms are aimed at our ASD work. 
The aSSR is diminished in autism and in first degree relatives of people with autism (Wilson et al., 2007; Seymour et al., 2020). Presenting clicks at 40 Hz, using the aSSR we will test the integrity of auditory driven gamma band oscillatory function. EEG will be collected while participants are presented with 500 ms duration 40Hz (25ms between clicks) or 27Hz (37ms between clicks) click streams. With the other functioning as a deviant. The stimuli are presented at a comfortable listening level of ~~75dB SPL. These will be presented to central space through a single hidden speaker~~ **still undecided**. Participants will fixate centrally on a cross on the screen in front of them while they try to detect the deviants. Analyses will focus on the gamma band auditory evoked response. See Figure 1 pilot data, aSSR from NTs and individuals with Rett Syndrome.--> 


### Built With

* [Presentation® (NeuroBehavioral Systems)](https://www.neurobs.com/)

## Installation

[Download this Repo](https://github.com/CognitiveNeuroLab/Illusory-Contours/)

Folder 1 - "Presentation Files" - this folder should contain all the presentation files and Sequences

Folder 2 - "Logfiles"           - this folder will be filled with all the presentation logfiles containing the behavioral data

Folder 3 - "Stimuli"            - this folder will contain all the pictures


## Info about the experiment

### Stimuli

<!--There are 2 clickstreams that are created in the lab. One will be a **40Hz clickstream of 500ms in duration** the other is a **27Hz clickstream also of 500ms in duration**. While the participant listens to them, they will see a fixation cross.
There are some pictures that will show up when the participant is half way during each block, this is so that people have a little break. Because we will collect data from kids we don't want them to click when they are ready, but instead it counts down and tells them to re-focus.-->


### Logfiles

logfiles with experiment reaction times and other information are automatically placed in the logfile folder. In these logfiles you will find the behavioral information of each time the experiment is ran. It is good practice to create a folder with participant ID to separate all these files. 

### Sequences 

<!--There are sequence files that dictate when a deviant will happen. These files are created in MATLAB and contain 1s and 2s. Each 1 results in a standard being presented and every 2 will result a deviant. The rule in MATLAB is that the first 5 trials are always standards and after that there are always at least 2 standards between a deviant. Furthermore, there are 100 trials and the standard/deviant ration is 85/15. 
The experiment chooses a new order for each participant. Currently only 1 sequence file exists. To run the experiment you will first need to open the MATLAB file called MMN_makeSequence and run it 1x. This will create 100 randomized sequence files. -->

### Inter stimulus interval  
  
<!--The paradigm has a somewhat jittered Inter stimulus interval(ISI). The ISI ranges from 500 to 800 ms in 20ms steps. This results in 16 possibilities that are randomized used for 16 trials and randomized again on a loop until the paradigm is done. Like this we make sure that whatever ISI is chosen is random, but also that all of them happen as often as possible within the amount of trials of the paradigm.-->

### Instructions

Still need to write out the exact instructions word for word.

### Trigger codes

The presentation software sends codes to the EEG system so that the responses and the stimuli can be time-locked in the EEG data. The following is an explanation of each trigger code: 
<!--
```
port code 201 = start recording
port code 200 = pause recording 
port code 1   = response
port code 11  = 40hz standard tone
port code 12  = 27hz deviant
port code 21  = 27hz standard tone
port code 22  = 40hz deviant
port code 27  = The version with 27hz as standard has begon
port code 12  = The version with 40hz as standard has begon

```
-->
### Timing
The reason this experiment is coded in presentation, is because of the timing resolution of this software/language. When setup correctly this experiment has potentially 1ms of jitter. This will be measured here at our lab, using an oscilloscope. It is critical that this is re-tested before EEG data is collected. This has not yet happened because we haven't decided on the duration of the trials.

<!--After testing the timing we can now say that the port_code triggers happen at the same time (0ms) with the onset of the stimuli.  
![assr_27hz_onset](https://github.com/CognitiveNeuroLab/ASSR-oddball/blob/main/images/assr_27hz_onset.JPG) ![assr_40hz_onset](https://github.com/CognitiveNeuroLab/ASSR-oddball/blob/main/images/assr_40hz_onset.JPG)   
This is the onset of the 27hz tone burst ------- This is the onset of the 40hz tone burst  
![assr_27hz_freq](https://github.com/CognitiveNeuroLab/ASSR-oddball/blob/main/images/assr_27hz_freq.JPG) ![assr_40hz_freq](https://github.com/CognitiveNeuroLab/ASSR-oddball/blob/main/images/assr_40hz_freq.JPG)    
This is the frequency of the 27 hz tone burst ------- This is the frequency of the 40 hz tone burst  
![assr_40hz_isi_example](https://github.com/CognitiveNeuroLab/ASSR-oddball/blob/main/images/assr_40hz_isi_example.JPG)  
This is one of the ISIs as an example. In this case it's after the 40hz tone burst with the ISI set to 628. As you can see this results in a ISI of 640ms.   -->


**if you plan to use this paradigm** 
You need to do the same and test if for your setup the timing is also okay. This timing is dictated by the refresh rate of your screen, the quality of your computer and potentially other minor factors. If you want to change the timing you can change  "deltat = ..". Whenever this shows up in the code it will delay the sending of the trigger by x amount of milliseconds. So in our case we noticed the screen being 9ms delayed, so this is why we delay the trigger by the same amount. 
-->
### Data collection
This experiment is used to collected EEG data, eye tracking data and RT data.  


### Piloting Results  
  
<!--We tested the paradigm on 5 members from our lab and show here that the paradigm indeed works. Specially the 40hz stream seems to be giving the expected reponse in adults and there is reason to thing that the 27hz will be instead more clear in the target age range (8-12y/o). To see more specifics of the analysis [click here](https://github.com/CognitiveNeuroLab/sfari-analysis-pipelines/blob/main/ASSR.md). The results are as followed:  
  
The strength of the evoked response:  
  
![evoked reponse](https://github.com/CognitiveNeuroLab/ASSR-oddball/blob/main/images/ERP_cz.png)  
  
The power spectrum:  
  
![Power Spectrum](https://github.com/CognitiveNeuroLab/ASSR-oddball/blob/main/images/Power_spectrum.jpg)  
The lighter one is the 40hz stream the darker one is the 27Hz.  
  
The time/frequency analysis (using newtimef):  
![Time Frequency analysis 27hz](https://github.com/CognitiveNeuroLab/ASSR-oddball/blob/main/images/Time_freq_27.jpg) ![Time Frequency analysis 40hz](https://github.com/CognitiveNeuroLab/ASSR-oddball/blob/main/images/Time_freq_40.jpg)  
Showing the same pattern where the 40hz stream is clear and the 27hz is not as much.  -->
  
  
## Sfari project changes  
  
1. We are only using the stimuli showing up in the center, so we can reduce the trials (by 3X)  
2. We are saving the eye tracking data  
3. We are not pausing the paradigm if we lose eye tracking  
4. Block (x trials) will be interrupted after (x trials) with a little break  
5. The attention task is in blue and yellow (to reduce the change that color blind people wouldn't be able to see the change)

## License

Distributed under the MIT License. See [LICENSE](https://github.com/CognitiveNeuroLab/ASSR-oddball/blob/master/LICENSE.txt) for more information.



<!-- CONTACT -->
## Contact

Main project - Emily Knight - twitter? - email? - website? 
Sfari - Douwe Horsthuis - [@douwejhorsthuis](https://twitter.com/douwejhorsthuis) - douwehorsthuis@gmail.com - www.douwehorsthuis.com

Project Link: [https://github.com/CognitiveNeuroLab/Illusory-Contours](https://github.com/CognitiveNeuroLab/Illusory-Contours)




<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements
 
<!--* [Sophie Molhom](https://www.cognitiveneurolab.com/dr-sophie-molholm)-->
