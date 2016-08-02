//
//  SqliteManager.m
//  Ophio Restaurant Finder
//
//  Created by Pranav Sah on 01/05/15.
//  Copyright (c) 2015 Pranav Sah. All rights reserved.
//

#import "SqliteManager.h"

@implementation SqliteManager
@synthesize dbHandle,dbName;

- (id)init{
    self = [super init];
    if (self) {
        dbName = @"Ophio1.sqlite";
        [self openDatabase];
        [self closeDatabase];
    }
    return self;
}

-(void) openDatabase{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:dbName];
    success = [fileManager fileExistsAtPath:databasePath];
    if(success){
        if(sqlite3_open([databasePath UTF8String], &dbHandle) == SQLITE_OK){
            NSString *sql = [NSString stringWithFormat:@"PRAGMA FOREIGN_KEYS=ON;"];
            const char *sqlStatment = [sql UTF8String];
            sqlite3_stmt *sStatement;
            if(sqlite3_prepare_v2(dbHandle, sqlStatment, -1, &sStatement, NULL) == SQLITE_OK)
                sqlite3_finalize(sStatement);
        }
        return;
    }
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:databasePath error:&error];
    if(!success)
        NSAssert1(0, @"Failed to create writeable database with message '%@'.", [error localizedDescription]);
}

-(void) closeDatabase{
    sqlite3_close(dbHandle) ;
    return;
}


-(NSMutableArray *) readBlockedRestaurants {
    NSMutableArray *blockedRestaurants = [[NSMutableArray alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent: dbName];
    if(sqlite3_open([databasePath UTF8String], &dbHandle) == SQLITE_OK){
        NSString *sql = [NSString stringWithFormat:@"SELECT Restaurant_name FROM Restaurant_Table WHERE isBlocked = 1;"];
        const char *sqlStatment = [sql UTF8String];
        sqlite3_stmt *searchStatement;
        if(sqlite3_prepare_v2(dbHandle, sqlStatment, -1, &searchStatement, NULL) == SQLITE_OK){
            while(sqlite3_step(searchStatement) == SQLITE_ROW){
                 NSString *restaurantName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStatement, 0)];
                [blockedRestaurants addObject:restaurantName];
            }
            sqlite3_finalize(searchStatement);
        }
    }
    return blockedRestaurants;
}
-(BOOL) updateBlockedStatusForRestaurantId:(NSInteger)restaurantID to:(BOOL)newMode{
   
    NSString *sql = [NSString stringWithFormat:@"UPDATE Restaurant_Table SET isBlocked = %d WHERE Restaurant_ID = %lu;",newMode,restaurantID];
    const char *sqlStatment = [sql UTF8String];
    sqlite3_stmt *insertStatement;
    if(sqlite3_prepare_v2(dbHandle, sqlStatment, -1, &insertStatement, NULL) == SQLITE_OK){
        if (SQLITE_DONE != sqlite3_step(insertStatement)){
            sqlite3_finalize(insertStatement);
            return FALSE;
        }
        else{
            sqlite3_finalize(insertStatement);
            return TRUE;
        }
    }
    return FALSE;

}
-(BOOL) readCurrentBlockedStatusForRestaurantId:(NSInteger)restaurantID{
    
    BOOL isThumbedDown = FALSE;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent: dbName];
    if(sqlite3_open([databasePath UTF8String], &dbHandle) == SQLITE_OK){
        NSString *sql = [NSString stringWithFormat:@"SELECT isBlocked FROM Restaurant_Table WHERE Restaurant_ID = %lu;",restaurantID];
        const char *sqlStatment = [sql UTF8String];
        sqlite3_stmt *searchStatement;
        if(sqlite3_prepare_v2(dbHandle, sqlStatment, -1, &searchStatement, NULL) == SQLITE_OK){
            while(sqlite3_step(searchStatement) == SQLITE_ROW){
                isThumbedDown = (BOOL)sqlite3_column_int64(searchStatement, 0);
            }
            sqlite3_finalize(searchStatement);
        }
    }
    return isThumbedDown;

}

-(BOOL) recordExistsForRestaurant:(NSString *)restaurantName{
   
    int recordCount = 0;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent: dbName];
    if(sqlite3_open([databasePath UTF8String], &dbHandle) == SQLITE_OK){
        NSString *sql = [NSString stringWithFormat:@"SELECT COALESCE(MAX(Restaurant_ID), 0) FROM Restaurant_Table Where Restaurant_name = '%@';",restaurantName];
//        NSLog(@"sql : %@",sql);
        const char *sqlStatment = [sql UTF8String];
        sqlite3_stmt *searchStatement;
        if(sqlite3_prepare_v2(dbHandle, sqlStatment, -1, &searchStatement, NULL) == SQLITE_OK){
            while(sqlite3_step(searchStatement) == SQLITE_ROW){
                recordCount = (int)sqlite3_column_int64(searchStatement, 0);
            }
            sqlite3_finalize(searchStatement);
        }
    }
    NSLog(@"recordCount :%d",recordCount);
    if(recordCount > 0)
        return TRUE;
    else
        return FALSE;

}
-(NSInteger) fetchIDForRestaurant:(NSString *)restaurantName{
    
    NSInteger restID = 0;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent: dbName];
    if(sqlite3_open([databasePath UTF8String], &dbHandle) == SQLITE_OK){
        NSString *sql = [NSString stringWithFormat:@"SELECT Restaurant_ID FROM Restaurant_Table WHERE Restaurant_name = '%@';",restaurantName];
        const char *sqlStatment = [sql UTF8String];
        sqlite3_stmt *searchStatement;
        if(sqlite3_prepare_v2(dbHandle, sqlStatment, -1, &searchStatement, NULL) == SQLITE_OK){
            while(sqlite3_step(searchStatement) == SQLITE_ROW){
               restID = (NSInteger)sqlite3_column_int64(searchStatement, 0);
            }
            sqlite3_finalize(searchStatement);
        }
    }
    return restID;
}


