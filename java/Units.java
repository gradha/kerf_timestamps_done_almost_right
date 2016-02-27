import java.util.*;
import java.util.stream.*;
import myqual.Nano;
import myqual.Plain;
import myqual.Stamp;
import static abomination.NanoUtils.*;
import static abomination.StampUtils.*;
import static extra.Out.*;

public class Units
{
	public static void main(String[] args) {
		testSeconds();
		testStamps();
		testBlogExamples();
	}

	static void testBlogExamples() {
		echo("Showing blog examples.\n");

		@Stamp long a = Date("2012.01.01");
		echo("Example 1: " + sStr(a));
		echo("Example 2:");
		echo("\t" + sStr(sadd(a, d(1))));
		echo("\t" + sStr(sadd(Date("2012.01.01"), d(1))));
		echo("Example 3: " + sStr(sadd(Date("2012.01.01"),
			madd(m(1), d(1), h(1), i(15), s(17)))));

		// Nice try, java, nice try.
		List<Long> values = IntStream.range(0, 10)
			.boxed() // Hint, if the language requires boxing, it sucks.
			// First create Longs contaning the nano offsets.
			.map(intStep -> nbox(mul(
				madd(m(1), d(1), h(1), i(15), s(17)),
				(int)intStep)))
			// Apply the nano offsets to a stamp.
			.map(longNano -> sbox(sadd(Date("2012.01.01"), Nano(longNano))))
			.collect(Collectors.toList());

		echo("Example 4: @[" + values.stream()
			.map(longStamp -> sStr(Stamp(longStamp)))
			.collect(Collectors.joining(", ")) + "]");

		echo("Example 5: b[week]: @[" + values.stream()
			.map(longStamp -> String.valueOf(sWeek(Stamp(longStamp))))
			.collect(Collectors.joining(", ")) + "]");

		echo("Example 5: b[second]: @[" + values.stream()
			.map(longStamp -> String.valueOf(sSecond(Stamp(longStamp))))
			.collect(Collectors.joining(", ")) + "]");

		echo("\nDid most examples, awkwardly.");
	}
}
