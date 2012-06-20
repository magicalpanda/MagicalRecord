//
//  MagicalFactory.m
//  MagicalRecord
//
//  Created by Saul Mora on 6/19/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalFactory.h"

static NSMutableDictionary *definedFactories;

@implementation MagicalFactory

+ (NSSet *) factories;
{
    return [NSSet setWithArray:[definedFactories allValues]];
}

+ (void) resetAll;
{
    [self setupFactories];
}

+ (void) setupFactories;
{
    definedFactories = [NSMutableDictionary dictionary];    
}

+ (void) initialize
{
    if (self == [MagicalFactory class])
    {
        [self setupFactories];
    }
}

+ (MRFactoryObject *) findFactoryWithName:(NSString *)factoryKey;
{
    @synchronized(self)
    {
        MRFactoryObject *factory = [definedFactories valueForKey:factoryKey];
//        if (factory == nil)
//        {
//            factory = [MRFactoryObjectDefinition factoryWithClass:NSClassFromString(factoryKey)];
//            [definedFactories setObject:factory forKey:factoryKey];
//        }
        return factory;
    }
}

+ (void) define:(id)stringOrClass do:(void(^)(id<MRFactoryObject>))configurationBlock;
{
    NSString *factoryKey = [stringOrClass isKindOfClass:[NSString class]] ? stringOrClass : NSStringFromClass(stringOrClass);
    MRFactoryObject *factory = [self findFactoryWithName:factoryKey];
    if (factory == nil)
    {
        factory = [MRFactoryObject factoryWithClass:NSClassFromString(factoryKey)];
        [definedFactories setObject:factory forKey:factoryKey];
    }
    
    if (configurationBlock)
    {
        configurationBlock(factory);
    }
}

+ (void) define:(id)stringOrClass as:(NSString *)alias do:(void (^)(id<MRFactoryObject>))configurationBlock;
{
    NSString *factoryKey = alias;
    MRFactoryObject *factory = [self findFactoryWithName:factoryKey];
    if (factory == nil)
    {
        factory = [MRFactoryObject factoryWithClass:stringOrClass as:factoryKey];
        [definedFactories setObject:factory forKey:factoryKey];
    }
    
    if (configurationBlock)
    {
        configurationBlock(factory);
    }
}

@end
