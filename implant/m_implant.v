module implant
import strconv
import os
import windows
import linux
// detect os
pub fn start_implant() bool {
	return confirm_os()
}

fn handle_windows_implant() bool {
	println("Building implant for $g_config.selected_implant_os")
	return handle_implant()
}

fn handle_linux_implant() bool {
	println("Building implant for $g_config.selected_implant_os")
	return handle_implant()
}

fn handle_implant() bool {
	return true
}

fn confirm_os() bool {
	println("Supported Implant OSes:")
	println("\t0) Exit")
	for i, o_s in g_config.supported_oses {
		println("\t${i+1}) $o_s")
	}
	users_os := os.user_os()
	mut user_choice := strconv.atoi(os.input("Which os would you like to use? [Enter to use detected OS: $users_os]")) or { 777 }
	if user_choice == 0 {
		return true
	}
	else if user_choice == 777 {
		g_config.selected_implant_os = users_os
	}
	else if user_choice > g_config.supported_oses.len || user_choice < 0 {
		return false
	} else {
		g_config.selected_implant_os = g_config.supported_oses[user_choice-1]
	}
	match g_config.selected_implant_os {
		"windows" {
			return handle_windows_implant()
		}
		"linux" {
			return handle_linux_implant()
		}
		else {
			println("unsupported os, will try to add MacOS in the future")
		}
	}
	return false
}
// start beacon

// wait for tasks
