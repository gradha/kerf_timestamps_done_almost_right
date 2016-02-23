import org.checkerframework.framework.qual.*;        // for DefaultQualifier[s]
import myqual.Encrypted;
import myqual.NotEncrypted;

public class YourProgram {
	private final int OFFSET = 13;

	public @Encrypted String encrypt(@NotEncrypted String text) {
		@Encrypted String encryptedText = new @Encrypted String();
		for (char character : text.toCharArray()) {
			encryptedText += encryptCharacter(character);
		}
		return encryptedText;
	}

	@SuppressWarnings("encrypted")
	private @Encrypted char encryptCharacter(char character) {
		@Encrypted int encryptInt = (character + OFFSET) % Character.MAX_VALUE;
		return (@Encrypted char) encryptInt;
	}


	// Only send encrypted data!
	public void sendOverInternet(@Encrypted String msg) {
		// ...
	}

	void sendText(@NotEncrypted String plaintext) {
		// ...
		@Encrypted String ciphertext = encrypt(plaintext);
		sendOverInternet(ciphertext);
		// ...
	}

	void sendPassword() {
		@NotEncrypted String password = (@NotEncrypted String)"a";
		sendText(password);
		//sendText("wrong");
	}

	static void normalInts(int x) {
		System.out.println("Normal int " + x);
	}

	static void encryptedInts(@Encrypted int x) {
		System.out.println("encrypted int " + x);
	}

	public static void main(String[] args) {
		@Encrypted String test = (@Encrypted String) "Hello World";
		System.out.println(test);
		@Encrypted int num = (@Encrypted int)42;
		int plainNum = 3;
		normalInts(num);
		encryptedInts(num);
		normalInts(plainNum);
		encryptedInts((@Encrypted int)plainNum);
	}
}
