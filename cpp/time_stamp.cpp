#include "time_stamp.h"

#include "time_nanos.h"

#include <iostream>
#include <iomanip>
#include <string>
#include <assert.h>


using namespace std;


struct Stamp {
	long long val; // The timestamp
	// construct a Value from a long long
	constexpr explicit Stamp(unsigned long long int x) : val(x) {}

	inline Stamp operator+(const Nano& rhs) const;
	inline Stamp operator-(const Nano& rhs) const;
	inline Stamp operator*(const int& rhs) const;
	inline Stamp operator/(const int& rhs) const;
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

std::ostream& operator<<(std::ostream& o, const Stamp& x);

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

Stamp Stamp::operator+(const Nano& rhs) const
{
	return Stamp(val + rhs.val);
}

Stamp Stamp::operator-(const Nano& rhs) const
{
	return Stamp(val - rhs.val);
}

// Requires C++14 support.
constexpr Stamp operator"" _date(const char* x, const size_t len)
{
	assert(len >= 10 and len < MAX_STAMP_LEN);

	int temp = ((*x++) - '0') * 1000;
	temp += ((*x++) - '0') * 100;
	temp += ((*x++) - '0') * 10;
	temp += ((*x++) - '0') * 1;
	assert(temp >= EPOCH_OFFSET);
	x++;

	Stamp result = Stamp(((long long)temp - EPOCH_OFFSET)
		* ONE_SECOND * 60 * 60 * 24 * 365);

	temp = ((*x++) - '0') * 10;
	temp += (*x++) - '0';
	assert(temp > 0 && temp < 13);
	x++;

	result.val += ((long long)temp - 1) * ONE_SECOND * 60 * 60 * 24 * 30;

	temp = ((*x++) - '0') * 10;
	temp += (*x++) - '0';
	assert(temp > 0 && temp < 32);

	result.val += ((long long)temp - 1) * ONE_SECOND * 60 * 60 * 24;

	if (len < MINUTES_START - 1)
		return result;

	assert('T' == *x);
	x++;

	temp = ((*x++) - '0') * 10;
	temp += (*x++) - '0';
	assert(temp >= 0 && temp < 24);
	result.val += (long long)temp * ONE_SECOND * 60 * 60;

	if (len < SECONDS_START - 1)
		return result;

	assert(':' == *x);
	x++;

	temp = ((*x++) - '0') * 10;
	temp += (*x++) - '0';
	assert(temp >= 0 && temp < 60);
	result.val += (long long)temp * ONE_SECOND * 60;

	if (len < NANOS_START - 1)
		return result;

	assert(':' == *x);
	x++;

	temp = ((*x++) - '0') * 10;
	temp += (*x++) - '0';
	assert(temp >= 0 && temp < 60);
	result.val += (long long)temp * ONE_SECOND;

	if (len > NANOS_START) {
		assert('.' == *x);
		x++;
#define _CHECK() do { if (*x < '0' || *x > '9') return result; } while(0)
		_CHECK(); result.val += (long long)(*x++ - '0') * 100000000;
		_CHECK(); result.val += (long long)(*x++ - '0') * 10000000;
		_CHECK(); result.val += (long long)(*x++ - '0') * 1000000;
		_CHECK(); result.val += (long long)(*x++ - '0') * 100000;
		_CHECK(); result.val += (long long)(*x++ - '0') * 10000;
		_CHECK(); result.val += (long long)(*x++ - '0') * 1000;
		_CHECK(); result.val += (long long)(*x++ - '0') * 100;
		_CHECK(); result.val += (long long)(*x++ - '0') * 10;
		_CHECK(); result.val += (long long)(*x++ - '0') * 1;
#undef _VALID
	}

	return result;
}

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
	o << setw(2) << numeric_days << '.';

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
}
