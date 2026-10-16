package app.buddy.assistant;

import android.app.Activity;
import android.content.Context;
import android.content.res.Configuration;
import android.os.Bundle;
import java.util.Locale;

/** Base for Buddy's screens: applies the theme, locale, and rebuilds when appearance settings change. */
abstract class Screen extends Activity {
    private String themeKey;

    @Override
    protected void attachBaseContext(Context newBase) {
        String lang = Prefs.language(newBase);
        if (!lang.isEmpty()) {
            Locale locale = new Locale(lang);
            Locale.setDefault(locale);
            Configuration config = new Configuration(newBase.getResources().getConfiguration());
            config.setLocale(locale);
            newBase = newBase.createConfigurationContext(config);
        }
        super.attachBaseContext(newBase);
    }

    @Override
    protected void onCreate(Bundle state) {
        Theme.apply(this);
        themeKey = Theme.key();
        super.onCreate(state);
    }

    @Override
    protected void onResume() {
        super.onResume();
        Theme.load(this);
        if (!Theme.key().equals(themeKey)) recreate();
    }

    /** Re-apply the theme in place (after a change made on this screen). */
    protected void rethemed() {
        Theme.apply(this);
        themeKey = Theme.key();
    }
}
