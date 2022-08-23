%{
	#include <bits/stdc++.h>
	#include "irvect.h"
	using namespace std;
	string global_name="GLOBAL",block_name="BLOCK",temp_name="T",stack_sign="$",lable_name="label";
	int block_counter=0,temp_counter=-1,label_num=0,scope_counter=0,link_counter=1,param_counter=1,local_counter=0;
	bool in_function=0;
	map<string, bool> func_var_map,func_type_map;
	extern int yyparse();
	extern int yylineno;
	template <typename T> std::string stringify(const T& yyy)
	{
		ostringstream stm ;
		stm<<yyy;
		return stm.str() ;
	}
	int block=0;
	vector<std::vision*> SymTabHead;
	extern int yylex();
	extern char* yytext();
	int extravar=0;
	stack<int> label_counter;
	map<symbol*,int> newMap,*currMap=&newMap;
	vector<string*> scope_table;
	vector<IR_code*> IR_vector;
	void yyerror(char const *msg){}
%}
%type <s> id str
%type <string_list> id_list id_tail
%type <ast_node> primary factor_prefix postfix_expr mulop addop factor expr_prefix expr assign_expr call_expr
%type <expr_vector> expr_list_tail expr_list
%type <val> var_type compop any_type

%token PROGRAM _BEGIN END STRING FLOATLITERAL INTLITERAL VOID FUNCTION READ WRITE RETURN IF FI ELSE FOR ROF ADD SUB MUL DIV EQ NEQ EXCL LT GT LTEQ GTEQ OP CP SEMI COMMA ASSIGN 
%token <s> IDENTIFIER STRINGLITERAL
%token <val> INT FLOAT

%union
{
vector<std::string*> *string_list;
string* s;
int val;
nodeAST* ast_node;
vector <std::nodeAST*>* expr_vector;
}


%%
program : PROGRAM id _BEGIN
        {
            SymTabHead.push_back(new vision(global_name));
            IR_vector.push_back(new IR_code("IR","code","","",temp_counter));
        }
        pgm_body END{}
id : IDENTIFIER{$$ = yylval.s;}
pgm_body: decl{
			IR_code *extr12=new IR_code("PUSH","","","",temp_counter);
			for(int i=0;i<5;i++){
				IR_vector.push_back(extr12);
			}	
			IR_code *extr13=new IR_code("JSR","","","main",temp_counter);
			IR_code *extr14=new IR_code("HALT","","","",temp_counter);
			IR_vector.push_back(extr13);
			IR_vector.push_back(extr14);
} func_declarations{};
decl:string_decl decl{} 
|var_decl decl{}
|;
string_decl : STRING id ASSIGN str SEMI
            {
                symbol *var231=new symbol($2,$4,STRING,0);
                IR_code *var232=new IR_code("STRING_DECL",*$2,"",*$4,temp_counter);
                SymTabHead.back()->insert_record(*($2),var231);
                if(in_function==1) link_counter++;
                else IR_vector.push_back(var232);
                func_var_map[*$2]=in_function;
            }
str : STRINGLITERAL{$$=yylval.s;}
var_decl : var_type id_list SEMI
        {
            string var236="";
            for(int i=$2->size()-1;i>=0;i--){
                if(in_function==1) local_counter--;
                symbol *var233=new symbol((*$2)[i],NULL,$1,local_counter);
                SymTabHead.back()->insert_record(*((*$2)[i]),var233);
                func_var_map[*((*$2)[i])]=in_function;
                if($1==FLOAT) var236="FLOAT_DECL";
                if($1==INT) var236="INT_DECL";
                IR_code *var234=new IR_code(var236,*((*$2)[i]),"","",temp_counter);
                if(in_function==1) link_counter++;
                else IR_vector.push_back(var234);
            }
    }
var_type : FLOAT {$$=FLOAT;}
    | INT {$$=INT;}
any_type : var_type{$$=$1;}
    | VOID {$$ = VOID;}
