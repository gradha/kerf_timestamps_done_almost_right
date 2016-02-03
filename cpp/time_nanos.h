#ifndef _TIME_NANOS_H_
#define _TIME_NANOS_H_

#include <iostream>

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
std::ostream& operator<<(std::ostream& o, const Nano& x);

constexpr long long operator/(const long long& lhs, const Nano& rhs)
{
	return lhs / rhs.val;
}

constexpr long long operator%(const long long& lhs, const Nano& rhs)
{
	return lhs % rhs.val;
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


extern const Nano u_nano;
extern const Nano u_second;
extern const Nano u_minute;
extern const Nano u_hour;
extern const Nano u_day;
extern const Nano u_month;
extern const Nano u_year;

void test_nanos();

#endif // _TIME_NANOS_H_
