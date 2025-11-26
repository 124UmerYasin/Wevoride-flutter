package com.wevoride

import android.os.Build
import android.os.Bundle
import androidx.activity.enableEdgeToEdge
import androidx.core.view.WindowCompat
import com.google.android.material.color.DynamicColors
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        
        // Enable edge-to-edge for all Android versions
        // This prevents Flutter from calling deprecated status/navigation bar APIs
        WindowCompat.setDecorFitsSystemWindows(window, false)
        
        super.onCreate(savedInstanceState)
        
        // Apply Material3 dynamic colors if available
        DynamicColors.applyToActivityIfAvailable(this)
        
        // Note: Status bar and navigation bar colors are managed by Material3 theme
        // in styles.xml with transparent system bars for proper edge-to-edge display
    }
}

