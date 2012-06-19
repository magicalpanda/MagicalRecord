//
//  MRFactoryObject.h
//  MagicalRecord
//
//  Created by Saul Mora on 6/18/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MRFactoryObject <NSObject>

@end


@class MRFactoryObjectDefinition;


typedef  id(^MRFactoryObjectBuildAction)(MRFactoryObjectDefinition *obj);
typedef  id(^MRFactoryObjectSequenceBuildAction)(MRFactoryObjectDefinition *obj, NSUInteger sequenceIndex);


@interface MRFactoryObjectDefinition : NSObject

@property (nonatomic, strong, readonly) NSArray *actions;

- (id) initWithClass:(Class)klass;

- (void) setValue:(id)value forPropertyNamed:(NSString *)propertyName;
- (void) setAction:(MRFactoryObjectBuildAction)action forPropertyNamed:(NSString *)propertyName;
- (void) setSequenceAction:(MRFactoryObjectSequenceBuildAction)action forPropertyNamed:(NSString *)propertyName;

@end
