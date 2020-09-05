.PHONY: demo

demo:
	vim -u essentials.vim essentials.vim

plug_demo:
	DO_PLUG_DEMO=1 vim -u essentials.vim essentials.vim
