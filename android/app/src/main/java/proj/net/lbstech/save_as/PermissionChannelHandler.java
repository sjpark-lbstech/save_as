package proj.net.lbstech.save_as;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.os.Build;

import io.flutter.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class PermissionChannelHandler implements MethodChannel.MethodCallHandler{

    private final int RQ_CODE = 0XE04;
    private final String[] permissions = {
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.WRITE_EXTERNAL_STORAGE,
            Manifest.permission.ACCESS_NETWORK_STATE
    };

    private final Activity activity;
    private MethodChannel.Result result;

    PermissionChannelHandler(Activity activity){
        this.activity = activity;
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method){
            case "check":
                {
                    boolean isAllGranted = true;
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        for (String permission : permissions) {
                            int state = activity.checkSelfPermission(permission);
                            if (state != PackageManager.PERMISSION_GRANTED) {
                                isAllGranted = false;
                                break;
                            }
                        }
                    }
                    result.success(isAllGranted);
                }
                break;
            case "request":
                {
                    if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        this.result = result;
                        activity.requestPermissions(permissions, RQ_CODE);
                    }
                }
                break;
        }
    }

    void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        if (requestCode == RQ_CODE && result != null){
            Log.i("PERMISSION_HANDLER", "request permission call back 수신");
            boolean isAllGranted = true;
            for (int grantResult : grantResults){
                if (grantResult != PackageManager.PERMISSION_DENIED){
                    isAllGranted = false;
                    break;
                }
            }
            result.success(isAllGranted);
            result = null;
        }
    }
}
