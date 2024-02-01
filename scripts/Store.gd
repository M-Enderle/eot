extends Node

var openai_key = "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"
var rev_ip = ""
var input_tokens = 0
var output_tokens = 0

func set_rev_ip(inv_code):
	var reverse_ip_template = "http://212.87.<inv_code>:3000"
	rev_ip = reverse_ip_template.replace("<inv_code>", inv_code)

func get_cost():
	# see https://openai.com/pricing
	return (input_tokens / 1000) * 0.001 + (output_tokens / 1000) * 0.002
