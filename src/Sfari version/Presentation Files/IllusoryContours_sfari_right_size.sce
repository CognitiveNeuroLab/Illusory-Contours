# Header Info ##########################################
pulse_width = 5;    
write_codes = true;
response_matching = simple_matching;

active_buttons = 1;
button_codes = 100;

default_text_color = 255, 255, 255;
default_background_color = 128, 128, 128;

no_logfile = false;

# Begin SDL portion of code ############################
begin;


$inducer_on = 80;
$dot_on = 160;

### kid's break stuff ###
array {
   LOOP $i 9;
   $k = '$i + 1';
   bitmap { filename = "kids_$k.jpg"; };
   ENDLOOP;
} kids_pics;
bitmap {filename = "kids_1.jpg"; preload = true;} spongebob_1;
### kid's break stuff ###

bitmap {filename = "4_1.bmp"; transparent_color = 128,128,128; width=950; height=1220;} IC_bmp; #gives a 12x12cm IC stim for 1280x1024
bitmap {filename = "4_2.bmp"; transparent_color = 128,128,128; width=950; height=1220;} NC_bmp;

box {height = 5; width = 5; color = 255,255,0;} green_dot; #re-calibrated from 6, 222, 181 on 8-21-08 (52,147,125)   #Douwe 1/24/2021 edit: changed it to yellow for color blindness
box {height = 5; width = 5; color = 0, 0, 255;} red_dot;   # re-calibrated from 255, 137, 190 on 8-21-08 (199,36,84) #Douwe 1/24/2021 edit: changed it to blue for color blindness

text {caption = "Break Time"; font_size = 32; font_color = 50,100,200;} break_text;
text {caption = "a"; font_size = 26; font_color = 100,200,50;} block_score;
text {caption = "a"; font_size = 26; font_color = 0,0,0;} total_score;
text {caption = "Click once to start the next block"; font_size = 16; font_color = 255,255,255;} continue_text;

picture {box red_dot; x = 0; y = 0;} default;
picture {box green_dot; x = 0; y = 0;} dot_pic;
picture {bitmap IC_bmp; x = 0; y = 0; box red_dot; x = 0; y = 0;} inducer_pic;
picture { background_color = 128, 128, 128;} et_calibration; #change the background of the Eyetracker calibration to gray
bitmap { filename = "et_bit.bmp"; preload = true; } et_bit;# for the eyetracker

picture {text break_text; x = 0; y = 100; text block_score; x = 0; y = 0; text total_score; x = 0; y = -100; 
	text continue_text; x = 0; y = -200;
} break_pic;

trial{
	stimulus_event{ nothing{}; port_code = 201; code = "Start";} start_event;
} start_trial;

trial{
	picture { text {caption = "We might calibrate the eyetracker now";} calibr_text; x = 0; y = 0;} calibr_pic; duration = 3000; port_code = 200; code = "Block done";} pause_trial;
	
trial{
	picture { text {caption = "You did amazing, you are done with this one \n \n waiting for eye tracking data to be saved";} end_text; x = 0; y = 0;} finish_pic; duration = 3000; port_code = 200; code = "Paradigm done";} end_trial;	

trial{
	picture dot_pic; duration = $dot_on;
	stimulus_event{ nothing{}; deltat = 7; port_code = 77; code = "DotFlip";} dot_evt;
} dot_trial;

trial {
	picture inducer_pic; duration = $inducer_on;
	stimulus_event{ nothing{}; deltat = 7; port_code = 255; code = "InducerOn";} inducer_evt;
} inducer_trial;

trial {
	trial_duration = forever;
	trial_type = correct_response;
	stimulus_event {
		picture break_pic;
		target_button = 1;
	} break_event;
} break_time;

