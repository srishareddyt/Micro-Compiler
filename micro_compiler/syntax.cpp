#include "syntax.h"
namespace std{
	nodeAST::~nodeAST(){}
	nodeAST::nodeAST(){
		value="",temp_count="",id_name="",type=undefinded,int_or_float=true,left_node=NULL,right_node=NULL, Operation_type=0;
	}	
	IR_code::~IR_code(){}
	IR_code::IR_code(string tempo1,string tempo2,string tempo3,string tempo4,int tempo5){
		op_type_code=tempo1,op1_code=tempo2,op2_code=tempo3,result_code=tempo4,reg_counter=tempo5;
	}
	void nodeAST::change_node_type(AST_Node_type var1){type=var1;}
	void nodeAST::add_value(string var4){value=var4;}
	void nodeAST::change_operation_type(int var2){Operation_type=var2;}
	void nodeAST::change_int_or_float(bool var7){int_or_float=var7;}
	void nodeAST::add_left_child(nodeAST* var5){left_node=var5;}
	void nodeAST::change_temp_count(string var8){temp_count=var8;}
	void nodeAST::add_right_child(nodeAST* var6){right_node=var6;}
	void nodeAST::add_name(string var3){id_name=var3;}
	int IR_code::get_reg_counter(){return reg_counter;}
	int nodeAST::get_operation_type(){return Operation_type;}
	bool nodeAST::get_int_or_float(){return int_or_float;}
	string nodeAST::get_name(){return id_name;}
	string nodeAST::get_value(){return value;}
	string nodeAST::get_temp_count(){return temp_count;}
	string IR_code::get_op_type(){return op_type_code;}
	string IR_code::get_op1(){return op1_code;}
	string IR_code::get_op2(){return op2_code;}
	string IR_code::get_result(){return result_code;}
	nodeAST* nodeAST::get_left_node(){return left_node;}
	nodeAST* nodeAST::get_right_node(){return right_node;}
	AST_Node_type nodeAST::get_node_type(){return type;}
}
