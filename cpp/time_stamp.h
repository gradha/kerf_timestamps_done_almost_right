#ifndef _TIME_STAMP_H_
#define _TIME_STAMP_H_

#include "time_nanos.h"

#include <iostream>
#include <vector>

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

	template<typename T>
	std::vector<Stamp> operator+(const std::vector<T>& rhs) const;
};

std::ostream& operator<<(std::ostream& o, const Stamp& x);
constexpr Stamp operator"" _date(const char* x, const size_t len);

void test_stamp();

#include "time_stamp_inline.h"

#endif // _TIME_STAMP_H_
