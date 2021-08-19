module c2

import os
import windows
import linux
import term
import strconv
import rand
import net
// detect os

fn handle_linux_c2() bool {
	term.clear()
	println("running on linux...")
	println("=====================")
	results := linux.get_ip_addresses() or {
		panic(err)
	}
	return handle_c2(results)
	
}
fn handle_windows_c2() bool {
	term.clear()
	println("running on windows...")
	println("=====================")
	results := windows.get_ip_addresses() or {
		panic(err)
	}
	return handle_c2(results)
}

fn handle_c2(results []string) bool {
	println("Which IP would you like to listen on?")
	println("0). Back")
	for idx, ip in results {
		println("${idx+1}). $ip")
	}
	mut choice := strconv.atoi(os.input("Input interface number: ")) or { 777 }
	if choice == 0 {
		term.clear()
		return true
	}
	if choice == 777 {
		return false
	}
	choice = choice - 1
	term.clear()
	println("Selected Interface with IP: ${results[choice]}")
	port_choice := strconv.atoi(os.input("What port would you like to listen on? [Press enter for random high]")) or {
		rand.int_in_range(50000,65535)
	}
	term.clear()
	println("Starting listener on ${results[choice]}:$port_choice")
	return create_listener(results[choice], port_choice)
}

pub fn create_listener(ip string, port int) bool {	
	if !g_config.bind_c2("$ip:$port") {
		return false
	}
	println("Successfully started UDP Listener on $ip:$port")
	defer {
		println("Closing port")
	}
	go handle_listener()
	for {
		if select {
			a := <-g_config.connection_stream {
				println(string(a))
				if string(a) == "Exit\n" {
					return true
				}
			}
		} {
			println("Received")
		} else {
			println("channel closed")
			return true
		}
	}
	return false
}

pub fn view_listener() {
	
}

fn handle_listener() {
	for {
		mut buf := []byte{len: 100, init: 0}
		mut con := g_config.c2_listen_handle
		read, addr := con.read(mut buf) or { continue } {
			println('Server got addr $addr')
		}
		con.write_to(addr, buf[..read]) or {
			println('Server: connection dropped')
		}
		if string(buf) == "Exit\n" {
			g_config.close_c2()
		}
		g_config.connection_stream <- buf
	}
}

pub fn start_c2() bool {
	match os.user_os() {
		"windows" {
			return handle_windows_c2()
		}
		"linux" {
			return handle_linux_c2()
		}
		else {
			println("unsupported os, will try to add MacOS in the future")
			return false
		}
	}
}

pub fn stop_c2() bool {
	return true
}