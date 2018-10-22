# FlickrGallery
Simple Flickr Gallery with Search Functionality

Architecture: The project uses MVC pattern for coding. As the project was fairly simple MVC pattern suits it best. If focus is on auomation more specially unit tests then MVVM + C architecture would be good and for more serious automation testing VIPER architecture could be choosen. Give the time same project can migrated to these patterns as well.

Class Diagram:
FlickrSearchViewController: This is the main view controller which controls home screen where user can search and display images
API.swift: This is wrapper class to  Network call. This centralises all APIs to one common place under API namespace. There are many advantages of having central place for API call. This also contains APIFetchRequest protocol which could be used to inherit any future APIs and simplyfy the to coding to many fold.
ImageDonwaloadManager: This is singleton manager for images download from server. It does maintains progressing downloads and cancels the unsed requests. This class also caches the images for faster user experience.
FlickrSearchResponseModel: This is model class for Flickr API response and it does convert JSON to Object and vice versa using Codable protocol

