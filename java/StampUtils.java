import java.lang.StringBuilder;
import myqual.Nano;
import myqual.Stamp;
import static extra.Out.*;

@SuppressWarnings("nano:cast.unsafe")
public class StampUtils
{
	static final int yearsStart = "".length();
	static final int monthsStart = "YYYY-".length();
	static final int daysStart = "YYYY-MM-".length();
	static final int hoursStart = "YYYY-MM-DDT".length();
	static final int minutesStart = "YYYY-MM-DDThh:".length();
	static final int secondsStart = "YYYY-MM-DDThh:mm:".length();
	static final int nanosStart = "YYYY-MM-DDThh:mm:ss:".length();
	static final int maxStampLen = "YYYY-MM-DDThh:mm:ss:012345678".length();
	static final int epochOffset = 1970;
	static final int daysInAMonth = 30;

	// Conversion procs to help with math annotation conversions.
	public static @Stamp long Date(String x) {
		assert(x.length() >= 10 && x.length() <= maxStampLen);
		final String yearToken = parseDigitsWhile(x, yearsStart);
		final int yyyy = Integer.valueOf(yearToken);
		assert(yearToken.length() == 4 && yyyy >= epochOffset);

		final String monthsToken = parseDigitsWhile(x, monthsStart);
		final int mm = Integer.valueOf(monthsToken);
		assert(monthsToken.length() == 2 && mm > 0 && mm < 13);

		final String daysToken = parseDigitsWhile(x, daysStart);
		final int dd = Integer.valueOf(daysToken);
		assert(daysToken.length() == 2 && dd > 0 && dd < 32);

		// Finally, convert the individual values to a (fake) calendar.
		@Stamp long result = Stamp(
			NanoUtils.add(
				NanoUtils.add(
					NanoUtils.mul(yyyy - epochOffset, NanoUtils.uYear),
					NanoUtils.mul((mm - 1) * daysInAMonth, NanoUtils.uDay)
					),
				NanoUtils.mul(dd - 1, NanoUtils.uDay)
				)
			);

		if (x.length() < minutesStart - 1) {
			return result;
		}

		// Ugh, we got some times… ok, try to parse them.
		final String hoursToken = parseDigitsWhile(x, hoursStart);
		final int hh = Integer.valueOf(hoursToken);
		assert(hoursToken.length() == 2 && hh >= 0 && hh < 24);
		result = add(result, NanoUtils.h(hh));

		if (x.length() < secondsStart - 1) {
			return result;
		}

		final String minutesToken = parseDigitsWhile(x, minutesStart);
		final int minutes = Integer.valueOf(minutesToken);
		assert(minutesToken.length() == 2 && minutes >= 0 && minutes < 60);
		result = add(result, NanoUtils.i(minutes));

		if (x.length() < nanosStart - 1) {
			return result;
		}

		final String secondsToken = parseDigitsWhile(x, secondsStart);
		final int seconds = Integer.valueOf(secondsToken);
		assert(secondsToken.length() == 2 && seconds >= 0 && seconds < 60);
		result = add(result, NanoUtils.s(seconds));

		if (x.length() > nanosStart) {
			final String nanosToken = parseDigitsWhile(x, nanosStart);
			int numNanos = nanosToken.length();
			assert(numNanos > 0 && numNanos < 10);
			int nanos = Integer.valueOf(nanosToken);
			while (numNanos < 9) {
				nanos = nanos * 10;
				numNanos++;
			}

			result = add(result, NanoUtils.Nano(nanos));
		}

		return result;
	}

	// Lifted code from Nim to make it look as close as possible to original.
	static String parseDigitsWhile(final String s, final int start) {
		StringBuilder result = new StringBuilder(10);
		assert(start < s.length());
		for (int f = start; f < s.length(); f++) {
			if (Character.isDigit(s.codePointAt(f))) {
				result.append(s.charAt(f));
			} else {
				break;
			}
		}
		return result.toString();
	}

	// Lifted code from Nim to make it look as close as possible to original.
	static String zeroAlign(String x, int count) {
		if (x.length() < count) {
			int spaces = count - x.length();
			StringBuilder result = new StringBuilder(count);
			while (spaces > 0) {
				result.append("0");
				spaces--;
			}
			result.append(x);
			return result.toString();
		} else {
			return x;
		}
	}

	public static @Stamp long Stamp(@Nano long x) { return (@Stamp long)x; }

	// Poor man's operator overloading.
	public static @Stamp long add(@Stamp long x, @Nano long y) {
		return x + (@Stamp long)y;
	}

