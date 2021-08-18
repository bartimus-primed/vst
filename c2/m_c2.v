module c2

import os
import windows
import linux
import term
import strconv
import rand
import net
// detect os

struct Windows_C2_Config {

}

struct Linux_C2_Config {

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
	println("Selected Interface with IP: ${results[choice]}")
	port_choice := strconv.atoi(os.input("What port would you like to listen on? [Press enter for random high]")) or {
		rand.int_in_range(50000,65535)
	}
	term.clear()
	println("Starting listener on ${results[choice]}:$port_choice")
	create_listener(results[choice], port_choice)
	return true
}

pub fn create_listener(ip string, port int) {
	mut listener := net.listen_udp("$ip:$port") or {
		println("Failed to open UDP")
		return 
	}
	defer {
		println("Closing port")
		listener.close() or { panic("Failed to close port")}
	}
	println("Successfully started UDP Listener on $ip:$port")
	mut a := strconv.atoi(os.input("wait")) or { 777 }
	for a != 0 {
		a = strconv.atoi(os.input("wait")) or { 777 }
	}
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