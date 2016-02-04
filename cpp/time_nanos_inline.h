// This file can be included only by time_nanos.h
#ifdef _TIME_NANOS_H_

inline Nano Nano::operator+(const Nano& rhs) const
{
	return Nano(val + rhs.val);
}

inline Nano Nano::operator-(const Nano& rhs) const
{
	return Nano(val - rhs.val);
}

inline Nano Nano::operator*(const int& rhs) const
{
	return Nano(val * rhs);
}

inline Nano operator*(const int& lhs, const Nano& rhs)
{
	return Nano(lhs * rhs.val);
}

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


#endif // _TIME_NANOS_H_