id_list : id id_tail{
	extravar=extravar*12;
	$$=$2;
	$$->push_back($1);
	}
id_tail:COMMA id id_tail{
        extravar--;
	$$=$3;
	$$->push_back($2);
    }|{
		vector<string*>* exter1=new vector<std::string*>;
		$$=exter1;
	}
param_decl_list: param_decl param_decl_tail{} |;
param_decl : var_type id{
                symbol *exter2=new symbol($2,NULL,$1,++param_counter);
                extravar=extravar/5;
                SymTabHead.back()->insert_record(*($2),exter2);
                func_var_map[*($2)]=in_function;
	}
param_decl_tail:COMMA param_decl param_decl_tail{} |;
func_declarations:func_decl func_declarations{}|;
func_decl : FUNCTION any_type id
            {
		 vision *exter4=new vision(*$3);
                IR_code *exter5=new IR_code("LABEL","","",*$3,temp_counter);
                extravar++;
                SymTabHead.push_back(exter4);
                IR_vector.push_back(exter5);
                in_function=1;
                if($2==INT) func_type_map[*($3)]=1;
                else func_type_map[*($3)]=0;
	    }
		OP{
		   param_counter=1;
		   local_counter=0;
		} 
		param_decl_list CP _BEGIN func_body END{in_function=0;}
func_body : {link_counter=1;}
            decl{
               string fgh1=stringify(link_counter);
               extravar=0;
		IR_code *fgh2=new IR_code("LINK",fgh1,"","",link_counter);
		IR_vector.push_back(fgh2);
            } stmt_list{}
stmt_list:stmt stmt_list{};|
stmt:base_stmt{}|if_stmt{}|for_stmt{};
base_stmt:assign_stmt{}|read_stmt{}|write_stmt{}|return_stmt{};
assign_stmt : assign_expr SEMI{
	if(($1->get_right_node())->get_int_or_float()==($1->get_left_node())->get_int_or_float() && ($1->get_right_node())->get_int_or_float()==1){
		string hj1=temp_name;
		string fgh6=to_string(static_cast<long long>(temp_counter));
		hj1=hj1+fgh6;
		if(($1->get_right_node())->get_node_type()==name_value) hj1=($1->get_right_node())->get_name();
		IR_code *fgh7=new IR_code("STOREI",hj1,"",(($1->get_left_node())->get_name()),temp_counter);
		IR_vector.push_back(fgh7);
	}
	else if(($1->get_right_node())->get_int_or_float()==($1->get_left_node())->get_int_or_float() && ($1->get_right_node())->get_int_or_float()==0){
		string hj1=temp_name;
		string fgh8=to_string(static_cast<long long>(temp_counter));
		hj1=hj1+fgh8;
		if(($1->get_right_node())->get_node_type()==name_value) hj1=($1->get_right_node())->get_name();
		IR_code *fgh9=new IR_code("STOREF",hj1,"",(($1->get_left_node())->get_name()),temp_counter);
		IR_vector.push_back(fgh9);
	}
	}
