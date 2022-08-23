#ifndef AS
#define AS
#include <bits/stdc++.h>
using namespace std;
namespace std{
	enum AST_Node_type{
		undefinded,float_value,operator_value,func_value,int_value,name_value
	};
	class mosyed{
	public:
		int variable1;
		bool excell,excell4;
		long long int extra;
		string duff;
		float executing;
		double extravar;
		long int var12;
	};
	class nodeAST
	{
	public:
		AST_Node_type get_node_type(),dummyvar5,type;
		nodeAST *left_node,*get_left_node(),*dummyvar4,*get_right_node(),*right_node;
		string id_name,get_name(),value,get_temp_count(),get_value(),temp_count;
		int Operation_type,dummyvar1,get_operation_type();
		bool int_or_float,dummyvar2,get_int_or_float();
		nodeAST();
		virtual ~nodeAST(); 
		void change_node_type(AST_Node_type n_type),add_right_child(nodeAST* right),change_operation_type(int op_type),add_name(string name_string),change_temp_count(string number),add_value(string var_value),change_int_or_float(bool set),add_left_child(nodeAST* left);
	};
	class IR_code
	{
	public:
		virtual ~IR_code(); 
		string op_type_code,dummyvar6,op1_code,dummyvar7,op2_code,result_code,get_op_type(),dummyvar9,get_op1(),get_op2(),dummyvar10,get_result();
		IR_code(string op_type,string op1,string op2,string result,int counter);
		int reg_counter,dummyvar8,get_reg_counter();
	};
}
#endif
