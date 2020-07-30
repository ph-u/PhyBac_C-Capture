#!/bin/bash

# Desc 		: compile thesis for testing
# Input 	: ./thesis_test.sh
# Output 	: test thesis.pdf in this folder

nohup ../code/hk_luaLTX.sh ../code/thesis.tex ../p_feedbacks &
while [ `ps aux|grep hk_lua|grep tex|grep p_f|wc -l` -gt 0 ];do
	sleep 10
done
../code/hk_gen_readme.sh
