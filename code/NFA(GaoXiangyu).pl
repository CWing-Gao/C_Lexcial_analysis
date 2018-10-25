/*ASCII Distinguish*/
lower(X):- X>=97,X=<122.
upper(X):- X>=65,X=<90.
alphabet(X):- lower(X)|upper(X).
digit(X):- X>47,X<58.
underline(X):- X is 95.
asterisk(42).   % ASCII: *
add(43). 		% ASCII: +
sub(45). 		% ASCII: -
div(47).		% ASCII: /
not_(33).		% ASCII: !
lea(38).		% ASCII: &
mod(37).		% ASCII: %
or(124).		% ASCII: |
assign(61).		% ASCII: =
gt(62).			% ASCII: >
lt(60).			% ASCII: <
comma(44).		% ASCII: ,
colon(58).		% ASCII: :
semico(59).		% ASCII: ;
lparen(40).		% ASCII: (
rparen(41).		% ASCII: )
lbrac(123).		% ASCII: [
rbrac(125).		% ASCII: ]
space(32).		% ASCII: (space)

/*Classifying characters according to the C programming language*/
arithmetic_op(X):- asterisk(X) | add(X) | sub(X) | div(X). 
logic_op(X):- not_(X)  | lea(X) | mod(X) | or(X) | gt(X) | lt(X).
name_legal(X):-  alphabet(X) | digit(X) | underline(X). % naming legal character of C
delimiter(X):- arithmetic_op(X) | logic_op(X) | assign(X) | space(X) |
    comma(X) | colon(X) | semico(X) | lparen(X) | rparen(X) | lbrac(X) | rbrac(X).

/*Finite Automata*/
start(S):-
    name(S,L),
    write(L),nl,
    begin(L-_,_). % Begin Loop

% End Loop
begin(S-_,_):- S ==[].

%begin:int if
begin([X|Y]-Y,S):-
        [X|Y]\=[],
        X is 105,
        write('begin_i'),nl,
        mover(sta_i_1,Y-_,S),
        write(S),nl,
        begin(S-_,_).
% begin: char case continue 
begin([X|Y]-Y,S):-
    [X|Y]\=[],
    X is 99,
    write('begin_c'),nl,
    mover(sta_c_1,Y-_,S),
    write(S),nl,
    begin(S-_,_).
%begin:for
begin([X|Y]-Y,S):-
        [X|Y]\=[],
        X is 102,
        write('begin_for'),nl,
        mover(sta_f_1,Y-_,S),
        write(S),nl,
        begin(S-_,_).
% begin:void
begin([X|Y]-Y,S):-
        [X|Y]\=[],
        X is 118,
        write('begin_void'),nl,
        mover(sta_v_1,Y-_,S),
        write(S),nl,
        begin(S-_,_).
%begin: extern else
begin([X|Y]-Y,S):-
        [X|Y]\=[],
        X is 101,
        write('begin_e'),nl,
        mover(sta_e_1,Y-_,S),
        write(S),nl,
        begin(S-_,_).
%begin:switch
begin([X|Y]-Y,S):-
        [X|Y]\=[],
        X is 115,
        write('begin_switch'),nl,
        mover(sta_s_1,Y-_,S),
        write(S),nl,
        begin(S-_,_).
%begin:default do
begin([X|Y]-Y,S):-
        [X|Y]\=[],
        X is 100,
        write('begin_d'),nl,
        mover(sta_d_1,Y-_,S),
        write(S),nl,
        begin(S-_,_).
%begin:while
begin([X|Y]-Y,S):-
        [X|Y]\=[],
        X is 119,
        write('begin_while'),nl,
        mover(sta_w_1,Y-_,S),
        write(S),nl,
        begin(S-_,_).
%begin:break
begin([X|Y]-Y,S):-
        [X|Y]\=[],
        X is 98,
        write('begin_break'),nl,
        mover(sta_b_1,Y-_,S),
        write(S),nl,
        begin(S-_,_).
%begin:return
begin([X|Y]-Y,S):-
        [X|Y]\=[],
        X is 114,
        write('begin_return'),nl,
        mover(sta_r_1,Y-_,S),
        write(S),nl,
        begin(S-_,_).
% begin:variable 
begin([X|Y]-Y,S):-
    [X|Y]\=[],
    alphabet(X),
    % Remove the first letter of the keyword
    X\= 105, X\=99,X\=118,X\=101,X\=115,X\=100,X\=119,X\=102,X\=98,X\=114,
    write('begin_variable '),nl,
    mover(sta_var,Y-_,S),
    write(S),nl,
    begin(S-_,_).
