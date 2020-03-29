#  SwiftUI API For UICollectionView

This project creates a Flow struct, which creates a UICollectionView equivalent in SwiftUI.

### To Do: ###
1. Parse cellContent to allow SwiftUI view to be displayed in each collection view cell.
2. Allow .frame(width:height) modifier to be used on each cell in a step 1.
3. Create different initializers for Flow. Allow Flow to contain ForEach and FlowSection.
4. Allow .frame(width:height:) modifier to be modified on each cell / ForEach / FlowSection.
5. Allow Flow to dynamically handle data changes: fluid content changing handling



### Problems Encountered: ###
1. `Section` cannot be extended. We are thus using a custom `FlowSection` struct as a replacement.

2. Unable to use NSDiffableDataSource directly for each Identifiable element.

3. UICollectionViewCell probably has incorrect sizing information when dequeued. 


### Observations on the Frameworks: ###
1. SwiftUI could be using an internal API that takes Identifiable objects instead of Hashable objects. This is very likely since the UIKit team only needs to change the collection diffing API in Swift Standard Library to perform diffing on Identifiable objects. The reason why UIKit is providing an API based on Hashable is probably for backward-compatibility purposes, so that people not using Swift 5 can also be using the diffable data source.

2. List is wrapping a UITableView inside of a SwiftUI View wrapper first, and then for each row, it wraps the SwiftUI row content inside of a UIHostingController to present each row.

3. Collection view resizes itself correctly. Why? Is it because of the autoresizing mask?

4. To allow data source diffing to occur when the data (@State) passed into Flow changes, DynamicViewContent protocol probably, under the hood, instead of rerendering the entire View, calls the respective diffing functions to make changes instead of rerendering.

5. CompositionalLayout's .fractional() usage has a problem - because the screen width might not be divisible by 2 or 5, each collection view cell tries approximate using a decimal. However, since the collection view needs to span across the width / height, it actually leaves some gaps in between the cells in some .fractional() values. The sample code may have tries to cover this up by using borders around each cell. However, as long as the background color for the collection view and the background color for each cell are the same, this is not noticable, but can become a problem if the cellContent spans the entire cell's view frame.
