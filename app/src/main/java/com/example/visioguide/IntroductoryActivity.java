package com.example.visioguide;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;

public class IntroductoryActivity extends AppCompatActivity {

    private static int time = 2000;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_introductory);

        ImageView logo = findViewById(R.id.logo); // id 'logo'

        // Fade in animation
        Animation fadeIn = AnimationUtils.loadAnimation(getApplicationContext(), R.anim.fadein);
        logo.startAnimation(fadeIn);

        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                // Fade out animation
                Animation fadeOut = AnimationUtils.loadAnimation(getApplicationContext(), R.anim.fadeout);
                logo.startAnimation(fadeOut);

                // Start MainActivity after fade out animation completes
                fadeOut.setAnimationListener(new Animation.AnimationListener() {
                    @Override
                    public void onAnimationStart(Animation animation) {}

                    @Override
                    public void onAnimationEnd(Animation animation) {
                        Intent intent = new Intent(IntroductoryActivity.this, MainActivity.class);
                        startActivity(intent);
                        finish();
                    }

                    @Override
                    public void onAnimationRepeat(Animation animation) {}
                });
            }
        }, time);
    }
}