assign_expr : id ASSIGN expr{
	int sdf3;
	nodeAST *sdf1=new nodeAST();
	nodeAST *sdf2=new nodeAST();
	sdf1->change_node_type(name_value);
	sdf2->change_node_type(operator_value);
	string s=*($1);
	sdf2->change_operation_type(NEQ);
	if(!func_var_map[*($1)])
	{
		sdf3=((SymTabHead.front()->get_tab())[*($1)]->get_type());
		sdf1->change_int_or_float(sdf3==INT);
		sdf1->add_name(s);
	}
	else{		
		sdf3=((SymTabHead[SymTabHead.size()-1]->get_tab())[*($1)]->get_type());
		sdf1->change_int_or_float(sdf3==INT);
		int sdf5=((SymTabHead[SymTabHead.size()-1]->get_tab())[s]->get_stack_pointer());
		s=stack_sign+to_string(static_cast<long long>(sdf5));;
		sdf1->add_name(s);
	}
	sdf2->add_left_child(sdf1);
	sdf1->change_int_or_float(sdf3==INT);
	sdf2->add_right_child($3);
	$$=sdf2;
	sdf1->change_int_or_float((sdf3==INT));
}
read_stmt : READ OP id_list CP SEMI{
	int i=($3->size())-1;
	while(i>=0){
		string qwe1="";
		if(func_var_map[*((*$3)[i])]){
			if((SymTabHead[SymTabHead.size()-1]->get_tab())[*((*$3)[i])]->get_type()==INT) qwe1="READI";
			else if((SymTabHead[SymTabHead.size()-1]->get_tab())[*((*$3)[i])]->get_type()==FLOAT) qwe1="READF";
		}
		else{
			if((SymTabHead.front()->get_tab())[*((*$3)[i])]->get_type()==INT) qwe1="READI";
			else if((SymTabHead.front()->get_tab())[*((*$3)[i])]->get_type()==FLOAT) qwe1="READF";
		}
		string s=*((*$3)[i]);
		if(func_var_map[s])
		{
			int stack_num=((SymTabHead[SymTabHead.size()-1]->get_tab())[s]->get_stack_pointer());
			string stack_label=to_string(static_cast<long long>(stack_num));
			s =stack_sign+stack_label;
		}
		std::IR_code * read_code = new IR_code(qwe1, "", "", s, temp_counter);
		IR_vector.push_back(read_code);
		--i;
	}
}
write_stmt : WRITE OP id_list CP SEMI{
		for(int i=($3->size())-1;i>=0;--i){
			string s=*((*$3)[i]);
			string hjhj="";
			if(!func_var_map[*((*$3)[i])]){
				if((SymTabHead.front()->get_tab())[*((*$3)[i])]->get_type()==INT) hjhj="WRITEI";
				if((SymTabHead.front()->get_tab())[*((*$3)[i])]->get_type()==FLOAT) hjhj="WRITEF";
				if((SymTabHead.front()->get_tab())[*((*$3)[i])]->get_type()==STRING) hjhj="WRITES";
			}
			if(func_var_map[*((*$3)[i])]){				
				if((SymTabHead[SymTabHead.size()-1]->get_tab())[*((*$3)[i])]->get_type()==INT) hjhj="WRITEI";
				if((SymTabHead[SymTabHead.size()-1]->get_tab())[*((*$3)[i])]->get_type()==FLOAT) hjhj="WRITEF";
				if((SymTabHead[SymTabHead.size()-1]->get_tab())[*((*$3)[i])]->get_type()==STRING) hjhj="WRITES";
			}
			if(func_var_map[s])
			{
				int stack_num=((SymTabHead[SymTabHead.size()-1]->get_tab())[s]->get_stack_pointer());
				s=stack_sign+to_string(static_cast<long long>(stack_num));
			}
			IR_code *write_code=new IR_code(hjhj,s,"","",temp_counter);
			IR_vector.push_back(write_code);
		}
};
return_stmt : RETURN expr SEMI{
				string sar3="",sar2="",sar1="";
				if($2->get_node_type()==name_value) sar3=$2->get_name();
				else sar3=temp_name+to_string(static_cast<long long>(temp_counter));
				if($2->get_int_or_float()) sar2="STOREI";
				else sar2="STOREF";
				sar1=stack_sign+to_string(static_cast<long long>(param_counter+1));
				IR_code *ret_addr=new IR_code(sar2,sar3,"",sar1,temp_counter);
				IR_vector.push_back(ret_addr);
				IR_code *unlink_code=new IR_code("UNLINK","","","",temp_counter);
				IR_vector.push_back(unlink_code);
				IR_code *return_code=new IR_code("RET","","","",temp_counter);
				IR_vector.push_back(return_code);
};
expr: expr_prefix factor{
			if($1==NULL) $$=$2;
			else{
				string v11="",v12="",v13="",v14="" ;
				if($1->get_int_or_float()==$2->get_int_or_float()){
					$1->add_right_child($2);
					if(!$1->get_int_or_float()){
						if($1->get_operation_type()==ADD) v14="ADDF";
						else if($1->get_operation_type()==SUB) v14="SUBF";
					}
					else if($1->get_int_or_float()){
						if($1->get_operation_type()==ADD) v14="ADDI";
						else if($1->get_operation_type()==SUB) v14="SUBI";
					}
					if(($1->get_right_node())->get_node_type()==name_value) 
					v12=($1->get_right_node())->get_name();
					if(($1->get_right_node())->get_node_type()!=name_value) 
					v12=($1->get_right_node())->get_temp_count();
					if(($1->get_left_node())->get_node_type()==name_value) 
					v11=($1->get_left_node())->get_name();
					if(($1->get_left_node())->get_node_type()!=name_value) 
					v11=($1->get_left_node())->get_temp_count();
					v13=temp_name+to_string(static_cast<long long>(++temp_counter));
					$1->change_temp_count(v13);
					IR_code *v15=new IR_code(v14,v11,v12,v13,temp_counter);
					IR_vector.push_back(v15);
				}
				$$=$1;
				extravar=1+extravar;
			}
}

