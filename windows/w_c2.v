module windows
import os

fn parse_ip_output(result os.Result) ?[]string {
	if result.exit_code != 0 {
		return error("windows: GET IP FAILED")
	}
	mut detected_ips := []string{}
	for item in result.output.split_into_lines() {
		mut cleaned := item.replace(" ", "")
		if cleaned.starts_with("IPv4") {
			cleaned = cleaned.split(":")[1]
			cleaned = cleaned.split("(")[0]
			detected_ips << cleaned
		}
	}
	return detected_ips
}

pub fn get_ip_addresses() ?[]string {
	return parse_ip_output(os.execute("ipconfig /all"))
}