trial {
	stimulus_event{
		picture {
			bitmap spongebob_1; x = 0; y = 0;
			text {
				background_color = 0, 0, 0;
				caption = "Keep up the great work!";
				font_size = 30;
				text_align = align_center;
				font_color = 255,0,255;
			}txt_support;
			x = 0; y = -250;
		}pic_support; 
		time = 0; 
		duration = 3000;
		code = "feed_back_start";
		port_code=199;#so we know a break happened
	}support_event;
	stimulus_event{
		picture {
			bitmap spongebob_1; x = 0; y = 0;
			text {
				background_color = 0, 0, 0;
				caption = "The game restarts in 3";
				font_size = 30;
				text_align = align_center;
				font_color = 255,0,255;
			}txt_support_1;
			x = 0; y = -250;
		}pic_support_1; 
		time = 3000; 
		duration = 1000;
		code = "feed_back";
		port_code=200;
	}support_event_1;
	stimulus_event{
		picture {
			bitmap spongebob_1; x = 0; y = 0;
			text {
				background_color = 0, 0, 0;
				caption = "The game restarts in 2";
				font_size = 30;
				text_align = align_center;
				font_color = 255,0,255;
			}txt_support_2;
			x = 0; y = -250;
		}pic_support_2; 
		time = 4000; 
		duration = 1000;
		code = "feed_back";
	}support_event_2;	
   stimulus_event{
		picture {
			bitmap spongebob_1; x = 0; y = 0;
			text {
				background_color = 0, 0, 0;
				caption = "The game restarts in 1";
				font_size = 30;
				text_align = align_center;
				font_color = 255,0,255;
			}txt_support_3;
			x = 0; y = -250;
		}pic_support_3; 
		time = 5000; 
		duration = 1000;
		code = "feed_back_stop";
		port_code=201;
	}support_event_3;		
}support_trial;

trial { nothing{}; time = 0; port_code = 200;} pause_on;
trial { nothing{}; time = 0; port_code = 201;} pause_off;

# Begin PCL portion of code #############################
begin_pcl;

####################eyetracking setup ##################
##ET##
eye_tracker EyeLink = new eye_tracker( "PresLink" );#this starts the eyetracker , the name of this (currently "PresLink") is whatever your extention is called (sometimes "EyeTracker")
int dummy_mode = 0; #if this is 1 you can run the paradigm without eyetracking
if dummy_mode == 1 then
	EyeLink.set_parameter("tracker_address", "");
end;         
#connect to Eyelink tracker.
EyeLink.start_tracking();
string edfname_final = logfile.subject() + "IC_1"; #names the EDF file, choose here the name of your individual edf file
string edfname_out = "IC_1";

#here we are checking if the edf file already exists and if so it add a +1 to the ending
int cntr = 1;
loop
	bool good_edfname = false; 
until
	good_edfname == true
begin
	if file_exists(logfile_directory + edfname_final + ".edf") then
		cntr = cntr + 1;
		edfname_final = logfile.subject() + "IC_" + string(cntr); # + ".edf";
		edfname_out = "IC_" + string(cntr) 
	else
		good_edfname = true
	end;
end;

if edfname_out.count() > 8 then
	exit("EDF Filename needs to be smaller than 8 characters long (letters, numbers and underscores only)"); #if your EDF filename is longer it might start giving trouble specially if you do more than 9 blocks
end;
#remove the filename extension, because it will be added back later 
#(this allows user to enter EDF name either with or without the extension 
#when running the script
array<string> temp[0];
edfname_out.split(".", temp);
edfname_out = temp[1];
#Tell the Host PC to open the EDF file
EyeLink.set_parameter("open_edf_file",edfname_out+".edf");

# STEP 1c SET DISPLAY PARAMETERS
#create variables to store the monitor's width and height in pixels
int display_height = display_device.height();
int display_width  = display_device.width();

#this sends a command to set the screen_pixel_coords parameter on the Host PC, 
#which formats the eye position data to match that of the screen resolution
EyeLink.send_command("screen_pixel_coords 0 0 " + string(display_width-1) + 
	" " + string(display_height-1));
	
#this sends a message to the EDF tells Data Viewer the resolution of the experiment 
#so that it can format its Trial View window appropriately
EyeLink.send_message("DISPLAY_COORDS " + "0 0 " + string(display_width-1) + 
	" " + string(display_height-1)); 


#####  STEP 2: a) GET TRACKER VERSION; b)SELECT AVAILABLE SAMPLE/EVENT DATA
string Eyelink_ver = EyeLink.get_parameter("tracker_version"); # get et version

#tracker_ver will be something like EYELINK CL 4.48, but we want to get the 4.48
array <string> string_array[5];
Eyelink_ver.split(" ",string_array);
double el_v = double(string_array[3]); #Host PC software version will be el_v


