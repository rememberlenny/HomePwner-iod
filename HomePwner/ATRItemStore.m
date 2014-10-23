//
//  ATRItemStore.m
//  HomePwner
//
//  Created by Leonard Bogdonoff on 10/22/14.
//  Copyright (c) 2014 New Public Art Foundation. All rights reserved.
//

#import "ATRItem.h"
#import "ATRItemStore.h"

@interface ATRItemStore ()

@property (nonatomic) NSMutableArray *privateItems;

@end

@implementation ATRItemStore

+ (instancetype)sharedStore
{
    static ATRItemStore *sharedStore;
    
    // Do I need to create a sharedStore?
    if(!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

// If a programmer calls [[ATRItemStore alloc] init], let him
// know the error of his ways
- (instancetype)init
{
    [NSException raise:@"Singleton"
                format:@"Use +[ATRItemStore sharedStore]"];
    return nil;
}
     
- (instancetype)initPrivate
{
    self = [super init];
    if(self) {
        _privateItems = [[NSMutableArray alloc] init];
    }
    
    
    return self;
}

- (void)removeItem:(ATRItem *)item
{
    [self.privateItems removeObjectIdenticalTo:item];
}

- (NSArray *)allItems
{
    return [self.privateItems copy];
}

- (ATRItem *)createItem
{
    ATRItem *item = [ATRItem randomItem];
    [self.privateItems addObject:item];
    
    return item;
}

@end
