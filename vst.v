module main
import c2
import cli
import os
import term
import strconv
import vicl { Prompt_Manager, Prompt }

fn main() {
	mut app := cli.Command{
		name: 'V Security Tools'
		description: 'What have you pwned today?'
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
	beacon_create := &Prompt{
		title: "Create Beacon"
		func: fn() bool {return true}
	}
	c2_prompt := &Prompt{
		title: "C2 Server",
		choices: [vicl.back_, c2_start, c2_stop]
		sub_prompts: []&Prompt{}
	}
	beacon_prompt := &Prompt{
		title: "Beacons",
		choices: [vicl.back_, beacon_create],
		sub_prompts: []&Prompt{}
	}
	main_prompt := &Prompt{
		title: "Main Menu",
		choices: [vicl.exit_, c2_prompt, beacon_prompt],
		sub_prompts: [c2_prompt, beacon_prompt]
	}
	mut prompt_mgr := Prompt_Manager{
		status: "Main Menu",
		current_prompt: main_prompt,
		stored_prompts: []&Prompt{},
		prompts: [main_prompt]
	}

	println("Lets get you set up...")
	for prompt_mgr.status != "Exit" {
		prompt_mgr.start_repl()
	}
}

