//
//  ExpandableTableViewDataHelper.m
//  ExpandableTableViewDataHelper
//
//  Created by Mia on 7/15/16.
//  Copyright © 2016 Mia. All rights reserved.
//

#import "ExpandableTableViewDataHelper.h"
#import "ExpandableCellModel.h"

@interface ExpandableTableViewDataHelper ()
{
    UITableView *privateTableView;
}
@property (nonatomic, strong) NSMutableArray <NSMutableArray <ExpandableCellModel *> *> *sections;
@property (nonatomic, strong) NSArray *lastArray;
@property (nonatomic, assign) BOOL isRowAnimationSet;
@property (nonatomic, assign) NSInteger numberOfSections;

@end

@implementation ExpandableTableViewDataHelper

- (instancetype)initWithTableView:(UITableView *)tableView {
    if (self = [super init]) {
        privateTableView = tableView;
        self.numberOfSections = 1;
    }
    return self;
}

- (instancetype)init {
    if (self = [self initWithTableView:nil]) {
    }
    return self;
}

- (void)setDelegate:(id<ExpandableDataHelperDelegate>)delegate {
    _delegate = delegate;
    if (self.tableView) {
        self.numberOfSections = [self.tableView numberOfSections];
    }
    
    self.isRowAnimationSet = NO;
    if ([_delegate respondsToSelector:@selector(tableViewRownAnimationInSection:)]) {
        self.isRowAnimationSet = YES;
    }
    
    [self clearSections];
    
    for (int i = 0; i < self.numberOfSections; i++) {
        [self buildLevelTreeforSection:i];
    }
}

- (UITableView *)tableView {
    return privateTableView;
}

- (void)clearSections {
    self.sections = [@[] mutableCopy];
    for (int i = 0; i < self.numberOfSections; i++) {
        [self.sections addObject:[@[] mutableCopy]];
    }
}

- (void)resetSection:(NSInteger)section {
    
    self.sections[section] = [@[] mutableCopy];
}

- (void)buildLevelTreeforSection:(NSInteger)section {
    [self resetSection:section];
    
    NSArray *dataArray = [self.delegate dataArrayInSection:section];
    if (!dataArray || !dataArray.count) {
        NSLog(@"Empty data list");
        return;
    }
    
    [self isLevelSettingCorrectInSection:section];
    
    self.lastArray = dataArray; // first laoding
    
    ExpandableCellModel *root = [[ExpandableCellModel alloc] initWithContent:[NSString stringWithFormat:@"Section-%@", @(section)] level:0];
    
    ExpandableCellModel *curNode = root;
    NSInteger curLevel = root.level;
    NSArray *levelArray = [self.delegate levelArraysInSection:section];
    for (int i = 0; i < dataArray.count; i++) {
        id content = dataArray[i];
        ExpandableCellModel *model = [[ExpandableCellModel alloc] initWithContent:content level:[levelArray[i] integerValue]];
        [self configureExpandableSettingForModel:model];
        
        [self.sections[section] insertObject:model atIndex:i];
        
        if (model.level - curLevel == 1) {
            model.superLevelNode = curNode;
        } else if (model.level - curLevel == 0) {
            model.superLevelNode = curNode.superLevelNode;
        } else {
            ExpandableCellModel *parent = curNode;
            while (model.level - parent.level < 0) {
                parent = parent.superLevelNode;
            }
            model.superLevelNode = parent.superLevelNode;
        }
        curNode = model;
        curLevel = curNode.level;
    }
}

- (BOOL)isLevelSettingCorrectInSection:(NSInteger)section {
    
    NSArray *levelArray = [self.delegate levelArraysInSection:section];
    if (!levelArray) {
        @throw [NSException exceptionWithName:@"None level array setting" reason:[NSString stringWithFormat:@"The level array is nil in section %@", @(section)] userInfo:nil];
        return NO;
    }
    
    NSInteger curLevel = 0;
    
    for (NSNumber *level in levelArray) {
        if (level.integerValue <= 0 || level.integerValue - curLevel > 1) {
            @throw [NSException exceptionWithName:@"Wrong level setting" reason:[NSString stringWithFormat:@"Level array setting in section %@ is not correct.", @(section)] userInfo:nil];
            return NO;
        }
        
        curLevel = level.integerValue;
        
    }
    return YES;
}

- (void)configureExpandableSettingForModel:(ExpandableCellModel *)model {
    
    if (model.level == 0) {
        model.isVisible = NO;
        model.isExpandable = NO;
        model.isSelected = NO;
    }
    
    model.isSelected = NO;
    if (model.level == [self.delegate numberOfLevels]) {
        model.isExpandable = NO;
    } else {
        model.isExpandable = YES;
    }
    
    if (model.level == 1) {
        model.isVisible = YES;
    } else {
        model.isVisible = NO;
    }
    
}

