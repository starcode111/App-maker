package com.example.myapp;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.view.KeyEvent;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

/**
 * MainActivity - WebView wrapper for https://example.com/
 * Features:
 * - Loads website in WebView
 * - Handles back button navigation
 * - JavaScript enabled
 * - Error handling and null checks
 */
public class MainActivity extends AppCompatActivity {

    private WebView webView;
    private static final String WEBSITE_URL = "https://example.com/";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Initialize WebView
        initializeWebView();
    }

    /**
     * Initialize WebView with proper settings and load the website
     */
    @SuppressLint("SetJavaScriptEnabled")
    private void initializeWebView() {
        webView = findViewById(R.id.webView);

        if (webView != null) {
            // Configure WebView settings
            configureWebViewSettings();

            // Set WebViewClient to handle URL loading within the app
            webView.setWebViewClient(new WebViewClient() {
                @Override
                public boolean shouldOverrideUrlLoading(WebView view, String url) {
                    // Load URL in WebView instead of opening in browser
                    if (url != null && url.startsWith("http")) {
                        view.loadUrl(url);
                        return true;
                    }
                    return false;
                }

                @Override
                public void onPageFinished(WebView view, String url) {
                    super.onPageFinished(view, url);
                    // Page loading completed
                }

                @Override
                public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
                    super.onReceivedError(view, errorCode, description, failingUrl);
                    Toast.makeText(MainActivity.this, 
                        "Error: " + description, 
                        Toast.LENGTH_SHORT).show();
                }
            });

            // Load the website
            if (webView.getUrl() == null) {
                webView.loadUrl(WEBSITE_URL);
            }
        } else {
            Toast.makeText(this, "Error initializing WebView", Toast.LENGTH_SHORT).show();
        }
    }

    /**
     * Configure WebView settings for optimal performance
     */
    @SuppressLint("SetJavaScriptEnabled")
    private void configureWebViewSettings() {
        if (webView == null) {
            return;
        }

        try {
            // Enable JavaScript
            webView.getSettings().setJavaScriptEnabled(true);

            // Enable DOM storage
            webView.getSettings().setDomStorageEnabled(true);

            // Enable database
            webView.getSettings().setDatabaseEnabled(true);

            // Set user agent
            webView.getSettings().setUserAgentString(
                "Mozilla/5.0 (Linux; Android 12) AppleWebKit/537.36"
            );

            // Mixed content policy (for both http and https)
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
                webView.getSettings().setMixedContentMode(
                    android.webkit.WebSettings.MIXED_CONTENT_ALWAYS_ALLOW
                );
            }

            // Enable caching
            webView.getSettings().setCacheMode(android.webkit.WebSettings.LOAD_DEFAULT);

            // Enable zoom controls
            webView.getSettings().setBuiltInZoomControls(true);
            webView.getSettings().setDisplayZoomControls(false);

            // Enable media playback
            webView.getSettings().setMediaPlaybackRequiresUserGesture(false);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }



    /**
     * Handle back button navigation
     * Returns user to previous page in WebView history
     */
    @Override
    public boolean onKeyDown(int keyCode, @NonNull KeyEvent event) {
        if ((keyCode == KeyEvent.KEYCODE_BACK) && webView != null) {
            if (webView.canGoBack()) {
                webView.goBack();
                return true;
            }
        }
        return super.onKeyDown(keyCode, event);
    }

    /**
     * Cleanup resources
     */
    @Override
    protected void onDestroy() {
        if (webView != null) {
            webView.destroy();
            webView = null;
        }
        super.onDestroy();
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (webView != null) {
            webView.onResume();
        }
    }

    @Override
    protected void onPause() {
        if (webView != null) {
            webView.onPause();
        }
        super.onPause();
    }
}
