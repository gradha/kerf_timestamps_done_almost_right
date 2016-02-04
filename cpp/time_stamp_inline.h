// This file can be included only by time_stamp.h
#ifdef _TIME_STAMP_H_

#include <iomanip>
#include <string>
#include <assert.h>

extern const int YEAR_START;
extern const int MONTH_START;
extern const int DAYS_START;
extern const int HOURS_START;
extern const int MINUTES_START;
extern const int SECONDS_START;
extern const int NANOS_START;
extern const int MAX_STAMP_LEN;
extern const int DAYS_IN_A_MONTH;
extern const int EPOCH_OFFSET;
extern const long long ONE_SECOND;


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

inline Stamp Stamp::operator+(const Nano& rhs) const
{
	return Stamp(val + rhs.val);
}

inline Stamp Stamp::operator-(const Nano& rhs) const
{
	return Stamp(val - rhs.val);
}

inline int Stamp::year(void) const
{
	return Nano(val).year() + EPOCH_OFFSET;
}

inline int Stamp::month(void) const
{
	return Nano(val).month();
}

inline int Stamp::week(void) const
{
	return Nano(val).week();
}

inline int Stamp::day(void) const
{
	return Nano(val).day();
}

inline int Stamp::hour(void) const
{
	return Nano(val).hour();
}

inline int Stamp::minute(void) const
{
	return Nano(val).minute();
}

inline int Stamp::second(void) const
{
	return Nano(val).second();
}

inline int Stamp::millisecond(void) const
{
	return Nano(val).millisecond();
}

inline int Stamp::microsecond(void) const
{
	return Nano(val).microsecond();
}

inline int Stamp::nanosecond(void) const
{
	return Nano(val).nanosecond();
}

#endif // _TIME_STAMP_H_
