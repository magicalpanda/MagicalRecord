//
//  NSManagedObject+JSONHelpers.h
//  Gathering
//
//  Created by Saul Mora on 6/28/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (NSManagedObject_JSONHelpers)

- (void) mr_setValuesForKeysWithJSONDictionary:(NSDictionary *)jsonData;
+ (id) mr_importFromDictionary:(NSDictionary *)data;

@end


#ifdef MR_SHORTHAND
    #define importFromDictionary                    mr_importFromDictionary
    #define setValuesForKeysWithJSDONDictionary     mr_setValuesForKeysWithJSONDictionary
#endif