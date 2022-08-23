#include "irvect.h"
#include "micro.hpp"
#include <bits/stdc++.h>
using namespace std;
set<string> diffval;
int main(int argc,char **argv){
	extern FILE* yyin;	
        yyin=fopen(argv[1],"r");
        string str1=":",str2="op1",str3="op2",str4="result",str5=" ";
        char wer='T';
	int retval=yyparse(),xs=IR_vector.size(),dfg=0;
	while(dfg<xs){
		cout<<";"<<IR_vector[dfg]->get_op_type();
		if(IR_vector[dfg]->get_op1()!=""){
			cout<<str5;
			cout<<str2;
			cout<<str1;
			cout<<IR_vector[dfg]->get_op1();
			if((IR_vector[dfg]->get_op1()).find(wer)!=string::npos) diffval.insert(IR_vector[dfg]->get_op1());
		}
		if(IR_vector[dfg]->get_op2()!=""){
			cout<<str5;
			cout<<str3;
			cout<<str1;
			cout<<IR_vector[dfg]->get_op2();
			if((IR_vector[dfg]->get_op2()).find(wer)!=string::npos) diffval.insert(IR_vector[dfg]->get_op2());
		}
		if(IR_vector[dfg]->get_result()!=""){
			cout<<str5;
			cout<<str4;
			cout<<str1;
			cout<<IR_vector[dfg]->get_result();
			if((IR_vector[dfg]->get_result()).find(wer)!=string::npos) diffval.insert(IR_vector[dfg]->get_result());
		}
		for(int i=0;i<2;i++){
			cout<<"\n";
			break;
		}	
		dfg++;
	}
	cout<<"\n";
	for(auto a: diffval){
		cout<<"var";
		cout<<" ";
		cout<<a;
		cout<<"\n";
	}
	codeOptimizer* jdg=new codeOptimizer(IR_vector);
	jdg->genTiny();
	return 0;
}
