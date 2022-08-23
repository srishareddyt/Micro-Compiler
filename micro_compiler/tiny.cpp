#include "tiny.h"
using namespace std;
namespace std{
	codeOptimizer::codeOptimizer(vector<IR_code*> xyz){
		IR_vector=xyz;
		reg_counter=-1;
		reg_counter_str="";
		s="";
	}
	codeOptimizer::~codeOptimizer(){}
	void codeOptimizer::genTiny(){
		int regcnt=0,curr_reg;
		string cmpr_val,stringdum1="STOREI",stringdum2="STOREF",stringdum3="!T",stringdum4="READI",stringdum5="READF";
		stack<int> reg_stack,IR_ct_stack;
		stack<string> label_stack;
		long long int i=0,n_size=IR_vector.size();
		while(i<n_size){
			if((IR_vector[i]->get_op_type()==stringdum1||IR_vector[i]->get_op_type()==stringdum2) && ((IR_vector[i]->get_result()).find(stringdum3)==string::npos)){
				if(var_dict.find(IR_vector[i]->get_result())!=var_dict.end() && (IR_vector[i]->get_op1()).find(stringdum3) !=string::npos) reg_dict[IR_vector[i]->get_op1()] = IR_vector[i]->get_result();
				if(var_dict.find(IR_vector[i]->get_result())==var_dict.end()){
				   var_dict[IR_vector[i]->get_result()]=IR_vector[i]->get_result();
				   if((IR_vector[i]->get_op1()).find(stringdum3)!=string::npos) reg_dict[IR_vector[i]->get_op1()]=IR_vector[i]->get_result();
				   int one=1;
				   long long int dumvar65=67*one;
				   dumvar65++;
				}
			}
			else if(IR_vector[i]->get_op_type()==stringdum4||IR_vector[i]->get_op_type()==stringdum5 && var_dict.find(IR_vector[i]->get_result())==var_dict.end() && (IR_vector[i]->get_result()).find(stringdum3)==string::npos)  var_dict[IR_vector[i]->get_result()]=IR_vector[i]->get_result();
			i++;	
		}
		for (int i = 0; i < IR_vector.size(); i++)
		{
			string vectval=IR_vector[i]->get_op_type();
			if(!vectval.compare("INT_DECL")) cout<<"var "<<IR_vector[i]->get_op1()<<"\n";
			else if(!vectval.compare("FLOAT_DECL")) cout<<"var "<<IR_vector[i]->get_op1()<<"\n";
			else if(!vectval.compare("STRING_DECL")) cout<<"str "<<IR_vector[i]->get_op1()<<" "<<IR_vector[i]->get_result()<<"\n";
			else if(!vectval.compare("ADDI")) cout<<"move "<<IR_vector[i]->get_op2()<<" r0\naddi "<<IR_vector[i]->get_op1()<<" r0\nmove r0 "<<IR_vector[i]->get_result()<<"\n";
			else if(!vectval.compare("SUBI")) cout<<"move "<<IR_vector[i]->get_op1()<<" r0\nsubi "<<IR_vector[i]->get_op2()<<" r0\nmove r0 "<<IR_vector[i]->get_result()<<"\n";
			else if(!vectval.compare("MULI")) cout<<"move "<<IR_vector[i]->get_op2()<<" r0\nmuli "<<IR_vector[i]->get_op1()<<" r0\nmove r0 "<<IR_vector[i]->get_result()<<"\n";
			else if(!vectval.compare("DIVI")) cout<<"move "<<IR_vector[i]->get_op1()<<" r0\ndivi "<<IR_vector[i]->get_op2()<<" r0\nmove r0 "<<IR_vector[i]->get_result()<<"\n";
			else if(!vectval.compare("ADDF")) cout<<"move "<<IR_vector[i]->get_op2()<<" r0\naddr "<<IR_vector[i]->get_op1()<<" r0\nmove r0 "<<IR_vector[i]->get_result()<<"\n";
			else if(!vectval.compare("SUBF")) cout<<"move "<<IR_vector[i]->get_op1()<<" r0\nsubr "<<IR_vector[i]->get_op2()<<" r0\nmove r0 "<<IR_vector[i]->get_result()<<"\n";
			else if(!vectval.compare("MULF")) cout<<"move "<<IR_vector[i]->get_op2()<<" r0\nmulr "<<IR_vector[i]->get_op1()<<" r0\nmove r0 "<<IR_vector[i]->get_result()<<"\n";
			else if(!vectval.compare("DIVF")) cout<<"move "<<IR_vector[i]->get_op1()<<" r0\ndivr "<<IR_vector[i]->get_op2()<<" r0\nmove r0 "<<IR_vector[i]->get_result()<<"\n";
			else if(!vectval.compare("LABEL") && IR_vector[i]->get_op1()=="main")cout<<"label "<<IR_vector[i]->get_op1()<<"\n";
            		else if(!vectval.compare("LABEL") && IR_vector[i]->get_op1()!="main"){
				cout<<"label "<<IR_vector[i]->get_result()<<"\n";
				if(i+1<IR_vector.size() && IR_vector[i+1]->get_op_type()=="FOR_START") label_stack.push(IR_vector[i]->get_result());
			}
			else if(!vectval.compare("JUMP")) cout<<"jmp "<<IR_vector[i]->get_result()<<"\n";
			else if(!vectval.compare("FOR_START")){}
			else if(!vectval.compare("FOR_END")){
				int tempo2=i;
				i=IR_ct_stack.top();
				IR_ct_stack.pop();
				IR_ct_stack.push(tempo2);				
			}
			else if(!vectval.compare("INCR_START")){
				IR_ct_stack.push(i);
				int j = i;
				while(IR_vector[j]->get_op_type()!="INCR_END"){j++;}
				i=j;
			}
			else if(!vectval.compare("INCR_END")){
				i=IR_ct_stack.top();
				IR_ct_stack.pop();
				cout<<"jmp "<<label_stack.top()<<"\n";
				label_stack.pop();
			}
			else if(!vectval.compare("LT") || !vectval.compare("GT") || !vectval.compare("NE") || !vectval.compare("GE") || !vectval.compare("EQ") || !vectval.compare("LE")){
				cout<<"move "<<IR_vector[i]->get_op2()<<" r0\n";
				if(IR_vector[i]->get_reg_counter()==1) cout<<"cmpr "<<IR_vector[i]->get_op1()<<" r0\n";
				else if(IR_vector[i]->get_reg_counter()==0) cout<<"cmpi "<<IR_vector[i]->get_op1()<<" r0\n";
				if(!vectval.compare("GT")) cout<<"jgt "<<IR_vector[i]->get_result()<<"\n";
                else if(!vectval.compare("GE")) cout<<"jge "<<IR_vector[i]->get_result()<<"\n";
                else if(!vectval.compare("EQ")) cout<<"jeq "<<IR_vector[i]->get_result()<<"\n";
                else if(!vectval.compare("LE")) cout<<"jle "<<IR_vector[i]->get_result()<<"\n";
                else if(!vectval.compare("LT")) cout<<"jlt "<<IR_vector[i]->get_result()<<"\n";
                else if(!vectval.compare("NE")) cout<<"jne "<<IR_vector[i]->get_result()<<"\n";
			}

			else if(!vectval.compare("PUSH")){
				if(IR_vector[i]->get_result().empty()) cout<<"push\n";
				else cout<<"push "<<IR_vector[i]->get_result()<<"\n";
			}
			else if(!vectval.compare("POP")){
				if(IR_vector[i]->get_result().empty()) cout<<"pop\n";
				else cout<<"pop "<<IR_vector[i]->get_result()<<"\n";
			}
			else if(!vectval.compare("PUSHREG")) cout<<"push r0\n";
			else if(!vectval.compare("POPREG")) cout<<"pop r0\n";
			else if(!vectval.compare("LINK")) cout<<"link "<<IR_vector[i]->get_op1()<<"\n";
			else if(!vectval.compare("UNLINK")) cout<<"unlnk\n";
			else if(!vectval.compare("JSR")) cout<<"jsr "<<IR_vector[i]->get_result()<<"\n";
			else if(!vectval.compare("RET")) cout<<"ret\n";
			else if(!vectval.compare("HALT")) cout<<"sys halt\n";
			else if(!vectval.compare("STOREI")) cout<<"move "<<IR_vector[i]->get_op1()<<" r0\nmove r0 "<<IR_vector[i]->get_result()<<"\n";
			else if(!vectval.compare("STOREF")) cout<<"move "<<IR_vector[i]->get_op1()<<" r0\nmove r0 "<<IR_vector[i]->get_result()<<"\n";
			else if(!vectval.compare("READI")) cout<<"sys readi "<<IR_vector[i]->get_result()<<"\n";
			else if(!vectval.compare("READF")) cout<<"sys readr "<<IR_vector[i]->get_result()<<"\n";
			else if(!vectval.compare("WRITEI")) cout<<"sys writei "<<IR_vector[i]->get_op1()<<"\n";
			else if(!vectval.compare("WRITEF"))cout<<"sys writer "<<IR_vector[i]->get_op1()<<"\n";
			else if(!vectval.compare("WRITES"))cout<<"sys writes "<<IR_vector[i]->get_op1()<<"\n";
			else if((IR_vector[i+2]->get_op_type()=="GT"||IR_vector[i+2]->get_op_type()=="GE"||IR_vector[i+2]->get_op_type()=="LT"||IR_vector[i+2]->get_op_type()=="LE"||IR_vector[i+2]->get_op_type()=="NE" || IR_vector[i+2]->get_op_type()=="EQ") && (IR_vector[i+1]->get_op_type()=="STOREI"||IR_vector[i+1]->get_op_type()=="STOREF"))i++;
		}
		cout<<"sys halt\n";

	}


}