expr_prefix:expr_prefix factor addop{
			if($1==NULL){
				$3->add_left_child($2);
				$3->change_int_or_float($2->get_int_or_float());
			}
			else if($1!=NULL){
				string qwe2="",qwe3="",qwe4="",qw1="";
				if($2->get_int_or_float()==$1->get_int_or_float()){
					$1->add_right_child($2);
					$3->change_int_or_float($1->get_int_or_float());
					$3->add_left_child($1);
					if($1->get_operation_type()==ADD){
						if($1->get_int_or_float()) qw1="ADDI";
						else qw1="ADDF";
					}
					else if($1->get_operation_type()==SUB){
						if($1->get_int_or_float()) qw1="SUBI";
						else qw1="SUBF";
					}
					if(($1->get_left_node())->get_node_type()==name_value) qwe2=($1->get_left_node())->get_name();
					else if(($1->get_left_node())->get_node_type()!=name_value) qwe2=($1->get_left_node())->get_temp_count();
					if(($1->get_right_node())->get_node_type()==name_value) qwe3=($1->get_right_node())->get_name();
					else if(($1->get_right_node())->get_node_type()!=name_value) qwe3=($1->get_right_node())->get_temp_count();
					qwe4=temp_name+to_string(static_cast<long long>(++temp_counter));
					$1->change_temp_count(qwe4);
					IR_code *www3=new IR_code(qw1,qwe2,qwe3,qwe4,temp_counter);
					IR_vector.push_back(www3);
				}
			}
		$$ = $3;
	}|{$$ = NULL;};
