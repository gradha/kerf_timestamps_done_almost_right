let year_start = "".len
let month_start = "YYYY-".len
let days_start = "YYYY-MM-".len
let hours_start = "YYYY-MM-DDT".len
let minutes_start = "YYYY-MM-DDThh:".len
let seconds_start = "YYYY-MM-DDThh:mm:".len
let nanos_start = "YYYY-MM-DDThh:mm:ss:".len
let max_stamp_len = "YYYY-MM-DDThh:mm:ss:012345678".len
let epoch_offset = 1970
let days_in_a_month = 30
let digits: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

struct Stamp : CustomStringConvertible {
	var value: Int64 = 0

	init(_ x: Int64) { value = x }
	init(_ x: Nano) { value = x.value }

	var description: String { return "\(s)" }

	// Constructor/parser of a string.
	init(_ x: String) {
		assert(x.len >= 10 && x.len <= max_stamp_len)
		var token = "" // Annoying compiler requires initialisation.
		precondition(4 == parse_while(x, &token, digits, year_start))

		let yyyy = Int(token)!
		precondition(yyyy >= epoch_offset)

		precondition(2 == parse_while(x, &token, digits, month_start))
		let mm = Int(token)!
		precondition(mm > 0 && mm < 13)

		precondition(2 == parse_while(x, &token, digits, days_start))
		let dd = Int(token)!

		// Finally, convert the individual values to a (fake) calendar.
		value = ((yyyy - epoch_offset) * u_year).value
		// Ouch, another "too complex" expression for the compiler… sigh.
		value = value + ((mm - 1) * days_in_a_month * u_day).value
		value = value + ((dd - 1) * u_day).value

		if x.len < minutes_start - 1 {
			return
		}

		// Ugh, we got some times… ok, try to parse them.
		precondition(2 == parse_while(x, &token, digits, hours_start))
		let hh = Int(token)!
		precondition(hh >= 0 && hh < 24)
		value = value + hh.h.value

		if x.len < seconds_start - 1 {
			return
		}

		precondition(2 == parse_while(x, &token, digits, minutes_start))
		let minutes = Int(token)!
		precondition(minutes >= 0 && minutes < 60)
		value = value + minutes.i.value

		if x.len < nanos_start - 1 {
			return
		}

		precondition(2 == parse_while(x, &token, digits, seconds_start))
		let seconds = Int(token)!
		precondition(seconds >= 0 && seconds < 60)
		value = value + seconds.s.value

		if x.len > nanos_start {
			var num_nanos = parse_while(x, &token, digits, nanos_start)
			precondition(num_nanos > 0 && num_nanos < 10)
			var nanos = Int(token)!
			// Compensate lack of decimals during parsing with pow-like loop.
			while num_nanos < 9 {
				nanos = nanos * 10
				num_nanos = num_nanos + 1
			}
			value += nanos
		}
	}

	var s: String {
		assert(value >= 0)
		var total = Nano(self.value)
		let seconds = total % u_minute
		total = total - seconds

		let minutes = total % u_hour
		total = total - minutes

		let hours = total % u_day
		total = total - hours

		let days = total % u_year
		let years = (total - days) / u_year

		var result = "\(epoch_offset + years)."

		var numeric_days = Int(days / u_day)
		let numeric_months = Int(numeric_days / days_in_a_month)
		numeric_days = numeric_days % days_in_a_month

		result += align(String(1 + numeric_months), 2, "0") + "."
		result += align(String(1 + numeric_days), 2, "0")

		let numeric_seconds = Int(seconds / u_second)
		let numeric_minutes = Int(minutes / u_minute)
		let numeric_hours = Int(hours / u_hour)
		let numeric_nanos = Int(seconds % u_second)

		// Return already if the time ends at midnight.
		if numeric_seconds < 1 && numeric_minutes < 1 &&
				numeric_hours < 1 && numeric_nanos < 1 {
			return result
		}

		result += "T" + align(String(numeric_hours), 2, "0")
		result += ":" + align(String(numeric_minutes), 2, "0")
		result += ":" + align(String(numeric_seconds), 2, "0")

		if numeric_nanos > 0 {
			result += "." + align(String(numeric_nanos), 9, "0")
		}
		return result
	}

	var year: Int { return Nano(self).year + epoch_offset }
	var week: Int { return Nano(self).week }
	var month: Int { return Nano(self).month }
	var day: Int { return Nano(self).day }
	var hour: Int { return Nano(self).hour }
	var minute: Int { return Nano(self).minute }
	var second: Int { return Nano(self).second }
	var microsecond: Int { return Nano(self).microsecond }
	var millisecond: Int { return Nano(self).millisecond }
	var nanosecond: Int { return Nano(self).nanosecond }
}

func +(lhs: Stamp, rhs: Nano) -> Stamp { return Stamp(lhs.value + rhs.value) }
func -(lhs: Stamp, rhs: Nano) -> Stamp { return Stamp(lhs.value - rhs.value) }

extension String {
	var date: Stamp { return Stamp(self) }
	// Avoid losing sanity. Hey, at least this is not java!
	var len: Int { return self.characters.count }
}

// Lifted code from Nim to make it look as close as possible to original.
func align(x: String, _ count: Int, _ padding: Character = " ") -> String {
	if x.len < count {
		let spaces = count - x.len
		let pad = String(count: spaces, repeatedValue: padding)
		return "\(pad)\(x)"
	} else {
		return x
	}
}

// Lifted code from Nim to make it look as close as possible to original.
func parse_while(s: String,
		inout _ token: String,
		_ validChars: Set<Character>,
		_ start: Int = 0) -> Int {

	let firstCharacter = s.startIndex.advancedBy(start)
	var parsedChars = 0
	var i = firstCharacter
	while i < s.endIndex {
		if validChars.contains(s[i]) {
			i = i.successor()
			parsedChars += 1
		} else {
			break
		}
	}
	token = s[firstCharacter..<i]
	return parsedChars
}

func test_stamps() {
	print("Testing stamps:\n")
	var a = "2012-01-01".date
	print("let's start at \(a)")
	print("plus one day is \(a + 1.d)")
	print("plus one month is \(a + 1.m)")
	print("plus one month and a day is \(a + 1.m + 1.d)")
	print("…plus 1h15i17s \(a + 1.m + 1.d + 1.h + 15.i + 17.s)")
	print("…plus 23 hours \(a + 1.m + 2.d - 1.h)")
	print("\("2001.01.01T01".date)")
	print("\("2001.01.01T02:01".date)")
	print("\("2001.01.01T03:02:01".date)")
	print("\("2001.01.01T04:09:02.1".date)")
	print("\("2001.01.01T04:09:02.12".date)")
	print("\("2001.01.01T04:09:02.123".date)")
	print("\("2001.01.01T05:04:03.0123".date)")
	print("\("2001.01.01T06:05:04.012345678".date)")
	a = "2001.01.01T06:05:04.012345678".date
	print("\tyear \(a.year)")
	print("\tmonth \(a.month)")
	print("\tday \(a.day)")
	print("\thour \(a.hour)")
	print("\tminute \(a.minute)")
	print("\tsecond \(a.second)")
	print("\tmicrosecond \(a.microsecond)")
	print("\tmillisecond \(a.millisecond)")
	print("\tnanosecond \(a.nanosecond)")
}
