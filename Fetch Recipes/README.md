### Steps to Run the App
    1. Clone the repository: git clone <repository-url>
    2. Open the project in Xcode: Ensure you have the latest version of Xcode installed.
    3. Build and run the project: Select a simulator or a connected device. Press Cmd + R to run.

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
    Networking Layer:

    * Developed a reusable and decodable-friendly NetworkManager to handle API requests efficiently. 
        - Ensured clear separation of concerns by splitting the networking and image download logic into protocols (DataTaskDownloadable and ImageDownloadable).
    
    * Image Caching:

        - Implemented an efficient ImageCacheService using both in-memory caching (NSCache) and disk storage to optimize performance and reduce redundant network calls.
    
        - Prioritized caching for frequently accessed images to improve user experience.

    * Modularity and Testability:

        - Focused on creating a well-structured, modular architecture to facilitate unit testing.
        - Added mock implementations for services like NetworkManager and ImageFileStorage to test networking and caching functionalities independently.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
    * Planning and Architecture Design: ~0.5 hour
    * Networking Implementation: ~0.25 hour
    * Image Caching Implementation: ~1 hour
    * ViewModel Integration and Data Flow: ~0.5 hour
    * Unit Testing: ~0.5 hour
    * UI Implemenattion: ~2 hours
    * Total Time Spent: ~4.75 hours

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
    * Limited UI Enhancements:

        - Focused on the core functionality (networking, caching, and ViewModel logic) rather than creating a polished UI to save time.
        - This approach allowed for a cleaner demonstration of backend and architectural design.

### Weakest Part of the Project: What do you think is the weakest part of your project?
    * I did not use Swift UI nor I used latest concurrency introduced by apple!

### External Code and Dependencies: Did you use any external code, libraries, or dependencies?
    * No external libraries were used. The project relies on native APIs such as URLSession, NSCache, and Codable.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
    
    * The project was built to demonstrate clean code principles, including:
        - Decoupled services with protocols.
        - Dependency injection for easier testing.
        - Async-safe methods for UI updates.

    * Constraints:
        - Simulated network and caching behaviors using mock objects during unit testing.
        - Optimized for learning and demonstrating architecture, not production use.
