//
//  ExpandableTableViewDataHelper.h
//  ExpandableTableViewDataHelper
//
//  Created by Mia on 7/15/16.
//  Copyright © 2016 Mia. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MPInsertionPositionOption) {
    MPInsertionPositionOptionTop = 0,
    MPInsertionPositionOptionBottom = 1
};

@protocol ExpandableDataHelperDelegate <NSObject>

@required

- (NSArray * _Nullable)dataArrayInSection:(NSInteger)section; // data array list: @[AnyObject] array. e.g. [NSString, SomeObject...]
- (NSInteger)numberOfLevels; // maximum level in the tableview
- (NSArray *_Nullable)levelArraysInSection:(NSInteger)section; // level array of the data array list, start from 1. e.g. @[1,2,3,1,2], the correctness of the level array will be checked when build up the inner data structure, which is a tree, BTW

@optional

- (UITableViewRowAnimation)tableViewRowAnimationInSection:(NSInteger)section; // the animation when doing expanding.

@end

@interface ExpandableTableViewDataHelper : NSObject

@property (nonatomic, weak) id<ExpandableDataHelperDelegate> _Nullable delegate;
@property (nonatomic, strong, readonly) UITableView * _Nullable tableView; // the tableview that init with

- (instancetype _Nullable)initWithTableView:(UITableView * _Nullable )tableView NS_DESIGNATED_INITIALIZER;

- (void)reloadData; // re-generate the data structure of the provided dara array list, which in return will reset all expanded cell but the level-1 cell as folded status
- (void)reloadDataInSection:(NSInteger)section; // same as reloadDate, but only will affect data array in a section

- (NSInteger)numberOfRowsInSection:(NSInteger)section; // return the number, including all hidden data
- (id _Nullable)objectAtIndexPath:(NSIndexPath * _Nonnull)indexPath; // can be used in cellForRow, to obtain the dataSource
- (void)didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath; // the selector to do the expansion

- (NSInteger)levelForObjectAtIndexPath:(NSIndexPath * _Nonnull)indexPath; // obtain the level of an object at that indexPath


@end
