//
//  SingleEntityWithNoRelationships+CoreDataProperties.h
//  MagicalRecord
//
//  Created by Tony Arnold on 22/11/2015.
//  Copyright © 2015 Magical Panda Software LLC. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SingleEntityWithNoRelationships.h"

NS_ASSUME_NONNULL_BEGIN

@interface SingleEntityWithNoRelationships (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *booleanAsStringTestAttribute;
@property (nullable, nonatomic, retain) NSNumber *booleanTestAttribute;
@property (nullable, nonatomic, retain) id colorTestAttribute;
@property (nullable, nonatomic, retain) NSDate *dateTestAttribute;
@property (nullable, nonatomic, retain) NSDate *dateWithCustomFormat;
@property (nullable, nonatomic, retain) NSDecimalNumber *decimalTestAttribute;
@property (nullable, nonatomic, retain) NSNumber *doubleTestAttribute;
@property (nullable, nonatomic, retain) NSNumber *floatTestAttribute;
@property (nullable, nonatomic, retain) NSNumber *int16TestAttribute;
@property (nullable, nonatomic, retain) NSNumber *int32TestAttribute;
@property (nullable, nonatomic, retain) NSNumber *int64TestAttribute;
@property (nullable, nonatomic, retain) NSString *mappedStringAttribute;
@property (nullable, nonatomic, retain) NSString *notInJsonAttribute;
@property (nullable, nonatomic, retain) NSNumber *nullTestAttribute;
@property (nullable, nonatomic, retain) NSString *numberAsStringTestAttribute;
@property (nullable, nonatomic, retain) NSString *stringTestAttribute;
@property (nullable, nonatomic, retain) NSDate *unixTime13TestAttribute;
@property (nullable, nonatomic, retain) NSDate *unixTimeTestAttribute;

@end

NS_ASSUME_NONNULL_END
