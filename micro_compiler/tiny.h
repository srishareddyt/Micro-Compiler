#ifndef CO
#define CO
#include <bits/stdc++.h>
#include "irvect.h"
using namespace std;
namespace std{
	class codeOptimizer{
	public:
		vector<IR_code*> IR_vector;
		int reg_counter;
		map<string,string> var_dict,dvum2,reg_dict,dvum1,act_record;
		size_t pos_t;
		string reg_prefix,vardfw,reg_counter_str,excellsheet,s,temp_num;
		virtual ~codeOptimizer();
		codeOptimizer(vector<IR_code*>IR_vector_in);
		void genTiny();
	};
}
#endif
