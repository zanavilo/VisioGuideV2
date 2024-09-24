package com.example.visioguide;

import android.graphics.Typeface;
import android.os.Bundle;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.TextUtils;
import android.text.style.StyleSpan;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        TextView textView = findViewById(R.id.say);
        String fullText = getString(R.string.say);

        // Split the string into lines
        String[] lines = fullText.split("\\n");

        // Create a SpannableStringBuilder
        SpannableString spannableString = new SpannableString(fullText);

        // Bold the capital words in each line
        int start = 0;
        for (String line : lines) {
            int lineStart = fullText.indexOf(line, start);
            int lineEnd = lineStart + line.length();

            // Split the line into words
            String[] words = line.split(" ");

            // Bold capital words
            for (String word : words) {
                if (TextUtils.isEmpty(word))
                    continue;
                if (Character.isUpperCase(word.charAt(0))) {
                    int startIndex = line.indexOf(word);
                    int endIndex = startIndex + word.length();
                    spannableString.setSpan(new StyleSpan(Typeface.BOLD), lineStart + startIndex, lineStart + endIndex, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
                }
            }

            start = lineEnd + 1; // Move to the next line
        }

        textView.setText(spannableString);
    }
}