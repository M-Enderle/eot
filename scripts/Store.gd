extends Node

var openai_key = "sk-"
var rev_ip = "212.87.<key>:3000"

func set_rev_ip(inv_code):
	var reverse_ip_template = "212.87.<inv_code>:3000"
	rev_ip = reverse_ip_template.replace("<inv_code>", inv_code)
