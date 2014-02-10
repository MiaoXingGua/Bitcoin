//
//  ALFMDBHelper.h
//  FMDB_DEMO
//
//  Created by Albert on 13-8-16.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import "ALFMDBConstants.h"

@interface ALFMDBHelper : NSObject

@property (nonatomic, readonly) NSString *databasePath;
//@property (nonatomic, readonly) FMDatabase *db;
@property (nonatomic, readonly) FMDatabaseQueue *queue;

+ (ALFMDBHelper *)shareDBHelper;

- (BOOL)setApplicationDataBaseName:(NSString *)theDBName;

- (void)dropAllTable;

@end
