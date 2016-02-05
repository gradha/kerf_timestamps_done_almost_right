#include "time_nanos.h"
#include "time_stamp.h"

#include <vector>

using namespace std;


void test_blog_examples()
{
	cout << "Showing blog examples." << endl;

	auto a = "2012.01.01"_date;
	cout << "Example 1: " << a << endl;
	cout << "Example 2:" << endl;
	cout << "\t" << a + 1_d << endl;
	cout << "\t" << "2012.01.01"_date + 1_d << endl;
	cout << "Example 3: " <<
		"2012.01.01"_date + 1_m + 1_d + 1_h + 15_i + 17_s << endl;

	auto r = range(0, 10);
	auto offsets = map(r, [] (int i) {
		return (1_m + 1_d + 1_h + 15_i + 17_s) * i;
		});
	auto values = map(offsets, [] (Nano x) { return "2012.01.01"_date + x; });
	cout << "Example 4: " << values << endl;

	cout << "…using helper procs… "
		<< "2012.01.01"_date + (1_m + 1_d + 1_h + 15_i + 17_s) * range(0, 10)
		<< endl;

	cout << "Example 5 b[week]: " <<
		map(values, [] (Stamp x) { return x.week(); }) << endl;
	cout << "Example 5 b[second]: " <<
		map(values, [] (Stamp x) { return x.second(); }) << endl;

	cout << endl << "Did all examples." << endl;
}

int main()
{
	test_nanos();
	test_stamp();
	test_blog_examples();
}
