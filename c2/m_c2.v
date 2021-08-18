module c2

import os
import windows
import linux

// detect os

pub fn get_os() string {
	return os.user_os()
}

pub fn start_c2() {
	println(get_os())
}


// start listener

// interact

// schedule tasks