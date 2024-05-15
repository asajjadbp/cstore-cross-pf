import 'package:cstore/database/table_name.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Model/database_model/category_model.dart';
import '../Model/database_model/client_model.dart';
import '../Model/database_model/dashboard_model.dart';
import '../Model/database_model/drop_reason_model.dart';
import '../Model/database_model/get_trans_photo_model.dart';
import '../Model/database_model/trans_photo_model.dart';
// import 'dart:io' as io;

import '../Model/response_model.dart/syncronise_response_model.dart';

class DatabaseHelper {
  static var instance;
  // static Database? _database;

  static Future<Database?> get database async {
    // Get a location using getDatabasesPath()
    const databaseName = "cstore_pro.db";

    // if (_database != null) {
    //   return _database;
    // }
    var databasesPath = await getDatabasesPath();
    // Check if data exists
    String path = join(databasesPath, databaseName);
    return openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // Create your tables here
      await db.execute('CREATE TABLE ' +
          TableName.tbl_drop_reason +
          "(" +
          TableName.drop_id +
          " INTEGER PRIMARY KEY," +
          TableName.drop_en_name +
          " TEXT, " +
          TableName.drop_ar_name +
          " TEXT, " +
          TableName.drop_status +
          " INTEGER" +
          ")");

      await db.execute('CREATE TABLE ' +
          TableName.tbl_agency_dashboard +
          "(" +
          TableName.agency_dash_id +
          " INTEGER PRIMARY KEY," +
          TableName.agency_dash_en_name +
          " TEXT, " +
          TableName.agency_dash_ar_name +
          " TEXT, " +
          TableName.agency_dash_icon +
          " TEXT, " +
          TableName.agency_dash_start_date +
          " TEXT, " +
          TableName.agency_dash_end_date +
          " TEXT, " +
          TableName.agency_dash_status +
          " INTEGER" +
          ")");

      await db.execute('CREATE TABLE ' +
          TableName.tbl_sys_category +
          "(" +
          TableName.cat_id +
          " INTEGER PRIMARY KEY," +
          TableName.cat_name +
          " TEXT, " +
          TableName.cat_client_id +
          " INTEGER" +
          ")");
      await db.execute('CREATE TABLE ' +
          TableName.tbl_sys_client +
          "(" +
          TableName.sys_client_id +
          " INTEGER PRIMARY KEY," +
          TableName.sys_client_name +
          " TEXT, " +
          TableName.sys_client_logo +
          " BLOB, " +
          TableName.sys_client_classification +
          " INTEGER, " +
          TableName.sys_client_chainSku_code +
          " INTEGER, " +
          TableName.sys_client_is_dayFreshness +
          " INTEGER, " +
          TableName.sys_client_order_avl +
          " INTEGER, " +
          TableName.sys_client_is_survey +
          " INTEGER, " +
          TableName.sys_client_geo_req +
          " INTEGER" +
          ")");

      await db.execute('CREATE TABLE ' +
          TableName.tbl_trans_photo +
          "(" +
          TableName.trans_photo_id +
          " INTEGER PRIMARY KEY," +
          TableName.trans_photo_client_id +
          " INTEGER, " +
          TableName.trans_photo_type_id +
          " INTEGER, " +
          TableName.trans_photo_cat_id +
          " INTEGER, " +
          TableName.trans_photo_name +
          " TEXT, " +
          TableName.trans_photo_gcs_status +
          " INTEGER" +
          ")");
      print("all data creted successfully");
    });
  }

  static Future<Database> initDataBase() async {
    return await openDatabase('cstore_pro.db');
  }

  // insert data arrayList
  static Future<void> insertClientArray(List<SysClient> modelList) async {
    // final db = await getDatabase();
    var db = await initDataBase();
    for (SysClient data in modelList) {
      await db.insert(
        TableName.tbl_sys_client,
        {
          TableName.sys_client_id: data.clientId,
          TableName.sys_client_name: data.clientName,
          TableName.sys_client_logo: data.logo,
          TableName.sys_client_classification: data.isClassification,
          TableName.sys_client_chainSku_code: data.isChainSkuCodes,
          TableName.sys_client_is_dayFreshness: data.isDayFreshness,
          TableName.sys_client_order_avl: data.isSuggetedOrderAvl,
          TableName.sys_client_is_survey: data.isSurvey,
          TableName.sys_client_geo_req: data.isGeoRequired
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<void> insertCategoryArray(
      // List<CategoryModel>
      List<CategoryResModel> modelList) async {
    var db = await initDataBase();
    for (
        // CategoryModel
        CategoryResModel data in modelList) {
      await db.insert(
        TableName.tbl_sys_category,
        {
          TableName.cat_client_id: data.clientId,
          TableName.cat_name: data.arName,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // Dashboard data insertion
  static Future<void> insertAgencyDashArray(
      // List<AgencyDashboardModel>
      List<SysAgencyDashboard> modelList) async {
    var db = await initDataBase();
    for (
        // AgencyDashboardModel
        SysAgencyDashboard data in modelList) {
      await db.insert(
        TableName.tbl_agency_dashboard,
        {
          // TableName.agency_dash_en_name: data.en_name,
          // TableName.agency_dash_ar_name: data.ar_name,
          // TableName.agency_dash_start_date: data.start_date,
          // TableName.agency_dash_end_date: data.end_date,
          // TableName.agency_dash_icon: data.icon,
          // TableName.agency_dash_status: data.start_date,

          TableName.agency_dash_en_name: data.enName,
          TableName.agency_dash_ar_name: data.arName,
          TableName.agency_dash_start_date: data.startDate,
          TableName.agency_dash_end_date: data.endDate,
          TableName.agency_dash_icon: data.iconSvg,
          TableName.agency_dash_status: data.startDate,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<void> insertDropReasonArray(List<Sys> modelList) async {
    var db = await initDataBase();
    for (Sys data in modelList) {
      await db.insert(
        TableName.tbl_drop_reason,
        {
          TableName.drop_en_name: data.enName,
          TableName.drop_ar_name: data.arName,
          TableName.drop_status: data.status,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<void> insertTransPhotoArray(
      List<TransPhotoModel> modelList) async {
    var db = await initDataBase();
    for (TransPhotoModel data in modelList) {
      await db.insert(
        TableName.tbl_trans_photo,
        {
          TableName.trans_photo_client_id: data.client_id,
          TableName.trans_photo_type_id: data.photo_type_id,
          TableName.trans_photo_cat_id: data.cat_id,
          TableName.trans_photo_name: data.img_name,
          TableName.trans_photo_gcs_status: data.gcs_status,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // insert data using Model
  static Future<void> insertClient(ClientModel model) async {
    var db = await initDataBase();
    await db.insert(
      TableName.tbl_sys_client,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> insertAgencyDashboard(
      AgencyDashboardModel dashmodel) async {
    var db = await initDataBase();
    await db.insert(
      TableName.tbl_agency_dashboard,
      dashmodel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<void> insertMultipleData(List<Map<String, dynamic>> dataList) async {
    final db = await DatabaseHelper.instance.database;
    await db.batch((batch) {
      for (final data in dataList) {
        batch.insert('my_table', data);
      }
    });
  }

  static Future<void> insertTransPhoto(TransPhotoModel transPhotoModel) async {
    var db = await initDataBase();
    await db.insert(
      TableName.tbl_trans_photo,
      transPhotoModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> insertCategory(CategoryModel model) async {
    var db = await initDataBase();
    await db.insert(
      TableName.tbl_sys_category,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> insertDropReason(DropReasonModel model) async {
    var db = await initDataBase();
    await db.insert(
      TableName.tbl_drop_reason,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<ClientModel>> getClientList() async {
    var db = await initDataBase();
    final List<Map<String, dynamic>> clientMaps = await db.rawQuery(
        "SELECT client_id as client_id, client_name as client_name FROM ${TableName.tbl_sys_client} WHERE ${TableName.sys_client_id} IN (1, 2)");

    return List.generate(clientMaps.length, (index) {
      return ClientModel(
        client_id: clientMaps[index][TableName.sys_client_id] as int,
        client_name: clientMaps[index][TableName.sys_client_name] as String,
      );
    });
  }

  static Future<List<CategoryModel>> getCategoryList() async {
    var db = await initDataBase();
    final List<Map<String, dynamic>> categoryMaps = await db.rawQuery(
        "SELECT sys_category.id as cat_id, sys_category.name as cat_name FROM  sys_category JOIN sys_client on sys_client.client_id=sys_category.client WHERE sys_category.client=sys_client.client_id GROUP by sys_category.id"
        // "SELECT sys_category.id as cat_id,sys_category.name as cat_name FROM  ${TableName.tbl_sys_category} JOIN ${TableName.tbl_sys_client} on sys_client.company_id=sys_category.client WHERE sys_category.client=1 GROUP by sys_category.client"
        );

    return List.generate(categoryMaps.length, (index) {
      print(categoryMaps[index]['cat_name']);
      return CategoryModel(
        name: categoryMaps[index]["cat_name"] as String,
        client: categoryMaps[index]["cat_id"] as int,
      );
    });
  }

// AgencyDashboardModel
  static Future<List<AgencyDashboardModel>> getAgencyDashboard() async {
    var db = await initDataBase();
    final List<Map<String, dynamic>> agencyDashboard =
        await db.rawQuery("SELECT *from ${TableName.tbl_agency_dashboard}");
    print(agencyDashboard);
    return List.generate(agencyDashboard.length, (index) {
      // return SysAgencyDashboard.fromJson(agencyDashboard[index]);
      return AgencyDashboardModel.fromJson(agencyDashboard[index]);
      // AgencyDashboardModel(
      //   en_name:
      //       agencyDashboard[index][TableName.agency_dash_en_name] as String,
      //   ar_name:
      //       agencyDashboard[index][TableName.agency_dash_ar_name] as String,
      //   icon: agencyDashboard[index]['icon_svg'] as String,
      //   start_date:
      //       agencyDashboard[index][TableName.agency_dash_start_date] as String,
      //   end_date:
      //       agencyDashboard[index][TableName.agency_dash_end_date] as String,
      //   status: agencyDashboard[index][TableName.agency_dash_status] as int,
      // );
    });
  }

  static Future<List<GetTransPhotoModel>> getTransPhoto() async {
    var db = await initDataBase();
    final List<Map<String, dynamic>> transphoto =
        await db.rawQuery("SELECT *from ${TableName.tbl_trans_photo}");
    return List.generate(transphoto.length, (index) {
      // print(transphoto[index]['id']);
      return GetTransPhotoModel(
        id: transphoto[index]['id'],
        client_id: transphoto[index][TableName.trans_photo_client_id] as int,
        photo_type_id: transphoto[index][TableName.trans_photo_type_id] as int,
        cat_id: transphoto[index][TableName.trans_photo_cat_id] as int,
        img_name: transphoto[index][TableName.trans_photo_name] as String,
        imageFile: null,
        gcs_status: transphoto[index][TableName.trans_photo_gcs_status] as int,
      );
    });
  }

  static Future<List<DropReasonModel>> getDropReason() async {
    var db = await initDataBase();
    final List<Map<String, dynamic>> dropreason =
        await db.rawQuery("SELECT *from ${TableName.tbl_drop_reason}");
    return List.generate(dropreason.length, (index) {
      return DropReasonModel(
        en_name: dropreason[index][TableName.drop_en_name] as String,
        ar_name: dropreason[index][TableName.drop_ar_name] as String,
        status: dropreason[index][TableName.drop_status] as int,
      );
    });
  }

  //delete data all tables
  Future<void> deleteData(Database database, String table_name) async {
    await database.rawDelete('DELETE FROM ${table_name}');
  }

  // check data is availiblle in databse
  Future<bool> checkDataExists(Database database) async {
    List<Map<String, dynamic>> result =
        await database.rawQuery('SELECT * FROM ${TableName.tbl_drop_reason}');
    return result.isNotEmpty;
  }

//delete tabale
  static Future<void> delete_table(String tbl_name) async {
    var db = await initDataBase();
    await db.rawDelete('DELETE FROM ${tbl_name}');
  }

  static Future<void> deleteOneRecord(String tblName, int id) async {
    var db = await initDataBase();
    await db.delete(tblName, where: 'id = ?', whereArgs: [id]);
  }
}