-(NSInteger) readNumberOfVisitForRestaurantId:(NSInteger)restaurantID{
    NSInteger currentVisits = 0;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent: dbName];
    if(sqlite3_open([databasePath UTF8String], &dbHandle) == SQLITE_OK){
        NSString *sql = [NSString stringWithFormat:@"SELECT Visit_Count FROM Restaurant_Table WHERE Restaurant_ID = %lu;",restaurantID];
        const char *sqlStatment = [sql UTF8String];
        sqlite3_stmt *searchStatement;
        if(sqlite3_prepare_v2(dbHandle, sqlStatment, -1, &searchStatement, NULL) == SQLITE_OK){
            while(sqlite3_step(searchStatement) == SQLITE_ROW){
                currentVisits = (NSInteger)sqlite3_column_int64(searchStatement, 0);
            }
            sqlite3_finalize(searchStatement);
        }
    }
    return currentVisits;

}
-(BOOL) updateNumberOfVisitsForRestaurantId:(NSInteger)restaurantID to:(NSInteger) newCount{
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE Restaurant_Table SET Visit_Count = %lu WHERE Restaurant_ID = %lu;",newCount,restaurantID];
    const char *sqlStatment = [sql UTF8String];
    sqlite3_stmt *insertStatement;
    if(sqlite3_prepare_v2(dbHandle, sqlStatment, -1, &insertStatement, NULL) == SQLITE_OK){
        if (SQLITE_DONE != sqlite3_step(insertStatement)){
            sqlite3_finalize(insertStatement);
            return FALSE;
        }
        else{
            sqlite3_finalize(insertStatement);
            return TRUE;
        }
    }
    return FALSE;
}

-(BOOL) createRestaurantWithName:(NSString *)restaurantName{
   
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO Restaurant_Table(Restaurant_name,isBlocked,Visit_Count) VALUES ('%@','0','0')",restaurantName];
//    NSLog(@"sql : %@",sql);
    const char *sqlStatment = [sql UTF8String];
    sqlite3_stmt *insertStatement;
    if(sqlite3_prepare_v2(dbHandle, sqlStatment, -1, &insertStatement, NULL) == SQLITE_OK){
        if (SQLITE_DONE != sqlite3_step(insertStatement)){
            sqlite3_finalize(insertStatement);
            return FALSE;
        }
        else{
            sqlite3_finalize(insertStatement);
            return TRUE;
        }
    }
    return FALSE;
}

-(BOOL) reviewsExistsForRestaurantId:(NSInteger)restaurantID {
   
    int reviewCount = 0;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent: dbName];
    if(sqlite3_open([databasePath UTF8String], &dbHandle) == SQLITE_OK){
        NSString *sql = [NSString stringWithFormat:@"SELECT COALESCE(MAX(Review_ID), 0) FROM Review_Table Where Restaurant_ID = %lu;",restaurantID];
        const char *sqlStatment = [sql UTF8String];
        sqlite3_stmt *searchStatement;
        if(sqlite3_prepare_v2(dbHandle, sqlStatment, -1, &searchStatement, NULL) == SQLITE_OK){
            while(sqlite3_step(searchStatement) == SQLITE_ROW){
                reviewCount = (int)sqlite3_column_int64(searchStatement, 0);
            }
            sqlite3_finalize(searchStatement);
        }
    }
    //    NSLog(@"recordCount :%d",recordCount);
    if(reviewCount > 0)
        return TRUE;
    else
        return FALSE;
    
}
-(BOOL) createReview:(NSString *)reviewRecieved forRestaurantId:(NSInteger)restaurantID{
   
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO Review_Table (Restaurant_ID,Review) VALUES (%lu,'%@');",restaurantID,reviewRecieved];
    NSLog(@"sql : %@",sql);
    const char *sqlStatment = [sql UTF8String];
    sqlite3_stmt *insertStatement;
    if(sqlite3_prepare_v2(dbHandle, sqlStatment, -1, &insertStatement, NULL) == SQLITE_OK){
        if (SQLITE_DONE != sqlite3_step(insertStatement)){
            sqlite3_finalize(insertStatement);
            return FALSE;
        }
        else{
            sqlite3_finalize(insertStatement);
            return TRUE;
        }
    }
    return FALSE;
}

-(NSMutableArray *) readAllReviewsForRestaurantId:(NSInteger)restaurantID{
   
    NSMutableArray *blockedRestaurants = [[NSMutableArray alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent: dbName];
    if(sqlite3_open([databasePath UTF8String], &dbHandle) == SQLITE_OK){
        NSString *sql = [NSString stringWithFormat:@"SELECT Review FROM Review_Table WHERE Restaurant_ID = %lu;",restaurantID];
        const char *sqlStatment = [sql UTF8String];
        sqlite3_stmt *searchStatement;
        if(sqlite3_prepare_v2(dbHandle, sqlStatment, -1, &searchStatement, NULL) == SQLITE_OK){
            while(sqlite3_step(searchStatement) == SQLITE_ROW){
                NSString *restaurantName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(searchStatement, 0)];
                [blockedRestaurants addObject:restaurantName];
            }
            sqlite3_finalize(searchStatement);
        }
    }
    return blockedRestaurants;

}
@end
