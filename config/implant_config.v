module config
import time
enum Implant_Status {
	alive
	upgraded
	success
	error
}
// S0_Implant is the lightest weight implant, all it does is beacon and wait for a C2 command to run or upgrade.
// the only thing S0_Implant sends is: ALIVE, UPGRADED, SUCCESS, ERROR.
struct S0_Implant {
	current_status Implant_Status
	date_installed  time.Time
	last_checkin_time time.Time
	desired_checkin_interval int
	c2_address string
}
// S1_Implant offers all the capabilities of a S0_Implant but allows an interactive shell mode, connected over a TCP Socket.
struct S1_Implant {
	previous_stage_holder S0_Implant

}
// S2_Implant offers all the capabilities of a S0_Implant and a S1_Implant as well as the ability to run custom modules designed for VST.
struct S2_Implant {
	previous_stage_holder S1_Implant
}