begin([X|Y]-Y,S):-
    [X|Y]\=[],
    underline(X),
    % Remove the first letter of the keyword
    X\= 105, X\=99,X\=118,X\=101,X\=115,X\=100,X\=119,X\=102,X\=98,X\=114,
    write('begin_variable '),nl,
    mover(sta_var,Y-_,S),
    write(S),nl,
    begin(S-_,_).
% begin:number
begin([X|Y]-Y,S):-
    [X|Y]\=[],
    digit(X),
    write('begin_number '),nl,
    mover(sta_num,Y-_,S),
    write(S),nl,
    begin(S-_,_).
% begin dlimiter
begin([X|Y]-Y,_):-
    [X|Y]\=[],
    delimiter(X),
    begin(Y-_,_).


/* mover: change state of Finite Automata */

% variable
mover(sta_var,[X|Y]-Y,S):-
    name_legal(X),
    write('sta_var '),nl,
    mover(sta_var,Y-_,S).
%end variable
mover(sta_var,[X|Y]-Y,S):-
    delimiter(X),
    write('This is a variable '),nl,
    append(Y,[],S).
% number
mover(sta_num,[X|Y]-Y,S):-
    digit(X),
    write('sta_num'),nl,
    mover(sta_num,Y-_,S).
%end variable
mover(sta_num,[X|Y]-Y,S):-
    delimiter(X),
    write('This is a number '),nl,
    append(Y,[],S).
%i 
mover(sta_i_1,[X|Y]-Y,S):-
	delimiter(X),
	write('This is a variable '),nl,
	append(Y,[],S).
%if
mover(sta_i_1,[X|Y]-Y,S):-
        X is 102,
        write('sta_i_1 '),nl,
        mover(sta_if_2,Y-_,S).
