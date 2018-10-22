# FlickrGallery
Simple Flickr Gallery with Search Functionality

Architecture: 
The project uses MVC architecture. As the project is fairly simple MVC pattern suits it best. If focus is on automation tests then MVVM + C architecture would be good and for even more serious automation testing VIPER architecture could be choosen and can be implemented. Given the time same project can migrated to these architectures as well.

Class Diagram:
- FlickrSearchViewController: This is the main view controller which controls home screen where user can search and display images
- API.swift: This is wrapper class to  Network call. This centralises all APIs to one common place under API namespace. There are many advantages of having central place for API call. This also contains APIFetchRequest protocol which could be used to inherit any future APIs and simplyfy the to coding to many fold.
- ImageDonwaloadManager: This is singleton manager for images download from server. It does maintains progressing downloads and cancels the unsed requests. This class also caches the images for faster user experience.
- FlickrSearchResponseModel: This is model class for Flickr API response and it does convert JSON to Object and vice versa using Codable protocol

Unit Tests:
- Tests for models parses JSON data accurately for valid datas and doen't parses invalid JSON
- Tests for pagination implementation
- Tests collection view binding and view outlet properly connected

UI Tests:
- Tests for UI proper working, searching working, scrolling working

TradeOffs:
- Same project could be done in MVVM + C or VIPER architecture which would give more coverage for TESTS
- Image caching could be further optimized
- API layer could be further enhanced
