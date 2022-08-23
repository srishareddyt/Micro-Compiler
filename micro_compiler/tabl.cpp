#include "tabl.h"
#include <bits/stdc++.h>
using namespace std;

namespace std{
	symbol::~symbol(){}
	int symbol::get_stack_pointer(){return stack_pointer;}
	string * symbol::get_name(){return name;}
	symbol::symbol(string* var1, string* var2, int var3, int var4){
		stack_pointer=var4;
		value_s=var2;
		name=var1;
		type=var3;
	}
	int symbol::get_type(){return type;}
	string * symbol::get_value(){return value_s;}
}
