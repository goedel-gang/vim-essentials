.PHONY: demo plug_demo

demo:
	vim -u essentials.vim -U gui_essentials.vim essentials.vim gui_essentials.vim

plugdemo:
	DO_PLUG_DEMO=1 vim -u essentials.vim -U gui_essentials.vim essentials.vim gui_essentials.vim

gdemo:
	gvim -u essentials.vim -U gui_essentials.vim essentials.vim gui_essentials.vim

gplugdemo:
	DO_PLUG_DEMO=1 gvim -u essentials.vim -U gui_essentials.vim essentials.vim gui_essentials.vim

