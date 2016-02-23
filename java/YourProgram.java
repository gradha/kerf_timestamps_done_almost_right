import myqual.Nano;
import myqual.Plain;

@SuppressWarnings("cast.unsafe")
public class YourProgram
{
	static void normalLongs(long x) {
		System.out.println("Normal long " + x);
	}

	static void nanoLong(@Nano long x) {
		@Nano long y = x * (@Nano long) 3;
		System.out.println("nanoed long " + y);
	}

	public static void main(String[] args) {
		@Nano long num = (@Nano long)42;
		long plainNum = 3l;
		//normalLongs(num);
		nanoLong(num);
		normalLongs(plainNum);
		nanoLong((@Nano long)plainNum);
	}
}
