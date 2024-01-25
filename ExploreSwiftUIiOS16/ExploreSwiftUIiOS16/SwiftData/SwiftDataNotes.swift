links:
- https://www.swiftyplace.com/blog/modeling-data-in-swiftdata
- https://www.swiftyplace.com/swiftdata
- https://www.hackingwithswift.com/quick-start/swiftdata/how-to-optimize-the-performance-of-your-swiftdata-apps

/*
 Notes:
 
 Missing Features:
 SwiftData is in its first version and is thus missing quite a few features. Here is a list of what you might miss out on:
 
 - sectioned queries are not supported
 - limited support of predicates with relationships
 - predicate support for case insensitive text filtering
 - predicates with enum properties
 - to-many relationships do not keep their order
 - iCloud sync works only with a private database
 
 Limitations:
 - app crashes when you use redo enabled container and custom types or enums as properties
 - to-many relationships with iCloud sync need to be optional. You have to work with optional arrays
 - to-many relationships are defined as arrays to other model classes. This makes the impression that they keep their sort order, but this is not the case, and the array is returned in seemingly random order.
 - app crashes after data migrations
 
 
 -However, SwiftData is a new framework and comes with certain limitations and bugs that need to be ironed out. Yet, its core concept of providing a Swift-native and user-friendly persistence framework holds potential.
 */
