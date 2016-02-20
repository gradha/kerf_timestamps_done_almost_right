func test_blog_examples() {
	print("Showing blog examples.\n")

	let a = "2012.01.01".date
	print("Example 1: \(a)")
	print("Example 2:")
	print("\t\(a + 1.d)")
	print("\t\("2012.01.01".date + 1.d)")

	print("Example 3: \("2012.01.01".date + 1.m + 1.d + 1.h + 15.i + 17.s)")

	let r = (0..<10)
	let offsets = r.map() { (1.m + 1.d + 1.h + 15.i + 17.s) * $0 }
	let values = offsets.map() { "2012.01.01".date + $0 }

	print("Example 4: \(values)")

	let x = String((0..<10)
		.map() { (1.m + 1.d + 1.h + 15.i + 17.s) * $0 }
		.map() { "2012.01.01".date + $0 })
	// Swift's compiler agrees that string interpolation is crap and bails out
	// if you try to embed the previous expression, so we create a temporal.
	print("…again but compressed… \(x)")

	print("…again with explicit concatenation… " + String((0..<10)
		.map() { (1.m + 1.d + 1.h + 15.i + 17.s) * $0 }
		.map() { "2012.01.01".date + $0 }))

	// Not trying to use helper procs version because
	// the compiler is too retarded for complex expressions.
	print("Example 5 b[week]: \(values.map() { $0.week })")
	print("Example 5 b[second]: \(values.map() { $0.second })")

	print("\nDid most examples.")
}

func main() {
	test_seconds()
	test_stamps()
	test_blog_examples()
}

main()
