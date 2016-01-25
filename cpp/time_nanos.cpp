#include "time_nanos.h"

#include <iostream>


using namespace std;

// A unit in our custom time system.
template<int D, int T> struct Time_unit {
	enum { d=D, t=T };
};

template<typename Time_unit>
struct Value {
	long long val; // The timestamp
	// construct a Value from a long long
	constexpr explicit Value(unsigned long long int x) : val(x) {}

	// display it
	friend ostream& operator<<(ostream & lhs, const Value& rhs)
	{
		if (rhs.val < 1) {
			lhs << "0s";
			return lhs;
		}

		long long nano = rhs.val % 1000000000;
		long long seconds = (rhs.val / 1000000000) % 60;
		long long minutes = rhs.val / 60000000000;

		if (nano) {
			lhs << nano << "ns";
			return lhs;
		}

		lhs << rhs.val;
		return lhs;
	}
};

using Nanosecond = Time_unit<1,0>;
using Stamp = Time_unit<0,1>;
typedef Value<Nanosecond> Nano;

// User defined literals described at
// http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2378.pdf.
constexpr Nano operator"" _ns(unsigned long long int x)
{
	return Value<Nanosecond>(x);
}

constexpr Value<Nanosecond> operator"" _s(unsigned long long int x)
{
	return Value<Nanosecond>(x * 1000000000);
}


void test_nanos()
{
	Nano a = 500_ns;
	Nano b = 0_s;
	cout << "Size of a nano " << sizeof(a) << " value " << a << endl;
	cout << "Value of b " << b << endl;
	cout << "Testing nanos module" << endl << endl;
}
