# ExpandableTableViewDataHelper

ExpandableTableViewDataHelper is an utility API to help easily making an expandable tableview. Providing only three required parameters, one can have a static expandable tableview (by static, the tableview is not editable). Those three parameters include:

  1. the maximum number of level the tableview can expand.
  2. the data source array in each section
  3. the level array list in each section
  
All those datas are passed through the delegation methods (sort of like the UITableviewDelegate protocol).

This API does not include any UI components as I thought which can provide more flexibility. With a tableview to init it with, one can customize the UI in a freedom way. 
## Getting Started

You can do either *pod* or *manual installation* as you like. 

### Cocoapod Installing

For anyone who is more confortable with cocoapod, just copy the following line into your podfile.

```
pod ExpandableTableViewDataHelper '~> 0.1.0'
```

Then run `pod install` as always.
### Manual Installation
For manual installation:

1) Clone this repo locally onto your computer, or press `Download ZIP` to download the latest master commit.

2) Drag the **ExpandableTableViewDataHelper** folder into your project.

### Added As A Static Library
For anyone who want to add it as a static library:
1) Clone this repo locally onto your computer, or press `Download ZIP` to download the latest master commit.
2) Select a **simulator** or an **iOS Device** as the scheme, and click **run**. You will have the lib in the **Supporting Files** folder. You then copy the .a lib from the **Finder** and copy to your project.
## How to use



### How to init

Provide a tableview with its designated method, while `-init` should be no longer used.
```
- (instancetype)initWithTableView:(UITableView *)tableView;
```
For example, you have a **UIViewController**, which contains a **UITableView** as its view's subview, then you instantiate your data manager as follows:
```
ExpandableTableViewDataHelper *dataManager = [[ExpandableTableViewDataHelper alloc] initWithTableView:yourTableView];
```

### Set the delegate
Once you have a **ExpandableTableViewDataHelper** instance, you should set its **delegate** immediately:
```
dataManager.delegate = someDelegate;
```
Now you should fill in the delegation methods as it asks:
```
- (NSArray *)dataArrayInSection:(NSInteger)section;
- (NSInteger)numberOfLevels;
- (NSArray *)levelArraysInSection:(NSInteger)section;
```

### How to expand the tableview
When **tableView:didSelectRowAtIndexPath:**, you simply call this method to do the expanding.
```
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
```


## Authors

* **Meng Pan** - *Initial work* - [mpan753](https://github.com/mpan753)

## License

This project is licensed under the MIT License - see the [LICENSE.md](https://github.com/mpan753/ExpandableTableViewDataHelper/blob/master/MIT%20License) file for details
