struct Nano : CustomStringConvertible {
	var value: Int64 = 0
	init(_ x: Int64) { self.value = x }
	var description: String { return "\(self.value)" }
}

let u_nano = Nano(1)
let u_second = Nano(1_000_000_00)
let u_minute = u_second * 60

func *(lhs: Nano, rhs: Int) -> Nano { return Nano(lhs.value * Int64(rhs)); }
func *(lhs: Int, rhs: Nano) -> Nano { return Nano(Int64(lhs) * rhs.value); }
func +(lhs: Nano, rhs: String) -> String { return lhs.description + rhs; }
func +(lhs: String, rhs: Nano) -> String { return lhs + rhs.description; }
func +(lhs: Nano, rhs: Nano) -> Nano { return Nano(lhs.value + rhs.value); }

extension Int {
	var ns: Nano { return Nano(Int64(self)) }
	var s: Nano { return self * u_second }
	var i: Nano { return self * u_minute }
}

func test_seconds() {
	print("Testing second operations:\n")
	print(u_minute + u_second + Nano(500) + " = " + 1.i + 1.s + 500.ns)
	print((u_minute + u_second + Nano(500)) + " = " + (1.i + 1.s + 500.ns))
}
