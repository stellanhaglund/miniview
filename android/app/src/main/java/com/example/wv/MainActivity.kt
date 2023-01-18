package com.example.wv

import android.Manifest
import android.annotation.SuppressLint
import android.annotation.TargetApi
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.webkit.*
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.webkit.WebSettingsCompat
import androidx.webkit.WebViewFeature
import org.json.JSONObject


class MainActivity : AppCompatActivity() {

    private val fragmentManager = supportFragmentManager
    private val permission = arrayOf(Manifest.permission.CAMERA,
        Manifest.permission.RECORD_AUDIO,
        Manifest.permission.MODIFY_AUDIO_SETTINGS)
    var views: Int = 0

    override fun onSupportNavigateUp(): Boolean {
        Log.d("activity", "navigate up")

        val webViewFragment = WebViewFragment.reuse()
        val fragmentTransaction = supportFragmentManager.beginTransaction()
        fragmentTransaction.replace(R.id.webview_container, webViewFragment)
        fragmentTransaction.addToBackStack("wv-stack")
        fragmentTransaction.commit()

        finish()
        return false
    }

    @SuppressLint("SetJavaScriptEnabled")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val color = intent.getIntExtra("color", 0)


        window.statusBarColor = Color.rgb(24, 24, 27)
        window.navigationBarColor = Color.rgb(24, 24, 27)
        supportActionBar?.setBackgroundDrawable(ColorDrawable(Color.rgb(24, 24, 27)))

        if (color != 0) {
            supportActionBar?.setDisplayHomeAsUpEnabled(true)
        }

        if(!WebViewFragment.has_webview){

            Log.d("fragment", "the fragment doesn't have a webview")

            val webView = WebView(this)


           /* val currentNightMode = resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK
            if (currentNightMode == Configuration.UI_MODE_NIGHT_YES) {
                webView.settings.forceDark = WebSettings.FORCE_DARK_ON
            } else {
                webView.settings.forceDark = WebSettings.FORCE_DARK_OFF
            }*/

            if (WebViewFeature.isFeatureSupported(WebViewFeature.FORCE_DARK)) {
                WebSettingsCompat.setForceDark(webView.settings,
                    WebSettingsCompat.FORCE_DARK_ON);
            }

            //webView.settings.setSupportMultipleWindows(true)

            webView.settings.javaScriptEnabled = true

            webView.webChromeClient = object : WebChromeClient() {
                @TargetApi(Build.VERSION_CODES.LOLLIPOP)
                override fun onPermissionRequest(request: PermissionRequest) {
                    request.grant(request.resources)
                }

            }

            if (!isPermissionGranted()) {

                askPermissions()

            }
            /*webView.webChromeClient = object : WebChromeClient() {
                override fun onCreateWindow(
                    view: WebView,
                    dialog: Boolean,
                    userGesture: Boolean,
                    resultMsg: Message
                ): Boolean {

                    Log.d("modal", "should show a modal")
                    //if(views > 1){
                    val bottomSheet = BottomSheetFragment()
                    bottomSheet.show(supportFragmentManager, bottomSheet.tag)

                    /*val fragmentTransaction = supportFragmentManager.beginTransaction()
                    fragmentTransaction.add(R.id.webview_container, bottomSheet)
                    fragmentTransaction.addToBackStack(null)
                    fragmentTransaction.commit()*/
                      //  views++
                    //}else{
                    //    views++
                   // }



                    return false
                }
            }*/


            webView.webViewClient = object : WebViewClient() {
                override fun shouldOverrideUrlLoading(view: WebView?, url: String?): Boolean {
                    return false
                }
            }


            webView.addJavascriptInterface(this, "Android")
            webView.loadUrl("https://test.meetme.ai/")

            val webViewFragment = WebViewFragment.newInstance(webView)
            val fragmentTransaction = supportFragmentManager.beginTransaction()
            fragmentTransaction.replace(R.id.webview_container, webViewFragment)
            fragmentTransaction.addToBackStack("wv-stack")
            fragmentTransaction.commit()

        }else {

            Log.d("fragment", "fragment reused")

            val webViewFragment = WebViewFragment.reuse()
            val fragmentTransaction = supportFragmentManager.beginTransaction()
            fragmentTransaction.replace(R.id.webview_container, webViewFragment)
            fragmentTransaction.addToBackStack("wv-stack")
            fragmentTransaction.commit()

        }

    }

    private fun askPermissions() {
        ActivityCompat.requestPermissions(this, permission, 1)
    }

    private fun isPermissionGranted(): Boolean {
        permission.forEach {
            if (ActivityCompat.checkSelfPermission(this, it) != PackageManager.PERMISSION_GRANTED)
                return false
        }

        return true
    }

    @JavascriptInterface
    fun postMessage(toast: String) {
        val data = JSONObject(toast)
        window.statusBarColor = Color.rgb(24, 24, 27)
        window.navigationBarColor = Color.rgb(24, 24, 27)
        supportActionBar?.setBackgroundDrawable(ColorDrawable(Color.rgb(24, 24, 27)))
        if(data.getString("to") != ""){
            val intent = Intent(this, MainActivity::class.java)
            intent.putExtra("color", 24)
            startActivity(intent)
        }

        Log.d("javascript", data.getJSONObject("route").toString())
    }

}