mover(sta_i_1,[X|Y]-Y,S):-
        X \= 102,X \= 110,
        write('sta_i_1 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_if_2,[X|Y]-Y,S):-
        delimiter(X),   write('sta_kw_if'),nl,
        append(Y,[],S),
        write('This is a key word:if'),nl.
mover(sta_if_2,[X|Y]-Y,S):-
        name_legal(X),  write('sta_if_2 '),nl,
        mover(sta_var,Y-_,S).
%int
mover(sta_i_1,[X|Y]-Y,S):-
        X is 110,
        write('sta_i_1 '),nl,
        mover(sta_int_2,Y-_,S).
mover(sta_int_2,[X|Y]-Y,S):-
        X is 116,
        write('sta_int_2 '),nl,
        mover(sta_int_3,Y-_,S).
mover(sta_int_2,[X|Y]-Y,S):-
        X \= 116,
        write('sta_int_2 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_int_3,[X|Y]-Y,S):-
        delimiter(X),   write('sta_kw_int'),nl,
        append(Y,[],S),
        write('This is a key word:int'),nl.
mover(sta_int_3,[X|Y]-Y,S):-
        name_legal(X),  write('sta_int_3 '),nl,
        mover(sta_var,Y-_,S).
%c 
mover(sta_c_1,[X|Y]-Y,S):-
	delimiter(X),
	write('This is a variable '),nl,
	append(Y,[],S).

%char
mover(sta_c_1,[X|Y]-Y,S):-
        X is 104,
        write('sta_c_1 '),nl,
        mover(sta_char_2,Y-_,S).
mover(sta_c_1,[X|Y]-Y,S):-
        X \= 104,X \= 97, X \= 111,
        write('sta_c_1 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_char_2,[X|Y]-Y,S):-
        X is 97,
        write('sta_char_2 '),nl,
        mover(sta_char_3,Y-_,S).
mover(sta_char_2,[X|Y]-Y,S):-
        X \= 97,
        write('sta_char_2 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_char_3,[X|Y]-Y,S):-
        X is 114,
        write('sta_char_3 '),nl,
        mover(sta_char_4,Y-_,S).
mover(sta_char_3,[X|Y]-Y,S):-
        X \= 114,
        write('sta_char_3 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_char_4,[X|Y]-Y,S):-
        delimiter(X),   write('sta_kw_char'),nl,
        append(Y,[],S),
        write('This is a key word:char'),nl.
mover(sta_char_4,[X|Y]-Y,S):-
        name_legal(X),  write('sta_char_4 '),nl,
        mover(sta_var,Y-_,S).
%case
mover(sta_c_1,[X|Y]-Y,S):-
        X is 97,
        write('sta_c_1 '),nl,
        mover(sta_case_2,Y-_,S).
mover(sta_case_2,[X|Y]-Y,S):-
        X is 115,
        write('sta_case_2 '),nl,
        mover(sta_case_3,Y-_,S).
mover(sta_case_2,[X|Y]-Y,S):-
        X \= 115,
        write('sta_case_2 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_case_3,[X|Y]-Y,S):-
        X is 101,
        write('sta_case_3 '),nl,
        mover(sta_case_4,Y-_,S).
mover(sta_case_3,[X|Y]-Y,S):-
        X \= 101,
        write('sta_case_3 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_case_4,[X|Y]-Y,S):-
        delimiter(X),   write('sta_kw_case'),nl,
        append(Y,[],S),
        write('This is a key word:case'),nl.
mover(sta_case_4,[X|Y]-Y,S):-
        name_legal(X),  write('sta_case_4 '),nl,
        mover(sta_var,Y-_,S).
%continue
mover(sta_c_1,[X|Y]-Y,S):-
        X is 111,
        write('sta_c_1 '),nl,
        mover(sta_continue_2,Y-_,S).
mover(sta_continue_2,[X|Y]-Y,S):-
        X is 110,
        write('sta_continue_2 '),nl,
        mover(sta_continue_3,Y-_,S).
mover(sta_continue_2,[X|Y]-Y,S):-
        X \= 110,
        write('sta_continue_2 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_continue_3,[X|Y]-Y,S):-
        X is 116,
        write('sta_continue_3 '),nl,
        mover(sta_continue_4,Y-_,S).
mover(sta_continue_3,[X|Y]-Y,S):-
        X \= 116,
        write('sta_continue_3 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_continue_4,[X|Y]-Y,S):-
        X is 105,
        write('sta_continue_4 '),nl,
        mover(sta_continue_5,Y-_,S).
mover(sta_continue_4,[X|Y]-Y,S):-
        X \= 105,
        write('sta_continue_4 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_continue_5,[X|Y]-Y,S):-
        X is 110,
        write('sta_continue_5 '),nl,
        mover(sta_continue_6,Y-_,S).
mover(sta_continue_5,[X|Y]-Y,S):-
        X \= 110,
        write('sta_continue_5 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_continue_6,[X|Y]-Y,S):-
        X is 117,
        write('sta_continue_6 '),nl,
        mover(sta_continue_7,Y-_,S).
mover(sta_continue_6,[X|Y]-Y,S):-
        X \= 117,
        write('sta_continue_6 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_continue_7,[X|Y]-Y,S):-
        X is 101,
        write('sta_continue_7 '),nl,
        mover(sta_continue_8,Y-_,S).
mover(sta_continue_7,[X|Y]-Y,S):-
        X \= 101,
        write('sta_continue_7 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_continue_8,[X|Y]-Y,S):-
        delimiter(X),   write('sta_kw_continue'),nl,
        append(Y,[],S),
        write('This is a key word:continue'),nl.
mover(sta_continue_8,[X|Y]-Y,S):-
        name_legal(X),  write('sta_continue_8 '),nl,
        mover(sta_var,Y-_,S).
%f 
mover(sta_f_1,[X|Y]-Y,S):-
	delimiter(X),
	write('This is a variable '),nl,
	append(Y,[],S).
%for
mover(sta_f_1,[X|Y]-Y,S):-
        X is 111,
        write('sta_f_1 '),nl,
        mover(sta_for_2,Y-_,S).
mover(sta_f_1,[X|Y]-Y,S):-
        X \= 111,
        write('sta_f_1 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_for_2,[X|Y]-Y,S):-
        X is 114,
        write('sta_for_2 '),nl,
        mover(sta_for_3,Y-_,S).
mover(sta_for_2,[X|Y]-Y,S):-
        X \= 114,
        write('sta_for_2 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_for_3,[X|Y]-Y,S):-
        delimiter(X),   write('sta_kw_for'),nl,
        append(Y,[],S),
        write('This is a key word:for'),nl.
%v
mover(sta_v_1,[X|Y]-Y,S):-
	delimiter(X),
	write('This is a variable '),nl,
	append(Y,[],S).
% void
mover(sta_v_1,[X|Y]-Y,S):-
        X is 111,
        write('sta_v_1 '),nl,
        mover(sta_void_2,Y-_,S).
mover(sta_v_1,[X|Y]-Y,S):-
        X \= 111,
        write('sta_v_1 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_void_2,[X|Y]-Y,S):-
        X is 105,
        write('sta_void_2 '),nl,
        mover(sta_void_3,Y-_,S).
mover(sta_void_2,[X|Y]-Y,S):-
        X \= 105,
        write('sta_void_2 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_void_3,[X|Y]-Y,S):-
        X is 100,
        write('sta_void_3 '),nl,
        mover(sta_void_4,Y-_,S).
mover(sta_void_3,[X|Y]-Y,S):-
        X \= 100,
        write('sta_void_3 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_void_4,[X|Y]-Y,S):-
        delimiter(X),   write('sta_kw_void'),nl,
        append(Y,[],S),
        write('This is a key word:void'),nl.
mover(sta_void_4,[X|Y]-Y,S):-
        name_legal(X),  write('sta_void_4 '),nl,
        mover(sta_var,Y-_,S).
%e
mover(sta_e_1,[X|Y]-Y,S):-
	delimiter(X),
	write('This is a variable '),nl,
	append(Y,[],S).
% extern
mover(sta_e_1,[X|Y]-Y,S):-
        X is 120,
        write('sta_e_1 '),nl,
        mover(sta_extern_2,Y-_,S).
mover(sta_e_1,[X|Y]-Y,S):-
        X \= 120,X \= 108,
        write('sta_e_1 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_extern_2,[X|Y]-Y,S):-
        X is 116,
        write('sta_extern_2 '),nl,
        mover(sta_extern_3,Y-_,S).
mover(sta_extern_2,[X|Y]-Y,S):-
        X \= 116,
        write('sta_extern_2 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_extern_3,[X|Y]-Y,S):-
        X is 101,
        write('sta_extern_3 '),nl,
        mover(sta_extern_4,Y-_,S).
mover(sta_extern_3,[X|Y]-Y,S):-
        X \= 101,
        write('sta_extern_3 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_extern_4,[X|Y]-Y,S):-
        X is 114,
        write('sta_extern_4 '),nl,
        mover(sta_extern_5,Y-_,S).
mover(sta_extern_4,[X|Y]-Y,S):-
        X \= 114,
        write('sta_extern_4 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_extern_5,[X|Y]-Y,S):-
        X is 110,
        write('sta_extern_5 '),nl,
        mover(sta_extern_6,Y-_,S).
mover(sta_extern_5,[X|Y]-Y,S):-
        X \= 110,
        write('sta_extern_5 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_extern_6,[X|Y]-Y,S):-
        delimiter(X),   write('sta_kw_extern'),nl,
        append(Y,[],S),
        write('This is a key word:extern'),nl.
mover(sta_extern_6,[X|Y]-Y,S):-
        name_legal(X),  write('sta_extern_6 '),nl,
        mover(sta_var,Y-_,S).
%else
mover(sta_e_1,[X|Y]-Y,S):-
        X is 108,
        write('sta_e_1 '),nl,
        mover(sta_else_2,Y-_,S).
mover(sta_else_2,[X|Y]-Y,S):-
        X is 115,
        write('sta_else_2 '),nl,
        mover(sta_else_3,Y-_,S).
mover(sta_else_2,[X|Y]-Y,S):-
        X \= 115,
        write('sta_else_2 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_else_3,[X|Y]-Y,S):-
        X is 101,
        write('sta_else_3 '),nl,
        mover(sta_else_4,Y-_,S).
mover(sta_else_3,[X|Y]-Y,S):-
        X \= 101,
        write('sta_else_3 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_else_4,[X|Y]-Y,S):-
        delimiter(X),   write('sta_kw_else'),nl,
        append(Y,[],S),
        write('This is a key word:else'),nl.
mover(sta_else_4,[X|Y]-Y,S):-
        name_legal(X),  write('sta_else_4 '),nl,
        mover(sta_var,Y-_,S).
%s
mover(sta_s_1,[X|Y]-Y,S):-
	delimiter(X),
	write('This is a variable '),nl,
	append(Y,[],S).
%switch
mover(sta_s_1,[X|Y]-Y,S):-
        X is 119,
        write('sta_s_1 '),nl,
        mover(sta_switch_2,Y-_,S).
mover(sta_s_1,[X|Y]-Y,S):-
        X \= 119,
        write('sta_s_1 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_switch_2,[X|Y]-Y,S):-
        X is 105,
        write('sta_switch_2 '),nl,
        mover(sta_switch_3,Y-_,S).
mover(sta_switch_2,[X|Y]-Y,S):-
        X \= 105,
        write('sta_switch_2 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_switch_3,[X|Y]-Y,S):-
        X is 116,
        write('sta_switch_3 '),nl,
        mover(sta_switch_4,Y-_,S).
mover(sta_switch_3,[X|Y]-Y,S):-
        X \= 116,
        write('sta_switch_3 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_switch_4,[X|Y]-Y,S):-
        X is 99,
        write('sta_switch_4 '),nl,
        mover(sta_switch_5,Y-_,S).
mover(sta_switch_4,[X|Y]-Y,S):-
        X \= 99,
        write('sta_switch_4 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_switch_5,[X|Y]-Y,S):-
        X is 104,
        write('sta_switch_5 '),nl,
        mover(sta_switch_6,Y-_,S).
mover(sta_switch_5,[X|Y]-Y,S):-
        X \= 104,
        write('sta_switch_5 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_switch_6,[X|Y]-Y,S):-
        delimiter(X),   write('sta_kw_switch'),nl,
        append(Y,[],S),
        write('This is a key word:switch'),nl.
mover(sta_switch_6,[X|Y]-Y,S):-
        name_legal(X),  write('sta_switch_6 '),nl,
        mover(sta_var,Y-_,S).
%d
mover(sta_d_1,[X|Y]-Y,S):-
	delimiter(X),
	write('This is a variable '),nl,
	append(Y,[],S).
% default
mover(sta_d_1,[X|Y]-Y,S):-
        X is 101,
        write('sta_d_1 '),nl,
        mover(sta_default_2,Y-_,S).
mover(sta_d_1,[X|Y]-Y,S):-
        X \= 101, X \= 111,
        write('sta_d_1 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_default_2,[X|Y]-Y,S):-
        X is 102,
        write('sta_default_2 '),nl,
        mover(sta_default_3,Y-_,S).
mover(sta_default_2,[X|Y]-Y,S):-
        X \= 102,
        write('sta_default_2 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_default_3,[X|Y]-Y,S):-
        X is 97,
        write('sta_default_3 '),nl,
        mover(sta_default_4,Y-_,S).
mover(sta_default_3,[X|Y]-Y,S):-
        X \= 97,
        write('sta_default_3 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_default_4,[X|Y]-Y,S):-
        X is 117,
        write('sta_default_4 '),nl,
        mover(sta_default_5,Y-_,S).
mover(sta_default_4,[X|Y]-Y,S):-
        X \= 117,
        write('sta_default_4 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_default_5,[X|Y]-Y,S):-
        X is 108,
        write('sta_default_5 '),nl,
        mover(sta_default_6,Y-_,S).
mover(sta_default_5,[X|Y]-Y,S):-
        X \= 108,
        write('sta_default_5 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_default_6,[X|Y]-Y,S):-
        X is 116,
        write('sta_default_6 '),nl,
        mover(sta_default_7,Y-_,S).
mover(sta_default_6,[X|Y]-Y,S):-
        X \= 116,
        write('sta_default_6 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_default_7,[X|Y]-Y,S):-
        delimiter(X),   write('sta_kw_default'),nl,
        append(Y,[],S),
        write('This is a key word:default'),nl.
mover(sta_default_7,[X|Y]-Y,S):-
        name_legal(X),  write('sta_default_7 '),nl,
        mover(sta_var,Y-_,S).
%do
mover(sta_d_1,[X|Y]-Y,S):-
        X is 111,
        write('sta_do_1 '),nl,
        mover(sta_do_2,Y-_,S).
mover(sta_do_2,[X|Y]-Y,S):-
        delimiter(X),   write('sta_kw_do'),nl,
        append(Y,[],S),
        write('This is a key word:do'),nl.
mover(sta_do_2,[X|Y]-Y,S):-
        name_legal(X),  write('sta_do_2 '),nl,
        mover(sta_var,Y-_,S).
%w 
mover(sta_w_1,[X|Y]-Y,S):-
	delimiter(X),
	write('This is a variable '),nl,
	append(Y,[],S).
%while
mover(sta_w_1,[X|Y]-Y,S):-
        X is 104,
        write('sta_w_1 '),nl,
        mover(sta_while_2,Y-_,S).
mover(sta_w_1,[X|Y]-Y,S):-
        X \= 104,
        write('sta_w_1 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_while_2,[X|Y]-Y,S):-
        X is 105,
        write('sta_while_2 '),nl,
        mover(sta_while_3,Y-_,S).
mover(sta_while_2,[X|Y]-Y,S):-
        X \= 105,
        write('sta_while_2 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_while_3,[X|Y]-Y,S):-
        X is 108,
        write('sta_while_3 '),nl,
        mover(sta_while_4,Y-_,S).
mover(sta_while_3,[X|Y]-Y,S):-
        X \= 108,
        write('sta_while_3 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_while_4,[X|Y]-Y,S):-
        X is 101,
        write('sta_while_4 '),nl,
        mover(sta_while_5,Y-_,S).
mover(sta_while_4,[X|Y]-Y,S):-
        X \= 101,
        write('sta_while_4 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_while_5,[X|Y]-Y,S):-
        delimiter(X),   write('sta_kw_while'),nl,
        append(Y,[],S),
        write('This is a key word:while'),nl.
mover(sta_while_5,[X|Y]-Y,S):-
        name_legal(X),  write('sta_while_5 '),nl,
        mover(sta_var,Y-_,S).
%b
mover(sta_b_1,[X|Y]-Y,S):-
	delimiter(X),
	write('This is a variable '),nl,
	append(Y,[],S).
% break
mover(sta_b_1,[X|Y]-Y,S):-
        X is 114,
        write('sta_b_1 '),nl,
        mover(sta_break_2,Y-_,S).
mover(sta_b_1,[X|Y]-Y,S):-
        X \= 114,
        write('sta_b_1 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_break_2,[X|Y]-Y,S):-
        X is 101,
        write('sta_break_2 '),nl,
        mover(sta_break_3,Y-_,S).
mover(sta_break_2,[X|Y]-Y,S):-
        X \= 101,
        write('sta_break_2 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_break_3,[X|Y]-Y,S):-
        X is 97,
        write('sta_break_3 '),nl,
        mover(sta_break_4,Y-_,S).
mover(sta_break_3,[X|Y]-Y,S):-
        X \= 97,
        write('sta_break_3 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_break_4,[X|Y]-Y,S):-
        X is 107,
        write('sta_break_4 '),nl,
        mover(sta_break_5,Y-_,S).
mover(sta_break_4,[X|Y]-Y,S):-
        X \= 107,
        write('sta_break_4 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_break_5,[X|Y]-Y,S):-
        delimiter(X),   write('sta_kw_break'),nl,
        append(Y,[],S),
        write('This is a key word:break'),nl.
mover(sta_break_5,[X|Y]-Y,S):-
        name_legal(X),  write('sta_break_5 '),nl,
        mover(sta_var,Y-_,S).
%r
mover(sta_r_1,[X|Y]-Y,S):-
	delimiter(X),
	write('This is a variable '),nl,
	append(Y,[],S).
%return
mover(sta_r_1,[X|Y]-Y,S):-
        X is 101,
        write('sta_r_1 '),nl,
        mover(sta_return_2,Y-_,S).
mover(sta_r_1,[X|Y]-Y,S):-
        X \= 101,
        write('sta_r_1 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_return_2,[X|Y]-Y,S):-
        X is 116,
        write('sta_return_2 '),nl,
        mover(sta_return_3,Y-_,S).
mover(sta_return_2,[X|Y]-Y,S):-
        X \= 116,
        write('sta_return_2 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_return_3,[X|Y]-Y,S):-
        X is 117,
        write('sta_return_3 '),nl,
        mover(sta_return_4,Y-_,S).
mover(sta_return_3,[X|Y]-Y,S):-
        X \= 117,
        write('sta_return_3 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_return_4,[X|Y]-Y,S):-
        X is 114,
        write('sta_return_4 '),nl,
        mover(sta_return_5,Y-_,S).
mover(sta_return_4,[X|Y]-Y,S):-
        X \= 114,
        write('sta_return_4 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_return_5,[X|Y]-Y,S):-
        X is 110,
        write('sta_return_5 '),nl,
        mover(sta_return_6,Y-_,S).
mover(sta_return_5,[X|Y]-Y,S):-
        X \= 110,
        write('sta_return_5 '),nl,
        mover(sta_var,Y-_,S).
mover(sta_return_6,[X|Y]-Y,S):-
        delimiter(X),   write('sta_kw_return'),nl,
        append(Y,[],S),
        write('This is a key word:return'),nl.
mover(sta_return_6,[X|Y]-Y,S):-
        name_legal(X),  write('sta_return_6 '),nl,
        mover(sta_var,Y-_,S).




    