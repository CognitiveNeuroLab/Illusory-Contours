# Header Info ##########################################
pulse_width = 5;    
write_codes = false;
response_matching = simple_matching;

active_buttons = 2;
button_codes = 100,255;

default_text_color = 255, 255, 255;
default_background_color = 128, 128, 128;

no_logfile = true;

# Begin SDL portion of code ############################
begin;
###################################
$pixpitch = 0.32025;					 #Pixel Pitch of monitor (find from your monitor's documentation)
$monitordist = 760;					 #Distance of the monitor from the subject (mm)
$trlinitwin = 2;						 #Trial initiation window, in degrees the size of the window around central fixation
###################################
$trlinitpix = 'ceil(((tan(0.0174533 * $trlinitwin))*$monitordist)/$pixpitch)';

$inducer_on = 80;
$dot_on = 160;

bitmap {filename = "4_1.bmp"; transparent_color = 128,128,128;} IC_bmp;
bitmap {filename = "4_2.bmp"; transparent_color = 128,128,128;} NC_bmp;

box {height = 5; width = 5; color = 100,170,60;} green_dot; #re-calibrated from 6, 222, 181 on 8-21-08 (52,147,125)
box {height = 5; width = 5; color = 175,60,150;} red_dot;    # re-calibrated from 255, 137, 190 on 8-21-08 (199,36,84)

text {caption = "Break Time"; font_size = 32; font_color = 50,100,200;} break_text;
text {caption = "a"; font_size = 26; font_color = 100,200,50;} block_score;
text {caption = "a"; font_size = 26; font_color = 0,0,0;} total_score;
text {caption = "Press the '1' button to start the next block"; font_size = 16; font_color = 255,255,255;} continue_text;

picture {box red_dot; x = 0; y = 0;} default;
picture {box green_dot; x = 0; y = 0;} dot_pic;
picture {bitmap IC_bmp; x = 0; y = 0; box red_dot; x = 0; y = 0;} inducer_pic;

picture {text break_text; x = 0; y = 100; text block_score; x = 0; y = 0; text total_score; x = 0; y = -100; 
	text continue_text; x = 0; y = -200;
} break_pic;

trial{
	picture dot_pic; duration = $dot_on;
	stimulus_event{ nothing{}; deltat = 5; port_code = 77; code = "DotFlip";} dot_evt;
} dot_trial;

trial {
	picture inducer_pic; duration = $inducer_on;
	stimulus_event{ nothing{}; deltat = 5; port_code = 10; code = "InducerOn";} inducer_evt;
} inducer_trial;

trial {
	trial_duration = forever;
	trial_type = correct_response;
	stimulus_event {
		picture break_pic;
		target_button = 2;
	} break_event;
} break_time;

# Begin PCL portion of code #############################
begin_pcl;
#################################################
bool toeyetrack = true;									#
int n_blocks = 7;											#
int n_trialsperblock = 24;								#
int n_images = 2;											#
int n_positions = 3;										#
int response_time = 300;								#			
array <int> ISI_interval[2] = {800, 1400};		#
array <int> dot_interval[2] = {1000, 10000};		#
#################################################
int initpix = int(get_sdl_variable("trlinitpix"));
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

eye_tracker tracker = new eye_tracker( "PresLink" );
eye_position_data eyedata;
if toeyetrack then
	tracker.start_tracking();
	tracker.set_parameter("screen_pixel_coords", "0 0 2560 1080");
	tracker.set_parameter("screen_distance", "880 850");
	tracker.set_parameter("screen_phys_coords", "-410.0, 173.0, 410.0, -173.0");
	tracker.send_message("DISPLAY_COORDS 0 0 2560 1080");
	tracker.set_parameter("file_event_filter", "LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT");
	tracker.set_parameter("link_event_filter","LEFT,RIGHT,FIXATION,SACCADE,BLINK,BUTTON");
	tracker.set_parameter("link_sample_data" ,"LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS,HTARGET");
	tracker.set_parameter("file_sample_data",  "LEFT,RIGHT,GAZE,AREA,GAZERES,STATUS,HTARGET,INPUT");
	tracker.set_parameter("calibration_type","HV9");
	tracker.start_data(0, false);
	tracker.calibrate(et_calibrate_default, 1.0, 0.0, 0.0); #in order to progress past this point in the code you need to run the calibration from the Eyelink PC
																		  #click the "Calibrate" button and run through the calibration, when done click the "Output/Record" button to progress
	tracker.set_recording(true);	
end;

loop
	int block_on = 1;
until
	block_on > n_blocks
begin

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
	
	loop
		int i = 1;
	until
		i > n_trialsperblock
	begin
	
		if stim_order[i] == 1 then #IC image, center position
			inducer_pic.set_part(1, IC_bmp);
			inducer_pic.set_part_x(1,0);
		elseif stim_order[i] == 2 then #IC image, left position
			inducer_pic.set_part(1, IC_bmp);
			inducer_pic.set_part_x(1,-250);
		elseif stim_order[i] == 3 then #IC image, right position
			inducer_pic.set_part(1, IC_bmp);
			inducer_pic.set_part_x(1,250);
		elseif stim_order[i] == 4 then #NC image, center position
			inducer_pic.set_part(1, NC_bmp);
			inducer_pic.set_part_x(1,0);
		elseif stim_order[i] == 5 then #NC image, left position
			inducer_pic.set_part(1, NC_bmp);
			inducer_pic.set_part_x(1,-250);
		elseif stim_order[i] == 6 then #NC image, right position
			inducer_pic.set_part(1, NC_bmp);
			inducer_pic.set_part_x(1,250);
		end;
		
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
		
		if toeyetrack then
			eyedata = tracker.last_position_data();
			if (eyedata.x() < initpix) && (eyedata.x() > -1*initpix) && (eyedata.y() < initpix) && (eyedata.y() > -1*initpix) then
				inducer_trial.present();
				ISI = random(ISI_interval[1],ISI_interval[2]);
				wait_interval(ISI);
				i = i + 1;
			end;
		else
			inducer_trial.present();
			ISI = random(ISI_interval[1],ISI_interval[2]);
			wait_interval(ISI);
			i = i + 1;
		end;
		
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

break_time.present();

block_on = block_on + 1;
end