### Step 2b SELECT AVAILABLE SAMPLE/EVENT DATA
#Select which events are saved in the EDF file. Include everything just in case
EyeLink.send_command("file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT");	#this ensures that Gaze data is recorded 
EyeLink.send_command("link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,BUTTON,INPUT");

#First, check tracker version so as to determine whether to include 'HTARGET' 
#to save head target sticker data for supported eye trackers
#Then, send commands to set the file_sample_data and link_sample_data parameters, 
#which specify which aspects of sample data will be recorded to the EDF file 
#and which will be available over the Ethernet link between the Host PC and Display PC
if (el_v >=4.0) then
	#include HTARGET (head target) data if tracker is EyeLink 1000 or later
	EyeLink.send_command("file_sample_data = LEFT,RIGHT,GAZE,AREA,GAZERES,STATUS,HTARGET,INPUT"); #Area token ensures Pupil size is recorded.
	EyeLink.send_command("link_sample_data = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS,HTARGET,INPUT");
else
	EyeLink.send_command("file_sample_data = LEFT,RIGHT,GAZE,AREA,GAZERES,STATUS,INPUT");
	EyeLink.send_command("link_sample_data = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS,INPUT"); 
end;


#####  STEP 3:CALIBRATE EYE TRACKER

#start calibration with camera support. If calibration_type is set to 
#et_calibrate_default and if the parameter 1 value is set to 1.0, 
#then the user defined target with the name et_calibration will be ignored 
#EyeLink.calibrate( et_calibrate_default, 1.0, 0.0, 0.0 );

##### CLEANUP SUBROUTINE -- CALLED WHEN THE SCRIPT ENDS #######################################

#this subroutine is called at the end of the script or if the Esc key is pressed during 
#the trial image presentation
#it closes the EDF file, and transfers it over to the logfile directory of the experiment on the Display PC
sub cleanup begin
	EyeLink.send_command("set_idle_mode"); #eyelink goes in idle mode
	EyeLink.send_command("clear_screen 0");#clear Host PC screen at end of session
	wait_interval(500); 
	EyeLink.send_command("close_data_file");#close the EDF file and then allow 100 msec to ensure it's closed
	if dummy_mode != 1 then
		EyeLink.set_parameter("get_edf_file",logfile_directory + edfname_final + ".edf");#transfer the EDF file to the logfile directory of the experiment	on the Display PC
	end;
	EyeLink.stop_tracking();
end;	
#Set the the tracker to idle mode.  
#It's important to do this before using commands to transfer graphics to / do drawing on the Host PC
EyeLink.send_command("set_idle_mode");
wait_interval(50);#in ms
EyeLink.send_command("clear_screen 0"); #clearing screen
EyeLink.set_parameter("transfer_image", et_bit.filename()); #showing stimuli on eyelink computer


#################################################
#bool toeyetrack = true;									#
int n_blocks = 3;											#
int n_trialsperblock = 180;							#
int n_images = 2;											#
int n_positions = 1;										#
int response_time = 500;								#			
array <int> ISI_interval[2] = {800, 1400};		#
array <int> dot_interval[2] = {1000, 10000};		#
#################################################

int n_conditions = n_images * n_positions;
int stim_reps = n_trialsperblock / n_conditions;
int ISI;
int block_hits;
int block_misses;
int total_hits = 0;
int total_misses = 0;
double dot_clock;

array <int> stim_order[n_trialsperblock];

parameter_window.remove_all();
int block_hits_parameter = parameter_window.add_parameter( "Block Hits" );
int block_misses_parameter = parameter_window.add_parameter( "Block Misses" );
int total_hits_parameter = parameter_window.add_parameter( "Total Hits" );
int total_misses_parameter = parameter_window.add_parameter( "Total Misses" );
int whichblock_parameter = parameter_window.add_parameter( "Block Number" );
int rest_complete_parameter = parameter_window.add_parameter( "Status" );
start_trial.present();
loop
	int block_on = 1; int ii=1;
until
	block_on > n_blocks
