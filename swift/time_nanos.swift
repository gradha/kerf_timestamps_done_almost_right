let u_nano = Nano(1),
	u_second = Nano(1_000_000_00),
	u_minute = u_second * 60,
	u_hour = u_minute * 60,
	u_day = 24 * u_hour,
	u_month = 30 * u_day,
	u_year = u_day * 365

struct Nano : CustomStringConvertible {
	var value: Int64 = 0

	init(_ x: Int64) {
		self.value = x
	}

	var description: String {
		return "\(self.value)"
	}

	var s: String { return description }
}

func *(lhs: Nano, rhs: Int) -> Nano { return Nano(lhs.value * Int64(rhs)); }
func *(lhs: Int, rhs: Nano) -> Nano { return Nano(Int64(lhs) * rhs.value); }
func +(lhs: Nano, rhs: String) -> String { return lhs.s + rhs; }
func +(lhs: String, rhs: Nano) -> String { return lhs + rhs.s; }
func +(lhs: Nano, rhs: Nano) -> Nano { return Nano(lhs.value + rhs.value); }

extension Int {
	var ns: Nano { return Nano(Int64(self)) }
	var s: Nano { return self * u_second }
	var i: Nano { return self * u_minute }
	var h: Nano { return self * u_hour }
	var d: Nano { return self * u_day }
	var m: Nano { return self * u_month }
	var y: Nano { return self * u_year }
}

func test_seconds() {
	print("Testing second operations:\n")
	print("\(Nano(500)) = \(500.ns)")
	print(Nano(500) + " = " + 500.ns)
	print(u_second + " = " + 1.s)
	// Uncomment this line to make the swift 2.1.1 compiler cry like a child.
	//print(u_minute + u_second + Nano(500) + " = " + 1.i + 1.s + 500.ns)
	print("\(u_minute + u_second + Nano(500)) = \(1.i + 1.s + 500.ns)")
	print((u_minute + u_second + Nano(500)) + " = " + (1.i + 1.s + 500.ns))
}
