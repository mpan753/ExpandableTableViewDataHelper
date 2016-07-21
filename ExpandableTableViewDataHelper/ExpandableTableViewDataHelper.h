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

- (NSArray * _Nullable)dataArrayInSection:(NSInteger)section;
- (NSInteger)numberOfLevels;
- (NSArray *_Nullable)levelArraysInSection:(NSInteger)section;

@optional

- (UITableViewRowAnimation)tableViewRownAnimationInSection:(NSInteger)section;

@end

@interface ExpandableTableViewDataHelper : NSObject

@property (nonatomic, weak) id<ExpandableDataHelperDelegate> _Nullable delegate;
@property (nonatomic, strong, readonly) UITableView * _Nullable tableView;

- (instancetype _Nullable)initWithTableView:(UITableView * _Nullable )tableView NS_DESIGNATED_INITIALIZER;

- (void)reloadData;
- (void)reloadDataInSection:(NSInteger)section;

- (NSInteger)numberOfRowsInsection:(NSInteger)section;
- (id _Nullable)objectAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;

- (NSInteger)levelForObjectAtIndexPath:(NSIndexPath * _Nonnull)indexPath;


@end