	public static String sStr(@Stamp long x) {
		@Nano long total = (@Nano long)x;
		@Nano final long seconds = total % NanoUtils.uMinute;
		total = total - seconds;

		@Nano final long minutes = total % NanoUtils.uHour;
		total = total - minutes;

		@Nano final long hours = total % NanoUtils.uDay;
		total = total - hours;

		@Nano final long days = total % NanoUtils.uYear;
		@Nano final int years = (int)((total - days) / NanoUtils.uYear);

		StringBuilder result = new StringBuilder(maxStampLen);
		result.append(String.valueOf(epochOffset + years));
		result.append(".");

		// Convert days to numbers for final in year calculations.
		int numericDays = (int)(days / NanoUtils.uDay);
		int numericMonths = numericDays / daysInAMonth;
		numericDays = numericDays % daysInAMonth;

		result.append(zeroAlign(String.valueOf(1 + numericMonths), 2));
		result.append(".");
		result.append(zeroAlign(String.valueOf(1 + numericDays), 2));

		final int numericSeconds = (int)(seconds / NanoUtils.uSecond);
		final int numericMinutes = (int)(minutes / NanoUtils.uMinute);
		final int numericHours = (int)(hours / NanoUtils.uHour);
		final int numericNanos = (int)(seconds % NanoUtils.uSecond);

		// Return already if the time ends at midnight.
		if (numericSeconds < 1 && numericMinutes < 1
				&& numericHours < 1 && numericNanos < 1) {

			return result.toString();
		}

		// Aww… format an hour then.
		result.append("T");
		result.append(zeroAlign(String.valueOf(numericHours), 2));
		result.append(":");
		result.append(zeroAlign(String.valueOf(numericMinutes), 2));
		result.append(":");
		result.append(zeroAlign(String.valueOf(numericSeconds), 2));

		if (numericNanos > 0) {
			result.append(".");
			result.append(zeroAlign(String.valueOf(numericNanos), 9));
		}

		return result.toString();
	}

	// Time unit extraction methods.
	public static int sYear(@Stamp long x) {
		return NanoUtils.nYear((@Nano long)x) + epochOffset;
	}

	public static int sMonth(@Stamp long x) {
		return NanoUtils.nMonth((@Nano long)x);
	}

	public static int sWeek(@Stamp long x) {
		return NanoUtils.nWeek((@Nano long)x);
	}

	public static int sDay(@Stamp long x) {
		return NanoUtils.nDay((@Nano long)x);
	}

	public static int sHour(@Stamp long x) {
		return NanoUtils.nHour((@Nano long)x);
	}

	public static int sMinute(@Stamp long x) {
		return NanoUtils.nMinute((@Nano long)x);
	}

	public static int sSecond(@Stamp long x) {
		return NanoUtils.nSecond((@Nano long)x);
	}

	public static int sMillisecond(@Stamp long x) {
		return NanoUtils.nMillisecond((@Nano long)x);
	}

	public static int sMicrosecond(@Stamp long x) {
		return NanoUtils.nMicrosecond((@Nano long)x);
	}

	public static int sNanosecond(@Stamp long x) {
		return NanoUtils.nNanosecond((@Nano long)x);
	}

	public static void test_stamps() {
		echo("Testing stamps:\n");
		@Stamp long a = Date("2012-01-01");
		echo("let's start at " + sStr(a));
		echo("plus one day is " + sStr(add(a, NanoUtils.d(1))));
		echo("plus one month is " + sStr(add(a, NanoUtils.m(1))));
		echo("plus one month and a day is " +
			sStr(add(a, NanoUtils.add(NanoUtils.m(1), NanoUtils.d(1)))));
		echo("…plus 1h15i17s " + sStr(add(a, NanoUtils.madd(
			NanoUtils.m(1), NanoUtils.d(1),
			NanoUtils.h(1), NanoUtils.i(15), NanoUtils.s(17)))));
		echo("…plus 23 hours " + sStr(add(a,
			NanoUtils.sub(NanoUtils.add(NanoUtils.m(1), NanoUtils.d(2)),
				NanoUtils.h(1)))));
		echo(sStr(Date("2001.01.01T01")));
		echo(sStr(Date("2001.01.01T02:01")));
		echo(sStr(Date("2001.01.01T03:02:01")));
		echo(sStr(Date("2001.01.01T04:09:02.1")));
		echo(sStr(Date("2001.01.01T04:09:02.12")));
		echo(sStr(Date("2001.01.01T04:09:02.123")));
		echo(sStr(Date("2001.01.01T05:04:03.0123")));
		echo(sStr(Date("2001.01.01T06:05:04.012345678")));
		a = Date("2001.01.01T06:05:04.012345678");
		echo("\tyear " + sYear(a));
		echo("\tmonth " + sMonth(a));
		echo("\tday " + sDay(a));
		echo("\thour " + sHour(a));
		echo("\tminute " + sMinute(a));
		echo("\tsecond " + sSecond(a));
		echo("\tmicrosecond " + sMicrosecond(a));
		echo("\tmillisecond " + sMillisecond(a));
		echo("\tnanosecond " + sNanosecond(a));
	}
}
