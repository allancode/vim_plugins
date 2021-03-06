/*
 * created by Longbin_Li <beangr@163.com>
 * 2014-12-05
 * 2015-03-09
 */
we can use these scripts to explorer souce code.
Before doing this, we may need to do following steps:

1. change directory to our home dir.
for instance, /home/mike; and then
	$ tar -zxvf vim_cfg_backup.tar.gz -C ~/

2. then change current directory to the source code location.
 for instance, kernel source locates /opt/kernel/
	$ cd /opt/kernel
 and android source locates /home/mike/projects/p1/LINUX/android/
	$ cd /home/mike/projects/p1/LINUX/android
 then use below commands to generate cscope files and tags in order to exploring source code;
	$ /bin/bash ~/.vim/tools/shell/gen_kernel_SrcExpl.sh      #for kernel
	$ /bin/bash ~/.vim/tools/shell/gen_android_SrcExpl.sh     #for android
 after this, we could see cscope.out and tags files under the source code directory;

3. use vim to open the file which you want to explorer.
	for instance,
	$ vim /opt/kernel/driver/input/touchscreen/atmel_mxt_ts.c
 then we could do following by
+-------------------------------------------------------------------------------+
|   <F2>        toggle the taglist window                                       |
|   <F3>        toggle the SrcExpl window, please do not open in android src    |
|   <F5>        toggle the NERDTree window                                      |
+-------------------------------------------------------------------------------+
SrcExpl is based on ctags' file tags;

Following shottcuts could help us jump freely, but we only recommend you use them
when analysising kernel source;
but for android please do not use them since its source code too large amount;
when analysising android source code please use the find commands which will be
introduced a moment later;
+-------------------------------------------------------------------------------+
|   <C-j>       show the next definition------>in SrcExpl window; need tags     |
|   <C-z>       back to last location--------->in SrcExpl window; need tags     |
+- -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -+
|   <C-]>       jump to definition in the edit window-->need cscope.out/tags    |
|   <C-t>       jump back to the last location--------->need cscope.out/tags    |
+-------------------------------------------------------------------------------+

below methods help us to jump to the file or function defination where we want to go;
to jump back we need use <C-t>; and we should have cscope.out file firstly;
It's recommended that to use this method to jump freely, especialy in android;
	$ cscope-indexer -r
+-------------------------------------------------------------------------------+
|   when the cursor is on the string/filename/function,                         |
|   we could use following key to find something shortcutly;                    |
|                                                                               |
|    \f          find the file and open it                                      |
|    \g          find global definition                                         |
|    \s          find this symbol                                               |
|    \d          find out functions those called by this func                   |
|    \c          find functions those calling/reference this func               |
|    \i          find file #include/reference this file                         |
|    \t          find text string                                               |
|    \e          find egrep pattern                                             |
+-------------------------------------------------------------------------------+
|   we could also use bellow commands by the underline mode of vim.             |
|                                                                               |
|   :cs find f ME           find ME and open it; ME is a file such as stdio.h   |
|   :cs find g ME           find ME; ME is a global definition                  |
|   :cs find s ME           find ME; ME is a symbol                             |
|   :cs find d ME           find who called ME, ME is a func or macro etc.      |
|   :cs find c ME           find the funcs; the funcs is calling/reference ME   |
|   :cs find i ME           find the files; the files #include/reference ME     |
|   :cs find t ME           find ME; ME is a text string                        |
|   :cs find e ME           find ME; ME is an egrep pattern                     |
+-------------------------------------------------------------------------------+

4. auto completion system in vim.
write following into ~/.vimrc file
-----------------------------------------------
	let g:neocomplcache_enable_at_startup=1
	set completeopt+=longest
	let g:neocomplcache_enable_auto_select=1
	let g:neocomplcache_disable_auto_complete=1
-----------------------------------------------
when need auto completion just press <C-n> to select which you like;

5. comment or uncomment to the source code.
+-----------------------------------------------------------------------+
|    \cc         comment                                     *          |
|    \cu         uncomment                                   *          |
|    \cm         comment minimal                                        |
|    \ci         comment or uncomment                                   |
|    \cs         comment for block codes sexily              *          |
|    \cA         comment to the end and go to insert mode               |
|                                                                       |
|    \ca         alternate the delimiters will be used                  |
+-----------------------------------------------------------------------+

6. Other operations in vim.

6.1 We can use following keys to fold and/or unfold the source code session.
+-----------------------------------------------------------------------+
|        foldenable                                                     |
|     zi         open/close all fold                                    |
|     zo         open the fold under current cursor                     |
|     zc         close the fold under current cursor                    |
|     <Space>    open/close the fold under current sursor               |
+-----------------------------------------------------------------------+
6.2 hilight the word by txtbrowser script.
+-----------------------------------------------------------------------+
|        txtbrowser                                                     |
|     \h         hilight the word under cursor in current file          |
|     *          search forward for the word under cursor               |
|     #          search backword for the word under cursor              |
+-----------------------------------------------------------------------+
6.3 Digraphs
Some characters are not on the keyboard.  For example, the copyright character (©).
To type these characters in Vim, you use digraphs, where two characters represent one.
To enter a ©, for example, you press three keys: >
        CTRL-K Co
To find out what digraphs are available, use the following command: >
		:digraphs
Vim will display the digraph table.  Here are three lines of it:

  AC ~_ 159  NS |  160  !I ¡  161  Ct ¢  162  Pd £  163  Cu ¤  164
  Ye ¥  165  BB ¦  166  SE §  167  ': ¨  168  Co ©  169  -a ª  170
  << «  171  NO ¬  172  -- ­  173  Rg ®  174  'm ¯  175  DG °  176
  +- ±  177  2S ²  178  3S ³  179 
This shows, for example, that the digraph you get by typing CTRL-K Pd is the
character (£).  This is character number 163 (decimal).

