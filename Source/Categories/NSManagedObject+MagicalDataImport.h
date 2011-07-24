//
//  NSManagedObject+JSONHelpers.h
//  Gathering
//
//  Created by Saul Mora on 6/28/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

extern NSString * const kNSManagedObjectDefaultDateFormatString;
extern NSString * const kNSManagedObjectAttributeJSONKeyMapKey;
extern NSString * const kNSManagedObjectAttributeJSONValueClassNameKey;

extern NSString * const kNSManagedObjectRelationshipJSONMapKey;
extern NSString * const kNSManagedObjectRelationshipJSONPrimaryKey;
extern NSString * const kNSManagedObjectRelationshipJSONTypeKey;

@interface NSManagedObject (NSManagedObject_JSONHelpers)

- (void) mr_setValuesForKeysWithJSONDictionary:(NSDictionary *)jsonData;
+ (id) mr_importFromDictionary:(NSDictionary *)data;

@end


#ifdef MR_SHORTHAND
    #define importFromDictionary                    mr_importFromDictionary
    #define setValuesForKeysWithJSDONDictionary     mr_setValuesForKeysWithJSONDictionary
#endif