factor: factor_prefix postfix_expr{
				if ($1 == NULL) $$ = $2;
				else{
					string qw1="",qw3="",qw2="",qw4="";
					if($1->get_int_or_float()==$2->get_int_or_float()){
						$1->add_right_child($2);
						if($1->get_int_or_float()){
							if($1->get_operation_type()==MUL) qw4="MULI";
							else if($1->get_operation_type()==DIV) qw4="DIVI";
						}
						else if(!$1->get_int_or_float()){
							if($1->get_operation_type()==MUL) qw4="MULF";
							else if($1->get_operation_type()==DIV) qw4="DIVF";
						}
						if(($1->get_right_node())->get_node_type()==name_value) qw3=($1->get_right_node())->get_name();
						else if(($1->get_right_node())->get_node_type()!=name_value) qw3=($1->get_right_node())->get_temp_count();
						if(($1->get_left_node())->get_node_type()==name_value) qw1=($1->get_left_node())->get_name();
						else if(($1->get_left_node())->get_node_type()!=name_value) qw1=($1->get_left_node())->get_temp_count();
						qw2=temp_name+to_string(static_cast<long long>(++temp_counter));				
						$1->change_temp_count(qw2);
						IR_code *zzz=new IR_code(qw4,qw1,qw3,qw2,temp_counter);
						IR_vector.push_back(zzz);
					}
					$$ = $1;
				}
}
factor_prefix:	factor_prefix postfix_expr mulop{
					if($1==NULL){
						$3 -> add_left_child($2);
						$3->change_int_or_float($2->get_int_or_float());
					}
					else{
						if($1->get_int_or_float()==$2->get_int_or_float()){
							$1->add_right_child($2);
							$3->change_int_or_float($1->get_int_or_float());
							$3->add_left_child($1);
							string qwe2 = "",qwe3 = "",qwe4 = "",qwe1 = "" ;
							if($1->get_operation_type()==MUL){
								if($1->get_int_or_float()) qwe1="MULI";
								else qwe1="MULF";
							}
							else if($1->get_operation_type()==DIV){
								if($1->get_int_or_float()) qwe1="DIVI";
								else qwe1="DIVF";
							}
						if(($1->get_left_node())->get_node_type()==name_value) qwe2=($1->get_left_node())->get_name();
						else if(($1->get_left_node())->get_node_type()!=name_value) qwe2=($1->get_left_node())->get_temp_count();
						if(($1->get_right_node())->get_node_type()==name_value) qwe3=($1->get_right_node())->get_name();
						else if(($1->get_right_node())->get_node_type()!=name_value) qwe3=($1->get_right_node())->get_temp_count();
						qwe4=temp_name+to_string(static_cast<long long>(++temp_counter));
						$1->change_temp_count(qwe4);
						IR_code *factor_code=new IR_code(qwe1,qwe2,qwe3,qwe4,temp_counter);
						IR_vector.push_back(factor_code);
					}
				}
				$$ = $3;
}|{$$ = NULL;};
postfix_expr:	primary{$$=$1;}|call_expr{$$=$1;};
call_expr : id OP expr_list CP{
				IR_code *push_reg=new IR_code("PUSHREG","","","",temp_counter);
				IR_vector.push_back(push_reg);
				IR_code *push_code=new IR_code("PUSH","","","",temp_counter);
				IR_vector.push_back(push_code);
				string s="";
				for(int i=0;i<$3->size();i++)
				{
					if((*$3)[i]->get_node_type()==name_value) s=(*$3)[i]->get_name();
					if((*$3)[i]->get_node_type()!=name_value) s=(*$3)[i]->get_temp_count();
					IR_code *er2=new IR_code("PUSH","","",s,temp_counter);
					IR_vector.push_back(er2);
				}
				IR_code *er3=new IR_code("JSR","","",*$1,temp_counter);
				IR_code *er4=new IR_code("POP","","","",temp_counter);
				IR_code *er5=new IR_code("POPREG","","","",temp_counter);
				IR_vector.push_back(er3);
				IR_vector.push_back(er4);
				for (int i=0;i<$3->size()-1;i++)
				{
					IR_code *er7=new IR_code("POP","","","",temp_counter);
					IR_vector.push_back(er7);
				}
				s=temp_name+to_string(static_cast<long long>(++temp_counter));
				nodeAST *er9=new nodeAST();
				IR_code *er6 = new IR_code("POP","","",s,temp_counter);
				IR_vector.push_back(er6);
				IR_vector.push_back(er5);
				er9->change_node_type(name_value);
				er9->add_name(s);
				er9->change_int_or_float(func_type_map[*($1)]);
				$$=er9;
};
expr_list:expr expr_list_tail{
				$$=$2;
				$$->push_back($1);
}|{vector<nodeAST*>* ss12=new vector<nodeAST*>;$$=ss12;}
expr_list_tail:COMMA expr expr_list_tail{
				$$=$3;
				$$->push_back($2);
		}|{vector<nodeAST*>* ss12=new vector<nodeAST*>; $$=ss12;};
