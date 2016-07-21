//
//  ExpandableCellModel.m
//  ExpandableTableView
//
//  Created by Mia on 7/11/16.
//  Copyright © 2016 Mia. All rights reserved.
//

#import "ExpandableCellModel.h"

@implementation ExpandableCellModel

- (instancetype)initWithContent:(id)content level:(NSInteger)level {
    if (self = [super init]) {
        self.level = level;
        self.content = content;
        self.subLevelNodes = [@[] mutableCopy];
        
    }
    return self;
}

- (instancetype)init {
    if (self = [self initWithContent:nil level:-1]) {
        
    }
    return self;
}

- (void)setSuperLevelNode:(ExpandableCellModel *)superLevelNode {
    _superLevelNode = superLevelNode;
    [_superLevelNode.subLevelNodes addObject:self];
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    for (ExpandableCellModel *subModel in self.subLevelNodes) {
        subModel.isVisible = _isSelected;
    }
}

- (void)setIsVisible:(BOOL)isVisible {
    _isVisible = isVisible;
    
    // ignore section node
    if (!self.level) {
        return;
    }
    // set all subNodes's isVisible
    if (!isVisible) {
        for (ExpandableCellModel *subModel in self.subLevelNodes) {
            subModel.isVisible = isVisible;
        }
    }
}

@end
