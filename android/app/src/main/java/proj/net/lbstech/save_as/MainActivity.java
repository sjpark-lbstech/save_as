package proj.net.lbstech.save_as;

import io.flutter.Log;
import android.view.KeyEvent;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity{

  private MainChannelHandler mainChannelHandler;
  private PermissionChannelHandler permissionHandler;
  private AzimuthHandler azimuthHandler;


  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);

    final String MAIN_CHANNEL = "proj.net.lbstech.main_channel";
    final String OPEN_CV_CHANNEL = "proj.net.lbstech.open_cv_channel";
    final String PERMISSION_CHANNEL = "proj.net.lbstech.permission_channel";
    final String KEY_EVENT_CHANNEL = "proj.net.lbstech.key_event";
    final String AZIMUTH_EVENT_CHANNEL = "proj.net.lbstech.azimuth_event_channel";

    // main channel
    mainChannelHandler = new MainChannelHandler(getContext());
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), MAIN_CHANNEL)
            .setMethodCallHandler(mainChannelHandler);
    new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), KEY_EVENT_CHANNEL)
            .setStreamHandler(mainChannelHandler);

    // permission channel
    permissionHandler = new PermissionChannelHandler(this);
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), PERMISSION_CHANNEL)
            .setMethodCallHandler(permissionHandler);

    // openCV channel
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), OPEN_CV_CHANNEL)
            .setMethodCallHandler(new OpenCVHandler());

    // azimuth event channel
    azimuthHandler = new AzimuthHandler(getContext());
    new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), AZIMUTH_EVENT_CHANNEL)
            .setStreamHandler(azimuthHandler);
  }

  @Override
  public void onRequestPermissionsResult(int requestCode,@NonNull String[] permissions,@NonNull int[] grantResults) {
    if (permissionHandler != null) {
      permissionHandler.onRequestPermissionsResult(requestCode, permissions, grantResults);
    }
    super.onRequestPermissionsResult(requestCode, permissions, grantResults);
  }

  @Override
  public boolean onKeyDown(int keyCode, KeyEvent event) {
    if (mainChannelHandler.isEventChannelEnable()){
      if (keyCode == KeyEvent.KEYCODE_VOLUME_UP) {
        mainChannelHandler.action(0);
        return true;
      } else if (keyCode == KeyEvent.KEYCODE_VOLUME_DOWN){
        mainChannelHandler.action(1);
        return true;
      }
    }
    return super.onKeyDown(keyCode, event);
  }

  @Override
  protected void onResume() {
    super.onResume();
    azimuthHandler.onResume();
  }

  @Override
  protected void onPause() {
    azimuthHandler.onPause();
    super.onPause();
  }

}
