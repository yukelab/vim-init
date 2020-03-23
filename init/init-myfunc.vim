"======================================================================
"****************************************************
"新文件标题
"新建.c,.h,.sh,.java文件，自动插入文件头
"****************************************************
autocmd BufNewFile *.vim,*.cpp,*.[ch],*.sh,*.rb,*.java,*.py exec ":call SetTitle()"
func! SetTitle()
	let l:string_time = strftime("%Y/%m/%d")
	" Last Modified: 2018/05/30 16:53:18
	"如果文件类型为.sh文件
	if &filetype == 'sh'
		let l:head_list = [
					\"\#!/bin/bash",
					\"",
					\]
	elseif &filetype == 'python'
		let l:head_list = [
					\"#!/usr/bin/env python",
					\"# -*- coding=utf-8 -*-",
					\"",
					\]

	elseif &filetype == 'ruby'
		let l:head_list = [
					\"#!/usr/bin/env ruby",
					\"# encoding: utf-8",
					\"",
					\]
	elseif &filetype == 'vim'
		let l:file_name = '" ' . expand("%:t")
		let l:string_time_all = strftime("%Y/%m/%d %T")
		let l:head_list = [
					\'" ======================================================================',
					\l:file_name,
					\'" -',
					\'" Created by yukelab on ' . l:string_time,
					\'" Last Modified: '. l:string_time_all,
					\'" ======================================================================',
					\""
					\]
	else
		let l:file_name = " * File Name   : ".expand("%:t")
		let l:author_name = " * ".expand(l:string_time).expand("     liqi         The first version.")
		let l:head_list = [
					\ "/*************************************************************************",
					\l:file_name,
					\" * Brief       :",
					\" * Change Logs :",
					\" * Date           Author       Notes",
					\l:author_name,
					\"*************************************************************************/",
					\"",
					\]
	endif
	echo &filetype

	if expand("%:e") == 'cpp'
		echo "filetype cpp"
		let l:local_header_list = [
					\"#include<iostream>",
					\"using namespace std;",
					\"",
					\]
		let l:head_list += l:local_header_list
	elseif &filetype == 'c'
		echo "filetype c"
		let l:local_header_list = [
					\"#include<stdio.h>",
					\"",
					\]
		let l:head_list += l:local_header_list
	elseif expand("%:e") == 'h'
		" echo "filetype h"
		let l:local_header_list = [
					\"#ifndef _" . toupper(expand("%:t:r")) . "_H",
					\"#define _" . toupper(expand("%:t:r")) . "_H",
					\"#endif",
					\"",
					\]
		let l:head_list += l:local_header_list
	endif

	if &filetype == 'java'
		let l:local_header_list = [
					\"public class ".expand("%:r"),
					\"",
					\]
		let l:head_list += l:local_header_list
	endif
	call append(0, l:head_list)
	"新建文件后，自动定位到文件末尾
	autocmd BufNewFile * normal G
endfunc

"*****************************************************
"代码格式优化化                                      *
"*****************************************************
map <F3> :call FormartSrc()<CR><CR>
"定义FormartSrc()
func! FormartSrc()
	exec "w"
	if &filetype == 'c' || &filetype == 'h'
		" exec "!astyle --style=ansi -A1 --suffix=none %"
		exec "!astyle --style=allman --indent=spaces=4 --indent-preproc-block --pad-oper --pad-header --unpad-paren --suffix=none --align-pointer=name --lineend=linux --convert-tabs --verbose %"
	elseif &filetype == 'cpp' || &filetype == 'hpp'
		exec "r !astyle --style=ansi --one-line=keep-statements -a --suffix=none %> /dev/null 2>&1"
	elseif &filetype == 'perl'
		exec "!astyle --style=gnu --suffix=none %"
	elseif &filetype == 'py'||&filetype == 'python'
		exec "r !autopep8 -i --aggressive %"
	elseif &filetype == 'java'
		exec "!astyle --style=java --suffix=none %"
	elseif &filetype == 'jsp'
		exec "!astyle --style=gnu --suffix=none %"
	elseif &filetype == 'xml'
		exec "!astyle --style=gnu --suffix=none %"
	else
		exec "normal gg=G"
		return
	endif
	exec "e! %"
endfunc

"*****************************************************
"                   插入文件头                      *
"*****************************************************
" iab xdt <c-r>=strftime("=======20%y.%m.%d(%A)=======")<cr>
" iab idate <c-r>=strftime("/******** Review date: %c *******/")<cr>
" map <F11> O<Esc>:call SetFileHead()<cr><cr>
func! SetFileHead()

	let l:string_time = strftime("%Y.%m.%d")
	if &filetype == 'vim'
		let l:string_time_all = strftime("%Y/%m/%d %T")
		let l:file_name = '" ' . expand("%:t")
		let l:head_list = [
					\'" ======================================================================',
					\l:file_name,
					\'" -',
					\'" Created by yukelab on ' . l:string_time,
					\'" Last Modified: '. l:string_time_all,
					\'" ======================================================================',
					\""
					\]
	else
		let l:file_name = " * File Name   : ".expand("%:t")
		let l:author_name = " * ".expand(l:string_time).expand("     liqi         refactoring version.")
		let l:head_list = [
					\ "/*************************************************************************",
					\l:file_name,
					\" * Brief       :",
					\" * Change Logs :",
					\" * Date           Author       Notes",
					\" * 2017-10-21     saber        the first version.",
					\l:author_name,
					\"*************************************************************************/",
					\""
					\]
	endif
	call append(0, l:head_list)
endfunc

"*****************************************************
"                   插入修改块                      *
"*****************************************************
" map <F12> O<Esc>:call SetReviewBlock()<cr><cr>
func! SetReviewBlock()
	let l:string_time = strftime("%c")
	if &filetype == 'c' || &filetype == 'h' || &filetype == 'cpp' || &filetype == 'hpp'
		let l:review_list = [
					\printf("/* yukelab: %s */", l:string_time),
					\"/* Rev Block Start:*/",
					\"",
					\"",
					\"/* Rev Block End. */"
					\]
	elseif &filetype == 'py' || &filetype == 'python'
		let l:review_list = [
					\printf("#* yukelab: %s *#", l:string_time),
					\"#* Rev Block Start:",
					\"",
					\"",
					\"#* Rev Block End.",
					\]
	else
		let l:review_list = [
					\printf("// yukelab: %s *#", l:string_time),
					\"// Rev Block Start:",
					\"",
					\"",
					\"// Rev Block End.",
		]
	endif
	call append(line("."), l:review_list)
endfunc


map ,ch :call SetColorColumn()<CR>
function! SetColorColumn()
	let col_num = virtcol(".")
	let cc_list = split(&cc, ',')
	if count(cc_list, string(col_num)) <= 0
		execute "set cc+=".col_num
	else
		execute "set cc-=".col_num
	endif
endfunction

