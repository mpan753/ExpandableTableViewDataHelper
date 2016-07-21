//
//  ExpandableCellModel.h
//  ExpandableTableView
//
//  Created by Mia on 7/11/16.
//  Copyright © 2016 Mia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpandableCellModel : NSObject

@property (nonatomic, strong) id content;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, strong) ExpandableCellModel *superLevelNode;
@property (nonatomic, strong) NSMutableArray *subLevelNodes;

@property (nonatomic, assign) BOOL isExpandable;
@property (nonatomic, assign) BOOL isVisible;
@property (nonatomic, assign) BOOL isSelected;

- (instancetype)initWithContent:(id)content level:(NSInteger)level NS_DESIGNATED_INITIALIZER;

@end