- (void)reloadData {
    for (int i = 0; i < self.numberOfSections; i++) {
        [self reloadDataInSection:i];
    }
    [self.tableView reloadData];
}

- (void)reloadDataInSection:(NSInteger)section {
    [self buildLevelTreeforSection:section];
}

- (NSInteger)numberOfRowsInsection:(NSInteger)section {
    
    NSArray *arrayForSection = self.sections[section];
    if (!arrayForSection || !arrayForSection.count) {
        NSLog(@"No data in section: %@", @(section));
        return 0;
    }
    
    NSInteger count = 0;
    
    for (ExpandableCellModel *model in arrayForSection) {
        count += model.isVisible ? 1 : 0;
    }
    return count;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    
    return [[self expandableObjectAtIndexPath:indexPath] content];
    
}

- (ExpandableCellModel *)expandableObjectAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arrayInSection = self.sections[indexPath.section];
    
    if (!arrayInSection || !arrayInSection.count) {
        NSLog(@"No data in section: %@", @(indexPath.section));
        return nil;
    }
    NSInteger count = 0;
    for (ExpandableCellModel *model in arrayInSection) {
        count+= model.isVisible ? 1 : 0;
        if (count == indexPath.row + 1) {
            return model;
        }
    }
    return nil;
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ExpandableCellModel *model = [self expandableObjectAtIndexPath:indexPath];
    model.isSelected = !model.isSelected;
    UITableViewRowAnimation rowAnimation = self.isRowAnimationSet ? [self.delegate tableViewRownAnimationInSection:indexPath.section] : UITableViewRowAnimationAutomatic;
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:rowAnimation];
}

- (void)insertDataList:(NSArray *)dataList withLevelArrays:(NSArray *)levelArray inSection:(NSInteger)section atIndexes:(NSIndexSet *)indexes {
    if (dataList.count != levelArray.count) {
        [NSException exceptionWithName:@"Unmatchable dataList with its level array." reason:@"The number of dataList and its levelarray does not match" userInfo:nil];
    }
    
    NSMutableArray *newLevelArray = [self.delegate levelArraysInSection:section].mutableCopy;
    NSLog(@"oldLevelArray: %@", newLevelArray.description);
    [newLevelArray insertObjects:levelArray atIndexes:indexes];
    
    [self isLevelSettingCorrectInSection:section];
    
    NSLog(@"newLevelArray: %@", newLevelArray.description);
}

- (NSInteger)levelForObjectAtIndexPath:(NSIndexPath *)indexPath {
    return [[self expandableObjectAtIndexPath:indexPath] level];
}

- (void)insertSameLevelObject:(id)object aboveObjectAtIndexPath:(NSIndexPath *)indexPath animationOption:(UITableViewRowAnimation)animationOption {
    
}

- (void)insertSameLevelObject:(id)object belowObjectAtIndexPath:(NSIndexPath *)indexPath animationOption:(UITableViewRowAnimation)animationOption {
    
}

- (void)addSubLevelObject:(id)object toObjectAtIndexPath:(NSIndexPath *)indexPath insertionPositionOption:(MPInsertionPositionOption)option animationOption:(UITableViewRowAnimation)animationOption {
    ExpandableCellModel *model = [self expandableObjectAtIndexPath:indexPath];
    NSInteger level = model.level;
    if (level + 1 > [self.delegate numberOfLevels]) {
        NSLog(@"The Maximum number of level has been reached!");
        return;
    }
    ExpandableCellModel *addedModel = [[ExpandableCellModel alloc] initWithContent:object level:level + 1];
    [self configureExpandableSettingForModel:addedModel];
    addedModel.superLevelNode = model;
    NSMutableArray *dataArray = self.sections[indexPath.section];
    NSInteger index = [dataArray indexOfObject:model];
    if (option == MPInsertionPositionOptionTop) {
        [dataArray insertObject:addedModel atIndex:index+1];
    } else {
        [dataArray insertObject:addedModel atIndex:index+model.subLevelNodes.count];
    }
    
    // make all its subNode to be visible
    model.isSelected = YES;
    
    // make ths isVisible the same as its superNode's expanded status
    //    addedModel.isVisible = model.isSelected;
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:animationOption];
}

- (void)addTopLevelObjects:(NSArray *)objects toEndOfSection:(NSInteger)section {
    
}

@end
