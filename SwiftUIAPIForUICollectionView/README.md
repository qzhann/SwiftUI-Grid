#  SwiftUI API For UICollectionView

This project creates a Flow struct, which creates a UICollectionView equivalent in SwiftUI.

### To Do: ###
1. Create different initializers for Flow.
2.



### Problems Encountered: ###
1. `Section` cannot be extended. We are thus using a custom `FlowSection` struct as a replacement.

2. Unable to know the **frame** at creation time of the collection view / collection view controller. How to resize?
    a. Wrap the Collection's view body inside of a Geometry Reader?
    
3. Unable to use NSDiffableDataSource directly for each Identifiable element.

4. Should we be using a UICollectionView or a UICollectionViewController? Because UICollectionViewController might be able to scale its own frame properly!



### Observations: ###
1. SwiftUI could be using an internal API that takes Identifiable objects instead of Hashable objects. This is very likely since the UIKit team only needs to change the collection diffing API in Swift Standard Library to perform diffing on Identifiable objects. The reason why UIKit is providing an API based on Hashable is probably for backward-compatibility purposes, so that people not using Swift 5 can also be using the diffable data source.

2. List is wrapping a UITableView inside of a SwiftUI View wrapper first, and then for each row, it wraps the SwiftUI row content inside of a UIHostingController to present each row.
