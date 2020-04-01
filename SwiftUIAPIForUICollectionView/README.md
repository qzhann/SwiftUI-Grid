#  SwiftUI API For UICollectionView

This project creates a Flow struct, which creates a UICollectionView equivalent in SwiftUI.

### To Do: ###
1. Create different initializers for Flow. Allow Flow to contain ForEach and FlowSection.
2. Allow .frame(width:height:) modifier to be modified on each cell / ForEach / FlowSection.
3. Allow Flow to dynamically handle data changes: fluid content changing handling



### Problems Encountered: ###
1. `Section` cannot be extended. We are thus using a custom `FlowSection` struct as a replacement.

2. Swift Generics does not allow us to extend an existing protocol. We are thus unable to use NSDiffableDataSource directly for each Identifiable element. We are also unable to interpret the CellContent as our custom protocol, so that instead of effectively using generics, we have to do a dynamic cast to see whether it is a FlowItem that has width and height dimensions specified, and then modifify the collectionview layout on the fly.

3. UIHostingController is not always laying out its SwiftUI view with the correct size. If we scroll the collectionview too quickly, the UIHostingController will have its managed view at a correct size, but its underlying SwiftUI view does NOT occupy the entire view frame. (We can reveal this bug by setting the hostingController's view's background color, and have the cell content be a SwiftUIView with a flexible frame that streches on both width and height.) This probably have something to do with how Compositional Layout is working: maybe it is first initializing the frame at a different estimate, and then auto layout / frame resetting comes.

4. Xcode Preview is not doing dynamic casting correctly. Thus, we are unable to preview the .frame(width:height:) modifier correctly. But you see a flicker of the correctly view first, and then the wrong view again. Why?


### Observations on the Frameworks: ###
1. SwiftUI could be using an internal API that takes Identifiable objects instead of Hashable objects. This is very likely since the UIKit team only needs to change the collection diffing API in Swift Standard Library to perform diffing on Identifiable objects. The reason why UIKit is providing an API based on Hashable is probably for backward-compatibility purposes, so that people not using Swift 5 can also be using the diffable data source.

2. List is wrapping a UITableView inside of a SwiftUI View wrapper first, and then for each row, it wraps the SwiftUI row content inside of a UIHostingController to present each row.

3. Collection view resizes itself correctly. Why? Is it because of the autoresizing mask?

4. To allow data source diffing to occur when the data (@State) passed into Flow changes, DynamicViewContent protocol probably, under the hood, instead of rerendering the entire View, calls the respective diffing functions to make changes instead of rerendering.

5. CompositionalLayout's .fractional() usage has a problem - because the screen width might not be divisible by 2 or 5, each collection view cell tries approximate using a decimal. However, since the collection view needs to span across the width / height, it actually leaves some gaps in between the cells in some .fractional() values. The sample code may have tries to cover this up by using borders around each cell. However, as long as the background color for the collection view and the background color for each cell are the same, this is not noticable, but can become a problem if the cellContent spans the entire cell's view frame.
