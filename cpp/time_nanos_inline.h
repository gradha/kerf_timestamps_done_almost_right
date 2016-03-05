// This file can be included only by time_nanos.h
#ifdef _TIME_NANOS_H_

#include <algorithm>
#include <assert.h>
#include <iomanip>
#include <numeric>
#include <string>

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
	return 1 + (result / 7);
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


// Picked from http://stackoverflow.com/a/10758845/172690.
template <typename T>
std::ostream& operator<< (std::ostream& out, const std::vector<T>& v)
{
	if (!v.empty()) {
		out << '[';
		std::copy (v.begin(), v.end(), std::ostream_iterator<T>(out, ", "));
		out << "\b\b]";
	}
	return out;
}

// Stolen from http://stackoverflow.com/q/23871757/172690.
template<typename T, typename Functor>
auto map(const std::vector<T> &v, Functor &&f) -> std::vector<decltype(f(*v.begin()))>
{
	std::vector<decltype(f(*v.begin()))> ret;
	std::transform(begin(v), end(v), std::inserter(ret, ret.end()), f);
	return ret;
}

// Inspired by http://stackoverflow.com/a/18626013/172690.
template<typename T> std::vector<T> range(T start, T end)
{
	assert(end >= start);
	std::vector<T> result(end - start);
	int n(start);
	std::iota(result.begin(), result.end(), n);
	return result;
}

template<typename T>
std::vector<Nano> Nano::operator*(const std::vector<T>& rhs) const
{
	std::vector<Nano> result;
	result.reserve(rhs.size());
	for (int f = 0; f < rhs.size(); f++) {
		result.push_back(Nano(val * rhs[f]));
	}
	return result;
}

#endif // _TIME_NANOS_H_
