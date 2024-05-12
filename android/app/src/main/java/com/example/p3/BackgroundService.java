// BackgroundService.java
package com.example.p3;

import android.app.Notification;
import android.app.Service;
import android.app.admin.DevicePolicyManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.util.Log;

import androidx.core.app.NotificationCompat;

public class BackgroundService extends Service {
    private static final String CHANNEL_ID = "ForegroundServiceChannel";
    private SensorManager sensorManager;
    private Sensor lightSensor;
    private SensorEventListener lightEventListener;
    private DevicePolicyManager devicePolicyManager;
    private ComponentName componentName;
    private static final int THRESHOLD = 10; // Set your threshold value

    private boolean isDark = false; // Add this line

    private Handler handler = new Handler(Looper.getMainLooper());
    private Runnable runnable = new Runnable() {
        @Override
        public void run() {
            if (isDark) { // Check if it's still dark
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.FROYO) {
                    if (devicePolicyManager.isAdminActive(componentName)) {
                        devicePolicyManager.lockNow();
                    }
                }
            }
        }
    };
    @Override
    public void onCreate() {
        super.onCreate();

        Notification notification = new NotificationCompat.Builder(this, "ForegroundServiceChannel")
                .setContentTitle("Your App")
                .setContentText("Your app is running in the background.")
                .setSmallIcon(R.drawable.ic_notification)
                .build();


        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.ECLAIR) {
            startForeground(1, notification);
        }

        sensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.CUPCAKE) {
            lightSensor = sensorManager.getDefaultSensor(Sensor.TYPE_LIGHT);
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.FROYO) {
            devicePolicyManager = (DevicePolicyManager)getSystemService(Context.DEVICE_POLICY_SERVICE);
        }
        componentName = new ComponentName(this, AdminReceiver.class);

        if (lightSensor == null) {
            // Device doesn't support light sensor
            stopSelf();
            return;
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.CUPCAKE) {
            lightEventListener = new SensorEventListener() {
                @Override
                public void onSensorChanged(SensorEvent event) {
                    Log.d("LightSensor", "Sensor value: " + event.values[0]);  // Log the sensor value

                    if (event.values[0] < THRESHOLD) { // Check light sensor value
                        // If light sensor value is less than THRESHOLD, start the timer
                        isDark = true; // Add this line
                        handler.postDelayed(runnable, 3000);  // 3 seconds delay
                    } else {
                        // If light sensor value is not less than THRESHOLD, cancel the timer
                        isDark = false; // Add this line
                        handler.removeCallbacks(runnable);
                    }
                }

                @Override
                public void onAccuracyChanged(Sensor sensor, int accuracy) {
                    // Do nothing
                }
            };
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.CUPCAKE) {
            sensorManager.registerListener(lightEventListener, lightSensor, SensorManager.SENSOR_DELAY_NORMAL);
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.CUPCAKE) {
            sensorManager.unregisterListener(lightEventListener);
        }
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
