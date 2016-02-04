#include "time_stamp.h"

#include "time_nanos.h"


using namespace std;


const int YEAR_START = 0;
const int MONTH_START = YEAR_START + 5;
const int DAYS_START = MONTH_START + 3;
const int HOURS_START = DAYS_START + 3;
const int MINUTES_START = HOURS_START + 3;
const int SECONDS_START = MINUTES_START + 3;
const int NANOS_START = SECONDS_START + 3;
const int MAX_STAMP_LEN = 30;
const int DAYS_IN_A_MONTH = 30;
const int EPOCH_OFFSET = 1970;
const long long ONE_SECOND = 1000000000;

ostream& operator<<(std::ostream& o, const Stamp& x)
{
	long long total = x.val;
	const long long seconds = total % u_minute.val;
	total = total - seconds;

	const long long minutes = total % u_hour.val;
	total = total - minutes;

	const long long hours = total % u_day.val;
	total = total - hours;

	const long long days = total % u_year.val;
	const long long years = (total - days) / u_year.val;

	o << (EPOCH_OFFSET + years) << "." << setfill('0') << right;
	long long numeric_days = days / u_day.val;
	const long long numeric_months = 1 + numeric_days / DAYS_IN_A_MONTH;
	numeric_days = 1 + (numeric_days % DAYS_IN_A_MONTH);

	o << setw(2) << numeric_months << '.';
	o << setw(2) << numeric_days;

	const long long numeric_seconds = seconds / u_second.val;
	const long long numeric_minutes = minutes / u_minute.val;
	const long long numeric_hours = hours / u_hour.val;
	const long long numeric_nanos = seconds % u_second.val;

	if (numeric_seconds < 1 && numeric_minutes < 1
			&& numeric_hours < 1 && numeric_nanos < 1)
		return o;

	o << 'T';
	o << setw(2) << numeric_hours << ':';
	o << setw(2) << numeric_minutes << ':';
	o << setw(2) << numeric_seconds;

	if (numeric_nanos > 0) {
		o << '.' << setw(9) << numeric_nanos;
	}
	return o;
}

//const auto a = "2012-0101"_date;

void test_stamp()
{
	cout << "Testing stamp module" << endl << endl;

	auto a = "2012-01-01"_date;
	cout << "let's start at " << a << endl;
	cout << "plus one day is " << a + 1_d << endl;
	cout << "plus one month is " << a + 1_m << endl;
	cout << "plus one month and a day is " << a + 1_m + 1_d << endl;
	cout << "…plus 1h15i17s " << a + 1_m + 1_d + 1_h + 15_i + 17_s << endl;
	cout << "…plus 23 hours " << a + 1_m + 2_d - 1_h << endl;
	cout << "2001.01.01T01"_date << endl;
	cout << "2001.01.01T02:01"_date << endl;
	cout << "2001.01.01T03:02:01"_date << endl;
	cout << "2001.01.01T04:09:02.1"_date << endl;
	cout << "2001.01.01T04:09:02.12"_date << endl;
	cout << "2001.01.01T04:09:02.123"_date << endl;
	cout << "2001.01.01T05:04:03.0123"_date << endl;
	cout << "2001.01.01T06:05:04.012345678"_date << endl;
	a = "2001.01.01T06:05:04.012345678"_date;
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
