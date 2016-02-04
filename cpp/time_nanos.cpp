#include "time_nanos.h"

#include <iostream>
#include <string>
#include <assert.h>


using namespace std;


const Nano u_nano = 1_ns;
const Nano u_second = Nano(1000000000);
const Nano u_minute = u_second * 60;
const Nano u_hour = u_minute * 60;
const Nano u_day = 24 * u_hour;
const Nano u_month = 30 * u_day;
const Nano u_year = u_day * 365;

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
	cout << "\tmicrosecond " << a.microsecond() << endl;
	cout << "\tmillisecond " << a.millisecond() << endl;
	cout << "\tnanosecond " << a.nanosecond() << endl;
}
