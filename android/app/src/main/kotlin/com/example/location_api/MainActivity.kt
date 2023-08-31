package com.example.location_api

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.location.LocationManager
import android.os.Bundle
import android.util.Log
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    var latitude: Double = 0.0
    var longitude: Double = 0.0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_COARSE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            ActivityCompat.requestPermissions(
                this, arrayOf(Manifest.permission.ACCESS_COARSE_LOCATION),
                10
            )
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "android").setMethodCallHandler { call, result ->
            when (call.method) {
                "getCoordinate" -> {
                    result.success(mapOf("latitude" to latitude, "longitude" to longitude))
                }
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        Log.d(TAG, "onActivityResult() called with: requestCode = $requestCode, resultCode = $resultCode, data = $data")
        if (resultCode == 1) {
            getLocation()
        }
    }

    override fun onResume() {
        super.onResume()
        getLocation()
    }

    private fun getLocation() {

        if (ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_COARSE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            return
        }

        val lm = getSystemService((LOCATION_SERVICE)) as LocationManager

        lm.requestLocationUpdates(
            LocationManager.NETWORK_PROVIDER, 1L, 1000.0f
        ) {
            Log.d("TAG", "getLocation: it : $it")
            latitude = it.latitude
            longitude = it.longitude

        }
    }

    companion object {
        private const val TAG = "MainActivity"
    }

}