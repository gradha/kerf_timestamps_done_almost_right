let u_nano = Nano(1)
let u_second = Nano(1_000_000_000)
let u_minute = u_second * 60
let u_hour = u_minute * 60
let u_day = 24 * u_hour
let u_month = 30 * u_day
let u_year = u_day * 365

struct Nano : CustomStringConvertible {
	var value: Int64 = 0

	init(_ x: Int64) {
		self.value = x
	}

	var description: String {
		assert(self.value >= 0)
		if (self.value < 1) {
			return "0s"
		}

		let nano = self.value % 1_000_000_000
		var seconds = (self.value / 1_000_000_000) % 60
		var minutes = self.value / 60_000_000_000

		var result = (0 == nano ? "" : "\(nano)ns")
		result = (0 == seconds ? result : "\(seconds)s\(result)")
		if (minutes < 1) {
			return result
		}

		var hours = minutes / 60
		minutes = minutes % 60

		result = (0 == minutes ? result : "\(minutes)m\(result)")
		if (hours < 1) {
			return result
		}

		var days = hours / 24
		hours = hours % 24

		result = (0 == hours ? result : "\(hours)h\(result)")
		if (days < 1) {
			return result
		}

		let years = days / 365
		days = days % 365

		result = (0 == days ? result : "\(days)d\(result)")
		if (years < 1) {
			return result
		}

		return "\(years)y\(result)"
	}

	var s: String { return description }

	func year() -> Int { return Int(self.value / u_year.value); }

	func month() -> Int {
		let result = Int(self.value / u_day.value) % 365
		return 1 + result % 12
	}

	func week() -> Int {
		let result = Int(self.value / u_day.value) % 365
		return 1 + result / 7
	}

	func day() -> Int {
		let result = Int(self.value / u_day.value) % 365
		return 1 + result % 30
	}

	func hour() -> Int {
		let result = Int(self.value / u_hour.value)
		return result % 24
	}

	func minute() -> Int {
		let result = Int(self.value / u_minute.value)
		return result % 60
	}

	func second() -> Int {
		let result = Int(self.value / u_second.value)
		return result % 60
	}

	func millisecond() -> Int {
		return Int(self.value % u_second.value) / 1_000_000
	}

	func microsecond() -> Int {
		return Int(self.value % u_second.value) / 1_000
	}

	func nanosecond() -> Int {
		return Int(self.value % u_second.value)
	}
}

func *(lhs: Nano, rhs: Int) -> Nano { return Nano(lhs.value * Int64(rhs)); }
func *(lhs: Int, rhs: Nano) -> Nano { return Nano(Int64(lhs) * rhs.value); }
func +(lhs: Nano, rhs: String) -> String { return lhs.s + rhs; }
func +(lhs: String, rhs: Nano) -> String { return lhs + rhs.s; }
func +(lhs: Nano, rhs: Nano) -> Nano { return Nano(lhs.value + rhs.value); }
func -(lhs: Nano, rhs: Nano) -> Nano { return Nano(lhs.value - rhs.value); }

extension Int {
	var ns: Nano { return Nano(Int64(self)) }
	var s: Nano { return self * u_second }
	var i: Nano { return self * u_minute }
	var h: Nano { return self * u_hour }
	var d: Nano { return self * u_day }
	var m: Nano { return self * u_month }
	var y: Nano { return self * u_year }
}

let composed_difference = 1.h + 23.i + 45.s
let composed_string: String = composed_difference.s

func test_seconds() {
	print("Testing second operations:\n")
	print("\(Nano(500)) = \(500.ns)")
	print(Nano(500) + " = " + 500.ns)
	print(u_second + " = " + 1.s)
	// Uncomment this line to make the swift 2.1.1 compiler cry like a child.
	//print(u_minute + u_second + Nano(500) + " = " + 1.i + 1.s + 500.ns)
	print("\(u_minute + u_second + Nano(500)) = \(1.i + 1.s + 500.ns)")
	print((u_minute + u_second + Nano(500)) + " = " + (1.i + 1.s + 500.ns))
	print("\(1.h + 23.i + 45.s) = \(composed_difference) = \(composed_string)")
	print("\(u_day) = \(1.d)")
	print("\(u_year) = \(1.y)")
	print("\(u_year - 1.d)")

	let a = composed_difference + 3.y + 6.m + 4.d + 12_987.ns
	print("total \(a)")
	print("\tyear \(a.year())")
	print("\tmonth \(a.month())")
	print("\tday \(a.day())")
	print("\thour \(a.hour())")
	print("\tminute \(a.minute())")
	print("\tsecond \(a.second())")
}