primary:OP expr CP{$$=$2;} |id{
	nodeAST *id_node=new nodeAST();
	id_node->change_node_type(name_value);
	string s=(*($1));
	if(func_var_map[*($1)]==1){
		int rr1=((SymTabHead[SymTabHead.size()-1]->get_tab())[s]->get_stack_pointer());
		int rr2=((SymTabHead[SymTabHead.size()-1]->get_tab())[*($1)]->get_type());
		s=stack_sign+to_string(static_cast<long long>(rr1));
		id_node->add_name(s);
		id_node->change_int_or_float(rr2==INT);
	}
	else if(func_var_map[*($1)]==0){
		int rr3=((SymTabHead.front()->get_tab())[*($1)]->get_type());
		id_node->add_name(s);
		id_node->change_int_or_float(rr3==INT);
	}
	$$ = id_node;
}
|INTLITERAL{
	nodeAST *yu1=new nodeAST();
	yu1->change_node_type(int_value);
	yu1->change_int_or_float(1);
	yu1->add_value(*(yylval.s));
	string s=temp_name+to_string(static_cast<long long>(++temp_counter));
	$$=yu1;
	yu1->change_temp_count(s);
	IR_code *yu5=new IR_code("STOREI",*(yylval.s),"",s,temp_counter);
	IR_vector.push_back(yu5);
}
|FLOATLITERAL{
		std::nodeAST *io3=new nodeAST();
		io3->change_node_type(float_value);
		io3->add_value(*(yylval.s));
		io3->change_int_or_float(false);
		$$=io3;
		string s=temp_name+to_string(static_cast<long long>(++temp_counter));
		io3->change_temp_count(s);
		IR_code *io4=new IR_code("STOREF",*(yylval.s),"",s,temp_counter);
		IR_vector.push_back(io4);
	}
addop: ADD{
	nodeAST *ki1=new nodeAST();
	ki1->change_operation_type(ADD);
	ki1->change_node_type(operator_value);
	$$=ki1;
}
    | SUB{
	nodeAST *ki1=new nodeAST();
	ki1->change_operation_type(SUB);
	ki1->change_node_type(operator_value);
	$$=ki1;
}
    ;
