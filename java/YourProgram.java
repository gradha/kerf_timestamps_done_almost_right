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

	public static void main(String[] args) {
		System.out.println("Hello World");
	}
}
