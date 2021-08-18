module vicl
import term
import strconv
import os

// This should probably be it's own project...
// Prompts can hold other prompts
pub struct Prompt {
	title string
	choices []&Prompt
	sub_prompts []&Prompt
	// If it has a func, it shouldn't have sub_prompts
	func fn() bool
}

pub struct Prompt_Manager {
pub mut:
	status string
	current_prompt &Prompt
	stored_prompts []&Prompt
	prompts []&Prompt
}

pub const(
	back_ = &Prompt{
		title: "Back"
		func: fn() bool {return true}
	}
	exit_ = &Prompt{
		title: "Exit"
		func: fn() bool {return true}
	}
)


pub fn (p Prompt) display() {
	println("$p.title")
}

pub fn (mut p Prompt_Manager) selection(item int) {
	term.clear()
	if item <= 0 {
		if p.stored_prompts.len < 1 {
			p.status = "Exit"
			return
		}
		p.current_prompt = p.stored_prompts.pop()
		p.status = p.current_prompt.title
		return
	}
	if item == 777 {
		println("That is not valid")
		return
	}
	if item > p.current_prompt.choices.len-1 {
		println("You entered ${item - (p.current_prompt.choices.len-1)} higher than the last choice...")
		return
	}
	// There were no subprompts so we need to execute commands
	if p.current_prompt.sub_prompts.len < 1 {
		mut res := p.current_prompt.choices[item].func()
		for !res {
			res = p.current_prompt.choices[item].func()
		}
	} else {
		// There is a sub prompt, go into it.
		p.stored_prompts << p.current_prompt
		p.current_prompt = p.current_prompt.sub_prompts[item-1]
		p.status = p.current_prompt.title
	}
}

pub fn (p Prompt_Manager) display() {
	println("Current Choices for $p.status:")
	if p.current_prompt.choices.len > 0 {
		for index, choice in p.current_prompt.choices {
			println("${index}) $choice.title")
		}
	}
}

pub fn(mut p Prompt_Manager) start_repl() {
	p.display()
	choice_num := strconv.atoi(os.input("Enter Choice: ")) or { 777 }
	p.selection(choice_num)
}