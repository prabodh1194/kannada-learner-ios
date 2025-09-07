import Foundation

// Sample data for phrases
struct SamplePhrases {
    static let all: [Phrase] = [
        // Office Greetings
        Phrase(
            kannadaText: "ನಮಸ್ಕಾರ",
            englishTranslation: "Hello / Good morning",
            phoneticPronunciation: "Namaskara",
            audioFileName: "namaskara.mp3",
            category: .officeGreetings,
            difficulty: .beginner,
            isFavorite: false,
            masteryLevel: .new
        ),
        Phrase(
            kannadaText: "ಶುಭೋದಯ",
            englishTranslation: "Good morning",
            phoneticPronunciation: "Shubhodaya",
            audioFileName: "shubhodaya.mp3",
            category: .officeGreetings,
            difficulty: .beginner,
            isFavorite: false,
            masteryLevel: .new
        ),
        Phrase(
            kannadaText: "ಶುಭ ಸಂಜೆ",
            englishTranslation: "Good evening",
            phoneticPronunciation: "Shubha Sanje",
            audioFileName: "shubha_sanje.mp3",
            category: .officeGreetings,
            difficulty: .beginner,
            isFavorite: false,
            masteryLevel: .new
        ),
        Phrase(
            kannadaText: "ಏಗೆ ಇದ್ದೀರಾ?",
            englishTranslation: "How are you?",
            phoneticPronunciation: "Eege iddeera?",
            audioFileName: "eege_iddeera.mp3",
            category: .officeGreetings,
            difficulty: .beginner,
            isFavorite: false,
            masteryLevel: .new
        ),
        Phrase(
            kannadaText: "ಧನ್ಯವಾದಗಳು",
            englishTranslation: "Thank you",
            phoneticPronunciation: "Dhanyavaadagalu",
            audioFileName: "dhanyavaadagalu.mp3",
            category: .officeGreetings,
            difficulty: .beginner,
            isFavorite: false,
            masteryLevel: .new
        ),
        
        // Office Lunch
        Phrase(
            kannadaText: "ಊಟಕ್ಕೆ ಹೋಗೋಣ",
            englishTranslation: "Let's go for lunch",
            phoneticPronunciation: "Ootakke hogona",
            audioFileName: "ootakke_hogona.mp3",
            category: .officeLunch,
            difficulty: .intermediate,
            isFavorite: false,
            masteryLevel: .new
        ),
        Phrase(
            kannadaText: "ಇಂದು ಏನು ಊಟವಾಗ್ತೀರಾ?",
            englishTranslation: "What did you have for lunch today?",
            phoneticPronunciation: "Indu enu ootavaagtheera?",
            audioFileName: "indu_enu_ootavaagtheera.mp3",
            category: .officeLunch,
            difficulty: .intermediate,
            isFavorite: false,
            masteryLevel: .new
        ),
        
        // Shopping
        Phrase(
            kannadaText: "ಎಷ್ಟು ಬೆಲೆ?",
            englishTranslation: "How much is the price?",
            phoneticPronunciation: "Eshṭu bele?",
            audioFileName: "eshṭu_belee.mp3",
            category: .shopping,
            difficulty: .beginner,
            isFavorite: false,
            masteryLevel: .new
        ),
        Phrase(
            kannadaText: "ಇದನ್ನು ತೋರಿಸಿ",
            englishTranslation: "Show me this",
            phoneticPronunciation: "Idannu torisi",
            audioFileName: "idannu_torisi.mp3",
            category: .shopping,
            difficulty: .beginner,
            isFavorite: false,
            masteryLevel: .new
        ),
        
        // Transportation
        Phrase(
            kannadaText: "ಬಸ್ ಸ್ಟಾಪ್ ಎಲ್ಲಿದೆ?",
            englishTranslation: "Where is the bus stop?",
            phoneticPronunciation: "Bus stop yelliade?",
            audioFileName: "bus_stop_yelliade.mp3",
            category: .transportation,
            difficulty: .beginner,
            isFavorite: false,
            masteryLevel: .new
        ),
        Phrase(
            kannadaText: "ಅಳ್ಳಿಯವರೆಗೆ ಎಷ್ಟು ದೂರ?",
            englishTranslation: "How far is it to the next stop?",
            phoneticPronunciation: "Alliyavarege eshtu doora?",
            audioFileName: "alliyavarege_eshtu_doora.mp3",
            category: .transportation,
            difficulty: .intermediate,
            isFavorite: false,
            masteryLevel: .new
        ),
        
        // Restaurants
        Phrase(
            kannadaText: "ಮೆನು ತೋರಿಸಿ",
            englishTranslation: "Show me the menu",
            phoneticPronunciation: "Menu torisi",
            audioFileName: "menu_torisi.mp3",
            category: .restaurants,
            difficulty: .beginner,
            isFavorite: false,
            masteryLevel: .new
        ),
        Phrase(
            kannadaText: "ನಾನು ವೆಜಿಟೇರಿಯನ್ ಆಗಿದ್ದೇನೆ",
            englishTranslation: "I am vegetarian",
            phoneticPronunciation: "Naanu vegetarian agiddeene",
            audioFileName: "naanu_vegetarian_agiddeene.mp3",
            category: .restaurants,
            difficulty: .intermediate,
            isFavorite: false,
            masteryLevel: .new
        )
    ]
}