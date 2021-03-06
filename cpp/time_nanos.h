#ifndef _TIME_NANOS_H_
#define _TIME_NANOS_H_

#include <iostream>
#include <vector>

struct Nano
{
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

	template<typename T>
	std::vector<Nano> operator*(const std::vector<T>& rhs) const;
};

Nano operator*(const int& lhs, const Nano& rhs);
std::ostream& operator<<(std::ostream& o, const Nano& x);

constexpr Nano operator"" _ns(unsigned long long int x);
constexpr Nano operator"" _s(unsigned long long int x);
constexpr Nano operator"" _i(unsigned long long int x);
constexpr Nano operator"" _h(unsigned long long int x);
constexpr Nano operator"" _d(unsigned long long int x);
constexpr Nano operator"" _m(unsigned long long int x);
constexpr Nano operator"" _y(unsigned long long int x);

extern const Nano u_nano;
extern const Nano u_second;
extern const Nano u_minute;
extern const Nano u_hour;
extern const Nano u_day;
extern const Nano u_month;
extern const Nano u_year;

void test_nanos();

template <typename T>
std::ostream& operator<< (std::ostream& out, const std::vector<T>& v);

template<typename T, typename Functor>
auto map(const std::vector<T> &v, Functor &&f) -> std::vector<decltype(f(*v.begin()))>;

template<typename T> std::vector<T> range(T start, T end);

#include "time_nanos_inline.h"

#endif // _TIME_NANOS_H_
