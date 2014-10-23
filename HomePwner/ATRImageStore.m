//
//  ATRImageStore.m
//  HomePwner
//
//  Created by Leonard Bogdonoff on 10/23/14.
//  Copyright (c) 2014 New Public Art Foundation. All rights reserved.
//

#import "ATRImageStore.h"

@interface ATRImageStore()

@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation ATRImageStore

+ (instancetype)sharedStore
{
    static ATRImageStore *sharedStore;
    
    if(!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

// No one should call nit
- (instancetype)init
{
    [NSException raise:@"Singleton"
                format:@"Ise +[ATRImageStore sharedStore]"];
    return nil;
}

//Secret designated initializer
- (instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    self.dictionary[key] = image;
}

- (UIImage *)imageForKey:(NSString *)key
{
    return self.dictionary[key];
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    
    [self.dictionary removeObjectForKey:key];
}

@end
