package com.example.wv

import android.annotation.SuppressLint
import android.content.res.Configuration
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.graphics.drawable.DrawableWrapper
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.MenuItem
import android.view.View
import android.view.ViewGroup
import android.webkit.WebView
import android.widget.FrameLayout
import androidx.activity.OnBackPressedCallback
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment

class WebViewFragment : Fragment() {
    lateinit var webView: WebView

    companion object {
        var has_webview: Boolean = false
        @SuppressLint("StaticFieldLeak")
        var webView: WebView? = null

        fun newInstance(webView: WebView): WebViewFragment {
            val fragment = WebViewFragment()
            fragment.webView = webView
            this.has_webview = true
            this.webView = webView
            return fragment
        }

        fun reuse(): WebViewFragment {
            val fragment = WebViewFragment()
            fragment.webView = this.webView!!
            return fragment
        }
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            android.R.id.home -> {

                Log.d("Fragment", "Home pressed")
               // return requireActivity().onSupportNavigateUp()
            }
        }
        return super.onOptionsItemSelected(item)
    }


    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        val view = inflater.inflate(R.layout.fragment_web_view, container, false)
        view.setBackgroundColor(Color.rgb(24, 24, 27));
        val webViewContainer = view.findViewById<FrameLayout>(R.id.web_view_container)

        webView.setBackgroundColor(Color.rgb(24, 24, 27));
        //(activity as AppCompatActivity).supportActionBar?.setDisplayHomeAsUpEnabled(true)
        /*val currentNightMode = resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK
        val userAgent = when (currentNightMode) {
            Configuration.UI_MODE_NIGHT_YES -> "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3; prefers-color-scheme: dark"
            else -> "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3; prefers-color-scheme: light"
        }
        webView.settings.userAgentString = userAgent*/


        activity?.onBackPressedDispatcher?.addCallback(viewLifecycleOwner, object : OnBackPressedCallback(true) {
            override fun handleOnBackPressed() {

                Log.e("DEBUG", "onResume of back")

                if (webView != null && webView.parent != null) {
                    val parent = webView.parent as ViewGroup
                    parent?.removeView(webView)
                }

                webView.goBack()

                webViewContainer.addView(webView)
                // in here you can do logic when backPress is clicked
            }
        })

        if (webView != null && webView.parent != null) {
            val parent = webView.parent as ViewGroup
            parent?.removeView(webView)
        }

        webViewContainer.addView(webView)
        return view
    }
}