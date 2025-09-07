import Foundation

// Sample data for phrases
struct SamplePhrases {
    static let all: [Phrase] = [
        // Office Greetings
        Phrase(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
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
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
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
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
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
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!,
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
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000005")!,
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
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000006")!,
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
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000007")!,
            kannadaText: "ಇಂದು ಏನು ಊಟವಾಗ್ತೀರಾ?",
            englishTranslation: "What did you have for lunch today?",
            phoneticPronunciation: "Indu enu ootavaagtheera?",
            audioFileName: "indu_enu_ootavaagtheera.mp3",
            category: .officeLunch,
            difficulty: .intermediate,
            isFavorite: false,
            masteryLevel: .new
        ),
        
        // Office Meetings
        Phrase(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000008")!,
            kannadaText: "ನಾವು ಮೀಟಿಂಗ್ ಪ್ರಾರಂಭಿಸೋಣ",
            englishTranslation: "Let's start the meeting",
            phoneticPronunciation: "Naavu meeting praarambhisona",
            audioFileName: "naavu_meeting_praarambhisona.mp3",
            category: .officeMeetings,
            difficulty: .intermediate,
            isFavorite: false,
            masteryLevel: .new
        ),
        Phrase(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000009")!,
            kannadaText: "ನಿಮ್ಮ ಅಭಿಪ್ರಾಯ ಏನು?",
            englishTranslation: "What is your opinion?",
            phoneticPronunciation: "Nimma abhipraaya enu?",
            audioFileName: "nimma_abhipraaya_enu.mp3",
            category: .officeMeetings,
            difficulty: .intermediate,
            isFavorite: false,
            masteryLevel: .new
        ),
        
        // Shopping
        Phrase(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000010")!,
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
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000011")!,
            kannadaText: "ಇದನ್ನು ತೋರಿಸಿ",
            englishTranslation: "Show me this",
            phoneticPronunciation: "Idannu torisi",
            audioFileName: "idannu_torisi.mp3",
            category: .shopping,
            difficulty: .beginner,
            isFavorite: false,
            masteryLevel: .new
        ),
        Phrase(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000012")!,
            kannadaText: "ನಾನು ಇದನ್ನು ಖರೀದಿಸುತ್ತೇನೆ",
            englishTranslation: "I'll buy this",
            phoneticPronunciation: "Naanu idannu khareedisuttene",
            audioFileName: "naanu_idannu_khareedisuttene.mp3",
            category: .shopping,
            difficulty: .beginner,
            isFavorite: false,
            masteryLevel: .new
        ),
        
        // Transportation
        Phrase(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000013")!,
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
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000014")!,
            kannadaText: "ಅಳ್ಳಿಯವರೆಗೆ ಎಷ್ಟು ದೂರ?",
            englishTranslation: "How far is it to the next stop?",
            phoneticPronunciation: "Alliyavarege eshtu doora?",
            audioFileName: "alliyavarege_eshtu_doora.mp3",
            category: .transportation,
            difficulty: .intermediate,
            isFavorite: false,
            masteryLevel: .new
        ),
        Phrase(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000015")!,
            kannadaText: "ನಾನು ಸ್ಟೇಶನ್‌ಗೆ ಹೋಗುತ್ತೇನೆ",
            englishTranslation: "I'm going to the station",
            phoneticPronunciation: "Naanu stationge hoguttene",
            audioFileName: "naanu_stationge_hoguttene.mp3",
            category: .transportation,
            difficulty: .beginner,
            isFavorite: false,
            masteryLevel: .new
        ),
        
        // Restaurants
        Phrase(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000016")!,
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
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000017")!,
            kannadaText: "ನಾನು ವೆಜಿಟೇರಿಯನ್ ಆಗಿದ್ದೇನೆ",
            englishTranslation: "I am vegetarian",
            phoneticPronunciation: "Naanu vegetarian agiddeene",
            audioFileName: "naanu_vegetarian_agiddeene.mp3",
            category: .restaurants,
            difficulty: .intermediate,
            isFavorite: false,
            masteryLevel: .new
        ),
        Phrase(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000018")!,
            kannadaText: "ಬಿಲ್ಲು ತೋರಿಸಿ",
            englishTranslation: "Show me the bill",
            phoneticPronunciation: "Billu torisi",
            audioFileName: "billu_torisi.mp3",
            category: .restaurants,
            difficulty: .beginner,
            isFavorite: false,
            masteryLevel: .new
        ),
        
        // Directions
        Phrase(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000019")!,
            kannadaText: "ನಿಮ್ಮ ಹೆಸರು ಏನು?",
            englishTranslation: "What is your name?",
            phoneticPronunciation: "Nimma hesaru enu?",
            audioFileName: "nimma_hesaru_enu.mp3",
            category: .directions,
            difficulty: .beginner,
            isFavorite: false,
            masteryLevel: .new
        ),
        Phrase(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000020")!,
            kannadaText: "ನಾನು ಸ್ವಲ್ಪ ಸಮಯ ಮಾತನಾಡಬಯಸುತ್ತೇನೆ",
            englishTranslation: "I'd like to speak for a few minutes",
            phoneticPronunciation: "Naanu swalpa samaya maatanaadaboyasuttene",
            audioFileName: "naanu_swalpa_samaya_maatanaadaboyasuttene.mp3",
            category: .directions,
            difficulty: .intermediate,
            isFavorite: false,
            masteryLevel: .new
        )
    ]
    
    // Sample collections
    static let sampleCollections: [PhraseCollection] = [
        PhraseCollection(
            id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
            name: "Office Essentials",
            phraseIds: [
                "00000000-0000-0000-0000-000000000001", // Namaskara
                "00000000-0000-0000-0000-000000000002", // Shubhodaya
                "00000000-0000-0000-0000-000000000004", // Eege iddeera?
                "00000000-0000-0000-0000-000000000005", // Dhanyavaadagalu
                "00000000-0000-0000-0000-000000000006"  // Ootakke hogona
            ],
            createdDate: Date(),
            updatedDate: Date()
        ),
        PhraseCollection(
            id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!,
            name: "Shopping Basics",
            phraseIds: [
                "00000000-0000-0000-0000-000000000010", // Eshṭu bele?
                "00000000-0000-0000-0000-000000000011", // Idannu torisi
                "00000000-0000-0000-0000-000000000012"  // Naanu idannu khareedisuttene
            ],
            createdDate: Date(),
            updatedDate: Date()
        )
    ]
}