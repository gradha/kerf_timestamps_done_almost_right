#include "time_nanos.h"

#include <iostream>
#include <string>
#include <assert.h>


using namespace std;


struct Nano {
	long long val; // The timestamp
	// construct a Value from a long long
	constexpr explicit Nano(unsigned long long int x) : val(x) {}

	inline Nano operator+(const Nano& rhs) const;
	inline Nano operator-(const Nano& rhs) const;
	inline Nano operator*(const int& rhs) const;
	inline Nano operator/(const int& rhs) const;
	inline int year(void) const;
	inline int month(void) const;
	inline int week(void) const;
	inline int day(void) const;
	inline int hour(void) const;
	inline int minute(void) const;
	inline int second(void) const;
	inline int millisecond(void) const;
	inline int microsecond(void) const;
	inline int nanosecond(void) const;
};

Nano operator*(const int& lhs, const Nano& rhs);
constexpr long long operator/(const long long& lhs, const Nano& rhs);
constexpr long long operator%(const long long& lhs, const Nano& rhs);
constexpr Nano operator"" _ns(unsigned long long int x);
constexpr Nano operator"" _s(unsigned long long int x);
constexpr Nano operator"" _i(unsigned long long int x);
constexpr Nano operator"" _h(unsigned long long int x);
constexpr Nano operator"" _d(unsigned long long int x);
constexpr Nano operator"" _m(unsigned long long int x);
constexpr Nano operator"" _y(unsigned long long int x);


const Nano u_nano = 1_ns;
const Nano u_second = Nano(1000000000);
const Nano u_minute = u_second * 60;
const Nano u_hour = u_minute * 60;
const Nano u_day = 24 * u_hour;
const Nano u_month = 30 * u_day;
const Nano u_year = u_day * 365;

inline int Nano::year(void) const { return val / u_year; }
inline int Nano::month(void) const
{
	auto result = val / u_day;
	result = result % 365;
	return 1 + (result % 12);
}

inline int Nano::week(void) const
{
	auto result = val / u_day;
	result = result % 365;
	return 1 + (result % 7);
}

inline int Nano::day(void) const
{
	auto result = val / u_day;
	result = result % 365;
	return 1 + (result % 30);
}

inline int Nano::hour(void) const { return (val / u_hour) % 24; }
inline int Nano::minute(void) const { return (val / u_minute) % 60; }
inline int Nano::second(void) const { return (val / u_second) % 60; }
inline int Nano::millisecond(void) const { return (val % u_second) / 1000000; }
inline int Nano::microsecond(void) const { return (val % u_second) / 1000; }
inline int Nano::nanosecond(void) const { return val % u_second; }

Nano Nano::operator+(const Nano& rhs) const { return Nano(val + rhs.val); }
Nano Nano::operator-(const Nano& rhs) const { return Nano(val - rhs.val); }
Nano Nano::operator*(const int& rhs) const { return Nano(val * rhs); }
Nano operator*(const int& lhs, const Nano& rhs) { return Nano(lhs * rhs.val); }
constexpr long long operator/(const long long& lhs, const Nano& rhs)
{
	return lhs / rhs.val;
}

constexpr long long operator%(const long long& lhs, const Nano& rhs)
{
	return lhs % rhs.val;
}

ostream& operator<<(ostream& o, const Nano& x)
{
	assert(x.val >= 0);
	if (x.val < 1) {
		o << "0s";
		return o;
	}

	long long nano = x.val % 1000000000;
	long long seconds = (x.val / 1000000000) % 60;
	long long minutes = x.val / 60000000000;
	long long hours, days, years;

	string buf = string("");
	if (nano) { buf += to_string(nano); buf += "ns"; }
	if (seconds) { buf.insert(0, to_string(seconds) + "s"); }

	if (minutes < 1)
		goto end;

	hours = minutes / 60;
	minutes = minutes % 60;

	if (minutes) { buf.insert(0, to_string(minutes) + "m"); }
	if (hours < 1)
		goto end;

	days = hours / 24;
	hours = hours % 24;

	if (hours) { buf.insert(0, to_string(hours) + "h"); }
	if (days < 1)
		goto end;

	years = days / 365;
	days = days % 365;

	if (days) { buf.insert(0, to_string(days) + "d"); }
	if (years < 1)
		goto end;

	buf.insert(0, to_string(years) + "y");

end:
	o << buf;
	return o;
}

// User defined literals described at
// http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2378.pdf.
constexpr Nano operator"" _ns(unsigned long long int x)
{
	return Nano(x);
}

constexpr Nano operator"" _s(unsigned long long int x)
{
	return Nano(x * 1000000000);
}

constexpr Nano operator"" _i(unsigned long long int x)
{
	return Nano(x * 1000000000 * 60);
}

constexpr Nano operator"" _h(unsigned long long int x)
{
	return Nano(x * 1000000000 * 60 * 60);
}

constexpr Nano operator"" _d(unsigned long long int x)
{
	return Nano(x * 1000000000 * 60 * 60 * 24);
}

constexpr Nano operator"" _m(unsigned long long int x)
{
	return Nano(x * 1000000000 * 60 * 60 * 24 * 30);
}

constexpr Nano operator"" _y(unsigned long long int x)
{
	return Nano(x * 1000000000 * 60 * 60 * 24 * 365);
}

const auto composed_difference = 1_h + 23_i + 45_s;

void test_nanos()
{
	cout << "Testing nanos module" << endl << endl;
	cout << Nano(500) << " = " << 500_ns << endl;
	cout << u_second << " = " << 1_s << endl;
	cout << u_minute + u_second + Nano(500)
		<< " = " << 1_i + 1_s + 500_ns << endl;
	cout << u_hour << " = " << 1_h << endl;
	cout << 1_h + 23_i + 45_s << " = " << composed_difference << endl;
	cout << u_day << " = " << 1_d << endl;
	cout << u_year << " = " << 1_y << endl;
	cout << u_year - 1_d << endl;

	const auto a = composed_difference + 3_y + 6_m + 4_d + 12987_ns;
	cout << "total " << a << endl;
	cout << "\tyear " << a.year() << endl;
	cout << "\tmonth " << a.month() << endl;
	cout << "\tday " << a.day() << endl;
	cout << "\thour " << a.hour() << endl;
	cout << "\tminute " << a.minute() << endl;
	cout << "\tsecond " << a.second() << endl;
}
