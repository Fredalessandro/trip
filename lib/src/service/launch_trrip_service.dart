import 'dart:convert';

import '../model/launch_trip_model.dart';
import 'local_storage_service.dart';


class LaunchTripService  {
   static String KEY = "TRIPS_LAUNCH";
  
   static save(List<LaunchTrip> trips) async {
         SharedLocalStorageService sharedLocalStorageService = SharedLocalStorageService();
         remove();
         const JsonEncoder encoder = JsonEncoder();
         final String stringJson = encoder.convert(trips);
         sharedLocalStorageService.put(KEY, stringJson);
   }

   static Future<List<LaunchTrip>> get() async {
         
         SharedLocalStorageService sharedLocalStorageService = SharedLocalStorageService();
         
         const JsonDecoder decoder = JsonDecoder();
         String stringJson = ""; 
         
         await sharedLocalStorageService.getString(KEY).then((value) => {
                stringJson = value==null?"":value                
         });
         
         List<LaunchTrip> trips = []; 
         
         if (stringJson.isNotEmpty) {
            var object = decoder.convert(stringJson);
            
            object.forEach((element) {
              trips.add(LaunchTrip.fromJson(element as Map<String, dynamic>));
            });
          }   
         
         return trips;
   }

   static remove() async {
         SharedLocalStorageService sharedLocalStorageService = SharedLocalStorageService();
         sharedLocalStorageService.delete(KEY);
   }


}