begin
	##ET##
	wait_interval(100); #in ms
	EyeLink.calibrate(et_calibrate_default, 1.0, 0.0, 0.0);
   EyeLink.set_recording(true);
	wait_interval(100); #in ms
	##ET##
	
	parameter_window.set_parameter( whichblock_parameter, string(block_on) );
	parameter_window.set_parameter( rest_complete_parameter, "InBlock" );
	
	pause_off.present();
	
	loop
		int i = 1;
	until
		i > n_conditions
	begin
		stim_order.fill(1+(stim_reps*(i-1)), stim_reps*i, i, 0);
		i = i + 1;
	end;

	stim_order.shuffle();
	
	block_hits = 0;
	block_misses = 0;
	
	default.present();
	wait_interval(2000);

	dot_clock = random(dot_interval[1],dot_interval[2])+clock.time();
   double dot_clock_hold;
	loop
		int i = 1; int sup_p; 
	until
		i > n_trialsperblock
	begin
		
		if i==50 || i==90 || i==130 then
			dot_clock_hold = dot_clock; #so that the time of the break doesn't mess up the dot interval, but instead just delays it
			EyeLink.send_string( "Break");
			EyeLink.set_recording(false);
			sup_p=random(1,9); #choosing 1/9 pictures
			pic_support.set_part(1,kids_pics[sup_p]);
			pic_support_1.set_part(1,kids_pics[sup_p]);
			pic_support_2.set_part(1,kids_pics[sup_p]);
			pic_support_3.set_part(1,kids_pics[sup_p]);
			support_trial.present();
			EyeLink.set_recording(true);
			EyeLink.send_string( "End break");
			dot_clock = dot_clock_hold;
		end;
	
		EyeLink.send_command("record_status_message 'IC trial " + string(i) + "/" + string(n_trialsperblock) + " block " + string(block_on) + "/" + string(n_blocks)+ "'");
		EyeLink.send_string( "TRIALID " + string(ii));
		if stim_order[i] == 1 then #IC image, center position
			inducer_pic.set_part(1, IC_bmp);
			inducer_pic.set_part_x(1,0);
			inducer_evt.set_port_code(21);
			EyeLink.send_message("IC_image");
		elseif stim_order[i] == 2 then #NC image, center position
			inducer_pic.set_part(1, NC_bmp);
			inducer_pic.set_part_x(1,0);
			inducer_evt.set_port_code(20);
			EyeLink.send_message("NC_image");
		end;
		
		if clock.time() >= dot_clock then
			EyeLink.send_message("dot_trial");
			dot_trial.present();
			wait_interval(response_time);
			if response_manager.response_count() > 0 then
				block_hits = block_hits + 1;
			else
				block_misses = block_misses + 1;
			end;
			dot_clock = random(dot_interval[1],dot_interval[2])+clock.time();
			parameter_window.set_parameter( block_hits_parameter, string(block_hits) );
			parameter_window.set_parameter( block_misses_parameter, string(block_misses) );
		end;
		
         
			inducer_trial.present();
			EyeLink.send_message("ISI_onset");
			ISI = random(ISI_interval[1],ISI_interval[2]);
			wait_interval(ISI);
			i = i + 1;
			ii=ii + 1;

		
		if clock.time() >= dot_clock then
			dot_trial.present();
			wait_interval(response_time);
			if response_manager.response_count() > 0 then
				block_hits = block_hits + 1;
			else
				block_misses = block_misses + 1;
			end;
			dot_clock = random(dot_interval[1],dot_interval[2])+clock.time();
			parameter_window.set_parameter( block_hits_parameter, string(block_hits) );
			parameter_window.set_parameter( block_misses_parameter, string(block_misses) );
		end;
		
	end;

total_hits = total_hits + block_hits;
total_misses = total_misses + block_misses;
parameter_window.set_parameter( total_hits_parameter, string(total_hits) );
parameter_window.set_parameter( total_misses_parameter, string(total_misses) );

block_score.set_caption( "Your current score for this block is " + string(block_hits) + " out of " + string(block_hits+block_misses));
total_score.set_caption( "Your overall score is " + string(total_hits) + " out of " + string(total_hits+total_misses));
block_score.redraw();
total_score.redraw();
parameter_window.set_parameter( rest_complete_parameter, "Resting" );
pause_on.present();
break_time.present();
parameter_window.set_parameter( rest_complete_parameter, "CALIBRATE NOW" );
EyeLink.set_recording(false);

block_on = block_on + 1;
if block_on > n_blocks then
	end_trial.present();
else
	pause_trial.present();
end;
end;
cleanup();