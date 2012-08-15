//
//  NSManagedObject+MagicalDynamic.m
//  Magical Record
//
//  Created by Evan Cordell on 6/23/12.
//  Copyright (c) 2012 Evan Cordell. All rights reserved.
//

#import "NSManagedObject+MagicalDynamic.h"

static id dynamicFindBy(id self, SEL _cmd, NSString *string);
static id dynamicFindAllBy(id self, SEL _cmd, NSString *string);
static BOOL dynamicHas(id self, SEL _cmd);

@implementation NSManagedObject (Dynamic)

+ (BOOL) swizzledResolveClassMethod:(SEL)aSEL
{
    Class selfMetaClass = objc_getMetaClass([NSStringFromClass([self class]) UTF8String]);
    NSString *methodName = [NSString stringWithUTF8String:sel_getName(aSEL)];
    
    if ([methodName hasPrefix:@"findBy"]) {
        class_addMethod(selfMetaClass, sel_registerName([methodName UTF8String]), (IMP) dynamicFindBy, "@@:@");
        return YES;
    } else if ([methodName hasPrefix:@"findAllBy"]) {
        class_addMethod(selfMetaClass, sel_registerName([methodName UTF8String]), (IMP) dynamicFindAllBy, "@@:@");
        return YES;
    }
    
    //We only get here if an unknown method is called that doesn't start with our defined prefixes.
    //This actually calls the *original* resolveClassMethod    
    return [self swizzledResolveClassMethod:aSEL];
}

+ (BOOL)swizzledResolveInstanceMethod:(SEL)aSEL {
    NSString *methodName = [NSString stringWithUTF8String:sel_getName(aSEL)];
    
    if ([methodName hasPrefix:@"has"]) {
        class_addMethod(self, sel_registerName([methodName UTF8String]), (IMP) dynamicHas, "@@");
        return YES;
    }
    
    //We only get here if an unknown method is called that doesn't start with our defined prefixes, or if an @dynamic property is called.
    //This actually calls the *original* resolveInstanceMethod.
    return [self swizzledResolveInstanceMethod:aSEL];
}

+ (id)create:(NSDictionary *)params {
    NSManagedObject *newObject = [self object];
    for (NSString *propertyName in params) {
        id propertyValue = [params objectForKey:propertyName];
        SEL propertySelector = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [propertyName stringByUppercasingFirstLetter], nil]);
        if ([newObject respondsToSelector:propertySelector]) {
            [newObject performSelector:propertySelector withObject:propertyValue];
        }
    }
    return newObject;
}

+ (id)createWithBlock:(void (^) (id newObject))creationBlock {
    id newObject = [self object];    
    creationBlock(newObject);
    return newObject;
}

- (BOOL)save:(NSError **)error {
    return [[[self class] currentContext] save:error];
}

+ (id)find:(NSDictionary *)params {
    //TODO: check for nil dictionary?
    //check for existence of properties? Return nil and log error if invalid? 
    NSString *query = @"";
    NSString *atSign = [NSString stringWithUTF8String:"@"];
    NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:[params count]]; 
    for (NSString *propertyName in params) {
        id propertyValue = [params objectForKey:propertyName];
        if (![query isEqualToString:@""]) {
            query = [query stringByAppendingString:@" AND "];
        }
        query = [query stringByAppendingString:[NSString stringWithFormat:@"%@ == %%%@", propertyName, atSign]];
        [arguments addObject:propertyValue];
    }
    return [self findFirstWithPredicate:[NSPredicate predicateWithFormat:query argumentArray:arguments]];
}

+ (NSArray *)findAll:(NSDictionary *)params {
    //TODO: check for nil dictionary?
    NSString *query = @"";
    NSString *atSign = [NSString stringWithUTF8String:"@"];
    NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:[params count]]; 

    for (NSString *propertyName in params) {
        id propertyValue = [params objectForKey:propertyName];
        if (![query isEqualToString:@""]) {
            query = [query stringByAppendingString:@" AND "];
        }
        query = [query stringByAppendingString:[NSString stringWithFormat:@"%@ == %%%@", propertyName, atSign]];
        [arguments addObject:propertyValue];
    }
    return [self findAllWithPredicate:[NSPredicate predicateWithFormat:query argumentArray:arguments]];
}

@end

static id dynamicFindBy(id self, SEL _cmd, NSString *string) {
    
    NSString *methodName = [NSString stringWithUTF8String:sel_getName(_cmd)];
    NSRange range = NSMakeRange(6, [methodName length] - 7);
    NSString *propertyName = [[methodName substringWithRange:range] stringByLowercasingFirstLetter];
    
    if (class_getProperty([self class], [propertyName UTF8String]) == NULL) {
        return nil;
    }
    
    return [self find:[NSDictionary dictionaryWithObjectsAndKeys: string, propertyName, nil]];
}      

static id dynamicFindAllBy(id self, SEL _cmd, NSString *string) {
    
    NSString *methodName = [NSString stringWithUTF8String:sel_getName(_cmd)];
    NSRange range = NSMakeRange(9, [methodName length] - 10);
    NSString *propertyName = [[methodName substringWithRange:range] stringByLowercasingFirstLetter];
    
    if (class_getProperty([self class], [propertyName UTF8String]) == NULL) {
        return nil;
    }
    
    return [self findAll:[NSDictionary dictionaryWithObjectsAndKeys:string, propertyName, nil]];
}

static BOOL dynamicHas(id self, SEL _cmd) {
    NSString *methodName = [NSString stringWithUTF8String:sel_getName(_cmd)];
    NSRange range = NSMakeRange(3, [methodName length] - 3);
    NSString *propertyName = [[methodName substringWithRange:range] stringByLowercasingFirstLetter];
    
    if (class_getProperty([self class], [propertyName UTF8String])) {
        id property = [self valueForKey:propertyName];
        return (property) ? YES : NO;
    }
    
    return NO;
}
