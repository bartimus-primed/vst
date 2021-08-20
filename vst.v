module main
import c2
import implant
import cli
import os
import term
import strconv
import vicl { Prompt_Manager, Prompt }
import config { CONFIG }
__global (
	g_config CONFIG
)

fn init() {
	g_config = &CONFIG{
		connection_stream: chan []byte{}
	}
}

fn main() {
	mut app := cli.Command{
		name: 'V Security Tools'
		execute: fn(cmd cli.Command) ? {
			term.clear()
			println("Welcome... Starting interactive mode.")
			run_repl()
			println("Exiting...")
			return
		}
		commands: [
			cli.Command{
				name: 'C2'
				execute: fn(cmd cli.Command) ? {
					println("start C2?")
					c2.start_c2()
					return
				}
			}
		]
	}
	app.setup()
	app.parse(os.args)
}

fn run_repl() {

	c2_start := &Prompt{
		title: "Start C2"
		func: c2.start_c2
	}
	c2_stop := &Prompt{
		title: "Stop C2"
		func: c2.stop_c2
	}
	implant_create := &Prompt{
		title: "Create Implant"
		func: implant.start_implant
	}
	c2_prompt := &Prompt{
		title: "C2 Server",
		choices: [vicl.back_, c2_start, c2_stop]
		sub_prompts: []&Prompt{}
	}
	implant_prompt := &Prompt{
		title: "Implants",
		choices: [vicl.back_, implant_create],
		sub_prompts: []&Prompt{}
	}
	main_prompt := &Prompt{
		title: "Main Menu",
		choices: [vicl.exit_, c2_prompt, implant_prompt],
		sub_prompts: [c2_prompt, implant_prompt]
	}
	mut prompt_mgr := Prompt_Manager{
		status: "Main Menu",
		current_prompt: main_prompt,
		stored_prompts: []&Prompt{},
		prompts: [main_prompt]
	}
	// Need to work on sigint catching...
	// os.signal_opt(.int, fn(s os.Signal) {
	// 		ans := strconv.atoi(os.input("Are you trying to exit or just go back? [enter to exit]")) or { 0 }
	// 		if ans == 0 {
	// 			println("cleaning up and exiting...")
	// 			exit(0)
	// 		}
	// 		return
	// }) or { panic(err) }
	vicl.pgood("What have you pwned today?")
	vicl.pblue("Lets get you set up...")
	for prompt_mgr.status != "Exit" {
		prompt_mgr.start_repl()
	}
	g_config.close_c2()
}