import myqual.Encrypted;

public class YourProgram {
	private final int OFFSET = 13;

	public @Encrypted String encrypt(String text) {
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

	void sendText(String plaintext) {
		// ...
		@Encrypted String ciphertext = encrypt(plaintext);
		sendOverInternet(ciphertext);
		// ...
	}

	void sendPassword() {
		String password = "a";
		sendText(password);
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
