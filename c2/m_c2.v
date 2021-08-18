module c2

import os
import windows
import linux
import term
import strconv
// detect os

struct Windows_C2_Functions {

}

struct Linux_C2_Functions {

}

pub fn get_os() string {
	return os.user_os()
}

fn handle_windows_c2() bool {
	term.clear()
	println("running on windows...")
	println("=====================")
	results := windows.get_ip_addresses() or {
		panic(err)
	}
	println("Which IP would you like to listen on?")
	println("0). Back")
	for idx, ip in results {
		println("${idx+1}). $ip")
	}
	choice := strconv.atoi(os.input("Input interface number: ")) or { 777 }
	if choice == 0 {
		term.clear()
		return true
	}
	if choice == 777 {
		return false
	}
	term.clear()
	println("Starting listener on ${results[choice]}")
	return true
}

pub fn start_c2() bool {
	match get_os() {
		"windows" {
			return handle_windows_c2()
		}
		"linux" {
			println("running on linux")
			return false
		}
		else {
			println("unsupported os")
			return false
		}
	}
}

pub fn stop_c2() bool {
	return true
}


// start listener

// interact

// schedule tasks