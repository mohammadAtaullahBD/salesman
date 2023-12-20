package com.ipsitasoft.salesman

import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.location.Location
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.Priority
import com.google.android.gms.tasks.Task
import kotlinx.coroutines.DelicateCoroutinesApi
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class MyForegroundService : Service() {
    private val channelId = "my_channel"
    private lateinit var locationProvider: FusedLocationProviderClient
    private lateinit var builder: NotificationCompat.Builder
    private lateinit var notificationManager: NotificationManager

    private val locationUpdateInterval = 10000L // Interval in milliseconds (10 seconds)
    private val handler = Handler(Looper.getMainLooper())

    override fun onCreate() {
        super.onCreate()
        // Create a notification to make the service a foreground service
        builder = NotificationCompat.Builder(this, channelId)
            .setContentText("Background Service start now!")
            .setContentTitle("Bengal App is Running As Background Service")
            .setSmallIcon(android.R.drawable.stat_notify_chat)
            .setPriority(NotificationCompat.PRIORITY_LOW)
        startForeground(101, builder.build())
        notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        locationProvider = LocationServices.getFusedLocationProviderClient(this)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val userID = intent?.getStringExtra("userID")
        userID?.let { startLocationUpdates(it) }
        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        // Stop location updates or any ongoing tasks
        handler.removeCallbacksAndMessages(null)
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    private fun startLocationUpdates(userID:String) {
        handler.postDelayed(object : Runnable {
            override fun run() {
                sendLocation(userID)
                handler.postDelayed(this, locationUpdateInterval)
            }
        }, locationUpdateInterval)
    }

    @OptIn(DelicateCoroutinesApi::class)
    private fun sendLocation(userID:String) {
        if (ActivityCompat.checkSelfPermission(this,android.Manifest.permission.ACCESS_FINE_LOCATION)
            != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this,android.Manifest.permission.ACCESS_COARSE_LOCATION)
            != PackageManager.PERMISSION_GRANTED){
            return
        }
        val task: Task<Location> = locationProvider.getCurrentLocation(
            Priority.PRIORITY_HIGH_ACCURACY, null
        )

        task.addOnSuccessListener { location ->
            if (location != null) {
                val client = OkHttpClient()
                val mediaType = "application/json".toMediaType()
                val body = "{\"latitude\":\"${location.latitude}\",\"longitude\":\"${location.longitude}\"}".toRequestBody(mediaType)
                val request = Request.Builder()
                    .url("https://salesman.ipsitacomputersltd.com/api/user-location/$userID")
                    .put(body)
                    .addHeader("Content-Type", "application/json")
                    .build()

                GlobalScope.launch(Dispatchers.IO) {
                    try {
                        launch(Dispatchers.Main) {
                            // Get the current time
                            val currentTime = System.currentTimeMillis()

                            // Format the time with the device's locale
                            val dateFormat = SimpleDateFormat("hh:mm a", Locale.getDefault())
                            val formattedTime = dateFormat.format(Date(currentTime))
                            val updatedNotification = builder.setContentText(
                                // TODO: make the time dynamic
                                "Location updated at $formattedTime."
                            )
                            notificationManager.notify(101, updatedNotification.build())
                        }
                        val response = client.newCall(request).execute()

                        println(response)
                    } catch (e: Exception) {
                        // Handle exceptions
                        e.printStackTrace()
                    }
                }
            }
        }
    }
}
