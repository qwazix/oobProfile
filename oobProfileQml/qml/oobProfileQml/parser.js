function loaded(all)
{
    listModel.clear();
    for ( var i=0;i<=all.length;i++   )
    {
        listModel.append({
                             "name" : all[i-1],
    }
    )}
    //listModel.sync();
}//telos loaded

function cut(lat1,lon1,lat2,lon2){

    var R = 6371; // km
    var dLat = toRad(lat2-lat1);
    var dLon = toRad(lon2-lon1);
    lat1 = toRad(lat1);
    lat2 = toRad(lat2);

    var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
            Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    var d = R * c;
    d=d*1000;
    return d;
}//telos cut


function toRad(Value) {
    return Value * Math.PI / 180;
}//telos toRad

function getSetting(key){
    var setting
    var db = openDatabaseSync("oobProfileDatabase", "1.0", "", 1000000);
    db.transaction(function(tx) {
         var result=tx.executeSql("SELECT value FROM settings WHERE key='"+key+"'");
         setting=result.rows.item(0).value;
    })
    return setting;
}//telos getSetting

function getBoolSetting(key){
    var active
    var db = openDatabaseSync("oobProfileDatabase", "1.0", "", 1000000);
    db.transaction(function(tx) {
        var result=tx.executeSql("SELECT value FROM settings WHERE key='"+key+"'");
        active=result.rows.item(0).value;
        if(active=="1") active=true; else active=false;
    })
    return active;
}//telos getBoolSetting

function updateSetting(key, value){
    var db = openDatabaseSync("oobProfileDatabase", "1.0", "", 1000000);
    db.transaction(function(tx) {
         tx.executeSql("UPDATE settings SET value=? WHERE key=?",[value,key]);
    })
}
