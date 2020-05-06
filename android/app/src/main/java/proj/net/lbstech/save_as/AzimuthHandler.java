package proj.net.lbstech.save_as;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;

public class AzimuthHandler implements EventChannel.StreamHandler {

    private SensorManager sensorManager;
    private Sensor vecSensor;
    private SensorEventListener listener;

    private HashMap<String, Double> result = new HashMap<>();

    private double azimuth, yaw, pitch, roll;
    private double filter = 1.0f;

    AzimuthHandler(Context context) {
        sensorManager = (SensorManager) context.getSystemService(Context.SENSOR_SERVICE);
        vecSensor = sensorManager.getDefaultSensor(Sensor.TYPE_ROTATION_VECTOR);
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink eventSink) {
        listener = new SensorEventListener() {
            @Override
            public void onSensorChanged(SensorEvent event) {
                float[] orientation = new float[3];
                float[] rMat = new float[9];

                double[] sensorValues = new double[4];
                SensorManager.getRotationMatrixFromVector(rMat, event.values);

                sensorValues[0] = ((Math.toDegrees((double) SensorManager.getOrientation(rMat, orientation)[0]) + (double) 360) % (double) 360 - Math.toDegrees((double) SensorManager.getOrientation(rMat, orientation)[2]) + (double) 360) % (double) 360;
                sensorValues[1] = Math.toDegrees((double) SensorManager.getOrientation(rMat, orientation)[0]);
                sensorValues[2] = Math.toDegrees((double) SensorManager.getOrientation(rMat, orientation)[1]);
                sensorValues[3] = Math.toDegrees((double) SensorManager.getOrientation(rMat, orientation)[2]);

                if (Math.abs(azimuth - sensorValues[0]) >= filter
                        || Math.abs(yaw - sensorValues[1]) >= filter
                        || Math.abs(pitch - sensorValues[2]) >= filter
                        || Math.abs(roll - sensorValues[3]) >= filter
                ) {
                    azimuth = sensorValues[0];
                    yaw = sensorValues[1];
                    pitch = sensorValues[2];
                    roll = sensorValues[3];

                    if(Math.abs(pitch) < 30 && Math.abs(roll) > 30){
                        // landscape 일때.
                        if(roll < 0){
                            // 왼쪽으로 기울어짐.
                            azimuth = azimuth + (roll + 90)*0.9;
                        }else if(roll >= 0){
                            // 오른쪽으로 기울어짐.
                            azimuth = azimuth + (roll - 90)*0.85;
                        }
                    }

                    result.clear();
                    result.put("azimuth", azimuth);
                    result.put("yaw", yaw);
                    result.put("pitch", pitch);
                    result.put("roll", roll);
                    eventSink.success(result);
                }
            }

            @Override
            public void onAccuracyChanged(Sensor sensor, int i) {}
        };

        sensorManager.registerListener(listener, vecSensor, SensorManager.SENSOR_DELAY_UI);
    }

    @Override
    public void onCancel(Object arguments) {
        sensorManager.unregisterListener(listener, vecSensor);
    }

    public void onPause(){
        if (listener != null){
            sensorManager.unregisterListener(listener, vecSensor);
        }
    }

    public void onResume(){
        if (listener != null){
            sensorManager.registerListener(listener, vecSensor, SensorManager.SENSOR_DELAY_UI);
        }
    }
}
