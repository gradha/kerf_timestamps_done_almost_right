package abomination;

import java.lang.StringBuilder;
import myqual.Nano;
import myqual.Plain;
import static extra.Out.*;

@SuppressWarnings("nano:cast.unsafe")
public class NanoUtils
{
	// Constants for human reference.
	public static final @Nano long uNano = (@Nano long)1;
	public static final @Nano long uSecond = mul(uNano, 1000000000);
	public static final @Nano long uMinute = mul(uSecond, 60);
	public static final @Nano long uHour = mul(uMinute, 60);
	public static final @Nano long uDay = mul(24, uHour);
	public static final @Nano long uMonth = mul(30, uDay);
	public static final @Nano long uYear = mul(uDay, 365);

	// Conversion procs to help with math annotation conversions.
	public static @Nano long Nano(int x) { return (@Nano long) x; }
	public static @Nano long Nano(Long x) { return (@Nano long) x; }
	public static @Nano long ns(int x) { return (@Nano long) x; }
	public static @Nano long s(int x) { return (@Nano long) x * uSecond; }
	public static @Nano long i(int x) { return (@Nano long) x * uMinute; }
	public static @Nano long h(int x) { return (@Nano long) x * uHour; }
	public static @Nano long d(int x) { return (@Nano long) x * uDay; }
	public static @Nano long m(int x) { return (@Nano long) x * uMonth; }
	public static @Nano long y(int x) { return (@Nano long) x * uYear; }

	public static Long nbox(@Nano long x) {
		return Long.valueOf((@Plain long)x);
	}

	// Poor man's operator overloading.
	public static @Nano long mul(@Nano long x, int y) {
		return (@Nano long)x * (@Nano long)y;
	}
	public static @Nano long mul(int x, @Nano long y) {
		return (@Nano long)x * (@Nano long)y;
	}
	public static @Nano long nadd(@Nano long x, int y) {
		return (@Nano long)x + (@Nano long)y;
	}
	public static @Nano long nadd(int x, @Nano long y) {
		return (@Nano long)x + (@Nano long)y;
	}
	public static @Nano long nadd(@Nano long x, @Nano long y) {
		return x + y;
	}
	public static @Nano long sub(@Nano long x, @Nano long y) {
		return x - y;
	}
	public static @Nano long madd(@Nano long... values) {
		@Nano long result = values[0];
		for (int f = 1; f < values.length; f++) {
			result = nadd(result, values[f]);
		}
		return result;
	}

	// Time unit extraction methods.
	public static int nYear(@Nano long x) {
		return (int)(x / uYear);
	}

	public static int nMonth(@Nano long x) {
		int result = (int)(x / uDay);
		result = result % 365;
		return 1 + (result % 12);
	}

	public static int nWeek(@Nano long x) {
		int result = (int)(x / uDay);
		result = result % 365;
		return 1 + (result % 7);
	}

	public static int nDay(@Nano long x) {
		int result = (int)(x / uDay);
		result = result % 365;
		return 1 + (result % 30);
	}

	public static int nHour(@Nano long x) {
		final int result = (int)(x / uHour);
		return result % 24;
	}

	public static int nMinute(@Nano long x) {
		final int result = (int)(x / uMinute);
		return result % 60;
	}

	public static int nSecond(@Nano long x) {
		final int result = (int)(x / uSecond);
		return result % 60;
	}

	public static int nMillisecond(@Nano long x) {
		return (int)(x % uSecond) / 1000000;
	}

	public static int nMicrosecond(@Nano long x) {
		return (int)(x % uSecond) / 1000;
	}

	public static int nNanosecond(@Nano long x) {
		return (int)(x % uSecond);
	}


	public static String nStr(@Nano long x) {
		assert(x >= 0);
		if (x < 1)
			return "0s";

		StringBuilder result = new StringBuilder();
		final int nano = (int)(x % 1000000000l);
		final int seconds = (int)(x / 1000000000l) % 60;
		int minutes = (int)(x / 60000000000l);

		if (0 != nano) {
			result.insert(0, "ns");
			result.insert(0, String.valueOf(nano));
		}
		if (0 != seconds) {
			result.insert(0, "s");
			result.insert(0, String.valueOf(seconds));
		}
		if (minutes < 1) {
			return result.toString();
		}

		int hours = minutes / 60;
		minutes = minutes % 60;

		if (0 != minutes) {
			result.insert(0, "m");
			result.insert(0, String.valueOf(minutes));
		}
		if (hours < 1) {
			return result.toString();
		}

		int days = hours / 24;
		hours = hours % 24;

		if (0 != hours) {
			result.insert(0, "h");
			result.insert(0, String.valueOf(hours));
		}
		if (days < 1) {
			return result.toString();
		}

		int years = days / 365;
		days = days % 365;

		if (0 != days) {
			result.insert(0, "d");
			result.insert(0, String.valueOf(days));
		}

		if (years > 0) {
			result.insert(0, "y");
			result.insert(0, String.valueOf(years));
		}

		return result.toString();
	}

	static final @Nano long composedDifference = h(1) + i(23) + s(45);
	static final String composedString = nStr(composedDifference);

	public static void testSeconds() {
		echo("Testing seconds operations:");
		echo(nStr(Nano(500)) + " = " + nStr(ns(500)));
		echo(nStr(uSecond) + " = " + nStr(s(1)));
		echo(nStr(uMinute + uSecond + (@Nano long) 500) +
			" = " + nStr(i(1) + s(1) + ns(500)));
		echo(nStr(uHour) + " = " + nStr(h(1)));
		echo(nStr(h(1) + i(23) + s(45)) + " = "
			+ nStr(composedDifference) + " = " + composedString);
		echo(nStr(uDay) + " = " + nStr(d(1)));
		echo(nStr(uYear) + " = " + nStr(y(1)));
		echo(nStr(uYear - d(1)));

		@Nano long a = composedDifference + y(3) + m(6) + d(4) + ns(12987);
		echo("total " + nStr(a));
		echo("\tyear " + nYear(a));
		echo("\tmonth " + nMonth(a));
		echo("\tday " + nDay(a));
		echo("\thour " + nHour(a));
		echo("\tminute " + nMinute(a));
		echo("\tsecond " + nSecond(a));
	}
}
