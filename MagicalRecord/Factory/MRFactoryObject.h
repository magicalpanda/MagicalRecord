//
//  MRFactoryObject.h
//  MagicalRecord
//
//  Created by Saul Mora on 6/18/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MRFactoryObject;

typedef  id(^MRFactoryObjectBuildAction)(MRFactoryObject *obj);
typedef  id(^MRFactoryObjectSequenceBuildAction)(MRFactoryObject *obj, NSUInteger sequenceIndex);


@protocol MRFactoryObject <NSObject>

//- (id) setDynamicValue:(MRFactoryObjectBuildAction)block;
- (id) setSequence:(MRFactoryObjectSequenceBuildAction)sequence;
- (id) setValue:(id)value;
- (id) forProperty;

@end


@interface MRFactoryObject : NSObject<MRFactoryObject>

@property (nonatomic, copy, readonly) NSString *alias;
@property (nonatomic, strong, readonly) NSArray *actions;

+ (id) factoryWithClass:(Class)klass;
+ (id) factoryWithClass:(Class)klass as:(NSString *)alias;
- (id) initWithClass:(Class)klass;
- (id) initWithClass:(Class)klass as:(NSString *)alias;

- (void) setValue:(id)value forPropertyNamed:(NSString *)propertyName;
- (void) setAction:(MRFactoryObjectBuildAction)action forPropertyNamed:(NSString *)propertyName;
- (void) setAssociation:(NSString *)referingFactory forPropertyNamed:(NSString *)propertyName;
- (void) setSequenceAction:(MRFactoryObjectSequenceBuildAction)action forPropertyNamed:(NSString *)propertyName;
- (void) setSequenceAction:(MRFactoryObjectSequenceBuildAction)action forPropertyNamed:(NSString *)propertyName withStartingIndex:(NSUInteger)startIndex;

- (id) create;
- (id) generate;

@end
