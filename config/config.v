module config
import json
import os
import net

pub struct CONFIG {
pub mut:
	connection_stream chan []byte
	c2_listen_handle net.UdpConn
	bind_info string = ""
}

pub fn (c &CONFIG) bind_c2(connection_string string) bool {
	g_config.c2_listen_handle = net.listen_udp(connection_string) or {
		println("Failed to open UDP")
		return false
	}
	g_config.bind_info = connection_string
	g_config.write_implant_config()
	return true
}

pub fn (c &CONFIG) close_c2() bool {
	g_config.c2_listen_handle.close() or {
		println("Failed to close C2 or C2 was already closed")
		return false
	}
	return true
}

fn (c &CONFIG) write_implant_config() {
	os.write_file("./config/implant.config", g_config.bind_info) or {
		println("Failed to write implant config for C2 instance")
	}
	println("Write Implant Config to VSTDIR/config/implant.config")
}