mulop: MUL{
	nodeAST *ki1=new nodeAST();
	ki1->change_operation_type(MUL);
	ki1->change_node_type(operator_value);
	$$=ki1;
}
    | DIV{
	nodeAST *ki1=new nodeAST();
	ki1->change_operation_type(DIV);
	ki1->change_node_type(operator_value);
	$$=ki1;
}
if_stmt : IF
        {
		label_num++;
		label_counter.push(label_num);
		label_num++;
	}
        OP cond CP decl stmt_list
        {
		string pp3=lable_name+to_string(static_cast<long long>(label_counter.top()+1));
		IR_code *pp4=new IR_code("JUMP","","",pp3,temp_counter);
		IR_vector.push_back(pp4);
		string pp1=lable_name+to_string(static_cast<long long>(label_counter.top()));
		IR_code *pp2=new IR_code("LABEL","","",pp1,temp_counter);
		IR_vector.push_back(pp2);
	}
        else_part FI{
		string ssw=lable_name+to_string(static_cast<long long>(label_counter.top()+1));
		IR_code *ssw1=new IR_code("LABEL","","",ssw,temp_counter);
		IR_vector.push_back(ssw1);
		label_counter.pop();
}
else_part:ELSE{} decl stmt_list{}|;
cond : expr compop expr{
		string yui8,s1,s2;
		int xc=0;
		switch($2){
			case GTEQ:
				yui8="LT";
				break;
			case LTEQ:
				yui8="GT";
				break;
			case EQ:
				yui8="NE";
				break;
			case NEQ:
				yui8="EQ";
				break;
			case GT:
				yui8="LE";
				break;
			case LT:
				yui8="GE";
				break;
			}
		if($1->get_int_or_float()==$3->get_int_or_float()){
			if($1->get_node_type()==name_value){
				s1=$1->get_name();
				if(func_var_map[s1])
				{
					int wq=((SymTabHead[SymTabHead.size()-1]->get_tab())[s1]->get_stack_pointer());
					s1=stack_sign+to_string(static_cast<long long>(wq));
				}
			}
			else s1=$1->get_temp_count();
			if($3->get_node_type()==name_value){
				s2=$3->get_name();
				if(func_var_map[s2])
				{
					int we=((SymTabHead[SymTabHead.size()-1]->get_tab())[s2]->get_stack_pointer());
					s2=stack_sign+to_string(static_cast<long long>(we));
				}
			}
			else s2 = $3->get_temp_count();
			if(!$1->get_int_or_float()) xc=1;
		}
	string sd=lable_name+to_string(static_cast<long long>(label_counter.top()));
	IR_code *sd1=new IR_code(yui8,s1,s2,sd,xc);
	IR_vector.push_back(sd1);
}
compop : LT{$$=LT;} | GT{$$=GT;} | EQ{$$=EQ;} | NEQ{$$=NEQ;} | LTEQ{$$=LTEQ;} | GTEQ{$$=GTEQ;};
init_stmt:assign_expr{
		if(($1->get_right_node())->get_int_or_float()==($1->get_left_node())->get_int_or_float()){
			string s=temp_name+to_string(static_cast<long long>(temp_counter));
			if(($1->get_right_node())->get_node_type() == name_value) s=($1->get_right_node())->get_name();
			if(($1->get_right_node())->get_int_or_float()){
				IR_code *yy=new IR_code("STOREI",s,"",(($1->get_left_node())->get_name()),temp_counter);
				IR_vector.push_back(yy);
			}
			else{
				IR_code *yy=new IR_code("STOREF",s, "",(($1->get_left_node())->get_name()),temp_counter);
				IR_vector.push_back(yy);
			}
		}
	}|;
incr_stmt:assign_expr{
		if(($1->get_right_node())->get_int_or_float()==($1->get_left_node())->get_int_or_float()){
			string s=temp_name +to_string(static_cast<long long>(temp_counter));
			if(($1->get_right_node())->get_node_type()==name_value) s=($1->get_right_node())->get_name();
			if(($1->get_right_node())->get_int_or_float()){
				IR_code *yy1=new IR_code("STOREI",s,"",(($1->get_left_node())->get_name()),temp_counter);
				IR_vector.push_back(yy1);
			}
			else{
				IR_code *yy1=new IR_code("STOREF",s,"",(($1->get_left_node())->get_name()),temp_counter);
				IR_vector.push_back(yy1);
			}
		}
	}|;
for_stmt : FOR{}
        OP init_stmt SEMI{
		label_num++;
		label_num++;
		label_counter.push(label_num);
		string label_s=lable_name+to_string(static_cast<long long>(label_counter.top()-1));
		IR_code *yuyu=new IR_code("LABEL","","",label_s,temp_counter);
		IR_code *yiyi=new IR_code("FOR_START","","","",temp_counter);
		IR_vector.push_back(yuyu);
		IR_vector.push_back(yiyi);
}cond SEMI{
	IR_code *qq=new IR_code("INCR_START","","","",temp_counter);
	IR_vector.push_back(qq);
	}
incr_stmt{
	IR_code *qq=new IR_code("INCR_END","","","",temp_counter);
	IR_vector.push_back(qq);
	}
CP decl stmt_list{
	IR_code *sd=new IR_code("FOR_END","","","",label_counter.top());
	string sd1=lable_name+to_string(static_cast<long long>(label_counter.top()));
	IR_code *sd2=new IR_code("LABEL","","",sd1,temp_counter);
	IR_vector.push_back(sd);
	IR_vector.push_back(sd2);
	label_counter.pop();
} ROF;
%%
