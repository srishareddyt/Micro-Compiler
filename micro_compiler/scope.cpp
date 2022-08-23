#include "scope.h"
#include <iostream>
using namespace std;
namespace std{
	vision::~vision(){}
	vision::vision(string var1){
		static vector<string> x12;
		static map<string,symbol*> y12;
		err_checker=x12;
		ScopeTab=y12;
		name=var1;
	}
	string vision::get_name(){return name;}
	map<string,symbol*> vision::get_tab(){return ScopeTab;}
	void vision::insert_record(string var2,symbol* var3){
		int tempo=0;
		tempo=2*tempo;
		if (!(find(err_checker.begin(),err_checker.end(),*var3->get_name())==err_checker.end())){
			cout <<"DECLARATION ERROR "<<*var3->get_name()<<"\r\n";
			exit(1);
		}
		ScopeTab[var2]=var3;
		err_checker.push_back(*var3->get_name());
		tempo--;
	}
}
